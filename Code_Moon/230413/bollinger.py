import pandas as pd 
import numpy as np 
import matplotlib.pyplot as plt
from datetime import datetime

# class ddd




# 1번 함수 생성

# 수정종가든, 종가든 다 되게 해보자
# 매개변수 추가 col


# 매개변수 추가 start , end


def create_band(df, col, start, end) :

    #인덱스를 시계열로 변경
    df.index = pd.to_datetime(df.index)

    # start, end를 시계열로 변경
    start = datetime.strptime(start, '%Y%m%d').isoformat()
    end = datetime.strptime(end, '%Y%m%d').isoformat()

    
    df = df.loc[~df.isin([np.nan, np.inf, -np.inf]).any(axis='columns'), [col]]
    df['center'] = df.rolling(20).mean()
    df['ub'] = df['center'] + (2* df[col].rolling(20).std())
    df['lb'] = df['center'] - (2* df[col].rolling(20).std())
    
    # 데이터를 시작시간부터 종료시간까지 필터
    df = df.loc[start : end]
    return df 


def add_trade(df) :
    # 기준이 되는 컬럼이 무엇인가 ? 
    # 기준이 되는 컬럼은 컬럼 중에 첫번째 이기 때문 : df.columns[0]
    
    col = df.columns[0]

    # trade 파생변수 생성 
    df['trade'] = ""
    for i in df.index : 
    # 상단 밴드보다 종가가 높은 경우
        if df.loc[i, col] > df.loc[i, 'ub']:
        # 현재 구매 상태이면(전날 'trade'가 'buy')
            if df.shift(1).loc[i, 'trade'] == 'buy' : 
            #매도
                df.loc[i, 'trade'] = ''
            else : 
                df.loc[i, 'trade'] = ''
    # 하단 밴드보다 종가가 낮은 경우
        elif df.loc[i, col] < df.loc[i, 'lb'] : 
        # 현재 구매상태이면,
            if df.shift(1).loc[i, 'trade'] == 'buy' :
            # 구매 상태를 유지 
                df.loc[i, 'trade'] = 'buy'
            else : 
            #매수
                df.loc[i, 'trade'] = 'buy'

        else :
        # 현재 구매상태이면
            if df.shift(1).loc[i , 'trade'] == 'buy' : 
                df.loc[i, 'trade'] = 'buy'
            else :
                df.loc[i, 'trade'] = ''
    
      
    return df


# 세번째 함수 생성

def add_rtn(df) :

    col = df.columns[0]

    
    rtn = 1.0
    df['return'] = 1
    buy = 0.0
    sell = 0.0

    for i in df.index :
    # 구매가 출력
        if (df.shift(1).loc[i, 'trade'] == '') and (df.loc[i, 'trade'] == 'buy') :
            buy = df.loc[i, col]
        
    # 판매가 출력
        elif (df.shift(1).loc[i, 'trade'] == 'buy') and (df.loc[i, 'trade'] == '') :
            sell = df.loc[i, col]
            rtn = (sell-buy) / buy + 1
            df.loc[i, 'return'] = rtn
           

    # 구매가, 판매가 초기화 
        if df.loc[i, 'trade'] == '':
            buy = 0.0
            sell = 0.0


    acc_rtn = 1.0

    for i in df.index :
        rtn = df.loc[i, 'return']
        acc_rtn *= rtn
        df.loc[i, 'acc_rtn'] = acc_rtn

    

    print('누적수익률 : ', acc_rtn)
    return df