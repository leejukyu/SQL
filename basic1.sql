-- �ǽ� 1) �ŷ��� ������ �м�
-- 2017����� 2021�� 3�������� ���ڻ�ŷ� �����ŷ��� (���� : �鸸��)
-- �� ȸ���� �ŷ��� �����Ͷ�� �����ص� ��

-- 1) ������ Ž��--------------------------------------------------------------

-- STEP 1) ��� �÷� �����ϱ�
select *
from gmv_trend

-- STEP 2) Ư�� �÷� �����ϱ�
select category , yyyy , mm 
from gmv_trend 

-- STEP 3) �ߺ��� ���� Ư�� �÷� �����ϱ�
select distinct category 
from gmv_trend

select distinct yyyy, mm 
from gmv_trend

-- 2) Ư�� ������ ���� Ž��--------------------------------------------------------------

-- 2-1) ������ �ϳ��� �� More Example
------ a) ���ڿ� (between, ��Һ�)

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

------ b) ���ڿ� (=, !=, like, in, not in)

select *
from gmv_trend
where category = '���� �� ���뼭��'

select *
from gmv_trend
where category != '���� �� ���뼭��'

select *
from gmv_trend 
where category in ('���� �� ���뼭��', '��Ȱ��ǰ')

select *
from gmv_trend 
where category not in ('���� �� ���뼭��', '��Ȱ��ǰ')

select *
from gmv_trend 
where category in ('���� �� ���뼭��', '��Ȱ��ǰ')

select *
from gmv_trend 
where category like '%�м�%'

select *
from gmv_trend 
where category not like '%�м�%'

-- 2-2) ������ �������� ��--------------------------------------------------------------
------ a) and ����

select *
from gmv_trend
where category = '��ǻ�� �� �ֺ����'
and yyyy = 2021

------ b) or ����

select *
from gmv_trend
where gmv > 1000000
or gmv < 10000

------ c) and, or ���� ȥ��

select *
from gmv_trend
where (gmv > 1000000 or gmv < 100000)
and yyyy = 2021

-- 3) ī�װ��� ���� �м�--------------------------------------------------------------

-- More Example) ī�װ���, ������ ����

select category, yyyy, sum(gmv) as total_gmv # as ���� ����
from gmv_trend
group by category, yyyy

select category, yyyy, sum(gmv) as total_gmv # as ���� ����
from gmv_trend
group by 1, 2 # select���� ù ��°, �� ��°�� ����, ���ڷ� ���°� ����

-- More Example) ��ü ����

select sum(gmv) as gmv, min(yyyy), max(yyyy), avg(gmv)
from gmv_trend
# ��ü ������ group by ���� �ʴ´�!!

-- group by + where ����

select category, yyyy, sum(gmv) as total_gmv
from gmv_trend
where category = '��ǻ�� �� �ֺ����'
group by 1, 2 

-- 4)������ ���� �ֿ� ī�װ��� Ȯ���ϱ�--------------------------------------------------------------

select category, sum(gmv) as total_gmv
from gmv_trend
group by 1
having sum(gmv) >= 50000000

-- More Example) where���̶� ���� ����

select category, sum(gmv) as total_gmv
from gmv_trend
where yyyy = 2020
group by 1
having sum(gmv) >= 10000000
# where ���� �� ������ ���͸�
# having ���� �� ������ ���͸�

-- 5) ������ ���� ������ ī�װ� �����ϱ�--------------------------------------------------------------

select category, sum(gmv) as gmv
from gmv_trend
group by 1
order by gmv # ��������

select category, sum(gmv) as gmv
from gmv_trend
group by 1
order by gmv desc # ��������

-- �������� Example

select category, yyyy , sum(gmv)
from gmv_trend
group by 1, 2
order by 1, 2 desc # 1�� ��������, 2�� ������������ ����

select category, yyyy , sum(gmv)
from gmv_trend
group by 1, 2
order by 1 desc, 2 desc

-- [�߰� ���� 1] ������ �÷����� ����

select yyyy, mm, sum(gmv) as gmv
from gmv_trend
group by 1, 2
order by 3 desc

-- [�߰� ���� 2] select ���� ���� �÷����� ���� �����ұ�? -> �Ұ���

select yyyy, sum(gmv) as gmv
from gmv_trend
group by 1
order by mm