--------��Ƽä�� ���̺������
create table chat_talking (
    �Ϸù�ȣ number(10) primary key,
    ��ȭ�� varchar2(30),
    ��ȭ���� varchar2(400),
    �Է³�¥ date default sysdate
);




-----��Ƽä�� ��������
create sequence chat_serial_num
    increment by 1
    start with 1
    minvalue 1 
    nomaxvalue
    nocycle
    nocache;




-----���ν��� 
create or replace procedure ChatingInsert(
    p_id varchar2,
    p_chat varchar2
        )
is
begin
    insert into chat_talking (�Ϸù�ȣ,��ȭ��,��ȭ����)
        values(chat_serial_num.nextval,p_id,p_chat);
        commit;
end;
/

set serveroutput on;

execute ChatingInsert('tester1','���ϰ� ����?');
select * from chat_talking;