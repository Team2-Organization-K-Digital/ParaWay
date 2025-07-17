from fastapi import FastAPI
from newsweather import router as newsweather_router
from subway_confusion import router as subway_router
from pred_chart import router as pred_chart_router

ip = "127.0.0.1"

app = FastAPI()
app.include_router(subway_router,prefix="/subway",tags=["subway"])
app.include_router(newsweather_router,prefix="/newsweather",tags=["newsweather"])
app.include_router(pred_chart_router,prefix="/pred_chart",tags=["pred_chart"])


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app,host=ip,port=8000,limit_max_requests=1024*1024*10)