import pandas as pd
import numpy as np
from datetime import datetime

# 1번 함수 
def func_1(x, col = 'Close', start = '20100101', end = '20230101') : 
    # Moon : df의 인덱스가 Date 아니면, Date컬럼을 인덱스로 변경
    if 'Date' in x.columns :
        x = x.set_index('Date')
    # start, end를 시계열로 변경
    start = datetime.strptime(start, '%Y%m%d').isoformat()
    end = datetime.strptime(end, "%Y%m%d").isoformat()   
    # 결측치&이상치 제거
    x = x.loc[~x.isin([np.nan, np.inf, -np.inf]).any(axis = 'columns')]
    # 수정종가를 제외한 나머지 컬럼 삭제
    x= x[[col]]
    # 인덱스를 시계열로
    x.index = pd.to_datetime(x.index, format = '%Y-%m-%d')
    x= x.loc[start : end]
    # STD-YM 컬럼 생성 
    x['STD-YM'] = list(map(lambda x : datetime.strftime(x, '%Y-%m'), x.index))

    return x 

# 2번 함수 : 월별 마지막날 추출 , 전월&전년 가격 컬럼 추가 
def func_2(x) :
    col = x.columns[0]
    y = x.loc[x['STD-YM'] != x.shift(-1)['STD-YM']] 

    #Moon   
    #  y = pd.DataFrame()
    # _list = x['STD_YM'].unique()
    # for i in _list : 
    #     last_df = df.loc[df['STD - YM'] == i].tail(1)
    #     y = pd.concat([y, last_df])
   
    y['BF_1M'] = y.shift(1)[col].fillna(0)
    y['BF_12M'] = y.shift(12)[col].fillna(0)

    return y

# 3번 함수 : df 2개 ! 
def func_3(df1, df2) : 
    df1['trade'] = ''
    df1['return'] = 1
    col = df1.columns[0]

    for i in df2.index : 
        signal = ''

        momentum_index = df2.loc[i, 'BF_1M'] / df2.loc[i, 'BF_12M'] -1
        
        flag = True if ((momentum_index > 0) & (momentum_index != np.inf) & (momentum_index != -np.inf)) else False

        if flag : 
            signal = 'buy'

        df1.loc[i, 'trade'] = signal

    rtn = 1.0
    buy = 0
    sell = 0

    for i in df1.index :
        if (df1.loc[i, 'trade'] == 'buy') & (df1.shift(1).loc[i, 'trade'] == '') :
            buy = df1.loc[i, col]
            print('구입일 : ', i, '구입 가격 : ', buy)
        elif (df1.loc[i, 'trade'] == '') & (df1.shift(1).loc[i, 'trade'] == 'buy') :
            sell = df1.loc[i, col]
            print('판매일 : ', i, '판매 가격 : ', sell)
        
            rtn = (sell - buy) / buy + 1
            df1.loc[i,'return'] = rtn

    acc_rtn = 1.0

    for i in df1.index : 
        acc_rtn *= df1.loc[i, 'return']
        df1.loc[i, 'acc_rtn'] = acc_rtn
    print(acc_rtn)

    return df1
