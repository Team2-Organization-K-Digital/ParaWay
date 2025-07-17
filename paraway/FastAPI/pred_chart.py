# p_n = ['역번호','시간','평일','토요일','일요일','점포수', '출구_수','월요일','화요일','수요일','목요일','금요일']
# p_w =['역번호','시간','출근시간', '퇴근시간', '점포수', '출구_수','총_직장_인구_수','월요일','화요일','수요일','목요일','금요일']
# c_n =['요일구분', '역번호',  '상하구분', '시간', '승차인원', '하차인원']
# c_w =['역번호', '상하구분', '시간', '승차인원', '하차인원', '출근시간','퇴근시간']
# --------------------------------------------------------------------- #
from fastapi import APIRouter
import os
import numpy as np
import joblib
from pydantic import BaseModel
import warnings
warnings.filterwarnings('ignore')
# --------------------------------------------------------------------- #
'''
- title         : Predict chart
- Description   : 사용자가 지하철 역을 상세보기 할 경우 해당 날짜의 06시 ~ 23시 까지의 혼잡도를
-                 예측하여 시간대 별 차트로 보여주기 위한 시트
- Author        : Lee ChangJun
- Created Date  : 2025.07.17
- Last Modified : 2025.07.17
- package       : fastapi, os, numpy, joblib, pydantic, warnings
'''
# --------------------------------------------------------------------- #
router = APIRouter()
# --------------------------------------------------------------------- #
# 머신러닝 모델을 불러오기 위한 os setting
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
MODEL_DIR = os.path.join(BASE_DIR,'mechineLearning')
# --------------------------------------------------------------------- #
# 머신러닝 모델
model_people_w_n = joblib.load(os.path.join(MODEL_DIR,'subway_work_people_on.h5'))
model_people_w_f = joblib.load(os.path.join(MODEL_DIR,'subway_work_people_off.h5'))
model_people_n_n = joblib.load(os.path.join(MODEL_DIR,'subway_people_on.h5'))
model_people_n_f = joblib.load(os.path.join(MODEL_DIR,'subway_people_off.h5'))
model_conf_n = joblib.load(os.path.join(MODEL_DIR,'subway_normal_confusion.h5'))
model_conf_w = joblib.load(os.path.join(MODEL_DIR,'subway_work_confusion.h5'))
# --------------------------------------------------------------------- #
@router.get('detail/pred')
def pred(sub_num:int, time:int, week:int , stores:int, exits:int, workp:int, holy:int ):
    wk = [False,]
    holy = True



# --------------------------------------------------------------------- #