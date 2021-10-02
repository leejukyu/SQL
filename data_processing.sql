-- 실습 3) 주문 데이터로 데이터 가공하기 연습
-- 2021년 6월 1일 하루동안의 주문 건
-- 실제 존재하는 패션 이커머스 데이터라고 생각하고 분석을 진행해 주세요!


-- 1. 원하는 형식으로 컬럼 가공하기--------------------------------------------------------------

-- a) 숫자를 문자열로 바꿔주기
select dt, cast(dt as char) as yyyymmdd # cast : 바꾸다
from online_order oo

-- b) 문자열 컬럼에서 일부만 잘라내기

select dt, left(cast(dt as char), 4) as yyyy,
substring(cast(dt as char),5,2) as mm, 
right(cast(dt as char), 2) as dd
from online_order oo 

-- c) yyyy-mm-dd 형식으로 이어주기

select dt,
concat(
left(cast(dt as char), 4), '-',
substring(cast(dt as char),5,2) ,'-',
right(cast(dt as char), 2) ) as yyyymmdd
from online_order oo

-- d) null 값인 경우 임의값으로 바꿔주기

select oo.userid, coalesce (oo.userid, 'NA') # null이면 'NA'를 출력
from online_order oo 
left join user_info ui on oo.userid = ui.userid

select coalesce (ui.gender , 'NA') as gender, coalesce (ui.age_band, 'NA') as age_band, sum(oo.gmv) as gmv
from online_order oo 
left join user_info ui on oo.userid = ui.userid
group by 1, 2
order by 1, 2

-- e) 내가 원하는 컬럼 추가해보기

select distinct case when gender = 'M' then '남성' 
					when gender = 'F' then '여성' 
					else 'NA' end as gender # case when == if
from user_info ui 

-- f) 연령대 그룹 만들어보기 (20대, 30대, 40대)

select
case 	when ui.age_band = '20~24' then '20s'
		when ui.age_band = '25~29' then '20s'
		when ui.age_band = '30~34' then '30s'
		when ui.age_band = '35~39' then '30s'
		when ui.age_band = '40~44' then '40s'
		when ui.age_band = '45~49' then '50s'
		else 'NA'
		end as age_group
, sum(gmv) as gmv
from online_order oo 
left join user_info ui on oo.userid = ui.userid 
group by 1
order by 1

-- g) TOP3 카테고리와 그 외 상품의 매출액 비교하기
select 
case when cate1 in ('스커트', '티셔츠', '원피스') then 'Top3'
else '기타' end as item_type
,sum(gmv) as gmv
from online_order oo 
join item i on oo.itemid = i.id
join category c on i.category_id = c.id 
group by 1
order by 2 desc

-- h) 특정 키워드가 담긴 상품과 그렇지 않은 상품의 매출 비교하기 (+item 개수도 같이 확인!)
select item_name,
case when item_name like '%깜찍%' then '깜찍 컨셉' # 깜찍과 시크가 동시에 있으면 첫번째 조건에 치환
	when item_name like '%시크%' then '시크 컨셉'
	when item_name like '%청순%' then '청순 컨셉'
	when item_name like '%기본%' then '기본 컨셉'
	else '미분류'
	end as item_concept
from item
;
select case when item_name like '%깜찍%' then '깜찍 컨셉'
	when item_name like '%시크%' then '시크 컨셉'
	when item_name like '%청순%' then '청순 컨셉'
	when item_name like '%기본%' then '기본 컨셉'
	else '미분류'
	end as item_concept
, sum(gmv) as gmv
from online_order oo 
join item i on oo.itemid = i.id 
group by 1
order by 2 desc

-- 2. 날짜 관련 함수 활용하기--------------------------------------------------------------

-- a) 오늘을 나타내는 기본 구문

select now() # 현재 날짜, 시간

select curdate() # 현재 날짜(=current_date)

select current_timestamp() # 현재 날짜, 시간 

-- b) 날짜 형식에서 문자 형식으로 변환하기

select date_format(now(), '%y%m%d')

select date_format(now(), '%y-%m-%d') 

-- c) 날짜 더하기/빼기

select adddate(now(), interval 1 month) # = date_add() 

select date_sub(now(), interval 1 day)

-- d 날짜로부터 연도, 월, 주 확인하기

select month(now())

select year(now())

select week(now())

-- d) 최근 1년 동안의 매출액 확인하기

select *
from gmv_trend gt
where yyyy = year(date_sub(now(), interval 1 year)) and mm >= month(date_sub(now(), interval 1 year))
order by 2,3

-- 3. 할인률, 판매가, 이익률 계산하기
select c.cate1,
round(sum(cast(discount as float)) / sum(gmv),2) * 100 as discount_rate, # 할인률, %로 보기
sum(gmv) - sum(discount) as paid_amount, # 판매가
sum(cast(product_profit as float)) / sum(gmv) as product_magin, # 이익률
sum(total_profit) / sum(gmv) as total_margin
from online_order oo 
join item i on oo.itemid = i.id 
join category c on i.category_id = c.id
group by 1
order by 3 desc
# 계산식에 group by를 할 때는 분자, 분모 둘 다 sum

-- 4. 고객 관점에서의 분석 (인당 평균 구매수량 / 인당 평균 구매금액)

-- 100명의 고객이 구매를 하였고, 총 판매수량이 200개
-- 인당 평균 구매수량 = 총 판매수량 / 총 고객 수
-- 인당 평균 구매금액 = 총 구매금액 / 총 고객 수

-- 인당 구매수량이 높은 상품은?
select i.item_name 
, sum(unitsold) as unitsold 
, count(distinct userid) as user_count
, round(sum(cast(unitsold as float)) / count(distinct userid), 2) as avg_unitsold_per_customer
, round(sum(cast(gmv as float)) / count(distinct userid), 2) as avg_gmv_per_customer
from online_order oo 
join item i on oo.itemid = i.id
group by 1
order by 4 desc

-- 인당 구매금액이 높은 성/연령대는? (지난 실습에서, 단순 구매금액 총합으로는 20대 여성이 높았는데...!)
select gender, age_band, sum(gmv) as gmv, count(distinct oo.userid) as user_count
, sum(gmv) / count(distinct oo.userid) as avg_gmv_per_customer
from online_order oo 
join user_info ui on oo.userid = ui.userid 
group by 1, 2
order by 5 desc