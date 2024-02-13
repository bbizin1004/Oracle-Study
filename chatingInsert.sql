/*
시나리오] member 테이블에 새로운 회원정보를 입력하는 프로시저를 생성하시오
    파라미터 : In => 아이디, 패스워드, 이름
              Out => returnVal(성공:1, 실패:0) */
/*Java에서 입력한 내용을 받을 인파라미터 정의 및 가입 성공여부를 반환하기 위한
아웃파라미터 정의*/
create or replace procedure ChatingInsert(
    idx1 number,
    id varchar2,
    chat varchar2
        )
is
begin
    --인파라미터를 통해  insert쿼리문을 작성
    insert into chating (idx,id,chat)
        values(chat_serial_num.nextval,p_pass,p_name);
        
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