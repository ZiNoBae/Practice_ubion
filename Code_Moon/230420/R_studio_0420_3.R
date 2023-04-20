# 결측치에 대한 계산
# 결측치는 연산이 되지 않는다
# 필터를 걸게되면 무조건 출력

c1 = c(1,2, NA, NA, 5)
c2 = c(1,2,3,4,5)
c3 = c(NA, 2,3,4,5)

df = data.frame(c1, c2, c3)
df

df %>% filter(c1 > 3)
df$c1 >3


# 결측치 확인하는 방법
is.na(df)
table(is.na(df)) # table() : True 갯수세기 value_counts() of PY 같은 것

is.na(df$c1)

# dplyr 패키지를 이용하여 결측치를 제거한 데이터 확인

df %>% filter(!is.na(c1))


na.omit(df) #NA가 있는 index를 모두 삭제 


# 결측치를 제외하고 연산 
mean(df$c1) # NA 결과나옴
mean(df$c2) # NA 없기에, mean값 나옴
mean(df$c3) # NA 가 있기에, NA라 나옴 

#NA 하나라도 있으면, 연산 불가
# NA 제외 후 연산 : 연산(안에 있는 매개변수 na.rm = T) --- rm : remove
mean(df$c1, na.rm = T)


exam = read.csv('Code_Moon/csv/csv_exam.csv')

exam[c(5,7), 3] = NA
exam

# Try it ! 
  # 수학 점수의 평균값
  # 결측치인 값을 수학 점수의 평균을 대체
  # ifelse()함수를 이용하여 결측치에 수학점수의 평균값을 대입

mean_math = mean(exam$math, na.rm = T)

ifelse(is.na(exam$math), mean_math, exam$math) -> exam$math
exam


# 이상치 
outlier = data.frame(gender = c(1,2,1,2,3),
                     score = c(80,90,70,80,50))
outlier 

# gender가 3인 데이터는 이상치로 체크

  # gender가 1 아니면 2인 경우에만 데이터를 출력
    # base함수를 이용하는 경우
outlier[outlier$gentder == 1 | outlier$gender ==2,]  # Check QQQQQQQQQQQ

    #dplyr 패키지 사용하는 경우
outlier %>% filter(gender == 1 | gender==2)


  # gender 가 1과 2가 아니면 결측치로 변경
# ZiNo : outlier %>% filter(gender!=1 & gender!=2)
  # 이거 자체가 True False로 나오지 않아 조건식으로 부적합
# ZiNo : ifelse(outlier %>% filter(gender!=1 & gender!=2), NA ,gender)

# Moon_Sol
ifelse(outlier$gender != 1 & outlier$gender != 2, NA, outlier$gender)
ifelse(outlier$gender %in% c(1,2), outlier$gender, NA)

outlier$gender[outlier$gender !=1 & outlier$gender !=2] <- NA
outlier
  # 결측치를 제거 : na.omit()
na.omit(outlier)

outlier %>% filter(!is.na(gender))
