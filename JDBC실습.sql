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

-------------------------------------------------
--JDBC > CallableStatement 인터페이스 사용하기
--study 계정에서 학습합니다.


/*
시나리오] 매개변수로 회원아이디(문자열)을 받으면 첫문자를 제외한 나머지 부분을 *로
 변환하는 함수를 생성하시오.
 실행 예) oracle21c => o***********
*/
--substr(문자열 혹은 컬럼명, 시작인덱스, 길이) : 시작인덱스부터 길이만큼 잘라낸다.
select substr('hongildong',1,1)from dual;
/*rpad(문자열 혹은 컬럼명,전체길이,채울문자) : 문자열의 남은 길이를 정해진 문자로
 채워준다.*/
select rpad('h',10,'*') from dual;
/*문자열의 첫글자를 제외한 나머지 부분을 *로 채울 쿼리문을 완성한다. */
select rpad(substr('hongildong',1,1),length('hongildong'),'*') from dual;

--매개변수는 문자형으로 선언
create or replace function fillAsterik (
    idStr varchar2
)
return varchar2 /*반환타입도 문자형으로 선언*/
is retStr varchar2(50); /* 마스킹 처리된 아이디를 저장할 변수*/
begin
    --아이디를 마스킹 처리후 반환
    retStr := rpad(substr(idStr,1,1),length(idStr),'*');
    return retStr;
end;
/
--아이디가 마스킹 처리되는지 확인
select fillAsterik('hongildong')from dual;
select fillAsterik('oracle21c')from dual;
select fillAsterik('hello')from dual;

/*
시나리오] member 테이블에 새로운 회원정보를 입력하는 프로시저를 생성하시오
    파라미터 : In => 아이디, 패스워드, 이름
              Out => returnVal(성공:1, 실패:0) */
/*Java에서 입력한 내용을 받을 인파라미터 정의 및 가입 성공여부를 반환하기 위한
아웃파라미터 정의*/
create or replace procedure MyMemberInsert(
        p_id in varchar2,
        p_pass in varchar2,
        p_name in varchar2,
        returnVal out number
        )
is
begin
    --인파라미터를 통해  insert쿼리문을 작성
    insert into member (id,pass,name)
        values(p_id,p_pass,p_name);
        
    if sql%found then
        --입력이 정상처리 되었다면 입력된 행으 갯수를 얻어온다.
        returnVal :=sql%rowcount;
        --행의 변화가 생겼으므로 반드시 커밋해야 한다.
        commit;
    else
        --입력에 실패하면 0을 반환한다.
        returnVal :=0;
    end if;
    /* (프로시저는 별도의 return 없이 아웃파라미터에 값을 할당하기만 하면 자동으로
        반환한다. */
end;
/

set serveroutput on;

var i_result varchar2(10);
execute MyMemberInsert('pro03','1234','프로시저3',:i_result);
execute MyMemberInsert('pro02','2222','프로시저2',:i_result);
print i_result;

select * from member;


/*예제3-1] 프로시저 : MyMemberDelete()

시나리오] member테이블에서 레코드를 삭제하는 프로시저를 생성하시오
    파라미터 : In => member_id(아이디)
              Out => returnVal(SUCCESS/FAIL 반환)  */
/* in파라미터는 삭제할 아이디, out 파라미터는 삭제 결과를 저장 */
create or replace procedure MyMemberDelete (
        member_id in varchar2,
        returnVal out varchar2
        )
is
begin
    --회원레코드를 삭제할 delete 쿼리문 작성
    delete from member where id=member_id;
    
    --삭제에 성공 혹은 실패를 판단한 후 결과값 반환
    if SQL%Found then
        returnVal := 'SUCCESS';
        commit;
    else
        returnVal :='FAIL';
    end if;
end;
/
set serveroutput on;

--바인드 변수 생성후 삭제 테스트
var delete_var varchar2(10);
execute MyMemberDelete('test99',:delete_var);
execute MyMemberDelete('pro01',:delete_var);

print delete_var;
        


