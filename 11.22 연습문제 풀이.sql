--tmep의 자료를 salary로 분류하여 30,000,000이하는 'D',
--30,000,000 초과 50,000,000이하는 'C'
--50,000,000 초과 70,000,000이하는 'B'
--70,000,000 초과는 'A'라고 등급을 분류하여 등급별 인원수를
--알고 싶다.

SELECT
		COUNT (CASE WHEN salary <= 30000000 THEN 'D' END) d,
		COUNT (CASE WHEN salary BETWEEN 30000001 AND 50000000 THEN 'C' END) c,
		COUNT (CASE WHEN salary BETWEEN 50000001 AND 70000000 THEN 'B' END) b,
		COUNT (CASE WHEN salary > 70000000 THEN 'A' END) a
FROM TEMP;

SELECT
		CASE WHEN salary <= 30000000 THEN 'D'
		WHEN salary BETWEEN 30000001 AND 50000000 THEN 'C'
		WHEN salary BETWEEN 50000001 AND 70000000 THEN 'B'
		WHEN salary > 70000000 THEN 'A' 
		END 등급,
		COUNT(*) 
FROM TEMP 
GROUP BY CASE WHEN salary <= 30000000 THEN 'D'
		WHEN salary BETWEEN 30000001 AND 50000000 THEN 'C'
		WHEN salary BETWEEN 50000001 AND 70000000 THEN 'B'
		WHEN salary > 70000000 THEN 'A' 
		END ;

	
	
-- 1) 판매날짜   판매개수   판매가격 
--	  20040601  nnn     nnn
--	  20040602  nnn     nnn
--	  20040603	nnn     nnn
--    총 계 : 	nnn     nnn

SELECT indate_vc FROM t_orderbasket;
SELECT * FROM t_orderbasket;
             
SELECT indate_vc FROM t_orderbasket
GROUP BY indate_vc;             

SELECT rno,indate_vc FROM t_orderbasket,
(SELECT rownum rno FROM dept WHERE rownum <3);

SELECT decode(b.rno, 1,indate_vc, 2,'총계') FROM t_orderbasket,
(SELECT rownum rno FROM dept WHERE rownum <3)b
GROUP BY decode(b.rno,1,indate_vc,2,'총계');

-- count는 row를 세는 것, num은 더하는 것
SELECT  count(QTY_NU), sum(qty_nu) 
  FROM T_ORDERBASKET;
 
SELECT SUM(price_nu) -- 단가만 반영된 것 -> 수량이 반영되지 않음
FROM t_orderbasket;

SELECT SUM(price_nu * QTY_NU) --> 판매 수량이 반영되어 총 판매 가격을 나타냄
FROM t_orderbasket;

-- 날짜별로.. 묶는다 GROUP BY INDATE_VC;
SELECT INDATE_VC, SUM(QTY_NU), SUM(price_nu * QTY_NU)  
	FROM T_ORDERBASKET 
GROUP BY INDATE_VC;

--
SELECT a.tot
	FROM (
			SELECT SUM(qty_nu * price_nu) tot
			FROM T_ORDERBASKET
			GROUP BY indate_vc
			)a

------------------------------------------------------------------------------------------------------------------------정답!
SELECT decode(b.rno, 1,indate_vc, 2,'총계') 판매날짜, SUM(qty_nu) 판매개수, SUM(price_nu * qty_nu) 판매가격  FROM t_orderbasket,
(SELECT rownum rno FROM dept WHERE rownum <3)b
GROUP BY decode(b.rno,1,indate_vc,2,'총계');



-- 2) case ... when 구분 활용
-- member1 테이블을 이용하여 아이디가 존재하지 않으면 -1반환
-- 아이디가 존재하면 비밀번호까지 비교하여 같으면 1을 반환
-- 다르면 0을 반환하는 select문을 작성하시오.
SELECT * FROM MEMBER1 ; 

SELECT m_name
	FROM MEMBER1
WHERE m_id =:id
	AND m_pw =:pw;

-- 아래 문장은 조건을 만족하지 않을 때 2건이 조회된다.
-- 왜냐면 두 건에 대해 모두 비교하고 결과를 반환하기 때문
SELECT  CASE WHEN m_id =:id THEN 0 ELSE -1 END FROM member1;
-- 만약 회원수가 5만명인 경우 5만건을 조회한다는 것 이니까 비효율 적이다.
-- 그렇다면 맨 위에 한 건만 사용해도 되는 거니까 첫 번째 로우만 출력하면 될 것 이다.
-- 그래서 rownum이라는 예약어를 사용하였다. 이것이 stop key의 역할을 한다.
SELECT  CASE WHEN m_id =:id THEN 0 END FROM member1
WHERE rownum = 1;

SELECT  CASE WHEN m_id =:id THEN 0 ELSE -1 END 
FROM member1
WHERE rownum = 1;

-- -1이면 아이디가 존재하지 않는다.
-- 1이면 아이디와 비밀번호가 모두 일치한다.
-- 0이면 아이디는 존재하지만 비밀번호는 틀리다.

