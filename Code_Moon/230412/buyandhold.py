import numpy as np


def bnh(x, col) : 
    x = x.loc[~x.isin([np.nan, np.inf, -np.inf]).any(1)]
    x = x[[col]]
    x['daily_rtn'] = x[col].pct_change()
    x['cumulative_rtn'] = (1 + x['daily_rtn']).cumprod()



    return x