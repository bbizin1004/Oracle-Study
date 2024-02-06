--------------------------------
--JDBC �ǽ��빮��
--------------------------------

--Java���� ù��° JDBC���α׷��� �غ���
--Ŭ������: HRSelected.java
--HR�������� ����
select * from employees where department_id=50
order by employee_id desc;

--CRUD �۾��� ���� ���̺� ����
--Ŭ������ : MyConnection.java
--study �������� ����
create table member (
    id varchar2(30),
    pass varchar2(40) not null,
    name varchar2(50) not null,
    regidate date default sysdate,
    primary key (id)
);
desc member;
select * from member;
--���ڵ� �Է��ϱ�
insert into member values('test1','1234','�׽���1',sysdate);
insert into member (id,pass,name)values('test3','3333','�׽���3');
commit;

--���ڵ� �����ϱ�
update member set pass = '9876', name ='������'
where id = 'dddd';
commit;

--���ڵ� �����ϱ�
delete from member where id ='test2';
commit;
--���ڵ� ��ȸ�ϱ�1
select id,pass,name,regidate,
    to_char(regidate,'yyyy.mm.dd.hh24:mi') d1
from member;
commit;

--���ڵ� ��ȸ�ϱ�2(�˻�)
select * from member where name like '%����%';
select * from member where name like '%��%';

-------------------------------------------------
--JDBC > CallableStatement �������̽� ����ϱ�
--study �������� �н��մϴ�.


/*
�ó�����] �Ű������� ȸ�����̵�(���ڿ�)�� ������ ù���ڸ� ������ ������ �κ��� *��
 ��ȯ�ϴ� �Լ��� �����Ͻÿ�.
 ���� ��) oracle21c => o***********
*/
--substr(���ڿ� Ȥ�� �÷���, �����ε���, ����) : �����ε������� ���̸�ŭ �߶󳽴�.
select substr('hongildong',1,1)from dual;
/*rpad(���ڿ� Ȥ�� �÷���,��ü����,ä�﹮��) : ���ڿ��� ���� ���̸� ������ ���ڷ�
 ä���ش�.*/
select rpad('h',10,'*') from dual;
/*���ڿ��� ù���ڸ� ������ ������ �κ��� *�� ä�� �������� �ϼ��Ѵ�. */
select rpad(substr('hongildong',1,1),length('hongildong'),'*') from dual;

--�Ű������� ���������� ����
create or replace function fillAsterik (
    idStr varchar2
)
return varchar2 /*��ȯŸ�Ե� ���������� ����*/
is retStr varchar2(50); /* ����ŷ ó���� ���̵� ������ ����*/
begin
    --���̵� ����ŷ ó���� ��ȯ
    retStr := rpad(substr(idStr,1,1),length(idStr),'*');
    return retStr;
end;
/
--���̵� ����ŷ ó���Ǵ��� Ȯ��
select fillAsterik('hongildong')from dual;
select fillAsterik('oracle21c')from dual;
select fillAsterik('hello')from dual;

/*
�ó�����] member ���̺� ���ο� ȸ�������� �Է��ϴ� ���ν����� �����Ͻÿ�
    �Ķ���� : In => ���̵�, �н�����, �̸�
              Out => returnVal(����:1, ����:0) */
/*Java���� �Է��� ������ ���� ���Ķ���� ���� �� ���� �������θ� ��ȯ�ϱ� ����
�ƿ��Ķ���� ����*/
create or replace procedure MyMemberInsert(
        p_id in varchar2,
        p_pass in varchar2,
        p_name in varchar2,
        returnVal out number
        )
is
begin
    --���Ķ���͸� ����  insert�������� �ۼ�
    insert into member (id,pass,name)
        values(p_id,p_pass,p_name);
        
    if sql%found then
        --�Է��� ����ó�� �Ǿ��ٸ� �Էµ� ���� ������ ���´�.
        returnVal :=sql%rowcount;
        --���� ��ȭ�� �������Ƿ� �ݵ�� Ŀ���ؾ� �Ѵ�.
        commit;
    else
        --�Է¿� �����ϸ� 0�� ��ȯ�Ѵ�.
        returnVal :=0;
    end if;
    /* (���ν����� ������ return ���� �ƿ��Ķ���Ϳ� ���� �Ҵ��ϱ⸸ �ϸ� �ڵ�����
        ��ȯ�Ѵ�. */
