## sav 파일 로드 
install.packages('foreign')
install.packages('readxl')

library(foreign)
library(readxl)

welfare = read.spss('Code_Moon/csv/Koweps_hpc10_2015_beta1.sav',
                    to.data.frame = T)
welfare = rename(welfare, 
                 gender = h10_g3,
                 birth = h10_g4,
                 marriage = h10_g10,
                 religion = h10_g11,
                 income = p1002_8aq1,
                 code_job = h10_eco9,
                 code_region = h10_reg7)

welfare %>%
  select(gender,birth, marriage, religion,
         income, code_job, code_region) -> welfare_copy

welfare_copy %>%  head()

# 성별 컬럼 데이터를 확인 

table(welfare_copy$gender)

ifelse(welfare_copy$gender==1, 'male', 'female')->welfare_copy$gender

table(welfare_copy$gender)

# 성별을 기준으로 월급이 평균이 어떻게 되는지 
welfare_copy %>% head()

# income 이 0이면, 수익이 존재하지 않는다. -> 결측치로 변경
# income이 99면, 극단치로 간주 -> 결측치로 변경 
ifelse(welfare_copy$income ==0 |welfare_copy$income==9999,
       NA,
       welfare_copy$income) -> welfare_copy$income

#결측치를 확인
table(is.na(welfare_copy$income))

# Try it
  #income의 결측치를 제외하고
  #성별로 그룹화
  #income평균 출력
  # 시각화 

  #Moon
welfare_copy %>% 
  filter(!is.na(income)) %>% 
  group_by(gender) %>% 
  summarise(mean_income = mean(income))-> gender_income

  ## 시각화
    # 1. 배경설정
ggplot(data = gender_income, 
       aes(x = gender, y = mean_income)) 
      + geom_col() # 2. 그래프 종류
      


#나이별 월급의 차이가 존재하는가 ? 

  # 결측치 제거
  # 파생변수 나이 생성
  # 나이로 그룹화
  # income 평균

welfare_copy %>% 
  mutate(age = 2023 - birth) %>% 
  filter(!is.na(income)) %>% 
  group_by(age)%>%
  summarise(age_income_mean = mean(income)) %>% 
  arrange(-age_income_mean) -> ageincome_mean

ggplot(data = ageincome_mean,
       aes(x = age, y = age_income_mean)) +
       geom_line()

# 연령대를 추가 
# age나이가 30미만이면 'young',
# 30이상 60미만이면 'middle'
# 60이상이면 'old'
# 연령대별 월급의 평균이 어떻게 되는가 ? 
# 시각화(막대그래프 geom_col())

  #ZiNo
welfare_copy %>% 
  mutate(age = 2023 - birth) -> welfare_copy

ifelse(welfare_copy$age < 30, 'young',
       ifelse(welfare_copy$age<60,'middle', 'old'))->welfare_copy$generation

welfare_copy %>% 
  filter(!is.na(income)) %>% 
  group_by(generation) %>% 
  summarise(gen_income_mean = mean(income))->genincome_mean

ggplot(data = genincome_mean,
       aes (x = generation, y = gen_income_mean)) +
        geom_col() +
  scale_x_discrete(limits = c('young', 'middle', 'old')) # Moon, x 순서 바꾸기

  # Moon
welfare_copy %>% 
  mutate(age = 2023-birth) %>% 
  mutate(ageg = ifelse(age<30, 'young',
                       ifelse(age<60,'middle', 'old'))) %>% 
  group_by(ageg) %>% 
  summarise(income_mean = mean(income, na.rm=T)) %>%  ageg_income

# 연령대, 성별 월급 평균 
welfare_copy %>% 
  filter(!is.na(income)) %>% 
  group_by(generation, gender) %>% 
  summarise(income_mean = mean(income))-> gen_gender_income

ggplot(data = gen_gender_income,
       aes(x = generation, y = income_mean, fill = gender))+
  geom_col(position = 'dodge') +
  scale_x_discrete(limits = c('young', 'middle', 'old'))

# 나이, 성별 월급의 평균을 비교 
welfare_copy %>% 
  filter(!is.na(income)) %>% 
  group_by(age, gender) %>% 
  summarise(income_mean = mean(income))-> age_gender_income

ggplot(data = age_gender_income, 
       aes(x = age, y = income_mean, color = gender))+
  geom_line()