/*예제4-1] 프로시저 : MyMemberAuth()

시나리오] 아이디와 패스워드를 매개변수로 전달받아서 회원인지 여부를 판단하는
        프로시저를 작성하시오. 
    매개변수 : 
        In -> user_id, user_pass
        Out -> returnVal
    반환값 : 
        0 -> 회원인증실패(둘다틀림)
        1 -> 아이디는 일치하나 패스워드가 틀린경우
        2 -> 아이디/패스워드 모두 일치하여 회원인증 성공
    프로시저명 : MyMemberAuth
*/

create or replace procedure MyMemberAuth
    ( /*인파라미터 Java에서 입력받은 아이디,패스워드*/
        user_id in varchar2,
        user_pass in varchar2,
        /*아웃파라미터 : 회원인증 여부 결과*/
        returnVal out number)
is
    --count(*)를 통해 반환되는 값을 저장
    member_count number(1) :=0;
    --조회한 패스워드를 저장
    member_pw varchar(50);
begin
    --해당 아이디가 존재하는지 판단하는 select문 작성
    select count(*) into member_count
    from member where id=user_id;
    --회원아이디가 존재한다면..
    if member_count=1 then
        --패스워드 확인을 위해 두번째 쿼리문을 실행
        select pass into member_pw
            from member where id=user_id;
        --인파라미터로 전달된 값과 DB의 패스워드를 비교한다.
        if member_pw=user_pass then
            returnVal :=2;
        else
            --비번이 틀린경우
            returnVal :=1;
        end if;
    else
        --아이디가 틀린경우
        returnVal :=0;
    end if;
end;
/

--바인드 변수 생성 후 테스트해본다.
variable member_auth number;
--둘다 맞는 경우 : 2
EXECUTE MyMemberAuth('dddd','0412',:member_auth);
print member_auth;
--비번이 틀린 경우 :1
EXECUTE MyMemberAuth('dddd','0412암호틀림',:member_auth);
print member_auth;
--아이디가 틀린경우 :0
EXECUTE MyMemberAuth('dddd아이디틀림','0412',:member_auth);
print member_auth;


/************************
JSP 웹 프로그래밍-
**********************/

alter session set "_ORACLE_SCRIPT"=true;

--계정 생성
create user musthave identified by 1234;

--권한 부여
grant connect, resource,unlimited tablespace to musthave;

/*
CMD환경에서 sqlplus를 통해 접속한 경우에는 다른 계정으로 전환시 아래와 같이
conn (혹은 connent)명령어를 사용할 수 있다. 하지만 SQL디벨로퍼에서는
사용할 수 없는 대신 우측 상단의 셀렉트박스를 통해 계정을 변경할 수 있다.
*/
conn musthave/1234;
show user;

--테이블 및 시퀀스 생성을 위해 musthave 계정 연결
--기존에 생성된 테이블이 있다면 삭제 후 다시 만들 수 있다.
drop table member;
drop table board;
drop sequence seq_board_num;

--회원 테이블 생성
create table member(
    id varchar2(10) not null,
    pass varchar2(10) not null,
    name varchar2(30) not null,
    regidate date default sysdate not null,
    primary key(id)
);

--모델1 방식의 회원제 게시판 테이블 생성
create table board(
    num number primary key,
    title varchar2(2000) not null,
    content varchar2(2000) not null,
    id varchar2(10) not null, /*회원제 게시판이므로 회원아이디 필요*/
    postdate date default sysdate not null, /*게시물의 작성일*/
    visitcount number(6) /* 게시물의 조회수 */
    );

--외래키 설정
/*
자식테이블인 board가 부모테이블인 member를 참조하는 외래키를 설정한다.
board의 id컬럼이 member의 기본키인 id를 참조한다.
*/
alter table board
    add constraint board_mem_fk foreign key(id)
    references member(id);
select * from user_cons_columns;    
    
--시퀀스 생성
--board테이블에 중복되지 않는 일련번호 부여를 위해 사용
create sequence seq_board_num
    increment  by 1
    start with 1
    minvalue 1
    nomaxvalue
    nocycle
    nocache;

--더미 데이터 입력
insert into member (id,pass,name) values('musthave', '1234','머스트해브');
insert into board (num,title,content,id,postdate,visitcount)
    values(seq_board_num.nextval,'제목1입니다','내용1입니다','musthave',
    sysdate,0);

