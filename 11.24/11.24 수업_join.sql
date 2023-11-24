-- 조인 -> 2개 이상의 테이블을 가지고 한다.
-- 집합과 집합은 관계가 있다.
-- 관계형태 - 1:1관계, 1:n관계, n:n관계
-- n:n은 업무에 대한 정의가 덜 된 경우이므로 조인을 하면 카타시안의 곱이 된다. - 주의할것. - ERD

------------------------------------ 1. natural join = equal조인(조금 더 직관적이지 않나?) ------------------------------------
--> 양쪽에 모두 있는 값만 나온다.
--> 어느 한쪽 테이블에만 있는 값은 나오지 않는다. (이건 outer조인 이다.)

SELECT empno, ename, dname  --> emp에는 dname이 없다. (dept에 있다.)
 FROM emp;

SELECT empno, ename, dname  
 FROM emp, dept; --> 카타시안의 곱 - 문제

SELECT a.empno, a.ename, b.dname  
 FROM emp a NATURAL JOIN dept b;

SELECT empno,ename,dname
  FROM emp NATURAL JOIN dept;
  
-- 과거의 표현 아래 2개
SELECT empno, ename, dname
 FROM emp a JOIN dept b
ON a.DEPTNO  = b.DEPTNO

SELECT empno, ename, dname  
 FROM emp,DEPT
 WHERE emp.DEPTNO  = dept.DEPTNO;

 
-- 연습문제) tcom의 work_year = '2001'인 자료와 temp를 사번으로 연결해서 join한 후
-- comm을 받는 직원의 성명, salary + COMM을 조회해 보시오.
SELECT 
	a.EMP_ID, a.EMP_NAME, a.SALARY + b.comm
 FROM TEMP a, TCOM b
WHERE a.emp_id = b.EMP_ID 
 AND b.work_year = '2001';

SELECT 
	EMP_ID, EMP_NAME, SALARY + comm
 FROM TEMP NATURAL JOIN TCOM
WHERE work_year = '2001';

------------------------------------ 2. non-equals조인 ------------------------------------
-- := 같다 로 비교하는 것 이외의 모든 것

-- 연습문제) temp와 emp_level을 이용해 emp_level의 과장 직급의 연봉 상한/하한 범위 내에
-- 드는 직원의 사번과, 성명, 직급, salary를 읽어보자.

SELECT * FROM EMP_LEVEL
WHERE lev = '과장';

SELECT 
	*
 FROM TEMP a, EMP_LEVEL b;

SELECT 
	a.emp_id, a.emp_name
 FROM TEMP a, EMP_LEVEL b
WHERE b.lev = '과장';

SELECT 
	a.emp_id, a.emp_name, a.LEV
 FROM TEMP a
WHERE a.SALARY BETWEEN '37000000' AND '75000000'

SELECT 
	a.emp_id, a.emp_name, a.LEV
 FROM TEMP a, EMP_LEVEL b
WHERE b.lev = '과장'
 AND a.SALARY BETWEEN FROM_SAL AND TO_SAL
 
 
 ------------------------------------ 3. outer join -> 어느 한쪽은 있고, 어느 한쪽은 없는데 없는 쪽에서도 보고싶을 때 ------------------------------------ 
 -- 수습 사원도 보이게! 
 
 SELECT 
 	b.EMP_ID 사번
 	, b.EMP_NAME 성명
 	, b.SALARY 연봉
 	, a.from_sal 하한
 	, a.to_sal 상한
  FROM emp_level a, TEMP b
 WHERE a.lev(+) = b.lev;

------------------------------------ 4. self join ------------------------------------

--연습문제) tdept테이블에 자신의 상위 부서 정보를 관리하고 있다.
--이 테이블을 이용하여 부서코드, 부서명, 상위부서코드, 상위부서명을 읽어오는 
--쿼리를 만들어 보자.

SELECT
	DEPT_NAME
 FROM TDEPT ;

SELECT
	DEPT_NAME, PARENT_DEPT
 FROM TDEPT ;

SELECT
	  DEPT_NAME AS "부서명"
	, DEPT_NAME AS "상위부서명"
 FROM TDEPT ;

SELECT
	  a.DEPT_NAME AS "부서명"
	, b.DEPT_NAME AS "상위부서명"
 FROM TDEPT a, TDEPT b;

SELECT
	  a.DEPT_NAME AS "부서명"
	, b.DEPT_NAME AS "상위부서명"
 FROM TDEPT a, TDEPT b
WHERE a.parent_dept = b.dept_code;

SELECT
	  a.dept_code AS "부서코드"
	, a.DEPT_NAME AS "부서명"
	, b.DEPT_CODE AS "상위부서코드"
	, b.DEPT_NAME AS "상위부서명"
 FROM TDEPT a, TDEPT b
WHERE a.parent_dept = b.dept_code;


