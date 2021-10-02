-- �ǽ� 3) �ֹ� �����ͷ� ������ �����ϱ� ����
-- 2021�� 6�� 1�� �Ϸ絿���� �ֹ� ��
-- ���� �����ϴ� �м� ��Ŀ�ӽ� �����Ͷ�� �����ϰ� �м��� ������ �ּ���!


-- 1. ���ϴ� �������� �÷� �����ϱ�--------------------------------------------------------------

-- a) ���ڸ� ���ڿ��� �ٲ��ֱ�
select dt, cast(dt as char) as yyyymmdd # cast : �ٲٴ�
from online_order oo

-- b) ���ڿ� �÷����� �Ϻθ� �߶󳻱�

select dt, left(cast(dt as char), 4) as yyyy,
substring(cast(dt as char),5,2) as mm, 
right(cast(dt as char), 2) as dd
from online_order oo 

-- c) yyyy-mm-dd �������� �̾��ֱ�

select dt,
concat(
left(cast(dt as char), 4), '-',
substring(cast(dt as char),5,2) ,'-',
right(cast(dt as char), 2) ) as yyyymmdd
from online_order oo

-- d) null ���� ��� ���ǰ����� �ٲ��ֱ�

select oo.userid, coalesce (oo.userid, 'NA') # null�̸� 'NA'�� ���
from online_order oo 
left join user_info ui on oo.userid = ui.userid

select coalesce (ui.gender , 'NA') as gender, coalesce (ui.age_band, 'NA') as age_band, sum(oo.gmv) as gmv
from online_order oo 
left join user_info ui on oo.userid = ui.userid
group by 1, 2
order by 1, 2

-- e) ���� ���ϴ� �÷� �߰��غ���

select distinct case when gender = 'M' then '����' 
					when gender = 'F' then '����' 
					else 'NA' end as gender # case when == if
from user_info ui 

-- f) ���ɴ� �׷� ������ (20��, 30��, 40��)

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

-- g) TOP3 ī�װ��� �� �� ��ǰ�� ����� ���ϱ�
select 
case when cate1 in ('��ĿƮ', 'Ƽ����', '���ǽ�') then 'Top3'
else '��Ÿ' end as item_type
,sum(gmv) as gmv
from online_order oo 
join item i on oo.itemid = i.id
join category c on i.category_id = c.id 
group by 1
order by 2 desc

-- h) Ư�� Ű���尡 ��� ��ǰ�� �׷��� ���� ��ǰ�� ���� ���ϱ� (+item ������ ���� Ȯ��!)
select item_name,
case when item_name like '%����%' then '���� ����' # ����� ��ũ�� ���ÿ� ������ ù��° ���ǿ� ġȯ
	when item_name like '%��ũ%' then '��ũ ����'
	when item_name like '%û��%' then 'û�� ����'
	when item_name like '%�⺻%' then '�⺻ ����'
	else '�̺з�'
	end as item_concept
from item
;
select case when item_name like '%����%' then '���� ����'
	when item_name like '%��ũ%' then '��ũ ����'
	when item_name like '%û��%' then 'û�� ����'
	when item_name like '%�⺻%' then '�⺻ ����'
	else '�̺з�'
	end as item_concept
, sum(gmv) as gmv
from online_order oo 
join item i on oo.itemid = i.id 
group by 1
order by 2 desc

-- 2. ��¥ ���� �Լ� Ȱ���ϱ�--------------------------------------------------------------

-- a) ������ ��Ÿ���� �⺻ ����

select now() # ���� ��¥, �ð�

select curdate() # ���� ��¥(=current_date)

select current_timestamp() # ���� ��¥, �ð� 

-- b) ��¥ ���Ŀ��� ���� �������� ��ȯ�ϱ�

select date_format(now(), '%y%m%d')

select date_format(now(), '%y-%m-%d') 

-- c) ��¥ ���ϱ�/����

select adddate(now(), interval 1 month) # = date_add() 

select date_sub(now(), interval 1 day)

-- d ��¥�κ��� ����, ��, �� Ȯ���ϱ�

select month(now())

select year(now())

select week(now())

-- d) �ֱ� 1�� ������ ����� Ȯ���ϱ�

select *
from gmv_trend gt
where yyyy = year(date_sub(now(), interval 1 year)) and mm >= month(date_sub(now(), interval 1 year))
order by 2,3

-- 3. ���η�, �ǸŰ�, ���ͷ� ����ϱ�
select c.cate1,
round(sum(cast(discount as float)) / sum(gmv),2) * 100 as discount_rate, # ���η�, %�� ����
sum(gmv) - sum(discount) as paid_amount, # �ǸŰ�
sum(cast(product_profit as float)) / sum(gmv) as product_magin, # ���ͷ�
sum(total_profit) / sum(gmv) as total_margin
from online_order oo 
join item i on oo.itemid = i.id 
join category c on i.category_id = c.id
group by 1
order by 3 desc
# ���Ŀ� group by�� �� ���� ����, �и� �� �� sum

-- 4. �� ���������� �м� (�δ� ��� ���ż��� / �δ� ��� ���űݾ�)

-- 100���� ���� ���Ÿ� �Ͽ���, �� �Ǹż����� 200��
-- �δ� ��� ���ż��� = �� �Ǹż��� / �� �� ��
-- �δ� ��� ���űݾ� = �� ���űݾ� / �� �� ��

-- �δ� ���ż����� ���� ��ǰ��?
select i.item_name 
, sum(unitsold) as unitsold 
, count(distinct userid) as user_count
, round(sum(cast(unitsold as float)) / count(distinct userid), 2) as avg_unitsold_per_customer
, round(sum(cast(gmv as float)) / count(distinct userid), 2) as avg_gmv_per_customer
from online_order oo 
join item i on oo.itemid = i.id
group by 1
order by 4 desc

-- �δ� ���űݾ��� ���� ��/���ɴ��? (���� �ǽ�����, �ܼ� ���űݾ� �������δ� 20�� ������ ���Ҵµ�...!)
select gender, age_band, sum(gmv) as gmv, count(distinct oo.userid) as user_count
, sum(gmv) / count(distinct oo.userid) as avg_gmv_per_customer
from online_order oo 
join user_info ui on oo.userid = ui.userid 
group by 1, 2
order by 5 desc