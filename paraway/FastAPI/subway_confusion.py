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


# class info_nomal(BaseModel):



@router.post('/confusion')
async def confusion():
    opeople = np.int32(model_people_n_n.predict([[222,12,True,False,False,17394,12,False,False,True,False,False]])[0])
    fpeople = np.int32(model_people_n_f.predict([[222,12,True,False,False,17394,12,False,False,True,False,False]])[0])
    confusion = model_conf_n.predict([[0,222,1,12,opeople,fpeople]])
    return {'on':int(opeople),'off':int(fpeople),'confusion':int(confusion)}
