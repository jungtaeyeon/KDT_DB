--1.월 급여는 연봉을 18로 나누어 홀수 달에는 연봉의 1/18이 지급되고, 짝수달에는 연봉의 2/18가 지급된다고 가정했을 때 홀수 달과 짝수 달에 받을 금액을 나타내시오.
-- (컬럼이 오는 자리에 사칙연산이 가능하다.)

SELECT  salary FROM temp;

SELECT  salary/18,  salary*2/18 FROM temp;

SELECT  salary/9 FROM temp;

-- 더블쿼테이션 없이 사용할 때 띄어쓰기는 불가능 하다!!
SELECT dname "부서명1", dname AS "부서명2", dname 부서명3 from dept;

SELECT  salary/18 as "홀수달급여",  salary*2/18 as "짝수달급여" FROM temp;

-- 소수점 한자리까지 나오게 반올림, 10의자리까지 나오게 반올림, 1의자리까지 나오게 반올림
SELECT round(12345.6789, 1), round(12345.6789, -1), round(12345.6789, 0) FROM dual;


SELECT  round(salary/18,-1) as "홀수달급여", round(salary/18,0)
           ,  round(salary*2/18,-1) as "짝수달급여" 
  FROM temp;
  
SELECT  round(salary/18,-1)||'원' as "홀수달급여"
           ,  round(salary*2/18,-1)||'원' as "짝수달급여" 
  FROM temp;  
  
 -- 오라클에서도 형전환 암수가 있다. -> 숫자형 -> 문자형 으로 바꾼다.
 -- 함수는 파라미터도 있고 리턴값도 있다???
SELECT  TO_CHAR(round(salary/18,-1), '999,999,999')||'원' as "홀수달급여"
           ,  round(salary*2/18,-1)||'원' as "짝수달급여" 
  FROM temp;  
 -- 조건에는
 -- 점조건과, ==, in구문
 -- 선분조건이 있다. between A and B, LIKE문
 
SELECT SYSDATE FROM dual;

SELECT 
	TO_CHAR(SYSDATE, 'YYYY-MM-DD'),
	TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS AM'),
	TO_CHAR(SYSDATE, 'YYYY-MM-DD HH:MI:SS AM'),
	TO_CHAR(SYSDATE, 'day') 
FROM dual;

-- 컬럼수가 증가하면 가로가 늘어난다.
SELECT 1,2,3,4,5 FROM dual;
-- 합집합을 사용하면 로우가 늘어난다.
SELECT 1 FROM DUAL 
UNION ALL
SELECT 2 FROM DUAL 
UNION ALL
SELECT 3 FROM DUAL;
-- 가로로 되어있는 값을 세로에 출력할 수 있다.
-- 세로에 있는 값을 가로에 출력할 수 있다.

SELECT deptno FROM dept
MINUS
SELECT deptno FROM emp;

SELECT deptno, 1 FROM dept
MINUS
SELECT deptno, 1 FROM emp;

SELECT deptno, 1 FROM dept
MINUS
SELECT deptno, 2 FROM emp;

SELECT deptno FROM dept
INTERSECT
SELECT deptno FROM emp;

-- all을 붙이면 중복제거를 안하고 전부 합쳐준다.
-- 중복 제거를 안해서 속도가 빠르다!
SELECT deptno FROM dept
UNION ALL 
SELECT deptno FROM emp;

-- all이 없으면 중복제거를 해준다.
-- 그리고 정렬을 해준다. 그래서 느리다.. (2차 가공을 하기 때문에.)
SELECT deptno FROM dept
UNION
SELECT deptno FROM emp;


-------------------------------------------------------------------------------------------------------------------------

--2.위에서 구한 월 급여에 교통비가 10만원씩 지급된다면(짝수달은 20만원)위의 문장이
--어떻게 바뀔지 작성해 보시오.
SELECT  TO_CHAR((round(salary/18,-1)+100000), '999,999,999')||'원' as "홀수달급여",
        TO_CHAR((round(salary*2/18,-1)+200000), '999,999,999')||'원' as "짝수달급여" 
  FROM temp; 


