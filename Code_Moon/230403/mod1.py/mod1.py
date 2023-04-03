# moon_sol

def custom_mean(*_list) :
    # while문
    # 초기값 설정
    i = 0
    sum = 0  # 합계 변수

    while i < len(_list) : 
        # print(_list[i])
        
        sum += _list[i]        
       
        # i값을 증가
        i += 1


def custom_max(*_list) :
    result = _list[0]

    for i in _list : 
        if result < i :
            result = i
    return result