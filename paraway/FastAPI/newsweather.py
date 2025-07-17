from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
import pymysql
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.common.by import By
from webdriver_manager.chrome import ChromeDriverManager
import time



router = FastAPI()
# CORS 설정 (Flutter에서 접속 가능하게)


@router.get("/news")
def get_news():
    titles = []
    contents = []
    chrome_options = webdriver.ChromeOptions()
    chrome_options.add_argument("--headless")  # 창 안 띄우기
    driver = webdriver.Chrome(
        service=Service(ChromeDriverManager().install()),
        options=chrome_options
    )
    driver.get("https://www.koti.re.kr/user/bbs/trfcNewsList.do")
    time.sleep(5)  # 페이지 로딩 대기

    headlines = []
    for i in range(1, 11):
        xpath = f'//*[@id="ui_contents"]/section[2]/div[2]/div[1]/div[2]/div[1]/ul/li[{i}]/a/p'
        elem = driver.find_element(By.XPATH, xpath)
        text = elem.text.strip()
        headlines.append({"title": text})

    driver.quit()

    return {"results": headlines}


@router.get("/newscontent")
def get_newscontent():
    chrome_options = webdriver.ChromeOptions()
    chrome_options.add_argument("--headless")
    driver = webdriver.Chrome(
        service=Service(ChromeDriverManager().install()),
        options=chrome_options
    )
    driver.get("https://www.koti.re.kr/user/bbs/trfcNewsList.do")
    time.sleep(5)

    results = []

    for i in range(1, 11):
        # 제목 가져오기
        xpath = f'//*[@id="ui_contents"]/section[2]/div[2]/div[1]/div[2]/div[1]/ul/li[{i}]/a/p'
        elem = driver.find_element(By.XPATH, xpath)
        title = elem.text.strip()

        # 클릭
        elem.click()
        time.sleep(1)

        # 상세 내용 가져오기
        content_xpath = '//*[@id="ui_contents"]/section[2]/div[2]/div[1]/div[2]/div/div[2]/dl/div/dd/div/div/div/div[2]/span[2]'
        content_elem = driver.find_element(By.XPATH, content_xpath)
        content = content_elem.text.strip()

        # 결과에 추가
        results.routerend({
            "title": title,
            "content": content
        })

        # 뒤로가기
        driver.back()
        time.sleep(1)

    driver.quit()
    return {"results": results}

@router.get("/weather")
def get_news():
    chrome_options = webdriver.ChromeOptions()
    chrome_options.add_argument("--headless")  # 창 안 띄우기
    driver = webdriver.Chrome(
        service=Service(ChromeDriverManager().install()),
        options=chrome_options
    )
    driver.get("https://weather.daum.net/?location-regionId=AI10000901&weather-cp=kweather")
    time.sleep(5)  # 페이지 로딩 대기

    weathers = []

    xpath = '//*[@id="fc7ac7d4-ea2b-4850-bfd1-4f1ba87a03af"]/div/div/div[2]/div'
    elem = driver.find_element(By.XPATH, xpath)
    text = elem.text.strip()
    weathers.append({"title": text})

    driver.quit()

    return {"results": weathers}


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(router, host="127.0.0.1", port=8000)

    

    #   cd /Users/gamseong/ParaWay/paraway/FastAPI
    #       source venv/bin/activate
    #       python main.py