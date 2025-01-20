import requests
from pprint import pprint
from flask import Flask, request, jsonify
import configparser
import urllib.parse
from flask_cors import CORS


app = Flask(__name__)
CORS(app)  # 모든 출처에서의 요청을 허용

URL = "http://apis.data.go.kr/1160100/service/GetASLundService/getAutomobileLundinfo"

config = configparser.ConfigParser()
config.read('./config.ini')

API_KEY = config['DEFAULT']['API_KEY']  # API 키 가져오기

def search_car(carNum):
    pageNo = 1
    param = {
    "serviceKey": API_KEY,
    "nowVhclNo": carNum,
    "pageNo": pageNo,  
    "numOfRows": 10,
    "resultType": "json"
    }

    res = requests.get(url=URL, params=param, verify=False) 
    
    result = res.json()
    
    return result

def parse_result(result):
    items = result['response']['body']['items']
    data = items['item']
    
    if data:
        acdnOccrDtm = data[0]['acdnOccrDtm'].split(' ')
    
        data[0]['acdnOccrDtm'] = acdnOccrDtm[0]
        
    return data
    
@app.route('/api/cars', methods=['GET'])
def get_car_info():
    car_num = request.args.get('carNum')  # URL 쿼리 파라미터에서 차량 번호를 가져옴
    if car_num:
        # 여기서 차량 번호에 대한 정보를 처리하는 로직을 추가할 수 있습니다.
        result = search_car(car_num)
        data = parse_result(result)
        pprint(data)
        if data == []:
            return jsonify({"nowVhclNo": car_num, "acdnKindNm": "정상"}), 200
        else:
            return jsonify(data[0]), 200
    else:
        return jsonify({"error": "Not Found Car Number"}), 400
        

if __name__ == "__main__":
    app.run(host="0.0.0.0", port="5000", debug=False)
