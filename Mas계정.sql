-- �Խ��� ������Ʈ ���̺� ���� �����.
alter session set "_ORACLE_SCRIPT"=true;

create user Mas identified by 1234;
    
grant connect, resource,unlimited tablespace to Mas;

-------------------------------------------------------

--ȸ�� ���̺� ����
create table member(
    id varchar2(10) not null,
    pass varchar2(15) not null,
    name varchar2(10) not null,
    tel varchar2(14) not null,
    email varchar2(40) not null,
    regidate date default sysdate not null,
    primary key(id)
);

--���̺� ���ﶧ
drop table member;

drop table freeboard;




--��1 ����� ȸ���� �Խ��� ���̺� ����
create table freeboard(
    num number primary key,
    title varchar2(200) not null,
    content varchar2(2000) not null,
    id varchar2(15) not null, /*ȸ���� �Խ����̹Ƿ� ȸ�����̵� �ʿ�*/
    postdate date default sysdate not null, /*�Խù��� �ۼ���*/
    visitcount number(6) /* �Խù��� ��ȸ�� */
    );

--�ܷ�Ű ����
/*
�ڽ����̺��� board�� �θ����̺��� member�� �����ϴ� �ܷ�Ű�� �����Ѵ�.
board�� id�÷��� member�� �⺻Ű�� id�� �����Ѵ�.
*/
alter table freeboard
    add constraint freeboard_mem_fk foreign key(id)
    references member(id);
select * from user_cons_columns;    
    
--������ ����
--board���̺� �ߺ����� �ʴ� �Ϸù�ȣ �ο��� ���� ���
create sequence seq_board_num
    increment  by 1
    start with 1
    minvalue 0
    nomaxvalue
    nocycle
    nocache;
-- ������ ����
drop sequence seq_board_num;

    
--���� ������ ������� �Ҵ�
select username,default_tablespace from dba_users where username in upper('Mas');
alter user mas quota 5m on users;

--ȸ������ ���� ������ �Է�
insert into member (id,pass,name,tel,email) values('mas', '1234','����','01033110789'
    ,'bbizin1004@korea.com');
    
    select * from member;
    
--������ ����
select * from member where id='bbizin';
update member set id= 'bbizin',pass='1234', name = '�ȼ���',
        tel='0103435625', email='bbizin@korea.com'
    where id='bbizin' and pass='12345';
    
    
--������ ���ﶧ 
delete from freeboard;

--�����Խ��� ���̵����� ����
insert into freeboard (num,title,content,id,postdate,visitcount)
    values(seq_board_num.nextval,'���� 1�Դϴ�.','����1�Դϴ�','mas',
    sysdate,0);

insert into freeboard (num,title,content,id,postdate,visitcount)
    values(seq_board_num.nextval,'����2�Դϴ�','����2�Դϴ�','bbizin',
    sysdate,0);
--Ŀ��
commit;


















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

