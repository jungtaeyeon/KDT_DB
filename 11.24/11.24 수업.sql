-- ER-WIN -> ERD(Entity Relation Diagram)를 그리는 도구이다.
--> 관계 형태(1:1, 1:n, n:n)를 그림으로 나타내줌
--> 이러한 관계형태를 그림으로 나타내게 되면 PK와 FK를 확인할 수 있다.
--> PK와 FK를 통해서 상속관계 증명 - 관계 - 주는쪽과 받는쪽이 결정된다.

-- 데이터베이스 모델링
--> 논리적 설계(개체, Entity, 속성(Attribute))
--> 물리적 설계(테이블, 컬럼-타입이 결정된다.)

-- DML 문
SELECT 
	FROM
WHERE 
GROUP BY 
[[HAVING]]
ORDER BY 

char 타입 -> 고정형 타입 hello_____
varchar2 타입 -> hello 나머지 5칸은 만납 - 가변형 타입

SELECT 컬럼명1, 컬럼명2, .... 함수명(컬럼명3)
	FROM 집합1, 집합2, (SELECT 문 -> 인라인뷰)
WHERE 컬럼명1 = 값(상수만이 아니라 SELECT문이 올 수 있다. -> 서브쿼리) - 조건검색만 가능한게 아니라 조인도 한다.
	AND 컬럼명2 = 값(상수만이 아니라 SELECT문이 올 수 있다.) -> 교집합 -> 원소가 줄어든다. -> 일량이 줄어든다
	 OR 컬럼명3 = 값 -> 합집합(경우의수가 계속 증가한다. 일량이 증가) 그래서-> OR 대신 IN 사용했었다.
GROUP BY 컬럼명1, 컬럼명2, (단 - 그룹함수가 아니다, GROUP BY 절에 없는 컬럼은 SELECT 문에 쓰지 못한다.)
[[HAVING]]
ORDER BY 

-- GROUP BY 절에 여러개의 조건이 올 수 있다. - 업무에 대한 복잡도 높을수록 이렇다.

SELECT deptno, job
FROM EMP 
GROUP BY DEPTNO, job
ORDER BY DEPTNO 

SELECT COUNT(empno), COUNT(comm) FROM emp; --> null도 포함해서 센다.  

SELECT DECODE(job, 'CLERK', sal, NULL)
FROM emp;

SELECT SUM(DECODE(job, 'CLERK', sal, NULL)) --> null은 포함하지 않는다. 
FROM emp;
