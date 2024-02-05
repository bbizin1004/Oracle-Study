/*****************
파일명: Or15PLSQL2.sql
PL/SQL
설명: 오라클에서 제공하는 프로그래밍 언어
*****************/


--제어문(조건문) : if문, case문과 같은 조건문을 학습한다.


--예제7] if문 기본
--if문 홀수와 짝수를 판단하는 if문 작성

--시나리오] 변수에 저장된 숫자가 홀수 or 짝수인지 판단하는 PL/SQL을 작성하시오.
declare
    --선언부에서 숫자타입의 변수를 선언
    num number;
begin
    --초기값으로 10을 할당
    num :=10;
    --mod(변수, 정수) : 변수를 정수로 나눈 나머지를 반환하는 함수.
    if mod(num,2) = 0 then
        dbms_output.put_line(num || '은 짝수');
    else
        dbms_output.put_line(num||'은 홀수');
    end if;
end;
/

--예제8] 제어문(조건문 : if-elsif)

/*시나리오] 사원번호를 사용자로부터 입력받은 후 해당 사원이 어떤부서에서
근무하는지를 출력하는 PL/SQL문을 작성하시오. 단, if~elsif문을 사용하여
구현하시오.*/
declare
    --치환연산자는 이와같이 선언부에 기술해도 된다. 사원번호를 입력받는다.
    emp_id employees.employee_id%type := &emp_id;
    emp_name varchar2(50);
    emp_dept employees.department_id%type;
    --부서명은 선언과 동시에 초기화한다.
    dept_name varchar2(30) := '부서정보없음';
begin
    --입력받은 사원번호를 통해  select한 후 변수에 값을 할당한다.
    select employee_id, last_name,department_id
        into emp_id,emp_name,emp_dept
    from employees
    where employee_id = emp_id;
    
    /*여러개의 조건을 사용할 경우 Java와 같이 else if를 사용하지 않고
    elsif로 기술해야 한다. 또한 중괄호 대신 then과 end if;가 사용된다.*/
    if emp_dept =50 then
        dept_name := 'shipping';
    elsif emp_dept =60 then
        dept_name:='IT';
    elsif emp_dept = 70 then
        dept_name:= 'Public Relations';
    elsif emp_dept = 80 then
        dept_name:= 'Sales';
    elsif emp_dept = 90 then
        dept_name:= 'Executive';
    elsif emp_dept = 100 then
        dept_name:= 'Finance';
    end if;
    
    dbms_output.put_line('사원번호' || emp_id || '의 정보');
    dbms_output.put_line('이름:' || emp_name
            ||',부서번호:'|| emp_dept
            ||',부서명:'|| dept_name);
end;
/
        
/*
case문: java의 switch문과 비슷한 조건문
    형식]
        case 변수
            when 값1 then '할당값1'
            when 값2 then '할당값2'
            .....값N
        end;
*/
--시나리오] 앞에서 if~elsif로 작성한 PL/SQL문을 case~when문으로 변경하시오.

declare
     emp_id employees.employee_id%type := &emp_id;
    emp_name varchar2(50);
    emp_dept employees.department_id%type;
    dept_name varchar2(30) := '부서정보없음';
begin
    select employee_id, last_name,department_id
        into emp_id,emp_name,emp_dept
    from employees
    where employee_id = emp_id;
    /*case~when문이 if문과 다른점은 할당할 변수를 먼저 선언한 후 문장네에서 
    조건을 판단하여 하나의 값을 할당하는 방식이다. 따라서 변수를 중복으로 기술하지
    않아도 된다. */
    dept_name :=
        case emp_dept
            when 50 then 'Shipping'
            when 60 then 'IT'
            when 70 then 'Public Relations'
            when 80 then 'Sales'
            when 90 then 'Executive'
            when 100 then 'Finance'
        end;
    
     dbms_output.put_line('사원번호' || emp_id || '의 정보');
        dbms_output.put_line('이름:' || emp_name
                ||',부서번호:'|| emp_dept
                ||',부서명:'|| dept_name);
end;
/
--------------------------------------------------------
--제어문(반복문)
/*
반복문1 : Basic loop문
    Java의 do~while문과 같이 조건체크없이 일단 loop로 진입한 후 탈출조건이 될때까지
    반복한다. 탈출시에는 exit를 사용한다.
*/
declare
    --변수를 숫자타입으로 선언 후 0으로 초기화
    num number :=0;
begin
    --조건 체크없이 루프로 진입한다.
    loop
        --0~10까지 출력한다.
        dbms_output.put_line(num);
        /*증가연산자나 복합대입연산자가 없으므로 일반적인 방식으로
        변수를 증가시켜야 한다.*/
        num := num +1;
        /* num이 10을 초과하면 loop문을 탈출한다. exit는 Java의 
        break와 동일하게 반복문을 탈출한다. */
        exit when (num>10);
    end loop;
