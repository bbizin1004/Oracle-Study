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


/************************
JSP �� ���α׷���-
**********************/

alter session set "_ORACLE_SCRIPT"=true;

--���� ����
create user musthave identified by 1234;

--���� �ο�
grant connect, resource,unlimited tablespace to musthave;

/*
CMDȯ�濡�� sqlplus�� ���� ������ ��쿡�� �ٸ� �������� ��ȯ�� �Ʒ��� ����
conn (Ȥ�� connent)��ɾ ����� �� �ִ�. ������ SQL�𺧷��ۿ�����
����� �� ���� ��� ���� ����� ����Ʈ�ڽ��� ���� ������ ������ �� �ִ�.
*/
conn musthave/1234;
show user;

--���̺� �� ������ ������ ���� musthave ���� ����
--������ ������ ���̺��� �ִٸ� ���� �� �ٽ� ���� �� �ִ�.
drop table member;
drop table board;
drop sequence seq_board_num;

--ȸ�� ���̺� ����
create table member(
    id varchar2(10) not null,
    pass varchar2(10) not null,
    name varchar2(30) not null,
    regidate date default sysdate not null,
    primary key(id)
);

--��1 ����� ȸ���� �Խ��� ���̺� ����
create table board(
    num number primary key,
    title varchar2(2000) not null,
    content varchar2(2000) not null,
    id varchar2(10) not null, /*ȸ���� �Խ����̹Ƿ� ȸ�����̵� �ʿ�*/
    postdate date default sysdate not null, /*�Խù��� �ۼ���*/
    visitcount number(6) /* �Խù��� ��ȸ�� */
    );

--�ܷ�Ű ����
/*
�ڽ����̺��� board�� �θ����̺��� member�� �����ϴ� �ܷ�Ű�� �����Ѵ�.
board�� id�÷��� member�� �⺻Ű�� id�� �����Ѵ�.
*/
alter table board
    add constraint board_mem_fk foreign key(id)
    references member(id);
select * from user_cons_columns;    
    
--������ ����
--board���̺� �ߺ����� �ʴ� �Ϸù�ȣ �ο��� ���� ���
create sequence seq_board_num
    increment  by 1
    start with 1
    minvalue 1
    nomaxvalue
    nocycle
    nocache;

--���� ������ �Է�
insert into member (id,pass,name) values('musthave', '1234','�ӽ�Ʈ�غ�');
insert into board (num,title,content,id,postdate,visitcount)
    values(seq_board_num.nextval,'����1�Դϴ�','����1�Դϴ�','musthave',
    sysdate,0);

insert into board (num,title,content,id,postdate,visitcount)
    values(seq_board_num.nextval,'����2�Դϴ�','����2�Դϴ�','tjoeun',
    sysdate,0);
--Ŀ��
commit;


/***********************
��1 ����� ȸ���� �Խ��� �����ϱ�.
*********************/
--���̵����� �߰��Է�
insert into board values (seq_board_num.nextval, '������ ���Դϴ�',
    '���ǿ���','musthave',sysdate,0);
insert into board values (seq_board_num.nextval, '������ �����Դϴ�',
    '�������','musthave',sysdate,0);
insert into board values (seq_board_num.nextval, '������ �����Դϴ�',
    '������ȭ','musthave',sysdate,0);
insert into board values (seq_board_num.nextval, '������ �ܿ��Դϴ�',
    '�ܿ￬��','musthave',sysdate,0);
commit;

--DAO�� selectCount() �޼���: board���̺��� �Խù� ���� ī��Ʈ
select count(*) from board;
select count(*) from board where title like '%�ܿ�%';
select count(*) from board where content like '%�ܿ�%';

--selectList() �޼��� : �Խ��� ��Ͽ� ����� ���ڵ带 �����ؼ� ����
select * from board order by num desc;
select * from board where title like '%����%' order by num desc;

