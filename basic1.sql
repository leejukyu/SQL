-- 실습 1) 거래액 데이터 분석
-- 2017년부터 2021년 3월까지의 전자상거래 추정거래액 (단위 : 백만원)
-- 내 회사의 거래액 데이터라고 생각해도 됨

-- 1) 데이터 탐색--------------------------------------------------------------

-- STEP 1) 모든 컬럼 추출하기
select *
from gmv_trend

-- STEP 2) 특정 컬럼 추출하기
select category , yyyy , mm 
from gmv_trend 

-- STEP 3) 중복값 없이 특정 컬럼 추출하기
select distinct category 
from gmv_trend

select distinct yyyy, mm 
from gmv_trend

-- 2) 특정 연도의 매출 탐색--------------------------------------------------------------

-- 2-1) 조건이 하나일 때 More Example
------ a) 숫자열 (between, 대소비교)

select *
from gmv_trend
where yyyy = 2021

select *
from gmv_trend
where yyyy >= 2019

select *
from gmv_trend
where yyyy between 2018 and 2020

select *
from gmv_trend
where yyyy != 2021

select *
from gmv_trend
where yyyy <> 2021

------ b) 문자열 (=, !=, like, in, not in)

select *
from gmv_trend
where category = '여행 및 교통서비스'

select *
from gmv_trend
where category != '여행 및 교통서비스'

select *
from gmv_trend 
where category in ('여행 및 교통서비스', '생활용품')

select *
from gmv_trend 
where category not in ('여행 및 교통서비스', '생활용품')

select *
from gmv_trend 
where category in ('여행 및 교통서비스', '생활용품')

select *
from gmv_trend 
where category like '%패션%'

select *
from gmv_trend 
where category not like '%패션%'

-- 2-2) 조건이 여러개일 때--------------------------------------------------------------
------ a) and 조건

select *
from gmv_trend
where category = '컴퓨터 및 주변기기'
and yyyy = 2021

------ b) or 조건

select *
from gmv_trend
where gmv > 1000000
or gmv < 10000

------ c) and, or 조건 혼용

select *
from gmv_trend
where (gmv > 1000000 or gmv < 100000)
and yyyy = 2021

-- 3) 카테고리별 매출 분석--------------------------------------------------------------

-- More Example) 카테고리별, 연도별 매출

select category, yyyy, sum(gmv) as total_gmv # as 생략 가능
from gmv_trend
group by category, yyyy

select category, yyyy, sum(gmv) as total_gmv # as 생략 가능
from gmv_trend
group by 1, 2 # select절의 첫 번째, 두 번째를 뜻함, 숫자로 쓰는게 편함

-- More Example) 전체 총합

select sum(gmv) as gmv, min(yyyy), max(yyyy), avg(gmv)
from gmv_trend
# 전체 총합은 group by 하지 않는다!!

-- group by + where 예시

select category, yyyy, sum(gmv) as total_gmv
from gmv_trend
where category = '컴퓨터 및 주변기기'
group by 1, 2 

-- 4)매출이 높은 주요 카테고리만 확인하기--------------------------------------------------------------

select category, sum(gmv) as total_gmv
from gmv_trend
group by 1
having sum(gmv) >= 50000000

-- More Example) where절이랑 같이 쓰기

select category, sum(gmv) as total_gmv
from gmv_trend
where yyyy = 2020
group by 1
having sum(gmv) >= 10000000
# where 집계 전 데이터 필터링
# having 집계 후 데이터 필터링

-- 5) 매출이 높은 순으로 카테고리 정렬하기--------------------------------------------------------------

select category, sum(gmv) as gmv
from gmv_trend
group by 1
order by gmv # 오름차순

select category, sum(gmv) as gmv
from gmv_trend
group by 1
order by gmv desc # 내림차순

-- 내림차순 Example

select category, yyyy , sum(gmv)
from gmv_trend
group by 1, 2
order by 1, 2 desc # 1은 오름차순, 2만 내림차순으로 정렬

select category, yyyy , sum(gmv)
from gmv_trend
group by 1, 2
order by 1 desc, 2 desc

-- [추가 예제 1] 복수의 컬럼으로 정렬

select yyyy, mm, sum(gmv) as gmv
from gmv_trend
group by 1, 2
order by 3 desc

-- [추가 예제 2] select 절에 없는 컬럼으로 정렬 가능할까? -> 불가능

select yyyy, sum(gmv) as gmv
from gmv_trend
group by 1
order by mm