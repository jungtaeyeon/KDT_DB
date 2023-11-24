-- DML - 데이터 조작어

SELECT * FROM temp;

SELECT * FROM tdept;

SELECT
      ename
 FROM emp;

-- 테이블을 드라이브 할 때 인덱스 정보 읽는다
-- 테이블을 엑세스하지 않고도, 즉 인덱스 정보만으로도 '조회가 된다'

-- 테이블을 access하지 않고 조회됨 

SELECT
      empno
 FROM emp;
 
SELECT
      empno, rowid rid
 FROM emp;
 
SELECT ename
  FROM emp
 WHERE rowid = 'AAARE8AAEAAAACTAAC';  
 
SELECT
      empno
 FROM emp 
ORDER BY empno desc;

-- 옵티마이저가 조건을 만족하는 정보를 직접 찾아온다
-- 병렬처리 지원, 클러스터 지원

SELECT
      ename
 FROM emp 
 
ORDER BY empno desc;
 -----------------------------------------
-- 부적합한 식별자: 자바 에러가 아님 
 SELECT
       dname
  FROM emp;
  
-- SELECT
--       dname
--  FROM emp,dept;

-- 카타시안곱: 집합을 복제해서 총합,소계,계를 구할 때 사용
-- 왜 복제인가? 하나의 값이 총계에서 한 번,소계에서 한 번,계를 구할 때 한 번
-- 같은 값이 4번 사용되어야 한다
-- 한 명의 사원이 근무할 수 있는 부서의 종류가 모두 출력되었기 때문에 14*4=56명의 직원이 나오고 있다

 SELECT
       dept.dname,emp.deptno,dept.deptno
  FROM emp,dept;
  
-- 쓰레기 값이 포함되어 있으니 제거해줘야 함
-- Natural join

-- 1:n의 관계: 이런 경우는 조인을 걸 수 있다
 SELECT
       dept.dname,emp.deptno,dept.deptno
  FROM emp,dept
 WHERE emp.deptno = dept.deptno;

delete from dept where deptno IN(60,80,90);

commit;

SELECT * FROM dept;

rollback;