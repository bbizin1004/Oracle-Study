/*1. inner join 방식중 오라클방식을 사용하여 first_name 이 Janette 인 
사원의 부서ID와 부서명을 출력하시오.
출력목록] 부서ID, 부서명 */

select D.department_id,department_name
from employees E , departments D
where E.department_id=D.department_id and first_name = 'Janette';

/* 2. inner join 방식중 SQL표준 방식을 사용하여 사원이름과 함께 그 사원이
소속된 부서명과 도시명을 출력하시오.
출력목록] 사원이름, 부서명, 도시명 */

select first_name,last_name,d.department_name,city
from employees E inner join departments D
    on e.department_id=d.department_id
    inner join locations L
    on d.location_id = l.location_id;
    
/*3. 사원의 이름(FIRST_NAME)에 'A'가 포함된 모든사원의 이름과 부서명을 출력하시오.
출력목록] 사원이름, 부서명 */
select first_name,last_name,department_name
from employees
    inner join departments using(department_id)
where first_name like '%A%';

/* 4. “city : Toronto / state_province : Ontario” 에서 근무하는 모든 사원의 이름, 
업무명, 부서번호 및 부서명을 출력하시오.
출력목록] 사원이름, 업무명, 부서ID, 부서명 */
select first_name,job_title,department_id,department_name
from jobs
    inner join employees using(job_id)
    inner join departments using(department_id)
    inner join locations using(location_id)
    where city='Toronto' and state_province = 'Ontario';

 /* 5. Equi Join을 사용하여 커미션(COMMISSION_PCT)을 받는 모든 사원의 이름, 
 부서명, 도시명을 출력하시오. 
출력목록] 사원이름, 부서ID, 부서명, 도시명 */

select first_name,last_name,department_id,department_name,city
from employees
    inner join departments using(department_id)
    inner join locations using (location_id)
where COMMISSION_PCT >0;

/* 6. inner join과 using 연산자를 사용하여 50번 부서(DEPARTMENT_ID)에 
속하는 모든 담당업무(JOB_ID)의 고유목록(distinct)을 부서의 도시명(CITY)을 포함하여
출력하시오.
출력목록] 담당업무ID, 부서ID, 부서명, 도시명 */

    
    
    
    
    
    
    
    
    