insert into board (num,title,content,id,postdate,visitcount)
    values(seq_board_num.nextval,'제목2입니다','내용2입니다','tjoeun',
    sysdate,0);
--커밋
commit;


/***********************
모델1 방식의 회원제 게시판 제작하기.
*********************/
--더미데이터 추가입력
insert into board values (seq_board_num.nextval, '지금은 봄입니다',
    '봄의왈츠','musthave',sysdate,0);
insert into board values (seq_board_num.nextval, '지금은 여름입니다',
    '여름향기','musthave',sysdate,0);
insert into board values (seq_board_num.nextval, '지금은 가을입니다',
    '가을동화','musthave',sysdate,0);
insert into board values (seq_board_num.nextval, '지금은 겨울입니다',
    '겨울연가','musthave',sysdate,0);
commit;

--DAO의 selectCount() 메서드: board테이블의 게시물 갯수 카운트
select count(*) from board;
select count(*) from board where title like '%겨울%';
select count(*) from board where content like '%겨울%';

--selectList() 메서드 : 게시판 목록에 출력할 레코드를 정렬해서 인출
select * from board order by num desc;
select * from board where title like '%여름%' order by num desc;

--insertWrite() 메서드: 글쓰기를 위해 insert쿼리를 실행
insert into board (num,title, content,id,visitcount)
    values (seq_board_num.nextval,'제목Test','내용Test','musthave',0);
commit;

--selectView () : 게시물의 일련번호를 통해 내용보기 구현
select * from board where  num=6;
--별칭을 부여하지 않아 테이블명을 그대로 사용한다.
select * from board inner join member
    on board.id=member.id
where  num=6;
--별칭을 부여해서 필요한 컬럼만 select 절에 기술한다.
select B.*, M.name from board B inner join member M
    on B.id=M.id
where  num=6;


--updageVisitCount() : 게시물 내용보기 시 조회수 1증가
update board set visitcount=visitcount +1 where num =6;
commit;

--내용보기시 다른 사람이 작성한 게시물을 확인하기 위해 더미데이터 추가
insert into member(id,pass,name) values
    ('tjoeun','1234','더조은');
commit;

--updateEdit() : 기존의 게시물을 수정
select * from board where num=7;
update board set title= '수정Test', content = '내용수정 Test'
    where num=7;

--deletePost() : 게시물 삭제
delete from board where num=6;
select * from board;
commit;


--게시판의 Paging 기능 추가를 위한 서브쿼리문 작성
--1.게시물을 작성한 순서의 내림차순으로 정렬
select * from board order by num desc;
--2.내림차순으로 정렬된 상태에서 rownum을 부여
select tb.*, rownum rNum from
    (select * from board order by num desc) tb;
--3.목록으로 출력할 게시물의 구간을 정해서 인출.  한페이지당 10개씩.
select *from(
    select tb.*, rownum rNum from
        (select * from board order by num desc) tb
)
where rNum>=1 and rNum<=10;

--게시판의 검색기능의 구현을 위해 like를 사용
select * from board where title like '%8%' order by num desc;

--페이징 쿼리문 + 검색기능 쿼리문
--검색기능은 가장 안쪽에 있는 서브쿼리에 추가하면 된다.
select *from(
    select tb.*, rownum rNum from
        (select * from board  where title like '%8%' order by num desc) tb
)
where rNum between 1 and 10;
--게시물으 구간은 비교연산자 혹은 between으로 작성할 수 있다.



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

drop table mvcboard;


--더미 데이터 입력
insert into mvcboard (idx, name, title, content, pass)
    values (seq_board_num.nextval, '김유신', '자료실 제목1 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pass)
    values (seq_board_num.nextval, '장보고', '자료실 제목2 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pass)
    values (seq_board_num.nextval, '이순신', '자료실 제목3 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pass)
    values (seq_board_num.nextval, '강감찬', '자료실 제목4 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pass)
    values (seq_board_num.nextval, '대조영', '자료실 제목5 입니다.','내용','1234');

commit;

    
    

-- 게시판 프로젝트 계정 만들기.
alter session set "_ORACLE_SCRIPT"=true;

create user Mas identified by 1234;
    
grant connect, resource,unlimited tablespace to Mas;
    
    
    
    
    
    
    
    



