--------------------------------
--JDBC 실습용문서
--------------------------------

--Java에서 첫번째 JDBC프로그래밍 해보기
--클래스명: HRSelected.java
--HR계정에서 실행
select * from employees where department_id=50
order by employee_id desc;

--CRUD 작업을 위한 테이블 생성
--클래스명 : MyConnection.java
--study 계정에서 실행
create table member (
    id varchar2(30),
    pass varchar2(40) not null,
    name varchar2(50) not null,
    regidate date default sysdate,
    primary key (id)
);
desc member;
select * from member;
--레코드 입력하기
insert into member values('test1','1234','테스터1',sysdate);
insert into member (id,pass,name)values('test3','3333','테스터3');
commit;

--레코드 수정하기
update member set pass = '9876', name ='나수정'
where id = 'dddd';
commit;

--레코드 삭제하기
delete from member where id ='test2';
commit;
--레코드 조회하기1
select id,pass,name,regidate,
    to_char(regidate,'yyyy.mm.dd.hh24:mi') d1
from member;
commit;

--레코드 조회하기2(검색)
select * from member where name like '%유겸%';
select * from member where name like '%테%';



























