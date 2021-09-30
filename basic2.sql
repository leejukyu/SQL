-- �ǽ� 2) �ֹ� ������ �м�
-- 2021�� 6�� 1�� �Ϸ絿���� �ֹ� ��
-- ���� �����ϴ� �м� ��Ŀ�ӽ� �����Ͷ�� �����ϰ� �м��� ������ �ּ���! 


-- 1. ������ Ž��--------------------------------------------------------------

-- a) �ֹ� ���̺�
select *
from online_order

-- b) ��ǰ ���̺�
select *
from item

-- c) ī�װ� ���̺�
select *
from category

-- d) ���� ���̺�
select *
from user_info

-- 2. TOP ��ǰ�� ���� Ȯ��--------------------------------------------------------------

-- ��ǰ�� ����� ���� ��, ����� ���� ������ �����ϱ�
	
select itemid , sum(gmv) as gmv
from online_order 
group by 1
order by 2 desc

-- ��ǰ�̸��� ��ǰID�� ������ ���Ƽ� �Ѵ��� ��ǰ�� ������� Ȯ���� �� �ֵ��� ����.

select itemid, item_name , sum(gmv) as gmv
from online_order oo 
join item i on oo.itemid = i.id
group by 1, 2
order by 2 desc

-- �߰�����: ī�װ��� ������� ��� �ɱ�?

select c.cate1 ,sum(gmv) as gmv
from online_order oo 
join category c on oo.itemid = c.id 
group by 1
order by 2 desc

-- Join ���̺� Join�� �ѹ���

select c.cate1, sum(gmv) as gmv
from online_order oo 
join item i on oo.itemid = i.id 
join category c on i.category_id = c.id 
group by 1
order by 2 desc

-- �߰�����: ��/���ɺ� ������� ��� �ɱ�?

select ui.gender , ui.age_band , sum(gmv) as gmv
from online_order oo 
join user_info ui on oo.userid  = ui.userid 
group by 1, 2
order by 1, 2

-- 3. ī�װ��� �ֿ� ��ǰ�� ���� Ȯ��--------------------------------------------------------------

select c.cate1 ,c.cate2 ,c.cate3 , sum(gmv) as gmv
from online_order oo 
join item i on oo.itemid = i.id
join category c on i.category_id = c.id 
group by 1, 2, 3
order by 4 desc 

-- �߰�����: ������ �����ϴ� �������� � ���� ������?

select item_name, sum(gmv) as gmv
from online_order oo 
join item i on oo.itemid = i.id 
join user_info ui on oo.userid = ui.userid
where gender = 'M'
group by 1
