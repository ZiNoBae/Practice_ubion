# csv 파일 로드
df = read.csv('./Code_Moon/csv/example.csv')
df
# 상위 n개
head(df, 3)

# 하위 n개 출력
tail(df)
tail(df, 3)

# 뷰어창에 df 확인
View(df)
view(df) # error 조심하세요 함수로 받습니다

# 데이터프레임크기 출력
dim(df)

# df에 기초통계량
summary(df)

# df의 정보를 출력 ( = info() of Python)
str(df)

library(dplyr)

# 컬럼의 이름 변경(after = before) -> python : (before = after)형태로 썻음
rename(df, '이름' = Name) 

# csv_exam 파일 로드

df = read.csv("Code_Moon/csv/csv_exam.csv")
df

View(df)

# 새로운 파생변수 하나 생성
  # 전체 점수의 합계 (total_score)
  # 전체 점수의 평균 (mean_score)

df$toal_score = df[['math']] + df[['english']] + df[['science']]
df
df$mean_score = (df[['math']]+df[['english']]+df[['science']])/3
View(df)

# MOON
total_score = df$math + df[['english']] + df[[5]] # 다양한방식으로 각 컬럼을 필터링

cbind(df, total_score)
data.frame(df, total_score)
df$total_score = total_score


df$mean_score = df$total_score/3
df

# 평균 점수가 60 점 이상이면 pass, 아니면 fail
# res 컬럼을 생성
# ifelse(조건식, True값, False값)

ifelse(df$mean_score >= 60, 'pass', 'fail')
df$res <- ifelse(df$mean_score >= 60, 'pass', 'fail')
df


# 1학년 중에 평균 점수가 가장 높은 삶의 정보를 출력

df[df$class == 1, ] -> df1
df1
df2 = df1[order(df1$mean_score, decreasing = TRUE),]
df2

df2[1,]
head(df2,1)

# dplyr 패키지를 사용

df = read.csv('Code_Moon/csv/csv_exam.csv')
df

#pipe %>% : python의 .함수에서 . 역할인듯. 
  # 뒤에오는 함수의 매개변수를 입력하지 않아도 돼
  # 앞에서 파이프로 그대로 가져왔음

# filter
df %>% filter(class == 1)

# 정렬
  #오름차순
df %>% arrange(math)

  #내림차순
df %>%  arrange(-math)
df %>% arrange(desc(math))

#정렬의 기준이 여러개인 경우
df %>% arrange(math, english)

df %>%  arrange(desc(class), math)
df %>%  arrange(-class, math)

# 특정 컬럼만 출력
df %>% select(math)
select(df, math)

# 파이프 %>% 는 여러함수를 한번에 쓸 수 있게 한다. 
df %>% arrange(desc(class)) %>% select(math, english)

# 특정 컬럼만 삭제
df %>% select(-id)

# 파생변수 생성
df %>% mutate(total_score = math + english + science, mean_score = total_score/3) -> df

df %>%
  filter(class == 1) %>%
  arrange(desc(mean_score)) %>%
  head(1)

# group화 summarise()
df %>%  group_by(class) %>% 
  summarise(mean_math = mean(math),
            mean_english = mean(english)) %>% 
              arrange(desc(mean_math)) %>% 
  head(1)


# join

df1 = data.frame(id = 1:5,
                 score = c(80, 70, 40, 60, 50))
df2 = data.frame(id = 1:5,
                 weight = c(80, 65, 70, 55, 90))
df3 = data.frame(id = 1:3,
                 class = c(1, 1, 2))
inner_join(df1, df2, b= 'id')
inner_join(df1, df3, by = 'id')
left_join(df1, df3, by = 'id')
right_join(df1,df3, by = 'id')

# 유니언 결합 (python : concat())
rbind(df1,df2) # 컬럼이름이 다르기에 error !
                # rbind는 컬럼이름과 컬럼 수가 동일해야해 조건 빡빡함
 
# 그래도 합치고 싶어?
bind_rows(df1,df2)
