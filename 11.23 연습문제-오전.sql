--문제1. 사원번호가 7500번 이상인 사원들의 이름, 
--입사일자, 급여를 출력하시오.

--조건절: where,having(group by)

SELECT ename,hiredate,sal
  FROM emp
 WHERE empno >= 7500;
 
 
-- 문제2:입사년도가 1981년인 사원들의 사번을 출력하시오.

--hiredate는 날짜 타입
--DATE이(가) 필요하지만 1981타입은 NUMBER임
SELECT
       empno
  FROM emp
 WHERE hiredate = 1981;
  
SELECT empno,to_char(hiredate,'YYYY')
  FROM emp
 WHERE '1981' = to_char(hiredate,'YYYY');

--문제3:사원의 이름이 A로 시작되는 사원들의 사원번호를 출력하시오.

--선분조건 - range scan(구간 검색)

SELECT empno,ename
  FROM emp
 WHERE ename LIKE 'A%';
 
--A에 한해서가 아닌 변수 적용해서 사용 가능
SELECT empno,ename
  FROM emp
 WHERE ename LIKE :x||'%';



--문제4:입사일자가 1981년 2월1일 에서 1981년 6월30일사이에 
--있는 사원들의 사번과 명단을 출력하시오  
SELECT * FROM EMP e ;

SELECT empno, ENAME, HIREDATE 
FROM emp
WHERE HIREDATE BETWEEN '1981-02-01' AND '1981-06-30';




--문제5:급여가 1000불보다 크거나 같고 3000불보다 작거나 같은
--직원들의 이름과 급여를 출력하시오.
SELECT ENAME, SAL 
FROM emp
WHERE sal BETWEEN 1000 AND 3000;

SELECT ENAME, SAL 
FROM emp
WHERE sal >= 1000 
AND sal <= 3000;
-- 구간검색에서 크거나 같다 작거나 같다 둘다 만족해야 한다.
-- 교집합 -INTERSECT
SELECT deptno FROM EMP e 
INTERSECT
SELECT DEPTNO  FROM dept;



--문제6:급여가 3000불이 아닌 사원들의 사번과 이름을 출력하시오.   
SELECT empno, ename
FROM emp
WHERE sal != 3000;

SELECT empno, ename
FROM emp
WHERE NOT sal = 3000;

-- 아닌걸 찾을때도 색인을 사용할 수 있나요??
-- 인덱스만 읽고도 조회가 된다??
-- 인덱스관리하는 테이블이 있다.
-- 인덱스키+rowid
SELECT empno
FROM emp;

SELECT empno, ENAME  -- ename은 인덱스가 없어서 실행계획이 위와 바뀌었다.
FROM emp;

SELECT empno, ENAME  
FROM emp
WHERE EMPNO = 7566;

SELECT empno, ENAME  
FROM emp
WHERE ename = 'SMITH'; -- ename은 인덱스가 없다.

CREATE INDEX i_ename ON emp(ename asc);
CREATE INDEX i_empno ON emp(empno asc);

SELECT empno
FROM emp;

SELECT ename
FROM emp;

SELECT ename
FROM EMP
WHERE ENAME = ''; -- 인덱스 사용x 

SELECT ename
FROM EMP
WHERE ENAME = ' '; -- 인덱스 사용

SELECT empno, ENAME  
FROM emp
WHERE EMPNO = 7566; -인덱스 사용

SELECT empno, ENAME  
FROM emp
WHERE EMPNO != 7566; -- 인덱스 사용x

SELECT /*+rule */ empno, ENAME  
FROM emp
WHERE EMPNO = 7566;


-- 힌트문에 대해서
-- 힌트문에 오타가 있으면 무시된다. -> 원래 실행계획대로 검색해준다.
-- RDBMS가 세운 실행계획보다 개발자가 세운 실행계획이 옳다 라고 판단될 때 
-- 옵티마이저에게 내 생각을 전달할 수 있는 유일한 방법이다.
 
 -- 인덱스
 -- pk가 아닌 일번컬럼도 인덱스 가질 수 있다.
 -- 일반컬럼에 인덱스를 생성할 때도 DDL구문을 사용한다.
 -- 인덱스가 있어도 조건에 사용되지 않으면 실행계획에 반영되지 않는다???
SELECT /*+index_desc(emp pk_emp)*/empno
  FROM emp;
 
 
--문제7:사원들의 부서별 급여평균을 구하시오.
 
-- 평균 : avg
 
 SELECT * FROM EMP ;

SELECT MIN(sal), MAX(sal), SUM(sal), COUNT(sal), AVG(sal)
FROM EMP ;

 SELECT DEPTNO, avg(SAL)
 FROM emp
GROUP BY deptno;

--------------------------------------------------------------------------------------------------
-- 주제 : 서브쿼리
-- 서브쿼리에 대해서....
-- 직접적인 조건이 아니라 간접조건을 주고 원하는 결과를 찾아달라고 할 때 이면....?
-- 차이 -> 위치
-- from절에 select문이면 인라인뷰(테이블자리)
-- ㄴ 인라인뷰에 사용한 컬럼명은 별칭이더라도 주쿼리에 사용이 가능함.
-- 조건절에 select문이면 서브쿼리(값)

