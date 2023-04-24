# class 선언 : Halloween

# class 속성(변수)
# 생성자 함수에서 데이터프레임, 시작연도, 종료연도  3개의 매개변수
# self변수를 생성, self.acc_rtn 변수는 1 로 고정 


# 1st function
# 누적수익률 계산하는 함수(accrtn)

# 3nd function
# CAGR 계산하는 함수(cagr) (투자 기간은 종료 연도 - 시작 연도)
# --------------------
import pandas as pd
from datetime import datetime


# class

class Halloween :
    
    # 변수
    def __init__(self, df, start, end) : 
        self.df = df
        self.start = start
        self.end = end
        self.acc_rtn = 1

    # 1st : accrtn
    def accrtn(self) : 
        if 'Date' in self.df.columns :
            self.df['Date'] = pd.to_datetime(self.df['Date'], format = '%Y-%m-%d')
            self.df.set_index('Date', inplace=True)

        for i in range(self.start, self.end):

            self.buy_mon = str(i) + '-11'
            self.sell_mon = str(i+1) + '-04'

            self.buy = self.df.loc[self.buy_mon].iloc[0]['Open']
            self.sell = self.df.loc[self.sell_mon].iloc[-1]['Close']

            self.rtn = (self.sell - self.buy)/self.buy + 1

            self.acc_rtn *= self.rtn

        return self.acc_rtn
            
    # 2nd : CAGR
    def cagr(self) :
        self.due = self.end - self.start
        self.CAGR = (self.acc_rtn ** (1/self.due)) - 1
        return self.CAGR * 100
        
    
