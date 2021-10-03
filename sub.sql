-- �� �� �ٵ���� �����Ͱ� �ʿ��� ��, ��������

-- 1. ���� �ֱ� �ֹ��� ������ ��󺸱�
-- 1) ���� �ֱ� �ֹ��� ���ϱ� (max_order_date)
select max(order_date) as max_order_date 
from orders_csv oc

-- 2) ���� �ֱ� �ֹ��Ͽ� �ش��ϴ� ������ ���͸��ϱ�
select *
from orders_csv oc
where order_date = (
select max(order_date) as max_order_date 
from orders_csv oc
)

-- 2. ���� ������ �ִ� �� ����Ʈ�� ���ϰ� ���� ��
-- 1) �ֹ� ���̺� �ִ� �� ����Ʈ ���ϱ�
select customer_id 
from orders_csv oc 

-- 2) ���� ���̺��� �ֹ� ���̺� �ִ� �� ���͸��ϱ�
select *
from orders_csv 
where customer_id in (select customer_id from orders_csv)
# join�� �޸� ���� ���ο� �÷��� �ʿ����� ���� �� �������� ���

-- 3. Ķ�����Ͼƴ� ����� �Ǹŷ��� �󸶾�?
-- 1) ��(state)���� �Ϻ� �Ǹŷ� ���ϱ�
select oc.order_date , uc.state , sum(oc.quantity) as daily_quantity
from orders_csv oc 
left join users_csv uc on uc.customer_id = oc.customer_id 
group by 1, 2
order by 2, 1

-- 2) �ֺ� �Ϻ� �Ǹŷ��� ��� ���ϱ�
select state, avg(daily_quantity) as state_daily_quantity
from (
select oc.order_date , uc.state , sum(oc.quantity) as daily_quantity
from orders_csv oc 
left join users_csv uc on uc.customer_id = oc.customer_id 
group by 1, 2
order by 2, 1
group by 1


-- 4. �ӽ����̺� : with

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