end;
/

--예제11] 제어문(반복문 : basic loop)
declare
    i number := 1;
    /*누적합을 저장하기 위한 변수로, Java에서는 보통 sum이라는 변수명을
    사용하지만 , Oracle에서는 그룹함수 sum()이 있으므로 
    아래와 같이 다른 이름을 사용해야 한다. */
    sumNum number :=0;
begin
    loop
        --증가하는 변수 i를 누적해서 더해준다.
        sumNum := sumNum +i;
        --변수 i는 1씩 증가한다.
        i := i +1;
        --10을 초과하면 탈출한다.
        exit when (i>10);
    end loop;
    dbms_output.put_line('1~10까지의 합은:'|| sumNum);
end;
/

---------------------------------------------------        


/*
반복문2 : while문
    Basic loop와는 다르게 조건을 먼저 확인하 후 실행한다.
    즉, 조건에 맞지 않는다면 한번도 실행되지 않을 수 있다.
    반복의 조건이 있으므로 특별한 경우가 아니라면 exit를 사용하지 않아도 된다.
*/

--예제12] 제어문(반복문 : while)
declare
    num1 number :=0;
begin
    while num1<11 loop
        dbms_output.put_line('이번숫자는:'|| num1);
        num1 := num +1;
    end loop;
end;
/

/* 시나리오] while loop문으로 다음과 같은 결과를 출력하시오.
*
**
***
****
*****

*/


declare 
    starStr varchar2(100);
    i number :=1;
    j number :=1;
begin
    while i <=5 loop
        while j <=5 loop
            starStr := starStr || '*';
            exit when (j<=i);
            j :=j+1;
        end loop;
            dbms_output.put_line(starStr);
            i := i +1;
            j:=1;
        end loop;
end;
/



--차후수정] 반복문 1개로 구현한 방식
declare 
    --*를 누적해서 연결한 문자형 변수를 선언한다.
    starStr varchar2(100);
    --반복을 위한 변수
    i number :=1;
begin
    --5번 반복한다.
    while i <=5 loop
        --반복문 내에서 *를 변수에 누적한다.
            starStr := starStr || '*';
            /*PL/SQL에는 줄바꿈이 없는 print()문이 별도로 없으므로 이와같이
            문자열에 누적시킨 후 출력해야 한다.*/
            dbms_output.put_line(starStr);
            i := i +1;
        end loop;
end;
/


--시나리오] while loop문으로 1부터 10까지의 정수의 합을 구하는 프로그램을 작성하시오. 
declare
    i number :=1;
    sumNum number :=0;
begin
    while i<=10 loop --조건
        sumNum := sumNum +i;
        i :=i +1; --증가식
    end loop;
    dbms_output.put_line('1~10까지의 합은 ' || sumNum);
end;
/
---------------------------------------
/*
반복문3 : for문 
    반복으 횟수를 지정하여 사용할 수 있는 반복문으로 , 반복을 위한 변수를
    별도로 선언하지 않아도 된다. 그러므로 특별한 이유가 없다면 선언부(declare)를
    기술하지 않아도 된다.
*/
declare
    -- 선언부에 선언한 변수가 없다.
begin
    --반복을 위한 변수는 별도의 선언없이 for문에서 사용할 수 있다.  
    for num2 in 0..10 loop
        dbms_output.put_line('for문짱인듯:'|| num2);
    end loop;
end;
/
begin 
    for num3 in reverse 0.. 10 loop
        dbms_output.put_line('거꾸로for문짱인듯:'|| num3);
    end loop;
end;
/

--연습문제] for loop문으로 구구단을 출력하는 프로그램을 작성하시오. 
--줄바꿈 있는 버전
begin
    --단에 해당하는 루프
    for dan in 2..9 loop
        dbms_output.put_line( dan || '단');
        --수에 해당하는 루프
        for su in 1..9 loop
            dbms_output.put_line( dan ||'*'|| su ||'='|| (dan*su));
         end loop;
    end loop;
end;
/
--줄바꿈 없이 하나의 단씩 출력되는 버전
declare
    --구구단에서 하나의 단을 저장하기 위한 문자형 변수 선언
    guguStr varchar2(1000);
begin
    --단에 해당하는 루프
    for dan in 2..9 loop
        --수에 해당하는 루프
        for su in 1..9 loop
            /*하나의 단을 문자형 변수에 누적해서 연결한다. 마지막 부분에는 
            띄어쓰기를 위해 스페이스를 하나 추가해준다. */
            guguStr := guguStr||dan||'*'||su||'='||(dan*su)||' ';
        end loop;
        --하나으 단이 모두 누적되면 즉시 출력한다.
        dbms_output.put_line(guguStr);
        --그 다음 단을 저장하기 위해 초기화 한다.
        guguStr := '';
    end loop;
