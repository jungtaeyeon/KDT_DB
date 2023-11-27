-- 연습문제1)
--각 사번의 성명, salary, 연봉하한금액, 연봉상한금액을 보고자 한다.
--temp와 emp_level을 조인하여 결과를 보여주되, 연봉의 상하한이 등록되어 있지 않은
--'수습' 사원은 성명, 이름, salary 까지만이라도 나올 수 있도록 쿼리를 작성하시오.

-- outer join
-- 두 개 이상의 테이블 조인 시 한 쪽 테이블의 행에 대해 다른쪽 테이블에
-- 일치하는 행이 없더라도 다른 쪽 테이블의 행을 null로 하여 행을 리턴하는 것
-- 연산자를 사용할 수 있다. (+)
-- 한쪽에만 올 수 있다.
-- 조인시에 값이 없는 조인측에 (+)기호를 위치시킨다.

SELECT * FROM EMP_LEVEL;

SELECT * FROM temp;

SELECT
	emp_id, emp_name, salary, t.lev, from_sal, to_sal
 FROM EMP_LEVEL el, TEMP t 
WHERE el.LEV(+) = t.LEV; 

-- LEFT OUTER JOIN - 오른편에 값이 없을 때
-- RIGHT OUTER JOIN - 왼편에 값이 없을 때
-- FULL OUTER JOIN - 양편에 모두 값이 없을 때

-- 아래 둘이 같은 결과

SELECT
	empno, ename, dname
 FROM emp, dept
WHERE emp.deptno(+) = dept.deptno;

SELECT
	empno, ename, dname
 FROM emp RIGHT OUTER JOIN dept
 	ON emp.DEPTNO = dept.DEPTNO;
 
 -- full outer join
 
SELECT
	empno, ename, dname
 FROM emp FULL OUTER JOIN dept
 	ON emp.DEPTNO = dept.DEPTNO;
 	
 -- 조인
 -- 둘 이상의 테이블을 연결(상속, 상속이 아닌경우)하여 데이터를 검색하는 방법
 
-- 회원집합과 상품집합의 관계형태는?? n:n
SELECT * FROM T_GIFTMEM;

SELECT * FROM T_GIFTPOINT;

-- 아래는 카타시안의 곱이 걸려서 의미없는 데이터가 있다.

SELECT
	*
 FROM T_GIFTMEM, T_GIFTPOINT;

SELECT
	*
 FROM T_GIFTMEM mem, T_GIFTPOINT poi
WHERE poi.NAME_VC = '과자종합';
 
-- 아래는 non-equals join이다. -> = 가 아닌 >=, <= 로 비교 

SELECT
	*
 FROM T_GIFTMEM mem, T_GIFTPOINT poi
WHERE poi.NAME_VC = '과자종합'
	AND poi.POINT_NU <= mem.POINT_NU ;   -- 회원이 가지고있는 포인트가 과자종합의 포인트보다 커야 가능하기 떄문
	
	
-- 조인 방법과 방식
-- 조인 방법 -> Natural join(등가조인, equal), Non-equal join, Self join, Outer join
-- 조인 방식 -> Nested Loop Join 방식, Hash Join 방식

	
-- Self join -> 하나의 테이블에서 조인이 발생
-- 나 자신과 1:1 또는, 1:n 관계일 때 사용
	
SELECT * FROM emp;

SELECT
	a.ename AS "매니저", b.ENAME AS "사원이름"
 FROM emp a, emp b
WHERE a.empno = b.mgr;
	
-- cross join은 카타시안의 곱과 같은 경우이다.
SELECT 
	*
 FROM emp CROSS JOIN DEPT;

-- 연습문제 2)
--temp와 tdept를 이용하여 다음 컬럼을 보여주는 SQL을 만들어 보자.
--상위부서가 'CA0001'인 부서에 소속된 직원을 1.사번, 2.성명, 3.부서코드
--4.부서명, 5.상위부서코드, 6.상위부서명, 7.상위부서장코드, 8.상위부서장성명
--순서로 보여주면 된다.

-- Natural join
SELECT 
	 a.EMP_ID, a.EMP_NAME, b.DEPT_CODE, b.DEPT_NAME
 FROM temp a, tdept b
WHERE a.DEPT_CODE  = b.DEPT_CODE

SELECT 
	 EMP_ID, EMP_NAME, DEPT_CODE, DEPT_NAME
 FROM temp NATURAL JOIN tdept;

-- 5, 6 추가 -> 테이블 갯수에서 n-1한 숫자가 join조건의 숫자와 같다.
SELECT 
	  a.EMP_ID, a.EMP_NAME, b.DEPT_CODE, b.DEPT_NAME
	, c.DEPT_CODE AS "상위부서코드"
	, c. DEPT_NAME AS "상위부서명"
 FROM temp a, tdept b, tdept c
WHERE a.DEPT_CODE  = b.DEPT_CODE
	AND b.PARENT_DEPT = c.DEPT_CODE
	AND c.DEPT_CODE = 'CA0001'

-- 7, 8 추가 
SELECT 
	  a.EMP_ID, a.EMP_NAME, b.DEPT_CODE, b.DEPT_NAME
	, c.DEPT_CODE AS "상위부서코드"
	, c. DEPT_NAME AS "상위부서명"
	, c.BOSS_ID AS "상위부서장아이디"
	, d.EMP_NAME AS "상위부서장이름"
 FROM temp a, tdept b, tdept c, temp d
WHERE a.DEPT_CODE  = b.DEPT_CODE
	AND b.PARENT_DEPT = c.DEPT_CODE
	AND c.BOSS_ID = d.EMP_ID;
	AND c.DEPT_CODE = 'CA0001'