SELECT  CASE WHEN m_id =:id THEN
		CASE WHEN m_pw =:pw THEN 1
		ELSE 0 END	
		ELSE -1 END RESULT
FROM member1
WHERE rownum = 1;
------------------------------------------------------------------------------------------------------------------------정답!
SELECT RESULT 
	FROM 
	(
	SELECT  CASE WHEN m_id =:id THEN
		CASE WHEN m_pw =:pw THEN 1
		ELSE 0 END	
		ELSE -1 END RESULT
		FROM member1
		ORDER BY RESULT DESC 
		)
	WHERE rownum = 1;


-- 사원번호를 채번하는데 최대값에서 1을 더한 값을 새로운 사원의 사번으로
-- 채번하는 경우를 생각해보면....

SELECT empno
FROM emp;

SELECT /*+index_desc(emp pk_emp)*/empno
FROM emp;

SELECT /*+index_desc(emp pk_emp) */empno+1
FROM emp;

SELECT /*+index_desc(emp pk_emp) */empno+1
FROM emp
WHERE rownum =1;



-- 3) 실전문제
-- - 로우에 있는 이름을 컬럼레벨에 나는 출력할 수도 있다.
-- emp 테이블의 사원이름을 한 행에 사번, 성명을 3명씩 보여주는 query 문을 작성하시오

SELECT rownum rno, MOD(rowdum,3) mno FROM emp;

SELECT rownum "순번",
		MOD(rownum, 3) AS "y축 좌표값",
		CEIL(rownum/3) AS "로우값"
		FROM EMP ;
	
SELECT CEIL(rownum/3),
		MAX(MOD(rownum, 3)) AS "y축 좌표값",
		MAX(CEIL(rownum/3)) AS "로우값"
		FROM EMP 
		GROUP BY CEIL(rownum/3);

-- 컬럼레벨에 있는 정원숫자를 굳이 로우레벨에 내려서 출력하시오.

SELECT  * FROM test11;

decode(rno, 1,'1학년', 2,'2학년', 3,'3학년', 4,'4학년')

SELECT dept, decode(rno, 1, '1학년', 2,'2학년', 3,'3학년', 4,'4학년') ,
 			decode(rno, 1,fre, 2,sup, 3,jun, 4,sen)
FROM TEST11,
(SELECT rownum rno FROM dept WHERE rownum <= 4)
ORDER BY dept ASC, decode(rno, 1,'1학년', 2,'2학년', 3,'3학년', 4,'4학년') ASC;


-- 4) 실전문 - 조인 없이 emp집합만으로 할 수 있는 만큼만 해본다.
SELECT 1,2,3 FROM dual; -- -> 컬럼(가로) 증가

SELECT 1 FROM DUAL
UNION ALL
SELECT 2 FROM DUAL; -- -> 세로(row) 증가



SELECT decode(job, 'CLERK',SAL),
		decode(job, 'SALESMAN',SAL),
		decode(job, 'CLERK',NULL, 'SALESMAN',NULL, SAL)
FROM EMP 

SELECT sum(sal)
FROM EMP 
GROUP BY DEPTNO ;


SELECT SUM( decode(job, 'CLERK',SAL)),
		SUM(decode(job, 'SALESMAN',SAL)),
		SUM(decode(job, 'CLERK',NULL, 'SALESMAN',NULL, SAL))
FROM EMP ;

SELECT DEPTNO,
		SUM( decode(job, 'CLERK',SAL)),
		SUM(decode(job, 'SALESMAN',SAL)),
		SUM(decode(job, 'CLERK',NULL, 'SALESMAN',NULL, SAL))
FROM EMP 
GROUP BY DEPTNO;


SELECT dname,
		SUM(decode(job, 'CLERK',SAL)),
		SUM(decode(job, 'SALESMAN',SAL)),
		SUM(decode(job, 'CLERK',NULL, 'SALESMAN',NULL, SAL)),
		SUM(sal) 
FROM EMP, DEPT
WHERE emp.DEPTNO = dept.DEPTNO
GROUP BY DEPT.dname;


SELECT '총계',
		SUM(decode(job, 'CLERK',SAL)),
		SUM(decode(job, 'SALESMAN',SAL)),
		SUM(decode(job, 'CLERK',NULL, 'SALESMAN',NULL, SAL)),
		SUM(sal) 
FROM EMP;


SELECT dname,
		SUM(decode(job, 'CLERK',SAL)),
		SUM(decode(job, 'SALESMAN',SAL)),
		SUM(decode(job, 'CLERK',NULL, 'SALESMAN',NULL, SAL)),
		SUM(sal) 
FROM EMP, DEPT
WHERE emp.DEPTNO = dept.DEPTNO
GROUP BY DEPT.dname
UNION ALL 
SELECT '총계',
		SUM(decode(job, 'CLERK',SAL)),
		SUM(decode(job, 'SALESMAN',SAL)),
		SUM(decode(job, 'CLERK',NULL, 'SALESMAN',NULL, SAL)),
		SUM(sal) 
