from fastapi import FastAPI

ip = "127.0.0.1"

app = FastAPI()

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app,host=ip,port=8000,limit_max_requests=1024*1024*10)