end;
/
---------------------------------------------------
/*
커서(Cursor)
    : select 문장에 의해 여러행이 반환되는 경우 각 행에 접근하기 위한 개체
    선언방법] Cursor 커서명 Is
                Select 쿼리문. 단 into절이 없는 형태로 기술한다.
                
    open Cursor
    :쿼리를 수행하라는 의미. 즉 Open 할때 Cursor선언시의 select문장이
    실행되어 결과셋을 얻게된다. Cursor는 그 결과셋의 첫번째행에
    위치하게 된다.
    Fetch~Into~
        : 결과셋에서 하나의 행을 읽어들이는 작업으로 결과셋의 인출(Fetch)
    후에 Cursor는 다음행으로 이동한다.
    Close Cursor 
        :커서 닫기로 결과셋의 자원을 반납한다. select문장이 모두 처리된후 
    Cursor를 닫아준다.
    
    Cursor의 속성
        %Found : 가장 최근에 인출(Fetch)이 행을 Return하면 True,
            아니면 False를 반환한다.
        %NotFound : %Found의 반대의 값을 반환한다.
        %RowCount : 지금까지 Return된 행의 갯수를 반환한다.
*/

--시나리오] 부서테이블의 레코드를 Cursor를 통해 출력하는 PL/SQL문을 작성하시오.

declare
    --부서테이블으 전체컬럼을 참조하는 참조변수로 선언한다.
    v_dept departments%rowtype;
    /*커서선언: 부서테이블으 모든 레코드를 조회하는 select문으로
    into 절이 없는 형태로 쿼리문을 작성한다. 쿼리의 실행결과가 cur1에 저장된다.*/
    cursor cur1 is
        select
            department_id, department_name,location_id
        from departments;
begin
    /*해당 쿼리문을 실행해서 결과셋(ResultSet)을 가져온다.
    결과셋이란 쿼리(질의)문을 수행한 후 반환되는 레코드의 결과를 말한다.*/
    open cur1;
    
    
    --basic루프문으로 얻어온 결과셋의 갯수만큼 반복하여 인출한다.
    loop
        --fetch한 결과를 참조변수에 각각 저장한다.
        fetch cur1 into
            v_dept.department_id,
            v_dept.department_name,
            v_dept.location_id;
        
        --탈출조건으로 더 이상 인출할 행이 없으면 exit가 실행된다.
        exit when cur1%notfound;
        
        dbms_output.put_line(v_dept.department_id||' '||
                         v_dept.department_name||' '||           
                         v_dept.location_id);
        end loop; --basic loop문의 종료
        dbms_output.put_line('인출된행의 갯수:'||cur1%rowcount);
        --커서의 자원 반납
        close cur1;
end;
/



/*시나리오] Cursor를 사용하여 사원테이블에서 커미션이 null이 아닌 사원의 사원번호,
이름, 급여를 출력하시오. 출력시에는 이름의 오름차순으로 정렬하시오.*/

--영업사원을 인출하면 총 35개의 레코드가 인출된다.
select * from employees where commission_pct is not null
    order by first_name asc;

--Cursor가 있는 PL/SQL문 작성
declare
    --작성한 쿼리를 통해 커서를 생성한다.
    cursor curEmp is
        select employee_id,last_name,salary
        from employees
        where commission_pct is not null
        order by last_name asc;
    --사원테이블의 전체컬럼을 참조하는 참조변수 선언
    varEmp employees%rowType;
begin
    --커서를 오픈해서 쿼리문을 실행
    open curEmp;
    
    loop
        --basic loop문을 통해 커서에 저장된 결과셋을 인출한다.
        fetch curEmp
            into varEmp.employee_id,varEmp.last_name,varEmp.salary;
            
            --인출할 결과셋이 없으면 loop문을 탈출한다.
            exit when curEmp%notFound;
            dbms_output.put_line(varEmp.employee_id || ' '||
                                varEmp.last_name||' ' ||
                                varEmp.salary);
    end loop;
    --커서를 닫아 자원을 반납한다.
    close curEmp;
end;
/


/*시나리오] 다음의 조건에 맞는 연관배열을 생성한 후 값을 할당하시오.
    연관배열 자료형 명 : avType, 값의자료형:문자형, 키의자료형:문자형
    key : girl, boy
    value : 트와이스, 방탄소년단
    변수명 : var_array
*/





 
 
 
 
 
 
 
 
 
 
 
 