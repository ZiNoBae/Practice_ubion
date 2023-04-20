# 벡터 데이터를 생성
a = c(1,2,3,4,5)
a
1:5 -> b
b
a = c(1,'test') # 같은 타입이어야 해서 1이 문자열로 들어감 
a

# 행렬 (dim = dimension) 4 x 5 행렬
d = array(1:20, dim = c(4,5))
d
e = matrix(1:20, nrow = 2)
e

# list형태 data(python의 dictionary 형태와 유사)
f = list(name = 'test', age = '20', phone = '01012345677')
f[1]
f['name']

# 데이터프레임
df = data.frame(name = c('test', 'test2'),
                age = c(20, 30),
                phone = c('01012345654', '01089322478'))
df

# 조건문 : if ~ {} 
a<-10
if(a>15){
  print('a는 15보다 크다')
}else{
  print('a는 15보다 작거나 같다')  
}

  # 조건식 여러개 
z = 15
if (z > 15){
  print('z는 15보다 크다')
}else if (z == 15){
  print('z는 15다')
}else{
  print('z는 15보다 작다')
}


# which문 (유사 w/ find() of python)

name = c('test', 'test2', 'test3')
which(name == 'test2')
which(name != 'test2')
which(name == 'test4')


# Package 설치 
# 1. insatall ~ 
install.packages('dplyr')

# 2. R_studio
  # packages - install 순으로

# package 로드 
  # 1. 아래처럼 library() 하거나
library(dplyr)
  #2. 우측하단 r_studio에서 체크박스 체크하거나

View(df)


# 연산자 생성

'%s%' = function(x,y){
  result = x + y
  return(result)
}
5%s%3


# 함수 생성

func_1 = function(){
  print('Hello World')
}
func_1()
func_1()

func_2 = function(x,y){
  result = x^y
  return(result)
}
func_2(5,2)

# 함수에 매개변수에 기본값을 지정

func_3 = function(x, y=3){
  result = x - y
  return(result)
}
func_3(5)
func_3(y=5,x=1)

# 데이터프레임 

name = c('test', 'test2', 'test3', 'test4') #벡터 데이타
grade = c(1,3,2,1)                  # 벡터 데이터

student = data.frame(name, grade)
student

# 행렬
midterm = c(70, 80, 60, 90)
final = c(60, 90, 80, 90)

score = cbind(midterm,final)

score

total_score = midterm + final  # 벡터 + 벡터 = 벡터
total_score

# 데이터프레임 생성시 행렬이든, 데이터프레임이든, 벡터든 조건만 맞다면
  # 데이터프레임으로 연결 가능 !! 
# student 데이터프레임, score 행렬, total_score 벡터 
  # 각각 다른 형태 데이터프레임으로 연결 가능 !

students = data.frame(student, score, total_score )
students

#gender 컬럼을 추가 
  # 방법1. cbind
gender = c("F", "M", "M", "F")
cbind(students, gender)

  # 방법2. 형식만 맞으면 data.frame()
data.frame(students, gender)

  # 방법3. 데이터프레임에 파생변수를 생성
students$gender = gender
students

# 컬럼을 하나만 출력
students$midterm
students[["midterm"]]
students

# 열을 추가해보자
new_student = data.frame(
  name = "test5",
  grade = 3,
  midterm = 80,
  final = 60,
  gender = "F",
  total_score = 140
)
new_student

# df끼리 합치면?

rbind(students, new_student)-> students


# df의 필터림
students[1]
students[1,]

students[c(2,4)]
students[c(2,4),]

students[1:3]
students[1:3,]

students[-1]
students[-1,] # index 1을 제외한 나머지 index의 값들

#특정 조건을 이용해서 필터링

  # 학년이 2학년 이상
students[['grade']] >= 2
students[students[['grade']] >= 2, ]

  # 중간성적이 70 이상이고 기말의 성적이 90이상인 학생들 정보 출력
students[['midterm']] >= 70
students[['final']] >= 90

students[['midterm']] >= 70 & students[['final']] >= 90 -> flag
students[flag, ]

students

students[flag] # 이건 왠지 모르겟네, 뜬금포로 grade가 왜 출력되지 
students[flag, ] #이게 우리가 원하는 것

# 정렬 변경
  #오름차순
order(students$grade)
students[order(students$grade), ]
  #내림차순
students[order(students$grade, decreasing = TRUE),]
students[order(-students$grade), ]