--insertWrite() �޼���: �۾��⸦ ���� insert������ ����
insert into board (num,title, content,id,visitcount)
    values (seq_board_num.nextval,'����Test','����Test','musthave',0);
commit;

--selectView () : �Խù��� �Ϸù�ȣ�� ���� ���뺸�� ����
select * from board where  num=6;
--��Ī�� �ο����� �ʾ� ���̺���� �״�� ����Ѵ�.
select * from board inner join member
    on board.id=member.id
where  num=6;
--��Ī�� �ο��ؼ� �ʿ��� �÷��� select ���� ����Ѵ�.
select B.*, M.name from board B inner join member M
    on B.id=M.id
where  num=6;


--updageVisitCount() : �Խù� ���뺸�� �� ��ȸ�� 1����
update board set visitcount=visitcount +1 where num =6;
commit;

--���뺸��� �ٸ� ����� �ۼ��� �Խù��� Ȯ���ϱ� ���� ���̵����� �߰�
insert into member(id,pass,name) values
    ('tjoeun','1234','������');
commit;

--updateEdit() : ������ �Խù��� ����
select * from board where num=7;
update board set title= '����Test', content = '������� Test'
    where num=7;

--deletePost() : �Խù� ����
delete from board where num=6;
select * from board;
commit;


--�Խ����� Paging ��� �߰��� ���� ���������� �ۼ�
--1.�Խù��� �ۼ��� ������ ������������ ����
select * from board order by num desc;
--2.������������ ���ĵ� ���¿��� rownum�� �ο�
select tb.*, rownum rNum from
    (select * from board order by num desc) tb;
--3.������� ����� �Խù��� ������ ���ؼ� ����.  ���������� 10����.
select *from(
    select tb.*, rownum rNum from
        (select * from board order by num desc) tb
)
where rNum>=1 and rNum<=10;

--�Խ����� �˻������ ������ ���� like�� ���
select * from board where title like '%8%' order by num desc;

--����¡ ������ + �˻���� ������
--�˻������ ���� ���ʿ� �ִ� ���������� �߰��ϸ� �ȴ�.
select *from(
    select tb.*, rownum rNum from
        (select * from board  where title like '%8%' order by num desc) tb
)
where rNum between 1 and 10;
--�Խù��� ������ �񱳿����� Ȥ�� between���� �ۼ��� �� �ִ�.



/***********************************************
��2(MVC����) ����� �ڷ���� �Խ��� �����ϱ�
***********************************************/

/*
��ȸ���� �Խ����̹Ƿ� id ��� name, pass �÷��� �߰��ȴ�.
��, �ۼ����� �̸��� ����, ������ ���� �н����� ���� ���� �߰���.
�ڷ�������� ���۵ǹǷ� ���ϰ��� �÷��� �߰��ȴ�
Ofile: 
sfile:
downcount:
*/
create table mvcboard(
    idx number primary key,
    name varchar2(50) not null,
    title varchar2(200) not null,
    content varchar2(2000) not null,
    postdate date default sysdate not null,
    ofile varchar2(200),
    sfile varchar2(30),
    downcount number(5) default 0 not null,
    pass varchar2(50) not null,
    visitcount number default 0 not null
);

drop table mvcboard;


--���� ������ �Է�
insert into mvcboard (idx, name, title, content, pass)
    values (seq_board_num.nextval, '������', '�ڷ�� ����1 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pass)
    values (seq_board_num.nextval, '�庸��', '�ڷ�� ����2 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pass)
    values (seq_board_num.nextval, '�̼���', '�ڷ�� ����3 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pass)
    values (seq_board_num.nextval, '������', '�ڷ�� ����4 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pass)
    values (seq_board_num.nextval, '������', '�ڷ�� ����5 �Դϴ�.','����','1234');

commit;

    
    

-- �Խ��� ������Ʈ ���� �����.
alter session set "_ORACLE_SCRIPT"=true;

create user Mas identified by 1234;
    
grant connect, resource,unlimited tablespace to Mas;
    
    
    
    
    
    
    
    



