from fastapi import FastAPI
from subway_confusion import router as subway_router

ip = "127.0.0.1"

app = FastAPI()
app.include_router(subway_router,prefix="/subway",tags=["subway"])

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app,host=ip,port=8000,limit_max_requests=1024*1024*10)