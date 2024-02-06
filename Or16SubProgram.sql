/************
파일명: Or16SubProgram.sql
서브프로그램
설명: 저장프로시져, 함수 그리고 프로시져의 일종인 트리거를 학습
************/

/*
서브프로그램(Sub Program)
-PL/SQL에서는 프로시져와 함수라는 두가지 유형의 서브프로그램이 있다.
-Select를 포함해서 다른 DML문을 이용하여 프로그래밍적인 요소를 통해
사용가능하다.
-트리거는 프로시져의 일종으로 특정테이블에 레코드의 변화가 있을경우
자동으로 실행된다.
-함수는 쿼리문으 일부분으로 사용하기 위해 생성한다. 즉 외부 프로그램에서 호출하는 경우는
거의없다.
-프로시저는 외부 프로그램에서 호출하기 위해 생성한다. 따라서, Java,JSP등에서 간단한
호출로 복잡한 쿼리를 실행할 수 있다.
*/


/*
1.저장프로시저(Stored Procedure)
-프로시저는 return문이 없는 대신 out파라미터를 통해 값을 반환한다.
-보안성을 높일 수 있고, 네트워크의 부하를 줄일 수 있다.
형식] create [or replace] procedure 프로시저명[(
        매개변수 in  자료형, 매개변수 out 자료형
    )]
    is[변수선언]
    begin
        실행문장
    end;
    /
※ 파라미터 설정시 자료형만 명시하고, 크기는 명시하지 않는다.
*/

--예제1] 사원의 급여를 가져와서 출력하는 프로시저 생성
--시나리오] 100번 사원의 급여를 select하여 출력하는 저장프로시저를 생성하시오.
--프로시저 생성시 or replace는 추가하는 것이 좋다.
create or replace procedure pcd_emp_salary 
is
    /* PL/SQL에서는 declare절에 변수를 선언하지만, 프로시저에서는 is절에 선언한다.
    만약 변수가 필요없다면 생략할 수 있다.*/
    --사원테이블의 급여 컬럼을 참조하는 참조변수로 생성
    v_salary employees.salary%type;
begin
    --100번 사원의 급여를 into를 통해 변수에 저장한다.
    select salary into v_salary from employees
    where employee_id = 100;
    dbms_output.put_line('사원번호100의 급여는:'||v_salary||'입니다');
end;
/

--데이터사전에서 확인한다. 저장은 대문자로 되므로 변환함수를 이용한다.
select * from user_source where name like upper('%pcd_emp_salary%');
--프로시저의 실행은 호스트환경에서 execute 명령을 이용한다.
execute pcd_emp_salary;



/*
예제2] IN파라미터 사용하여 프로시저 생성
시나리오] 사원의 이름을 매개변수로 받아서 사원테이블에서 레코드를 조회한후
해당사원의 급여를 출력하는 프로시저를 생성 후 실행하시오.
해당 문제는 in파라미터를 받은후 처리한다.
사원이름(first_name) : Bruce, Neena
*/

--프로시저 생성시 in파라미터를 설정한다. first_name을 참조하는 참조변수로 선언한다.
create or replace procedure pcd_in_param_salary
    (param_name in employees.first_name%type)
is
    /* 변수는 is절에서 선언하고, 필요없는 경우 생략할 수 있다.*/
    valSalary number(10);
begin
    /* 인파라미터로 전달된 사원명을 조건으로 급여를 구한 후 변수에 할당한다.
    하나의 결과가 출력되므로 into를 select절에서 사용한다. */
    select salary into valSalary
    from employees where first_name = param_name;
    --사원의 이름과 급여를 함께 출력한다.
    dbms_output.put_line(param_name||'의 급여는'||valSalary||'입니다');
end;
/
--데이터 사전에서 작성한 내용 확인
select *from user_source where name like upper('%pcd_in_param_salary%');
--사원의 이름을 파라미터로 전달해서 프로시저를 호출한다.
execute pcd_in_param_salary('Bruce');
execute pcd_in_param_salary('Neena');

/*
예제3] OUT파라미터 사용하여 프로시저 생성
시나리오] 위 문제와 동일하게 사원명을 매개변수로 전달받아서 급여를 조회하는
프로시저를 생성하시오. 단, 급여는 out파라미터를 사용하여 반환후 출력하시오*/

/*두가지 형식의 파라미터를 정의한다. 일반변수, 참조변수를 각각 사용해서 선언하였다.
파라미터는 용도에 따라 in, out을 각각 명시한다. 파라미터 정의시에는 크기는
별도로 명시하지 않는다. */
create or replace procedure pcd_out_param_salary
    (param_name in varchar2,
    param_salary out employees.salary%type)
is
    /* select한 결과를 out파라미터에 저장할 것이므로 별도의 변수가 필요하지 않아
    is절은 비워둔다. 이와같이 변수 선언은 생략할 수 있다. */
begin
    /*in 파라미터는 where절의 조건으로 사용하고, select한 결과값은 into절에서
    out파라미터에 저장한다. 저장된 값은 프로시져 외부로 반환된다. */
    select salary into param_salary
    from employees where first_name= param_name;
end;
/
--호스트 환경에서 바인드변수를 선언한다.
var v_salary varchar2(30);

/*프로시저 호출시 각각의 파라미터를 사용한다. 특히 바인드변수는 : 을 붙여야 한다.
out 파라미터인 param_salary에 저장된 값이 v_salary로 전달된다.*/
execute pcd_out_param_salary('Matthew',:v_salary);
print v_salary;



/*시나리오] 사원번호와 급여를 매개변수로 전달받아 해당사원의 급여를 수정하고, 
실제 수정된 행의 갯수를 반환받아서 출력하는 프로시저를 작성하시오.*/











