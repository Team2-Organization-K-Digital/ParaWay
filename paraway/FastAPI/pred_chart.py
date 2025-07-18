# --------------------------------------------------------------------- #
from fastapi import APIRouter
import os
import numpy as np
import joblib
from pydantic import BaseModel
import warnings
warnings.filterwarnings('ignore')
# 시각화
import matplotlib.pyplot as plt
import io
import base64
from fastapi.responses import HTMLResponse
# --------------------------------------------------------------------- #
'''
- title         : Predict chart
- Description   : 사용자가 지하철 역을 상세보기 할 경우 해당 날짜의 06시 ~ 23시 까지의 혼잡도를
-                 예측하여 시간대 별 차트로 보여주기 위한 시트
- Author        : Lee ChangJun
- Created Date  : 2025.07.17
- Last Modified : 2025.07.17
- package       : fastapi, os, numpy, joblib, pydantic, 
-                 warnings, matplotlib, io, base64
'''
# --------------------------------------------------------------------- #
router = APIRouter()
# --------------------------------------------------------------------- #
# 머신러닝 모델을 불러오기 위한 os setting
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
MODEL_DIR = os.path.join(BASE_DIR,'mechineLearning')
# --------------------------------------------------------------------- #
# 머신러닝 모델
model_people_w_n = joblib.load(os.path.join(MODEL_DIR,'subway_work_people_on.h5'))  # 승차 : 출퇴근
model_people_w_f = joblib.load(os.path.join(MODEL_DIR,'subway_work_people_off.h5')) # 하차 : 출퇴근
model_people_n_n = joblib.load(os.path.join(MODEL_DIR,'subway_people_on.h5'))       # 승차 : 평상시
model_people_n_f = joblib.load(os.path.join(MODEL_DIR,'subway_people_off.h5'))      # 하차 : 평상시
model_conf_n = joblib.load(os.path.join(MODEL_DIR,'subway_normal_confusion.h5'))    # 혼잡도 : 평상시
model_conf_w = joblib.load(os.path.join(MODEL_DIR,'subway_work_confusion.h5'))      # 혼잡도 : 출퇴근
# --------------------------------------------------------------------- #
# 조건에 따라 머신이 필요로 하는 컬럼
# p_n =['역번호','시간','평일','토요일','일요일','점포수', '출구_수','월요일','화요일','수요일','목요일','금요일']
# p_w =['역번호','시간','출근시간', '퇴근시간', '점포수', '출구_수','총_직장_인구_수','월요일','화요일','수요일','목요일','금요일']
# c_n =['요일구분', '역번호',  '상하구분', '시간', '승차인원', '하차인원']
# c_w =['역번호', '상하구분', '시간', '승차인원', '하차인원', '출근시간','퇴근시간']
# --------------------------------------------------------------------- #
# 1. 전달 받은 데이터를 통해 내,외선 예측 혼잡도를 06시~00시 까지 line chart 로 시각화 하여 전달하는 함수
@router.get('detail/pred_chart')
def pred_chart(sub_num:int, week:int , stores:int, exits:int, workp:int, holy:bool):
    time_range = range(6,23+1,1)  # 06~23시
    ocon_list = []
    fcon_list = []
    for time in time_range:
        res = pred(
                sub_num=sub_num,
                time=time,
                week=week,
                stores=stores,
                exits=exits,
                workp=workp,
                holy=holy
            )
        ocon_list.append(res['oconfusion'])
        fcon_list.append(res['fconfusion'])
    return {'results' : {'str_confusion' : ocon_list, 'rev_confusion' : fcon_list}}


# --------------------------------------------------------------------- #
# 2. 지하철 역의 혼잡도와 승,하차 인원수를 예측하는 머신러닝 모델이 들어간 함수
# 조건 : 역, 시간, 요일, 점포 수, 출구 수, 직장인 수, 공휴일 유무
def pred(sub_num:int, time:int, week:int , stores:int, exits:int, workp:int, holy:bool ):
# ------------------------------- #
# 머신러닝 모델에 들어갈 데이터 셋

# 결정된 설정을 저장할 변수 -> 예측 부분에서 사용
    state = 0
# 유동인구 예측
    p_a = [] # 선택된 리스트가 들어갈 변수
    p_n = [sub_num, time, False,False,False, stores, exits, False,False,False,False,False]
    p_w = [sub_num, time, False,False, stores, exits, workp, False,False,False,False,False]

# 혼잡도 예측
    c_a = []   # 선택된 리스트가 들어갈 변수
    c_n = [0, sub_num, 0, time, 0,0]
    c_w = [sub_num, 0, time,0,0, False,False]
# ------------------------------- #
# 주어진 조건에 따라 사용할 모델과 데이터 셋을 설정
# 공휴일 (평일), 토요일, 일요일 설정
    if holy == True | week == 6 | week == 7 :
        model_p_n = model_people_n_n
        model_p_f = model_people_n_f
        model_c = model_conf_n
        if week >= 6:
            p_n[week-3] = True # 토, 일요일
            c_n[0] = 2 if week == 6 else 3 # 토: 2 / 일: 3
        else :
            p_n[2] = True      # 평일
            c_n[0] == 1        # 공휴일
        p_a = p_n
        c_a = c_n
        state = 2
# --------------- #
# time 의 값이 출퇴근 시간에 해당 하는지 판별하여 모델 설정
# 평일, 출퇴근 시간의 설정
    else :
        if time >= 7 & time <= 9 | time >= 17 & time <= 19 :
            model_p_n = model_people_w_n
            model_p_f = model_people_w_f
            model_c = model_conf_w
            if time >= 7 & time <= 9:
                p_w[2] = True  # 출근
                c_w[5] = True  # 출근
            else :
                p_w[3] = True  # 퇴근
                c_w[6] = True  # 퇴근
            p_w[6+week] = True # 요일
            c_a = c_w
            p_a = p_w
            state = 1
# --------------- #
# 평일, 평상시의 설정
        else :
            model_p_n = model_people_n_n
            model_p_f = model_people_n_f
            model_c = model_conf_n
            p_n[7+week] = True # 요일
            p_n[2] = True      # 평일
            p_a = p_n
            c_a = c_n
            state = 2
# ------------------------------- #
# 머신러닝을 통한 예측

# 승하차 인원 예측
    opeople = np.int32(model_p_n.predict([p_a])[0])
    fpeople = np.int32(model_p_f.predict([p_a])[0])
# 예측된 승,하차 인원을 대입
    c_a[state+2] = opeople
    c_a[state+3] = fpeople
# 혼잡도 예측  0 : 외선 / 1 : 내선
    fconfusion = model_c.predict([c_a])
    c_a[state+1] = 1
    oconfusion = model_c.predict([c_a])
    return {'oconfusion':round(float((oconfusion)),2),'fconfusion':round(float((fconfusion)),2)}
# --------------------------------------------------------------------- #