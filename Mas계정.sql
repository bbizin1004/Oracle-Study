-- 게시판 프로젝트 테이블 계정 만들기.
alter session set "_ORACLE_SCRIPT"=true;

create user Mas identified by 1234;
    
grant connect, resource,unlimited tablespace to Mas;

-------------------------------------------------------

--회원 테이블 생성
create table member(
    id varchar2(10) not null,
    pass varchar2(15) not null,
    name varchar2(10) not null,
    tel varchar2(14) not null,
    email varchar2(40) not null,
    regidate date default sysdate not null,
    primary key(id)
);

--테이블 지울때
drop table member;

drop table freeboard;




--모델1 방식의 회원제 게시판 테이블 생성
create table freeboard(
    num number primary key,
    title varchar2(200) not null,
    content varchar2(2000) not null,
    id varchar2(15) not null, /*회원제 게시판이므로 회원아이디 필요*/
    postdate date default sysdate not null, /*게시물의 작성일*/
    visitcount number(6) /* 게시물의 조회수 */
    );

--외래키 설정
/*
자식테이블인 board가 부모테이블인 member를 참조하는 외래키를 설정한다.
board의 id컬럼이 member의 기본키인 id를 참조한다.
*/
alter table freeboard
    add constraint freeboard_mem_fk foreign key(id)
    references member(id);
select * from user_cons_columns;    
    
--시퀀스 생성
--board테이블에 중복되지 않는 일련번호 부여를 위해 사용
create sequence seq_board_num
    increment  by 1
    start with 1
    minvalue 0
    nomaxvalue
    nocycle
    nocache;
-- 시퀀스 삭제
drop sequence seq_board_num;

    
--마스 계정에 저장공간 할당
select username,default_tablespace from dba_users where username in upper('Mas');
alter user mas quota 5m on users;

--회원정보 더미 데이터 입력
insert into member (id,pass,name,tel,email) values('mas', '1234','마스','01033110789'
    ,'bbizin1004@korea.com');
    
    select * from member;
    
--데이터 수정
select * from member where id='bbizin';
update member set id= 'bbizin',pass='1234', name = '안성현',
        tel='0103435625', email='bbizin@korea.com'
    where id='bbizin' and pass='12345';
    
    
--데이터 지울때 
delete from freeboard;

--자유게시판 더미데이터 생성
insert into freeboard (num,title,content,id,postdate,visitcount)
    values(seq_board_num.nextval,'제목 1입니다.','내용1입니다','mas',
    sysdate,0);

insert into freeboard (num,title,content,id,postdate,visitcount)
    values(seq_board_num.nextval,'제목2입니다','내용2입니다','bbizin',
    sysdate,0);
--커밋
commit;


















/***********************************************
모델2(MVC패턴) 방식의 자료실형 게시판 제작하기
***********************************************/

/*
비회원제 게시판이므로 id 대신 name, pass 컬럼이 추가된다.
즉, 작성자의 이름과 수정, 삭제를 위한 패스워드 검증 로직 추가됨.
자료실형으로 제작되므로 파일관련 컬럼이 추가된다
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