FROM EMP;

-- 테이블을 한 번만 읽고 처리하는 방법은 없나??
-- 첫번째
-- 일단은 조인을 먼저 걸지말고 부서별 이니까 group by를 먼저 해본다.

SELECT 
		deptno, clerk_sum, salseman_sum, etc_sum
	FROM (
		SELECT deptno,
		SUM(decode(job, 'CLERK',SAL)) clerk_sum,
		SUM(decode(job, 'SALESMAN',SAL)) salseman_sum,
		SUM(decode(job, 'CLERK',NULL, 'SALESMAN',NULL, SAL)) etc_sum,
		SUM(sal) 
	FROM EMP
	GROUP BY deptno
		 );
		
-- 조인 걸기
-- 서브쿼리에서 사용한 컬럼은 주쿼리에서 사용불가능 하지만,
-- 인라인뷰에서 사용한 컬럼은 테이블 위치이므로 사용이 가능하다.
SELECT 
		d.dname, e.clerk_sum, e.salseman_sum, e.etc_sum
	FROM(
		SELECT 
			deptno, clerk_sum, salseman_sum, etc_sum
		FROM (
			SELECT deptno,
			SUM(decode(job, 'CLERK',SAL)) clerk_sum,
			SUM(decode(job, 'SALESMAN',SAL)) salseman_sum,
			SUM(decode(job, 'CLERK',NULL, 'SALESMAN',NULL, SAL)) etc_sum,
			SUM(sal) 
		FROM EMP
		GROUP BY deptno
		 )
		)e, dept d
WHERE e.deptno = d.deptno;

-- 더미테이블 '총계' 붙이기 1
SELECT 
		*
	FROM (
		SELECT 
			d.dname, e.clerk_sum, e.salseman_sum, e.etc_sum
		FROM(
			SELECT 
				deptno, clerk_sum, salseman_sum, etc_sum
			FROM (
				SELECT deptno,
				SUM(decode(job, 'CLERK',SAL)) clerk_sum,
				SUM(decode(job, 'SALESMAN',SAL)) salseman_sum,
				SUM(decode(job, 'CLERK',NULL, 'SALESMAN',NULL, SAL)) etc_sum,
				SUM(sal) 
			FROM EMP
			GROUP BY deptno
			 )
			)e, dept d
	WHERE e.deptno = d.deptno
		)a,
		(SELECT  rownum rno FROM dept WHERE rownum<3) b;
	
--	더미테이블 '총계' 붙이기 2	
	
SELECT 
		decode(b.rno, 1,dname, 2,'총계')
	FROM (
		SELECT 
			d.dname, e.clerk_sum, e.salseman_sum, e.etc_sum
		FROM(
			SELECT 
				deptno, clerk_sum, salseman_sum, etc_sum
			FROM (
				SELECT deptno,
				SUM(decode(job, 'CLERK',SAL)) clerk_sum,
				SUM(decode(job, 'SALESMAN',SAL)) salseman_sum,
				SUM(decode(job, 'CLERK',NULL, 'SALESMAN',NULL, SAL)) etc_sum,
				SUM(sal) 
			FROM EMP
			GROUP BY deptno
			 )
			)e, dept d
	WHERE e.deptno = d.deptno
		)a,
		(SELECT  rownum rno FROM dept WHERE rownum<3) b
GROUP BY decode(b.rno, 1,dname, 2,'총계') ;

-- 더미테이블 '총계' 붙이기 3 (직접 해보기)
SELECT 
		decode(b.rno, 1,dname, 2,'총계')
	FROM (
		SELECT 
			d.dname, e.clerk_sum, e.salseman_sum, e.etc_sum
		FROM(
			SELECT 
				deptno, clerk_sum, salseman_sum, etc_sum
			FROM (
				SELECT deptno,
				SUM(decode(job, 'CLERK',SAL)) clerk_sum,
				SUM(decode(job, 'SALESMAN',SAL)) salseman_sum,
				SUM(decode(job, 'CLERK',NULL, 'SALESMAN',NULL, SAL)) etc_sum,
				SUM(sal) 
			FROM EMP
			GROUP BY deptno
			 )
			)e, dept d
	WHERE e.deptno = d.deptno
		)a,
		(SELECT  rownum rno FROM dept WHERE rownum<3) b
GROUP BY decode(b.rno, 1,dname, 2,'총계') ;




SELECT 
			d.dname, e.clerk_sum, e.salseman_sum, e.etc_sum
		FROM(
			SELECT 
				deptno, clerk_sum, salseman_sum, etc_sum
			FROM (
				SELECT deptno,
				SUM(decode(job, 'CLERK',SAL)) clerk_sum,
				SUM(decode(job, 'SALESMAN',SAL)) salseman_sum,
				SUM(decode(job, 'CLERK',NULL, 'SALESMAN',NULL, SAL)) etc_sum,
				SUM(sal) 
			FROM EMP
			GROUP BY deptno
			 )
			)e, dept d
	WHERE e.deptno = d.deptno;








