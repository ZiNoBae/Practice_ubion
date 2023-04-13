import pandas as pd 
import numpy as np 
import matplotlib.pyplot as plt
from datetime import datetime

# class 선언
class Invest : 

    # 생성자 함수 
    def __init__(self, _df, _col ) :
        
        #self 변수는 클래스 각각의 독립적인 변수 
        self.df = _df
        self.col = _col




    # 1번 함수 생성

    # 수정종가든, 종가든 다 되게 해보자
    # 매개변수 추가 self.col


    # 매개변수 추가 start , end


    def create_band(self, start, end) :

        #인덱스를 시계열로 변경
        self.df.index = pd.to_datetime(self.df.index)

        # start, end를 시계열로 변경
        start = datetime.strptime(start, '%Y%m%d').isoformat()
        end = datetime.strptime(end, '%Y%m%d').isoformat()

        
        self.df = self.df.loc[~self.df.isin([np.nan, np.inf, -np.inf]).any(axis='columns'), [self.col]]
        self.df['center'] = self.df.rolling(20).mean()
        self.df['ub'] = self.df['center'] + (2* self.df[self.col].rolling(20).std())
        self.df['lb'] = self.df['center'] - (2* self.df[self.col].rolling(20).std())
        
        # 데이터를 시작시간부터 종료시간까지 필터
        self.df = self.df.loc[start : end]
        return self.df 


    def add_trade(self) :
        # 기준이 되는 컬럼이 무엇인가 ? 
        # 기준이 되는 컬럼은 컬럼 중에 첫번째 이기 때문 : self.df.columns[0]
        
        self.col = self.df.columns[0]

        # trade 파생변수 생성 
        self.df['trade'] = ""
        for i in self.df.index : 
        # 상단 밴드보다 종가가 높은 경우
            if self.df.loc[i, self.col] > self.df.loc[i, 'ub']:
            # 현재 구매 상태이면(전날 'trade'가 'buy')
                if self.df.shift(1).loc[i, 'trade'] == 'buy' : 
                #매도
                    self.df.loc[i, 'trade'] = ''
                else : 
                    self.df.loc[i, 'trade'] = ''
        # 하단 밴드보다 종가가 낮은 경우
            elif self.df.loc[i, self.col] < self.df.loc[i, 'lb'] : 
            # 현재 구매상태이면,
                if self.df.shift(1).loc[i, 'trade'] == 'buy' :
                # 구매 상태를 유지 
                    self.df.loc[i, 'trade'] = 'buy'
                else : 
                #매수
                    self.df.loc[i, 'trade'] = 'buy'

            else :
            # 현재 구매상태이면
                if self.df.shift(1).loc[i , 'trade'] == 'buy' : 
                    self.df.loc[i, 'trade'] = 'buy'
                else :
                    self.df.loc[i, 'trade'] = ''
        
        
        return self.df


    # 세번째 함수 생성

    def add_rtn(self) :

        self.col = self.df.columns[0]

        
        rtn = 1.0
        self.df['return'] = 1
        buy = 0.0
        sell = 0.0

        for i in self.df.index :
        # 구매가 출력
            if (self.df.shift(1).loc[i, 'trade'] == '') and (self.df.loc[i, 'trade'] == 'buy') :
                buy = self.df.loc[i, self.col]
            
        # 판매가 출력
            elif (self.df.shift(1).loc[i, 'trade'] == 'buy') and (self.df.loc[i, 'trade'] == '') :
                sell = self.df.loc[i, self.col]
                rtn = (sell-buy) / buy + 1
                self.df.loc[i, 'return'] = rtn
            

        # 구매가, 판매가 초기화 
            if self.df.loc[i, 'trade'] == '':
                buy = 0.0
                sell = 0.0


        acc_rtn = 1.0

        for i in self.df.index :
            rtn = self.df.loc[i, 'return']
            acc_rtn *= rtn
            self.df.loc[i, 'acc_rtn'] = acc_rtn

        

        print('누적수익률 : ', acc_rtn)
        return self.df