import pymysql
import pandas as pd

class Database : 
    # 생성자 함수 
    def __init__(self, _host, _user, _pass, _db, _port) :
        self.db = pymysql.connect(
            user = _user,
            password= _pass,
            host = _host,
            db= _db,
            port= _port
        )

        self.cursor = self.db.cursor(pymysql.cursors.DictCursor)

    def sql_query(self, sql, values = []) :
        # if (sql.find("select") != -1) & (sql.find('select') < 10) :
        if (sql.replace('\n', '').strip().startswith('select')) : 
            self.cursor.execute(sql, values) # sql 쿼리문 실행
            result = self.cursor.fetchall() # 결과값 받아오기 
            result = pd.DataFrame(result)
        else :  # insert , update, delete, create
            self.cursor.execute(sql, values)
            self.db.commit()
            result = "Query OK"

        return result

    # 접속 끊는 작업 
    def sql_close(self) :
        self.db.close()