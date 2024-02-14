/*******
MultiChat ¼³Á¤

*******/



create sequence index_num
    increment by 1
    start with 1
    minvalue 1 
    nomaxvalue
    nocycle
    nocache;

select * from user_sequences;

select * from CHAT_TALKING;

insert into tb_goods values (index_num.nextval,'¸ÔÅÂ±ø1');