-- 우리회사 사원중에 인센티브를 받지않는 사람의 이름와 사원번호를 출력하시오.
SELECT  empno, ename FROM EMP;
SELECT  empno, ename FROM EMP
WHERE comm > 0;

-- null인 사람
SELECT  empno, ename FROM EMP
WHERE comm IS NULL ; 
-- null이 아닌 사람 0도 포함
SELECT  empno, ename FROM EMP
WHERE comm IS NOT NULL ;
-- null도 아니고 0보다 커야함
SELECT  empno, ename FROM EMP
WHERE comm IS NOT NULL
AND comm > 0;
-- null도 아니고 0보다 커야함 -> 위와 같은 결과
SELECT empno, ename FROM emp WHERE comm IS NOT  NULL
UNION 
SELECT empno, ename FROM emp WHERE comm > 0;

SELECT  empno, ename FROM EMP
WHERE comm IS NOT NULL
OR comm > 0;

-------------------------------------------------------------------------------------------------------------------------

--3.TEMP 테이블에서 취미가 NULL 이 아닌 사람의 성명을 읽어오시오.
SELECT *FROM  TEMP t ;

SELECT emp_name,HOBBY FROM TEMP
WHERE HOBBY IS NOT NULL ;

-- 등산 또는 낚시
SELECT emp_name, HOBBY FROM TEMP
WHERE HOBBY = '등산'
OR HOBBY = '낚시';
-- 위와 같은 결과
SELECT emp_name, HOBBY FROM TEMP
WHERE HOBBY IN('등산', '낚시');

-- hobbyrk null 또는 등산인 경우
SELECT emp_name, HOBBY FROM TEMP
WHERE HOBBY = '등산'
OR HOBBY IS NULL;

-- hobby가 null또는 '낚시' 모두 속하지 않는 경우를 구하시오
SELECT emp_name, HOBBY FROM TEMP
WHERE HOBBY != '낚시'
AND HOBBY IS NOT NULL;

-- NOT IN 연산자에 null이 포함되면 어떤것도 출력되지 않는다!
SELECT emp_name, HOBBY FROM TEMP
WHERE HOBBY NOT IN (NULL, '낚시');

-------------------------------------------------------------------------------------------------------------------------


--4.TEMP 테이블에서 취미가 NULL인 사람은 모두 HOBBY를 “없음”이라고 값을 치환하여 가져오고 나머지는 그대로 값을 읽어오시오.
-- 값이 null인 경우 치환해준다. -> NVL
SELECT NVL(hobby, '없음') AS "취미" FROM TEMP;  

SELECT ename, comm, nvl(comm,0) AS "comm 0치환" FROM EMP ;

-------------------------------------------------------------------------------------------------------------------------

--5.TEMP의 자료 중 HOBBY의 값이 NULL인 사원을 ‘등산’으로 치환했을 때 HOBBY가 ‘등산인 사람의 성명을 가져오는 문장을 작성하시오.
SELECT EMP_NAME FROM TEMP
WHERE NVL(hobby, '등산')='등산';

SELECT ename, empno FROM EMP 
WHERE empno = 7566;
-- varchar로 검색하더라도 검색이 된다!
SELECT ename, empno FROM EMP 
WHERE empno = '7566';

-------------------------------------------------------------------------------------------------------------------------

--6.TEMP의 자료 중 EMP_ID와 EMP_NAME을 각각 ‘사번’,’성명’으로 표시되어 DISPLAY되도록 COLUMN ALLIAS를 부여하여 SELECT 하시오.

SELECT emp_id,  emp_name
  FROM temp;

SELECT emp_id as "사번",  emp_name as "성명"
  FROM temp;
  
SELECT emp_id  "사번",  emp_name  "성명"
  FROM temp;  
  
SELECT 사번, 성명
  FROM (SELECT emp_id  "사번",  emp_name  "성명"
  		FROM temp);


--7.TEMP의 자료를 직급 명(LEV)에 ASCENDING하면서 결과내에서 다시 사번 순으로
--DESCENDING하게 하는 ORDER BY하는 문장을 만들어 보시오.
