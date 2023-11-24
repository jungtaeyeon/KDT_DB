--분석함수 ROLLUP을 사용한 문제풀이
SELECT INDATE_VC AS 판매날짜, SUM(QTY_NU)||' 개' AS 판매개수,
            SUM(PRICE_NU) ||' 원' AS 판매가격
            FROM T_ORDERBASKET
          GROUP BY ROLLUP(INDATE_VC);
         
SELECT NVL(INDATE_VC,'총계') AS 판매날짜, SUM(QTY_NU)||' 개' AS 판매개수,
            SUM(PRICE_NU) ||' 원' AS 판매가격
            FROM T_ORDERBASKET
          GROUP BY ROLLUP(INDATE_VC);

-- ROLLUP 없이 문제풀기
         
-- 총계라는 셀을 추가한다.
-- 총계 위에는 날짜가 있다.
-- 없는 셀을어떻게 만들지?
-- 데이터를 복제하자 - 2배수로 복제한다.
-- 한 번은 날짜별로 계산되어야 하고, 또 다른 한 번은 총계를 구하는데 쓴다.         
-- 숫자가 1번이면 날짜별 계산에서 사용하고, 2번이면 총계를 계산할때 쓴다.         


SELECT 1 rno FROM DUAL 
UNION ALL 
SELECT 2 FROM dual;

-- 로우 수를 줄인다.
-- 컬럼은 줄일 수 있다.
-- rownum은 조회 결과에 대해서 순차적으로 번호를 매겨준다.
-- 크다 비교 안된다.
-- 작거나 같은만 된다.
-- 1과 같다 라고 조건을 붙이면 하나만 읽어서 1 출력된다. - stop key
-- 판정을 할 수 있는 경우일테니 부분범위 처리가 가능하다.
-- 단 2로 비교는 불가능하다. 1만 된다.
-- 아이디를 중복검사 하는데 만 명 중에서 100번째 아이디가 존재하는 걸 확인하였다.
-- 그렇다면 이 아이디는 사용이 불가하다 판정이 가능함.
-- 101번째 아이디와는 더 이상 비교할 필요가 없다. 왜냐면 회원가입 할 때마다 중복검사를 했으니까.

SELECT rownum rno FROM DEPT
WHERE rownum < 3;

SELECT indate_vc FROM T_ORDERBASKET;   

SELECT indate_vc FROM T_ORDERBASKET
GROUP BY indate_vc;

SELECT indate_vc FROM T_ORDERBASKET,
(SELECT rownum rno FROM dept WHERE rownum <3);

SELECT DECODE(b.rno, 1,indate_vc, 2, '소계') FROM T_ORDERBASKET,
(SELECT rownum rno FROM dept WHERE rownum <3) b;

SELECT DECODE(b.rno, 1,indate_vc, 2, '소계') FROM T_ORDERBASKET,
(SELECT rownum rno FROM dept WHERE rownum <3) b
GROUP BY DECODE(b.rno, 1,indate_vc, 2, '소계');

SELECT DECODE(b.rno, 1,indate_vc, 2, '소계') AS 판매날짜,
		SUM(qty_nu)||'개' AS 판매개수, 
		SUM(qty_nu * price_nu)||'원' AS 판매가격 
		FROM T_ORDERBASKET,
			(SELECT rownum rno FROM dept WHERE rownum <3) b
GROUP BY DECODE(b.rno, 1,indate_vc, 2, '소계');

SELECT DECODE(b.rno, 1,indate_vc, 2, '소계', 3,'총계') AS 판매날짜
		, DECODE(b.rno, 2, gubun_vc||'계', 1, gubun_vc) AS 물품구분
		, SUM(qty_nu)||'개' AS 판매개수
		, SUM(qty_nu * price_nu)||'원' AS 판매가격 
		FROM T_ORDERBASKET
			, (SELECT rownum rno FROM dept WHERE rownum <=3) b
GROUP BY DECODE(b.rno, 1,indate_vc, 2, '소계', 3,'총계'), DECODE(b.rno, 2, gubun_vc||'계', 1, gubun_vc);
         
         
         
         
         
         
-- 내가 한 문제 풀이!
         
SELECT * FROM T_ORDERBASKET ;

SELECT indate_vc AS 판매날짜, gubun_vc AS 물품구분, SUM(qty_nu)||'개' AS 판매개수, sum(qty_nu * price_nu)||'원' AS 판매가격
FROM T_ORDERBASKET
GROUP BY indate_vc, gubun_vc;