SELECT words_vc
FROM T_LETITBE 
WHERE WORDS_VC LIKE 'Let%';

SELECT DECODE(MOD(seq_vc, 2),0,words_vc) A
FROM T_LETITBE ;

SELECT DECODE(MOD(seq_vc, 2),0,words_vc) A
FROM T_LETITBE
WHERE A LIKE'LET%'; -- 불가능

SELECT 
	A
FROM (
	SELECT DECODE(MOD(seq_vc, 2),0,words_vc) A
	FROM T_LETITBE
	);

SELECT 
	A
FROM (
	SELECT DECODE(MOD(seq_vc, 2),1,words_vc) A
	FROM T_LETITBE
	)
WHERE A LIKE'Let%';



--1.temp에서 연봉이 가장 많은 직원의 row를 찾아서 이 금액과 동일한 금액을
--받는 직원의 사번과 성명을 출력하시오. 

SELECT * FROM TEMP;

SELECT MAX(SALARY) FROM TEMP;

SELECT emp_id, emp_name
FROM TEMP 
WHERE SALARY = (SELECT MAX(SALARY) FROM TEMP); --> 서브쿼리


--2.temp의 자료를 이용하여 salary의 평균을 구하고 이보다 큰 금액을 salary로 
--받는 직원의 사번과 성명, 연봉을 보여주시오.

SELECT * FROM TEMP;

SELECT AVG(SALARY) FROM TEMP;

SELECT emp_id, emp_name, salary
FROM TEMP
WHERE SALARY > (SELECT AVG(SALARY) FROM TEMP);

--3.temp의 직원 중 인천에 근무하는 직원의 사번과 성명을 읽어오는 SQL을 서브
--쿼리를 이용해 만들어보시오.

SELECT * FROM TEMP ; 
SELECT * FROM TDEPT ;

SELECT DEPT_CODE
FROM TDEPT 
WHERE AREA = '인천';

SELECT emp_id, emp_name
FROM TEMP 
WHERE DEPT_CODE IN (SELECT DEPT_CODE
					FROM TDEPT 
					WHERE AREA = '인천'
					);
				

--4. tcom에 연봉 외에 커미션을 받는 직원의 사번이 보관되어 있다.
--이 정보를 서브쿼리로 select하여 부서 명칭별로 커미션을 받는
--인원수를 세는 문장을 만들어 보시오.

SELECT * FROM TCOM ;
SELECT * FROM TEMP ; 
SELECT * FROM TDEPT ;

SELECT emp_id FROM TEMP
INTERSECT
SELECT emp_id FROM tcom;

SELECT 
	b.DEPT_NAME 
FROM temp a, tdept b
WHERE a.DEPT_CODE = b.DEPT_CODE 
	AND a.EMP_ID in(SELECT emp_id FROM TCOM);

SELECT 
	b.DEPT_NAME, COUNT(a.EMP_ID) 
FROM temp a, tdept b
WHERE a.DEPT_CODE = b.DEPT_CODE 
	AND a.EMP_ID in(SELECT emp_id FROM TCOM)
GROUP BY b.dept_name;

-- 다른 답 생각해보기!

SELECT emp_id 
 FROM TCOM ;

SELECT emp_id
 FROM TEMP 
 WHERE emp_id IN (SELECT emp_id 
 					FROM TCOM 
 				);
 			
SELECT dept_name


-- 5. 이전 레코드 참조하기 ( 하루 이전 날짜의 금액으로 계산)
-- 현재 날짜 AMT * 전 날 CRATE => 오늘 결제할 금액 구하기
SELECT * FROM test02;

SELECT rownum org_no, cdate, crate, amt FROM test02;

SELECT rownum copy_no, cdate, crate, amt FROM test02;

SELECT 
*
 FROM (
 		SELECT rownum org_no, cdate, crate, amt FROM test02
 	  )a,
 	  (
 		SELECT rownum copy_no, cdate, crate, amt FROM test02
	  )b
 WHERE a.org_no-1 = b.copy_no 
 
 
 SELECT 
		a.cdate, a.amt, b.crate, a.amt*b.crate AS "오늘 결제할 금액" 
 FROM (
 		SELECT rownum org_no, cdate, crate, amt FROM test02
 	  )a,
 	  (
 		SELECT rownum copy_no, cdate, crate, amt FROM test02
	  )b
 WHERE (a.org_no)-1 = b.copy_no ;

 SELECT 
		a.cdate, a.amt, b.crate, TO_CHAR((a.amt*b.crate), '9,999,999,999')||'원' AS "오늘 결제할 금액" 
 FROM (
 		SELECT rownum org_no, cdate, crate, amt FROM test02
 	  )a,
 	  (
 		SELECT rownum copy_no, cdate, crate, amt FROM test02
	  )b
 WHERE (a.org_no)-1 = b.copy_no ;


-- 만든 함수 사용
SELECT func_crate('20010903') 
	FROM dual;
	
SELECT func_crate('20010905')
	FROM dual;
	