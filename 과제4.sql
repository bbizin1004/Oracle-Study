/*1. inner join ����� ����Ŭ����� ����Ͽ� first_name �� Janette �� 
����� �μ�ID�� �μ����� ����Ͻÿ�.
��¸��] �μ�ID, �μ��� */

select D.department_id,department_name
from employees E , departments D
where E.department_id=D.department_id and first_name = 'Janette';

/* 2. inner join ����� SQLǥ�� ����� ����Ͽ� ����̸��� �Բ� �� �����
�Ҽӵ� �μ���� ���ø��� ����Ͻÿ�.
��¸��] ����̸�, �μ���, ���ø� */

select first_name,last_name,d.department_name,city
from employees E inner join departments D
    on e.department_id=d.department_id
    inner join locations L
    on d.location_id = l.location_id;
    
/*3. ����� �̸�(FIRST_NAME)�� 'A'�� ���Ե� ������� �̸��� �μ����� ����Ͻÿ�.
��¸��] ����̸�, �μ��� */
select first_name,last_name,department_name
from employees
    inner join departments using(department_id)
where first_name like '%A%';

/* 4. ��city : Toronto / state_province : Ontario�� ���� �ٹ��ϴ� ��� ����� �̸�, 
������, �μ���ȣ �� �μ����� ����Ͻÿ�.
��¸��] ����̸�, ������, �μ�ID, �μ��� */
select first_name,job_title,department_id,department_name
from jobs
    inner join employees using(job_id)
    inner join departments using(department_id)
    inner join locations using(location_id)
    where city='Toronto' and state_province = 'Ontario';

 /* 5. Equi Join�� ����Ͽ� Ŀ�̼�(COMMISSION_PCT)�� �޴� ��� ����� �̸�, 
 �μ���, ���ø��� ����Ͻÿ�. 
��¸��] ����̸�, �μ�ID, �μ���, ���ø� */

select first_name,last_name,department_id,department_name,city
from employees
    inner join departments using(department_id)
    inner join locations using (location_id)
where COMMISSION_PCT >0;

/* 6. inner join�� using �����ڸ� ����Ͽ� 50�� �μ�(DEPARTMENT_ID)�� 
���ϴ� ��� ������(JOB_ID)�� �������(distinct)�� �μ��� ���ø�(CITY)�� �����Ͽ�
����Ͻÿ�.
��¸��] ������ID, �μ�ID, �μ���, ���ø� */

    
    
    
    
    
    
    
    
    