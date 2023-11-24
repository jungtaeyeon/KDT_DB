--RDBMS제품이다.
--집합사이에 관계가 있다. - 부서집합과 사원집합
--
--관계형태
--1:1 - 회원과 포인트
--1:n - 회원과 주문, 학생과 수강신청 교과목과 수강신청 대여, 주문
--n;n - 회원과 상품 고객과 책 학생과 교과목
--
--부서집합이 부모집합이다.
--부서집합의 deptno를 받아서 태어난 집합이 사원집합이다.
--
--부서집합과 사원집합은 1:n의 관계이다.
--
--집합을 자바의 클래스로 설계할 수 있어야 JPA기술을 누릴 수 있다.
--
--부서집합의 deptno가 사원집합으로 가게 된 것은 관계 때문이었다.
--외래키라고 한다.
--관계형태 즉 1:n의 관계를 그려줄때 릴레이션(deptno)이 생성되었다
--
--1차 가공만으로 결과를 볼 수 있다.
--2차가공을 해야 결과를 본다
--일량의 차이가 있다.
--
--좀전에 봤던 실행계획을 떠올려 본다
--인덱스를 스캔해서 값을 출력하였다
--인덱스는 누가 만들어주나? - 자동으로 제공된다
--자동으로 만들때 정렬이 오름차순인가보다 추측

SELECT empno FROM emp;

--hint문 - 주석처럼 생긴 아이

SELECT
             /*+ ALL_ROWS  */ empno
  FROM emp;
  
-- 실행계획을 세울 때 
-- rule base 옵티마이저와 cost base옵티마이저 있다
--cost base옵티마이저의 경우에는 현재 데이터의 분포가 반영되어 있어야 
--올바른 선택을 기대할 수 있다.
--분포도를 처리해주는 쿼리문이 있다. - DBA권한을 가짐 
--
--인덱스는 기본적으로 오름차순 정렬이 적용되어 있다.
  
SELECT /*+index_desc(emp pk_emp) */ empno FROM emp;  

--실행계획이 인덱스를 읽어서 처리하는 것과 테이블을 억세스 하는 쪽으로 변경되었다.

SELECT empno, ename FROM emp;

SELECT ename FROM emp;

SELECT ename FROM emp
ORDER BY ename desc;

--양쪽 집합에 있는것만 나와  - natural join

SELECT empno, ename, dept.dname
  FROM emp, dept
 WHERE emp.deptno = dept.deptno;
-- 
-- 힌트문을 통해서 옵티마이저에게 개발자가 생각하는 실행계획을 전달할  수 있다
-- 만일 오타가 있으면 무시된다.
 
 SELECT /*+ rule */ *
  FROM emp, dept
 WHERE emp.deptno = dept.deptno;
 
-- 해쉬조인방식은 두 테이블을 각각 통째로 읽어서 먼저 줄을 세운뒤에
-- 조건을 비교해가면서 출력을 낸다
 
 SELECT rowid rid, ename FROM emp;
 
 SELECT rownum rno, ename FROM emp;
 
 SELECT rownum rno, empno, ename
    FROM (
                SELECT empno, ename FROM emp
                ORDER BY hiredate desc
              )

-- 그룹함수 -> 전체범위 처리 -> 속도 느리다. max min sum avg 등...
-- 전체범위 처리 반대 -> 부분범위처리(인라인뷰와 관계) -> 인라인뷰를 사용하면 일량을 줄여준다.

SELECT  SUM(sal)
FROM  emp;

SELECT count(comm)  -- null은 포함x
FROM emp;

-- 그룹함수와 일반함수는 같이 사용이 불가능하다.

SELECT  SUM(sal), ENAME 
FROM  emp;

-- GROUP BY 사용

SELECT  MIN(sal), ENAME
FROM  emp
GROUP BY ENAME ; 

--

SELECT MOD(seq_vc,2) mno
FROM T_LETITBE 
WHERE MOD(SEQ_VC,2) = 1;
-- 아래와같이 as명을 where절에 쓸 수 없다.
SELECT MOD(seq_vc,2) mno
FROM T_LETITBE 
WHERE mno = 1;
-- 아래는 가능하다... 왜?
SELECT mno
FROM (SELECT MOD(seq_vc,2) mno
		FROM T_LETITBE 
		)
		WHERE mno = 1;
		
	
SELECT deptno FROM emp;

SELECT DISTINCT(deptno) FROM emp;  -- 중복제거 함수 DISTINCT

SELECT deptno FROM emp
GROUP BY DEPTNO ; -- 이것도 중복제거 됨.
           
SELECT ename FROM emp;

SELECT ename FROM emp
GROUP BY ENAME ; -- 정렬도 된다.

----


--------- 아래 다시 확인하기!!

SELECT * FROM (
                 SELECT seq_vc,
                 decode(mod(seq_vc,2),1, words_vc) A
                FROM t_letitbe  
                UNION ALL -- 중복제거를 하지 않는다.
                 SELECT seq_vc,
                 decode(mod(seq_vc,2),0, words_vc) A
                FROM t_letitbe               
             );
-- t_letitbe를 두 번 읽어서 처리했다.
-- 왜 별칭을 A로 통일했나??

            
SELECT LOC  FROM DEPT
UNION ALL
SELECT DNAME  FROM DEPT;

SELECT DECODE(job,'CLERK', sal,null) FROM EMP ;

SELECT SUM(DECODE(job,'CLERK', sal,null))  FROM EMP ;

SELECT DECODE(job,'CLERK', sal,null),
		DECODE(job,'SALESMAN', sal,null),
		DECODE(job,'CLERK', sal,NULL)
		FROM EMP ;
	
	
SELECT 
	DEPTNO, sum(sal), COUNT(sal), MAX(sal), min(sal), AVG(sal) 
FROM EMP
GROUP BY deptno;


-- select ... from 절 사이에 조건문을 사용할 수 있다.
-- 1) decode -> 크다, 작다는 비교할 수 없다.

 SELECT decode(sign(1-2), 1,'앞에 숫자가 크다', -1,'뒤에숫자가크다', 0,'같다') 
 FROM dual;


-- 2) CASE문

 SELECT deptno, 
       CASE deptno
         WHEN 10 THEN 'ACCOUNTING'
         WHEN 20 THEN 'RESEARCH'
         WHEN 30 THEN 'SALES'
         ELSE 'OPERATIONS'
       END as "Dept Name"
  FROM dept;