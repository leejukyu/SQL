-- 한 번 다듬어진 데이터가 필요할 때, 서브쿼리

-- 1. 가장 최근 주문일 데이터 골라보기
-- 1) 가장 최근 주문일 구하기 (max_order_date)
select max(order_date) as max_order_date 
from orders_csv oc

-- 2) 가장 최근 주문일에 해당하는 데이터 필터링하기
select *
from orders_csv oc
where order_date = (
select max(order_date) as max_order_date 
from orders_csv oc
)

-- 2. 구매 경험이 있는 고객 리스트만 구하고 싶을 때
-- 1) 주문 테이블에 있는 고객 리스트 구하기
select customer_id 
from orders_csv oc 

-- 2) 유저 테이블에서 주문 테이블에 있는 고객 필터링하기
select *
from orders_csv 
where customer_id in (select customer_id from orders_csv)
# join과 달리 굳이 새로운 컬럼이 필요하지 않을 때 서브쿼리 사용

-- 3. 캘리포니아는 일평균 판매량이 얼마야?
-- 1) 주(state)별로 일별 판매량 구하기
select oc.order_date , uc.state , sum(oc.quantity) as daily_quantity
from orders_csv oc 
left join users_csv uc on uc.customer_id = oc.customer_id 
group by 1, 2
order by 2, 1

-- 2) 주별 일별 판매량의 평균 구하기
select state, avg(daily_quantity) as state_daily_quantity
from (
select oc.order_date , uc.state , sum(oc.quantity) as daily_quantity
from orders_csv oc 
left join users_csv uc on uc.customer_id = oc.customer_id 
group by 1, 2
order by 2, 1
group by 1


-- 4. 임시테이블 : with

with daily_quantity_table as(
select oc.order_date , uc.state , sum(oc.quantity) as daily_quantity
from orders_csv oc 
left join users_csv uc on uc.customer_id = oc.customer_id 
group by 1, 2
order by 2, 1
)



select state, avg(daily_quantity) as state_daily_quantity
from daily_quantity_table
group by 1