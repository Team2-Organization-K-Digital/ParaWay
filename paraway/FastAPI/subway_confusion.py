from fastapi import APIRouter
import os
import numpy as np
import joblib
from pydantic import BaseModel
import warnings
warnings.filterwarnings('ignore')

router = APIRouter()

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
MODEL_DIR = os.path.join(BASE_DIR,'mechineLearning')


model_people_w_n = joblib.load(os.path.join(MODEL_DIR,'subway_work_people_on.h5'))
model_people_w_f = joblib.load(os.path.join(MODEL_DIR,'subway_work_people_off.h5'))
model_people_n_n = joblib.load(os.path.join(MODEL_DIR,'subway_people_on.h5'))
model_people_n_f = joblib.load(os.path.join(MODEL_DIR,'subway_people_off.h5'))
model_conf_n = joblib.load(os.path.join(MODEL_DIR,'subway_normal_confusion.h5'))
model_conf_w = joblib.load(os.path.join(MODEL_DIR,'subway_work_confusion.h5'))


# p_n = ['역번호','시간','평일','토요일','일요일','점포수', '출구_수','월요일','화요일','수요일','목요일','금요일']
# p_w =['역번호','시간','출근시간', '퇴근시간', '점포수', '출구_수','총_직장_인구_수','월요일','화요일','수요일','목요일','금요일']
# c_n =['요일구분', '역번호',  '상하구분', '시간', '승차인원', '하차인원']
# c_w =['역번호', '상하구분', '시간', '승차인원', '하차인원', '출근시간','퇴근시간']

class Info(BaseModel):
    sub_num : int
    time : int 
    week : int
    stores : int
    exits : int
    workp : int
    holy : bool