SELECT DECODE(b.rno, 1,indate_vc, 2,'소계'),gubun_vc, SUM(qty_nu)||'개' AS 판매개수, sum(qty_nu * price_nu)||'원' AS 판매가격
FROM T_ORDERBASKET, (SELECT rownum rno FROM dept WHERE rownum <= 2) b
GROUP BY DECODE(b.rno, 1,indate_vc, 2,'소계'),gubun_vc ;


SELECT DECODE(b.rno, 1,indate_vc, 2,'소계') AS 판매날짜
		, gubun_vc AS 물품구분
		, SUM(qty_nu)||'개' AS 판매개수
		, sum(qty_nu * price_nu)||'원' AS 판매가격
	FROM T_ORDERBASKET
	, (SELECT rownum rno FROM dept WHERE rownum <= 2) b
GROUP BY DECODE(b.rno, 1,indate_vc, 2,'소계'),gubun_vc ;


SELECT DECODE(b.rno, 1,indate_vc, 2,'소계', 3,'총계') AS 판매날짜
		, DECODE(b.rno, 1, gubun_vc, 2,gubun_vc||'계') AS 물품구분
		, SUM(qty_nu)||'개' AS 판매개수
		, SUM(qty_nu * price_nu)||'원' AS 판매가격
	FROM T_ORDERBASKET
	, (SELECT rownum rno FROM dept WHERE rownum <= 3) b
GROUP BY DECODE(b.rno, 1,indate_vc, 2,'소계', 3,'총계'), DECODE(b.rno, 1, gubun_vc, 2,gubun_vc||'계')
ORDER BY DECODE(b.rno, 1,indate_vc, 2,'소계', 3,'총계'), DECODE(b.rno, 1, gubun_vc, 2,gubun_vc||'계');


---------------------------------------------------------------------------------------------------------------------------------------------


SELECT
      sum(decode(job,'CLERK',sal)) clerk_sal
     ,sum(decode(job,'SALESMAN',sal)) salesman_sal
     ,sum(decode(job, 'CLERK', null, 'SALESMAN', null, sal)) etc
  FROM scott.emp a, scott.dept b
 WHERE a.deptno = b.deptno  ;
       
SELECT 
      nvl(decode(b.no, '1', dname), '총계') dname
     ,sum(clerk) clerk
     ,sum(manager) manager
     ,sum(etc) etc
     ,sum(dept_sal) dept_sal
  FROM (
        SELECT bb.dname, clerk, manager, etc, dept_sal
          FROM (
                SELECT deptno
                      ,sum(decode(job, 'CLERK', sal)) clerk
                      ,sum(decode(job, 'MANAGER', sal)) manager
                      ,sum(decode(job, 'CLERK', null, 'MANAGER', null, sal)) etc
                      ,sum(sal) dept_sal 
                 FROM emp a
                GROUP BY deptno
               )aa, dept bb
         WHERE aa.deptno = bb.deptno  
       )a,
       (SELECT '1' no FROM dual
        union all
        SELECT '2' FROM dual 
       )b     
       GROUP BY decode(b.no, '1', dname)
ORDER BY dname  ;

-- 가능하다면 테이블은 한 번만 읽어서 처리한다.
-- 경우의 수를 줄인다. -> 인라인뷰 또는 GROUP BY
-- 조인을 하기전에 미리 먼저그룹핑을 한다.
-- 그룹핑을 하면서 그룹함수가 필요한 부분 (sum(decode패턴))이 있다면 같이 해도 된다.

-- 왜 조인을 했나??
-- 부서번호가 아니라 부서명을 출력하는것이 직관적이니까 

SELECT * FROM emp;

 SELECT deptno
       	,sum(decode(job, 'CLERK', sal)) clerk
        ,sum(decode(job, 'MANAGER', sal)) manager
        ,sum(decode(job, 'CLERK', null, 'MANAGER', null, sal)) etc
        ,sum(sal) dept_sal 
     FROM emp a
GROUP BY deptno;

SELECT * FROM DEPT ;

SELECT bb.dname, clerk, manager, etc, dept_sal
          FROM (
                SELECT deptno
                      ,sum(decode(job, 'CLERK', sal)) clerk
                      ,sum(decode(job, 'MANAGER', sal)) manager
                      ,sum(decode(job, 'CLERK', null, 'MANAGER', null, sal)) etc
                      ,sum(sal) dept_sal 
                 FROM emp a
                GROUP BY deptno
               )aa, dept bb
         WHERE aa.deptno = bb.deptno;