end;
/

set serveroutput on;

var i_result varchar2(10);
execute MyMemberInsert('pro03','1234','���ν���3',:i_result);
execute MyMemberInsert('pro02','2222','���ν���2',:i_result);
print i_result;

select * from member;


/*����3-1] ���ν��� : MyMemberDelete()

�ó�����] member���̺��� ���ڵ带 �����ϴ� ���ν����� �����Ͻÿ�
    �Ķ���� : In => member_id(���̵�)
              Out => returnVal(SUCCESS/FAIL ��ȯ)  */
/* in�Ķ���ʹ� ������ ���̵�, out �Ķ���ʹ� ���� ����� ���� */
create or replace procedure MyMemberDelete (
        member_id in varchar2,
        returnVal out varchar2
        )
is
begin
    --ȸ�����ڵ带 ������ delete ������ �ۼ�
    delete from member where id=member_id;
    
    --������ ���� Ȥ�� ���и� �Ǵ��� �� ����� ��ȯ
    if SQL%Found then
        returnVal := 'SUCCESS';
        commit;
    else
        returnVal :='FAIL';
    end if;
end;
/
set serveroutput on;

--���ε� ���� ������ ���� �׽�Ʈ
var delete_var varchar2(10);
execute MyMemberDelete('test99',:delete_var);
execute MyMemberDelete('pro01',:delete_var);

print delete_var;
        


/*����4-1] ���ν��� : MyMemberAuth()

�ó�����] ���̵�� �н����带 �Ű������� ���޹޾Ƽ� ȸ������ ���θ� �Ǵ��ϴ�
        ���ν����� �ۼ��Ͻÿ�. 
    �Ű����� : 
        In -> user_id, user_pass
        Out -> returnVal
    ��ȯ�� : 
        0 -> ȸ����������(�Ѵ�Ʋ��)
        1 -> ���̵�� ��ġ�ϳ� �н����尡 Ʋ�����
        2 -> ���̵�/�н����� ��� ��ġ�Ͽ� ȸ������ ����
    ���ν����� : MyMemberAuth
*/

create or replace procedure MyMemberAuth
    ( /*���Ķ���� Java���� �Է¹��� ���̵�,�н�����*/
        user_id in varchar2,
        user_pass in varchar2,
        /*�ƿ��Ķ���� : ȸ������ ���� ���*/
        returnVal out number)
is
    --count(*)�� ���� ��ȯ�Ǵ� ���� ����
    member_count number(1) :=0;
    --��ȸ�� �н����带 ����
    member_pw varchar(50);
begin
    --�ش� ���̵� �����ϴ��� �Ǵ��ϴ� select�� �ۼ�
    select count(*) into member_count
    from member where id=user_id;
    --ȸ�����̵� �����Ѵٸ�..
    if member_count=1 then
        --�н����� Ȯ���� ���� �ι�° �������� ����
        select pass into member_pw
            from member where id=user_id;
        --���Ķ���ͷ� ���޵� ���� DB�� �н����带 ���Ѵ�.
        if member_pw=user_pass then
            returnVal :=2;
        else
            --����� Ʋ�����
            returnVal :=1;
        end if;
    else
        --���̵� Ʋ�����
        returnVal :=0;
    end if;
end;
/

--���ε� ���� ���� �� �׽�Ʈ�غ���.
variable member_auth number;
--�Ѵ� �´� ��� : 2
EXECUTE MyMemberAuth('dddd','0412',:member_auth);
print member_auth;
--����� Ʋ�� ��� :1
EXECUTE MyMemberAuth('dddd','0412��ȣƲ��',:member_auth);
print member_auth;
--���̵� Ʋ����� :0
EXECUTE MyMemberAuth('dddd���̵�Ʋ��','0412',:member_auth);
print member_auth;


























