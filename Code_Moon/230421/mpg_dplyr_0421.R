library(dplyr)
library(ggplot2)

# 극단치

View(mpg)

# 극단치를 확인
boxplot(mpg$cty)

# 극단치를 수치로 표현
boxplot(mpg$cty)$stats

mpg = ggplot2 :: mpg

# 이상치 는 26초과 or 9미만인 경우
#  이상치를 결측치로 변환
# 결측치의 갯수 확인


ifelse(mpg$cty > 26 | mpg$cty < 9, NA, mpg$cty) -> mpg$cty

table(is.na(mpg$cty))


# dplyr 패키지를 이용하여
# 결측치 제거
# 제조사별로 그룹화 - manufacturer
# 도심연비의 평균 - cty
# 도심연비가 좋은 상위 5개 제조사 확인

# ZiNo
na.omit(mpg)->mpg

summary(mpg)

mpg %>% group_by(manufacturer) -> mpg
mpg %>% summarise(mean_cty= mean(cty))->mpg_cty
mpg_cty

mpg_cty %>% arrange( desc(mean_cty)) %>% head(5)


# Moon

mpg %>% filter(!is.na(cty)) %>% 
  group_by(manufacturer) %>% 
  summarise(cty_mean = mean(cty)) %>% 
  arrange(desc(cty_mean)) %>% 
  head(5)

# mpg 초기화

mpg = ggplot2 :: mpg

# total 파생변수
#   total: (cty + hwy)/2

# test 파생변수
#   test : total이 30 이상이면 'A'
        #  total이 20이상 30미만시 'B'
        #  total이 20미만이면 'C'
# ZiNo
mpg %>% mutate(total = (cty + hwy)/2)->mpg
mpg

  # ZiNo 방법 1 
mpg$test = 'C'
ifelse(mpg$total >=30, 'A', mpg$test) -> mpg$test
ifelse(mpg$total >=20 & mpg$total <30, 'B', mpg$test) -> mpg$test
ifelse(mpg$total < 20, 'C', mpg$test) -> mpg$test
mpg

mpg %>% filter(test == 'A')

  # Zino 방법 2
ifelse(mpg$total >=30, 'A', 
       ifelse (mpg$total >=20 & mpg$total <30, 'B', 'C')) -> mpg$test
mpg
# Moon -> 2번째 ifelse의 조건중 30미만 적을 필요 없어, 
        # 이미 첫ifelse조건에서 걸러짐
ifelse(mpg$total >=30, 'A', 
       ifelse (mpg$total >=20, 'B', 'C')) -> mpg$test


qplot(mpg$test)




# midwest 데이터

midwest = ggplot2 :: midwest

# 컬럼의 이름을 변경
# rename(df명, 새컬럼의 이름(after) = 기존 컬럼이름(before))
# popasian -> asian,  poptotal -> total

# 파생변수 ratio : 전체인구수 대비 아시아의 인구수 (백분율)

# 파생변수 group : ratio평균보다 ratio 값이 크면 'large', 아니면 'small'


  # ZiNo
summary(midwest)

#rename(midwest, asian = popasian)->midwest
#rename(midwest, total = poptotal)->midwest
#Moon 
rename(midwest, asian = popasian, total = poptotal) ->midwest

midwest

midwest %>% mutate(ratio = (asian*100)/total)->midwest
midwest$ratio


mean(midwest$ratio)
#midwest$group = ''  # 얘는 없어도 아래때문에 자동으로 컬럼생김 

ifelse(midwest$ratio > mean(midwest$ratio), 'large', 'small')->midwest$group
midwest

# 시각화
qplot(midwest$group)
# 수치로
table(midwest$group)
