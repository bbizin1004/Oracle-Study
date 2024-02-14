--------멀티채팅 테이블생성용
create table chat_talking (
    일련번호 number(10) primary key,
    대화명 varchar2(30),
    대화내용 varchar2(400),
    입력날짜 date default sysdate
);




-----멀티채팅 시퀀스용
create sequence chat_serial_num
    increment by 1
    start with 1
    minvalue 1 
    nomaxvalue
    nocycle
    nocache;




-----프로시저 
create or replace procedure ChatingInsert(
    p_id varchar2,
    p_chat varchar2
        )
is
begin
    insert into chat_talking (일련번호,대화명,대화내용)
        values(chat_serial_num.nextval,p_id,p_chat);
        commit;
end;
/

set serveroutput on;

execute ChatingInsert('tester1','머하고 지내?');
select * from chat_talking;