@router.post('/confusion')
async def confusion(info:Info):
        match info.week:
            case 1 :
                i=0
                if info.holy:
                    i=4
                    opeople = np.int32(model_people_n_n.predict([[info.sub_num,info.time,False,False,True,info.stores,info.exits,True,False,False,False,False]])[0])
                    fpeople = np.int32(model_people_n_f.predict([[info.sub_num,info.time,False,False,True,info.stores,info.exits,True,False,False,False,False]])[0])
                    oconfusion = model_conf_n.predict([[i,info.sub_num,0,info.time,opeople,fpeople]])
                    fconfusion = model_conf_n.predict([[i,info.sub_num,1,info.time,opeople,fpeople]])
                else: 
                    if 7<=info.time & info.time<=9:
                        opeople = np.int32(model_people_w_n.predict([[info.sub_num,info.time,True,False, info.stores,info.exits,info.workp,True,False,False,False,False]])[0])
                        fpeople = np.int32(model_people_w_f.predict([[info.sub_num,info.time,True,False, info.stores,info.exits,info.workp,True,False,False,False,False]])[0])
                        oconfusion = model_conf_w.predict([[info.sub_num,0,info.time,opeople,fpeople,True,False]])
                        fconfusion = model_conf_w.predict([[info.sub_num,1,info.time,opeople,fpeople,True,False]])
                    elif 17<=info.time&info.time<=19:
                        opeople = np.int32(model_people_w_n.predict([[info.sub_num,info.time,False,True, info.stores,info.exits,info.workp,True,False,False,False,False]])[0])
                        fpeople = np.int32(model_people_w_f.predict([[info.sub_num,info.time,False,True, info.stores,info.exits,info.workp,True,False,False,False,False]])[0])
                        oconfusion = model_conf_w.predict([[info.sub_num,0,info.time,opeople,fpeople,False,True]])
                        fconfusion = model_conf_w.predict([[info.sub_num,1,info.time,opeople,fpeople,False,True]])
                    else:
                        
                        opeople = np.int32(model_people_n_n.predict([[info.sub_num,info.time,True,False,False, info.stores,info.exits,True,False,False,False,False]])[0])
                        fpeople = np.int32(model_people_n_f.predict([[info.sub_num,info.time,True,False,False, info.stores,info.exits,True,False,False,False,False]])[0])
                        oconfusion = model_conf_n.predict([[i,info.sub_num,0,info.time,opeople,fpeople]])
                        fconfusion = model_conf_n.predict([[i,info.sub_num,1,info.time,opeople,fpeople]])
                
                
            case 2:
                i=0
                if info.holy:
                    i=4
                    opeople = np.int32(model_people_n_n.predict([[info.sub_num,info.time,False,False,True,info.stores,info.exits,False,True,False,False,False]])[0])
                    fpeople = np.int32(model_people_n_f.predict([[info.sub_num,info.time,False,False,True,info.stores,info.exits,False,True,False,False,False]])[0])
                    oconfusion = model_conf_n.predict([[i,info.sub_num,0,info.time,opeople,fpeople]])
                    fconfusion = model_conf_n.predict([[i,info.sub_num,1,info.time,opeople,fpeople]])
                else: 
                    if 7<=info.time & info.time<=9:
                        opeople = np.int32(model_people_w_n.predict([[info.sub_num,info.time,True,False, info.stores,info.exits,info.workp,False,True,False,False,False]])[0])
                        fpeople = np.int32(model_people_w_f.predict([[info.sub_num,info.time,True,False, info.stores,info.exits,info.workp,False,True,False,False,False,False]])[0])
                        oconfusion = model_conf_w.predict([[info.sub_num,0,info.time,opeople,fpeople,True,False]])
                        fconfusion = model_conf_w.predict([[info.sub_num,1,info.time,opeople,fpeople,True,False]])
                    elif 17<=info.time&info.time<=19:
                        opeople = np.int32(model_people_w_n.predict([[info.sub_num,info.time,False,True, info.stores,info.exits,info.workp,False,True,False,False,False]])[0])
                        fpeople = np.int32(model_people_w_f.predict([[info.sub_num,info.time,False,True, info.stores,info.exits,info.workp,False,True,False,False,False]])[0])
                        oconfusion = model_conf_w.predict([[info.sub_num,0,info.time,opeople,fpeople,False,True]])
                        fconfusion = model_conf_w.predict([[info.sub_num,1,info.time,opeople,fpeople,False,True]])
                    else:
                        opeople = np.int32(model_people_n_n.predict([[info.sub_num,info.time,True,False,False, info.stores,info.exits,False,True,False,False,False]])[0])
                        fpeople = np.int32(model_people_n_f.predict([[info.sub_num,info.time,True,False,False, info.stores,info.exits,False,True,False,False,False]])[0])
                        oconfusion = model_conf_n.predict([[i,info.sub_num,0,info.time,opeople,fpeople]])
                        fconfusion = model_conf_n.predict([[i,info.sub_num,1,info.time,opeople,fpeople]])
                
                    
            case 3:
                i=0
                if info.holy:
                    i=4
                    opeople = np.int32(model_people_n_n.predict([[info.sub_num,info.time,False,False,True,info.stores,info.exits,False,False,True,False,False]])[0])
                    fpeople = np.int32(model_people_n_f.predict([[info.sub_num,info.time,False,False,True,info.stores,info.exits,False,False,True,False,False]])[0])
                    oconfusion = model_conf_n.predict([[i,info.sub_num,0,info.time,opeople,fpeople]])
                    fconfusion = model_conf_n.predict([[i,info.sub_num,1,info.time,opeople,fpeople]])
                else: 
                    if 7<=info.time & info.time<=9:
                        opeople = np.int32(model_people_w_n.predict([[info.sub_num,info.time,True,False, info.stores,info.exits,info.workp,False,False,True,False,False]])[0])
                        fpeople = np.int32(model_people_w_f.predict([[info.sub_num,info.time,True,False, info.stores,info.exits,info.workp,False,False,True,False,False]])[0])
                        oconfusion = model_conf_w.predict([[info.sub_num,0,info.time,opeople,fpeople,True,False]])
                        fconfusion = model_conf_w.predict([[info.sub_num,1,info.time,opeople,fpeople,True,False]])
                    elif 17<=info.time&info.time<=19:
                        opeople = np.int32(model_people_w_n.predict([[info.sub_num,info.time,False,True, info.stores,info.exits,info.workp,False,False,True,False,False]])[0])
                        fpeople = np.int32(model_people_w_f.predict([[info.sub_num,info.time,False,True, info.stores,info.exits,info.workp,False,False,True,False,False]])[0])
                        oconfusion = model_conf_w.predict([[info.sub_num,0,info.time,opeople,fpeople,False,True]])
                        fconfusion = model_conf_w.predict([[info.sub_num,1,info.time,opeople,fpeople,False,True]])
                    else:
                        opeople = np.int32(model_people_n_n.predict([[info.sub_num,info.time,True,False,False, info.stores,info.exits,False,False,True,False,False]])[0])
                        fpeople = np.int32(model_people_n_f.predict([[info.sub_num,info.time,True,False,False, info.stores,info.exits,False,False,True,False,False]])[0])
                        oconfusion = model_conf_n.predict([[i,info.sub_num,0,info.time,opeople,fpeople]])
                        fconfusion = model_conf_n.predict([[i,info.sub_num,1,info.time,opeople,fpeople]])
                
            case 4:
                i=0
                if info.holy:
                    i=4
                    opeople = np.int32(model_people_n_n.predict([[info.sub_num,info.time,False,False,True,info.stores,info.exits,False,False,False,True,False]])[0])
                    fpeople = np.int32(model_people_n_f.predict([[info.sub_num,info.time,False,False,True,info.stores,info.exits,False,False,False,True,False]])[0])
                    oconfusion = model_conf_n.predict([[i,info.sub_num,0,info.time,opeople,fpeople]])
                    fconfusion = model_conf_n.predict([[i,info.sub_num,1,info.time,opeople,fpeople]])
                else: 
                    if 7<=info.time & info.time<=9:
                        opeople = np.int32(model_people_w_n.predict([[info.sub_num,info.time,True,False, info.stores,info.exits,info.workp,False,False,False,True,False]])[0])
                        fpeople = np.int32(model_people_w_f.predict([[info.sub_num,info.time,True,False, info.stores,info.exits,info.workp,False,False,False,True,False]])[0])
                        oconfusion = model_conf_w.predict([[info.sub_num,0,info.time,opeople,fpeople,True,False]])
                        fconfusion = model_conf_w.predict([[info.sub_num,1,info.time,opeople,fpeople,True,False]])
                    elif 17<=info.time&info.time<=19:
                        opeople = np.int32(model_people_w_n.predict([[info.sub_num,info.time,False,True, info.stores,info.exits,info.workp,False,False,False,True,False]])[0])
                        fpeople = np.int32(model_people_w_f.predict([[info.sub_num,info.time,False,True, info.stores,info.exits,info.workp,False,False,False,True,False]])[0])
                        oconfusion = model_conf_w.predict([[info.sub_num,0,info.time,opeople,fpeople,False,True]])
                        fconfusion = model_conf_w.predict([[info.sub_num,1,info.time,opeople,fpeople,False,True]])
                    else:
                        opeople = np.int32(model_people_n_n.predict([[info.sub_num,info.time,True,False,False, info.stores,info.exits,False,False,False,True,False]])[0])
                        fpeople = np.int32(model_people_n_f.predict([[info.sub_num,info.time,True,False,False, info.stores,info.exits,False,False,False,True,False]])[0])
                        oconfusion = model_conf_n.predict([[i,info.sub_num,0,info.time,opeople,fpeople]])
                        fconfusion = model_conf_n.predict([[i,info.sub_num,1,info.time,opeople,fpeople]])
                
            case 5:
                i=0
                if info.holy:
                    i=4
                    opeople = np.int32(model_people_n_n.predict([[info.sub_num,info.time,False,False,True,info.stores,info.exits,False,False,False,False,True]])[0])
                    fpeople = np.int32(model_people_n_f.predict([[info.sub_num,info.time,False,False,True,info.stores,info.exits,False,False,False,False,True]])[0])
                    oconfusion = model_conf_n.predict([[i,info.sub_num,0,info.time,opeople,fpeople]])
                    fconfusion = model_conf_n.predict([[i,info.sub_num,1,info.time,opeople,fpeople]])
                else: 
                    if 7<=info.time & info.time<=9:
                        opeople = np.int32(model_people_w_n.predict([[info.sub_num,info.time,True,False, info.stores,info.exits,info.workp,False,False,False,False,True]])[0])
                        fpeople = np.int32(model_people_w_f.predict([[info.sub_num,info.time,True,False, info.stores,info.exits,info.workp,False,False,False,False,True]])[0])
                        oconfusion = model_conf_w.predict([[info.sub_num,0,info.time,opeople,fpeople,True,False]])
                        fconfusion = model_conf_w.predict([[info.sub_num,1,info.time,opeople,fpeople,True,False]])
                    elif 17<=info.time&info.time<=19:
                        opeople = np.int32(model_people_w_n.predict([[info.sub_num,info.time,False,True, info.stores,info.exits,info.workp,False,False,False,False,True]])[0])
                        fpeople = np.int32(model_people_w_f.predict([[info.sub_num,info.time,False,True, info.stores,info.exits,info.workp,False,False,False,False,True]])[0])
                        oconfusion = model_conf_w.predict([[info.sub_num,0,info.time,opeople,fpeople,False,True]])
                        fconfusion = model_conf_w.predict([[info.sub_num,1,info.time,opeople,fpeople,False,True]])
                    else:
                        opeople = np.int32(model_people_n_n.predict([[info.sub_num,info.time,True,False,False, info.stores,info.exits,False,False,False,False,True]])[0])
                        fpeople = np.int32(model_people_n_f.predict([[info.sub_num,info.time,True,False,False, info.stores,info.exits,False,False,False,False,True,]])[0])
                        oconfusion = model_conf_n.predict([[i,info.sub_num,0,info.time,opeople,fpeople]])
                        fconfusion = model_conf_n.predict([[i,info.sub_num,1,info.time,opeople,fpeople]])
                
            case 6:
                opeople = np.int32(model_people_n_n.predict([[info.sub_num,info.time,False,True,False, info.stores,info.exits,False,False,False,False,False]])[0])
                fpeople = np.int32(model_people_n_f.predict([[info.sub_num,info.time,False,True,False, info.stores,info.exits,False,False,False,False,False]])[0])
                oconfusion = model_conf_n.predict([[2,info.sub_num,0,info.time,opeople,fpeople]])
                fconfusion = model_conf_n.predict([[2,info.sub_num,1,info.time,opeople,fpeople]])
                
            case 7:
                opeople = np.int32(model_people_n_n.predict([[info.sub_num,info.time,False,False,True, info.stores,info.exits,False,False,False,False,False]])[0])
                fpeople = np.int32(model_people_n_f.predict([[info.sub_num,info.time,False,False,True, info.stores,info.exits,False,False,False,False,False]])[0])
                oconfusion = model_conf_n.predict([[3,info.sub_num,0,info.time,opeople,fpeople]])
                fconfusion = model_conf_n.predict([[3,info.sub_num,1,info.time,opeople,fpeople]])
                
        return {'on':int(opeople),'off':int(fpeople),'oconfusion':round(float((oconfusion)),2),'fconfusion':round(float((fconfusion)),2)}
