# 라이브러리 로드
from flask import Flask, render_template, request, redirect, jsonify
import pandas as pd
# Flask 클래쓰 생성
# __name__ : 현재 파일의 이름
app = Flask(__name__)

# api 생성

# 네비게이션 함수 
# 해당하는 주소로 요청이 들어왔을 때, 아래의 함수를 실행  
# localhost(127.0.0.1) -> 자기 자신의 컴퓨터
# localhost:3000/  요청 시 아래의 함수를 실행



@app.route("/") # 
def index() :    # 함수이름은 뭐든 상관없음
    return render_template('index.html')

@app.route("/second")
def second() :
    return render_template("second.html")

# post형태의 api 생성
@app.route("/login", methods=['post'])
def login() :
    # 유저가 보낸 데이터를 변수에 대입
    id = request.form['_id']
    password = request.form['_pass']
    print(id, password)
    if (id == "test") and (password == "1234"):
        return render_template("main.html", _id = id)
    else:
        return redirect("/") 
    
@app.route("/corona")
def corona():
    # get형태에서 데이터를 받아서 변수에 대입
    servicekey = request.args['servicekey']
    if servicekey == 'aaa' :
        df = pd.read_csv('../csv/corona.csv')
        json_data= df.to_json()
        return jsonify(json_data)
    else:
        return "serveice error"

app.run(port = 3000)  