# 직업별로 평균 월급이 어떻게 되는가? 
list_job = read_excel('./Code_Moon/csv/Koweps_Codebook.xlsx', sheet = 2, col_names = T)

# 두개의 df을 join 결합 

left_join(welfare_copy, list_job, "code_job") -> welfare_copy

## 직업별 평균 월급 
## 직업이 결측치 이고 , 월급이 결측치인 경우 제거
## 직업을 기준으로 그룹화
## 월급의 평균값 

# ZiNo
welfare_copy %>% 
  filter(!is.na(income) & !is.na(job)) %>% 
  group_by(job) %>% 
  summarise(income_mean = mean(income)) %>% 
  arrange(desc(income_mean)) %>% head(10) -> job_income_mean_top

welfare_copy %>% 
  filter(!is.na(income) & !is.na(job)) %>% 
  group_by(job) %>% 
  summarise(income_mean = mean(income)) %>% 
  arrange(desc(income_mean)) %>% tail(10) -> job_income_mean_bottom

ggplot(data = job_income_mean_top,
       aes(x = reorder(job), y = income_mean)) +
  geom_col() 
 


ggplot(data = job_income_mean_bottom,
       aes(x = job, y = income_mean)) +
  geom_col() +
  scale_x_discrete(limits = c('가사 및 육아 도우미',
                              '임업관련 종사자',
                              '기타 서비스관련 단순 종사원',
                              '청소원 및 환경 미화원',
                              '약사 및 한약사',
                              '작물재배 종사자',
                              '농립어업관련 단순 종사원',
                              '의료 복지 관련 서비스 종사자',
                              '음식관련 단순 종사원',
                              '판매관련 단순 종사원'))
  

# Moon

welfare_copy %>% 
  filter(!is.na(income) & !is.na(job)) %>% 
  group_by(job) %>% 
  summarise(income_mean = mean(income)) %>% 
  arrange(desc(income_mean)) -> moon_job_income

# 상위 10개 직업군 시각화
  # x = reorder(x변수, 기준) -> 어떤 기준으로 x변수의 순서를 재배열 (오름,내림)
  # coord_flip() : x와 y위치 바꿔서 눕힌 바그래프 표현

ggplot(data = head(moon_job_income, 10),
       aes(x = reorder(job, -income_mean), y = income_mean)) +
  geom_col() +
  coord_flip()

# 하위 10개 직업군 시각화화
ggplot(data = tail(moon_job_income, 10),
       aes(x = reorder(job, income_mean), y = income_mean)) +
  geom_col() +
  coord_flip()


# 성별 기준 직업 수 count -> 상위 10개 출력
welfare_copy %>% 
  filter(!is.na(job) & gender == 'male') %>% 
  group_by(job) %>% 
  summarise(count = n()) %>% 
  arrange(desc(count)) %>% 
  head(10)

welfare_copy %>% 
  filter(!is.na(job) & gender == 'female') %>% 
  group_by(job) %>% 
  summarise(count = n()) %>% 
  arrange(desc(count)) %>% 
  head(10)

### marriage : 3인 경우 이혼
# 파생변수 생성 : group_marriage
# marriage가 3이면 divorce
# marriage가 1이면 marriage
# 연령대별 이혼율 출력 -> 시각화까지

# ZiNo -> give up
ifelse(welfare_copy$marriage == 3, 'divorce', 
       ifelse(welfare_copy$marriage == 1, 
              'marriage', NA)) -> welfare_copy$group_marriage

welfare_copy %>% 
  filter(!is.na(group_marriage)) %>% 
  group_by(generation) %>% 
  summarise(table('divorce')/(table('divorce')+table('marriage'))*100)


welfare_copy %>% 
  filter(!is.na(group_marriage)) %>% 
  group_by(group_marriage,generation) %>% 
  summarise()

welfare_copy %>% 
  filter(!is.na(group_marriage)) %>% 
  group_by(generation, group_marriage) %>% 
  summarise('marriage')/(sum('marriage')+sum('divorce')))

# Moon 
ifelse(welfare_copy$marriage == 3, 'divorce', 
        ifelse(welfare_copy$marriage == 1, 
               'marriage', NA)) -> welfare_copy$group_marriage

welfare_copy %>% 
  filter(!is.na(group_marriage)) %>% 
  group_by(generation, group_marriage) %>% 
  summarise(count = n()) %>% 
  mutate(total_count = sum(count)) %>%  
  mutate(pct = count/total_count*100)
