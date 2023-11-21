SELECT empno, ename
  FROM emp
 WHERE deptno = 10;

SELECT empno, ename
                  FROM emp
                 WHERE deptno = 10

SELECT empno, sal
  FROM (SELECT empno, ename
                  FROM emp
                 WHERE deptno = 10) ;
            
-- 속도향상의 원리 -  index,  인라인뷰 원소의 수줄임(대상값이 줄어듦)
-- pk는 인덱스 제공
-- 테이블 억세스 없이도 검색이 가능
-- fk는 해당없음 - 중복허락

PK는 제약조건
FK는 외래키 - 중복허락, 인덱스 없음
인덱스 별도 집합
PK-FK참조무결성 제약조건
PK -부모집합
FK - 자손집합
조인을 위해서 필요함


SELECT empno, ename
  FROM emp;            
  
--1. 파싱 - 문법체크  -parsing - 메모리 기억 - 한번 요청되면 다음에는 3단계진행됨 - 속도 빨라짐
--2. 실행계획 - RDBMS
--3. 옵티마이저 전달
--4. open..cursor .. fetch(메모리에 올림) - close
--  
--insert into 집합() values(select문)

SELECT ename, sal FROM emp;

--사원집합안에 부서명도 넣어줘  -  반정규화 권장하지 않음

-- 사원수 50만명, 부서종류 100가지

--실행계획 - Ctrl +  E
-- 테이블이 두 개 이상일때 먼저 읽어들이는 테이블의 순서에 따라 속도 차이발생함

SELECT emp.empno, emp.ENAME, dept.dname
  FROM emp, dept
 WHERE dept.deptno = emp.deptno;
 
 SELECT max(sal)
   FROM  emp;
   
 SELECT max(sal), ename
   FROM  emp;   
  
  

SELECT * FROM EMP;

--컬럼자리에 함수를 래핑할 수 있는데 이때 유효한 정보를 얻기 위해서는 
--서브쿼리가 필요하다   
   
 SELECT max(sal), max(ename),  min(ename)
   FROM  emp;   
   
SELECT ename, SAL
  FROM  emp
 WHERE sal  = (SELECT max(sal) FROM emp);   
 

--6.TEMP의 자료 중 EMP_ID와 EMP_NAME을 각각 '사번','성명'으로 표시되어 
--DISPLAY되도록 COLUMN ALLIAS를 부여하여 SELECT 하시오.

SELECT
            emp_id,  emp_name
  FROM temp;

SELECT
            emp_id as "사번",  emp_name as "성명"
  FROM temp;
  
SELECT
            emp_id  "사번",  emp_name  "성명"
  FROM temp;  
  
SELECT 사번, 성명
  FROM (SELECT emp_id  "사번",  emp_name  "성명"
        FROM temp);
  
--SELECT문은 commit과 rollback의 대상이 아니다
--왜냐면 테이블 구조에 있는 데이터를 오직 읽기만 가능한 구문임
--FROM절 아래서 사용된 컬럼명은 select문 뒤 컬럼이 오는 자리에 사용가능함
--인라인 뷰도 from절 아래서 사용된 집합이니 여기서 사용된 별칭은 주쿼리에서 사용가능함
--별칭을 줄때 as를 붙이든 붙이지 않든 모두 가능함

--7.TEMP의 자료를 직급 명(LEV)에 ASCENDING하면서 결과내에서 다시 사번 순으로
--DESCENDING하게 하는 ORDER BY하는 문장을 만들어 보시오. (edited) 

--연역적사고 귀납적 사고 - 메모습관
--집합적 사고하기

SELECT * FROM temp;

SELECT emp_id, emp_name, lev FROM temp;

SELECT emp_id, emp_name, lev FROM temp
ORDER BY lev asc;

SELECT emp_id, emp_name, lev FROM temp
WHERE lev = '과장'
ORDER BY lev asc,  emp_id desc;


SELECT emp_id, emp_name, lev FROM temp
ORDER BY lev asc,  emp_id desc;

부서별 급여 평균을 구하시오
:그룹함수는 전체범위 처리(-부분범위처리)를 한다. - 속도가 느리다. - 모두 다 따져야 하니까

SELECT sal
  FROM  emp;
  
 --그룹함수와 일반컬럼은 같이 사용할 수 없다. - 암기할것인가 
  
SELECT sal, avg(sal)
  FROM  emp;  
  
SELECT avg(sal)
  FROM  emp;  
  
SELECT distinct(deptno) FROM emp; --중복제거

SELECT sal
  FROM emp
GROUP BY deptno;


SELECT
             deptno
  FROM emp
GROUP BY deptno;

SELECT
             deptno, avg(sal)
  FROM emp
GROUP BY deptno;

SELECT
             deptno, avg(sal)
  FROM emp
GROUP BY deptno
HAVING avg(sal)  >2000;
  

1)영어가사만 나오게 하기
2)한글가사만 나오게 하기
3)영문가사와 한글 가사 모두 나오게 하기
3번 문제의 경우 SELECT * FROM t_letitbe는 답이 아닙니다.
조건:합집합을 이용하셔야 합니다.
      정렬 해주셔야 합니다.
     영문가사와 한글가사 교대로 출력되어야 합니다.
해당 테이블은 첨부해 드린 오라클 소스 폴더에 SQL에서
4장에 있는 t_letitbe를 참고하세요

SELECT * FROM t_letitbe;

SELECT MOD(seq_vc,2) FROM t_letitbe;
  
SELECT MOD(seq_vc,2) FROM t_letitbe
WHERE MOD(seq_vc,2) = 1;

SELECT MOD(seq_vc,2) FROM t_letitbe
WHERE MOD(seq_vc,2) = 0;

delete from t_letitbe;
ROLLBACK;

commit;

SELECT MOD(seq_vc,2), words_vc FROM t_letitbe
WHERE MOD(seq_vc,2) = 1;

SELECT MOD(seq_vc,2), words_vc FROM t_letitbe
WHERE MOD(seq_vc,2) = 0;

SELECT MOD(seq_vc,2), words_vc FROM t_letitbe
WHERE MOD(seq_vc,2) IN (0,1);

SELECT 1, 2, 3 FROM dual;

SELECT 1 FROM dual
UNION ALL
SELECT 2 FROM dual
UNION ALL
SELECT 3 FROM dual;

SELECT * FROM t_giftpoint;

SELECT * FROM t_giftmem;

주어진 정보 - 영화티켓 - 15000점

남은 포인트 -  회원보유포인트-영화티켓포인트 =잔여포인트

조건식

보유포인트 >= 영화티켓포인트

WHERE mem.point_nu >= poi.point_nu

SELECT point_nu
  FROM t_giftpoint
 WHERE  name_vc = '영화티켓';
 --카타시안곱 데이터를 복제한다.
 
SELECT * FROM t_giftpoint, t_giftmem;
  
  SELECT * FROM t_giftmem mem,
            (SELECT point_nu
             FROM t_giftpoint
             WHERE  name_vc = '영화티켓'            
            ) poi;
            
  SELECT mem.point_nu-poi.point_nu as "잔여포인트"
  FROM t_giftmem mem,
            (SELECT point_nu
             FROM t_giftpoint
             WHERE  name_vc = '영화티켓'            
            ) poi;            
            
  SELECT mem.point_nu-poi.point_nu as "잔여포인트"
  FROM t_giftmem mem,
            (SELECT point_nu
             FROM t_giftpoint
             WHERE  name_vc = '영화티켓'            
            ) poi
	WHERE  mem.point_nu >= poi.point_nu;

  SELECT mem.name_vc as "이름"
             ,  mem.point_nu as "보유포인트"
             ,  poi.point_nu as "적용포인트" 
             ,  mem.point_nu-poi.point_nu as "잔여포인트"
  FROM t_giftmem mem,
            (SELECT point_nu
             FROM t_giftpoint
             WHERE  name_vc = '영화티켓'            
            ) poi
	WHERE mem.point_nu >= poi.point_nu;


 --인라인뷰를 사용하지 않는 답안지
 -- Nested loop 조인방식으로 비교한다.
 -- 30가지의 경우수를 모두 체크한다
 
   SELECT mem.name_vc as "이름",
   			mem.point_nu as "보유포인트",
   			poi.point_nu as "적용포인트",
            mem.point_nu-poi.point_nu as "잔여포인트"
  FROM t_giftmem mem, t_giftpoint poi
WHERE  mem.point_nu >= poi.point_nu
     AND poi.name_vc = '영화티켓';
     
--김유신씨가 보유하고 있는 마일리지 포인트로 얻을 수 있는 상품 중 가장 포인트가 높은 것은 무엇인가?

SELECT point_nu FROM t_giftmem
WHERE name_vc = '김유신';

SELECT name_vc
   FROM t_giftpoint
  WHERE point_nu <= 50012;     
  
SELECT max(name_vc)
   FROM t_giftpoint
  WHERE point_nu <= 50012;    
  
SELECT max(point_nu)
   FROM t_giftpoint
  WHERE point_nu <= 50012; 
  
SELECT name_vc
  FROM t_giftpoint
 WHERE point_nu = 50000;        
  
SELECT name_vc
  FROM t_giftpoint
 WHERE point_nu = (SELECT max(point_nu)
                   FROM t_giftpoint
                   WHERE point_nu <= 50012  
                   );        
          
DECODE문 또 CASE..WHEN
                       
DECODE는 일반적인 프로그래밍 언어의 if문을  SQL문장 또는 PL/SQL
안으로 끌어들여 사용하기 위하여 만들어진 오라클 함수이다.
같은것만 비교할 수 있다.
크다, 작다는 비교할 수 없다.
:dual은 오라클에서만 제공되는 가상 테이블이다. - 함수테스트시에 사용하기 위해 제공됨
:로우 1개 컬럼1개인 가상 테이블이다.

함수는 반환값이 있다.

FROM절만 빼고는 어디서나 사용할 수 있다.
:ORDER BY절

문제:
강의시간과 학점이 같으면 '일반과목'을 리턴 받은 후 정렬도 하고 싶다면? 어떡하지?

강의시간  : lec_time
학점 : lec_point

같으면 - > decode(lec_time,lec_point, '일반과목', null)

-- 같을때만 값을 주었으니 다를때는 무조건 null이다.

SELECT
             decode(lec_time,lec_point, '일반과목', null)
    FROM lecture;

SELECT
                decode(lec_time,lec_point, '일반과목', null)
    FROM  lecture
 ORDER BY decode(lec_time,lec_point, '일반과목', null) desc;
 
SELECT
                decode(lec_time,lec_point, '일반과목', null)
    FROM  lecture
 ORDER BY decode(lec_time,lec_point, '일반과목', null) asc;
 

-- 널이 있는 경우에 정렬은 어떻게 되나?

SELECT comm
  FROM emp;
  
 SELECT comm
   FROM emp
 ORDER BY comm desc;

--null은 모른다 이므로 혹은 결정되지 않았다. 정렬을 할  수 없다.
--그래서 맨 뒤에 붙였다.
--그래서 null인 컬럼을  내림차순으로 정렬하면 null이 맨 앞에 왔다.

 SELECT comm
   FROM emp
 ORDER BY comm asc;


:WHERE절

SELECT sign(1+100), sign(-5000), sign(100-100), sign(5000-5000)
  FROM dual;

SELECT DECODE(SIGN(100-200),1, '양수',-1,'음수', 0, '0') FROM dual ;

SELECT
   FROM dual;


IF A = B THEN
    return 'T';
END IF;

DECODE(1,1,'T')

SELECT DECODE(1,1,'T') 
            , DECODE(1,2,'T', 'F')
  FROM dual;
  
문제1 -  주당 강의시간과 학점이 같으면 '일반과목'을 돌려 받고자 한다.
쿼리문을 작성하시오.

--조건절을 만족하지 않는 경우에는 null을 반환한다는 것을 알 수 있다.

SELECT decode(lec_time, lec_point, '일반과목') FROM lecture;

SELECT decode(lec_time, lec_point, '일반과목', null) FROM lecture;

문제2 - 주당강의시간과 학점이 같은 강의의 숫자를 알고 싶다. 
쿼리문을 작성하시오.

SELECT
             count(lec_id)
  FROM lecture
 WHERE lec_time = lec_point;
 
SELECT count(empno) FROM emp;

SELECT count(comm) FROM emp; 
 
  SELECT
              decode(lec_time, lec_point,1,null)
   FROM lecture;
 
 SELECT
              count(decode(lec_time, lec_point,1))
   FROM lecture;


문제3 - 강의시간과 학점이 같거나 강의시간이 학점보다 작으면 '일반과목' 을 돌려받고
강의시간이 학점보다 큰 경우만 '실험과목' 이라고 돌려받고 싶다면 어떻게 처리할 수 있을까요?

SELECT
             lec_id, lec_time, lec_point
  FROM lecture;
  
SELECT DECODE(lec_time - lec_point, 0,'일반과목')  FROM lecture; 

SELECT DECODE(SIGN(lec_time - lec_point), -1,'일반과목')  FROM lecture; 
  
-- 1이면  실험과목, 0 이거나 -1 이면 일반과목

SELECT DECODE(SIGN(lec_time - lec_point), 1,'실험과목', '일반과목')  FROM lecture; 

SELECT DECODE(SIGN(lec_time - lec_point), 1,'실험과목'
                                                                       , 0,'일반과목'
                                                                       , -1,'일반과목')  
   FROM lecture; 

SELECT
             lec_id, lec_time, lec_point
  FROM lecture;

문제3 -1
lec_time이 크면 '실험과목', lec_point가 크면 '기타과목', 둘이 같으면 '일반과목' 으로 값을 돌려 
받고자 한다. 쿼리문을 작성해 보시오.

DECODE(SIGN(lec_time - lec_point), 1, '실험과목', 0, '일반과목', -1,'기타과목')

SELECT lec_time, lec_point,
             DECODE(SIGN(lec_time - lec_point), 1, '실험과목', 0, '일반과목', -1,'기타과목')
  FROM lecture;


문제: 월요일엔 해당일자에 01을 붙여서 4자리 암호를 만들고, 
화요일엔 11, 수요일엔 21, 목요일엔, 31, 금요일엔 41, 토요일엔 51,
일요일엔 61을 붙여서 4자리 암호를 만든다고 할 때 
암호를 SELECT하는 SQL을 만들어 보시오.

--형전환함수
-- to_char
--to_number
--to_date


SELECT to_char(sysdate, 'YYYY-MM-DD') FROM dual;

SELECT sysdate-1, sysdate+2 FROM dual;

UI( user interface or View계층) 받아오는 값인 경우가 대부분이다.
받아온 값이 문자열이다.

<input type="text" name="start_day">

SELECT to_date('2023-11-23')+1 FROM dual;


SELECT to_char(sysdate, 'day') FROM dual;
  
  
SELECT DECODE(to_char(sysdate, 'day'), '화요일', '11', '나머지') 
   FROM dual;
  
SELECT to_char(sysdate, 'dd') FROM dual; 

SELECT to_char(sysdate, 'dd')||'11' FROM dual;
 
DECODE(to_char(sysdate, 'day'), '월요일', '01'
                                                     , '화요일', '11'
                                                     , '수요일', '21'
                                                     , '목요일', '31'
                                                     , '금요일', '41'
                                                     , '토요일', '51'
                                                     , '일요일', '61')
                                                     
SELECT to_char(sysdate, 'dd')||
              DECODE(to_char(sysdate, 'day'), '월요일', '01'
                                                                 , '화요일', '11'
                                                                 , '수요일', '21'
                                                                 , '목요일', '31'
                                                                 , '금요일', '41'
                                                                 , '토요일', '51'
                                                                 , '일요일', '61') sec_key
   FROM dual;                                                     
                                                     
실전문제

SELECT DECODE(job, 'CLERK', sal,null)
  FROM emp;
  
SELECT DECODE(job, 'CLERK', sal,null)
           ,  DECODE(job, 'SALESMAN', sal,null)
  FROM emp;  
  
SELECT DECODE(job, 'CLERK', sal,null)
           ,  DECODE(job, 'SALESMAN', sal,null)
           ,  DECODE(job, 'CLERK', null,  'SALESMAN', null, sal)
  FROM emp;    
  
 --모든 테이블은 한 번만 읽고 서 처리할것. 
 
실전문제
- 로우에 있는 이름을 컬럼레벨에 나는 출력할 수도 있다.
emp 테이블의 사원이름을 한 행에 사번, 성명을 3명씩 보여주는 query 문을 작성하시오. 
 
SELECT * FROM emp;

사전학습문제
각 행에 1학년 부터 4학년 까지를 분리해서 한 행에 하나의 학년만 나오도록
하고자 한다

6장 06-002


영어가사만 나오게하기

홀수만 출력하기 -  MOD(seq_vc,2)

SELECT
            DECODE(MOD(seq_vc,2),1,  words_vc) eng_words
  FROM t_letitbe;

--DECODE에서 조건을 걸지 않을 경우 그 나머지는 null로 치환됨

SELECT
            DECODE(MOD(seq_vc,2),1,  words_vc, '0') eng_words
  FROM t_letitbe;

SELECT dname FROM emp;

SELECT
            DECODE(MOD(seq_vc,2),1,  words_vc) eng_words
  FROM t_letitbe
 WHERE eng_words = 1;
 
 별칭을 굳이 조건절에서 사용하고 싶다면 인라인뷰를 사용하시오.
 
SELECT
                eng_words
  FROM (
                SELECT
                            DECODE(MOD(seq_vc,2),1,  words_vc) eng_words
                  FROM t_letitbe  
             );

SELECT
                num, eng_words
  FROM (
                SELECT MOD(seq_vc,2) num
                            ,DECODE(MOD(seq_vc,2),1,  words_vc) eng_words
                  FROM t_letitbe  
             )
WHERE num = 1;

SELECT
            DECODE(MOD(seq_vc,2),1,  words_vc) eng_words
  FROM t_letitbe
 WHERE MOD(seq_vc,2) = 1;
 
 SELECT
            DECODE(MOD(seq_vc,2), 0,  words_vc) han_words
  FROM t_letitbe
 WHERE MOD(seq_vc,2) = 0;
 
SELECT
             decode(job, 'CLERK', sal)
   FROM emp;
   
SELECT
             sum(decode(job, 'CLERK', sal)), max(sal), count(empno)
   FROM emp;   
   
 SELECT count(empno) FROM emp;  
 
 SELECT
             decode(job, 'CLERK', sal, null)
            ,decode(job,'SALESMAN', sal, null)
   FROM emp;
   
 SELECT
             count(decode(job, 'CLERK', sal, null))
            ,sum(decode(job,'SALESMAN', sal, null))
   FROM emp;   
   
 SELECT
             count(decode(job, 'CLERK', sal, null))
            ,sum(decode(job, 'CLERK', sal, null))
             ,count(decode(job,'SALESMAN', sal, null))
            ,sum(decode(job,'SALESMAN', sal, null))
   FROM emp;      
   
-- empno는 다른 값들과 아무런 관련이 없다   
--empno에 max함수를 씌우는건 문법적인 문제를 해결하기 위해서일 뿐이다
   
 SELECT max(empno),
             count(decode(job, 'CLERK', sal, null))
            ,sum(decode(job, 'CLERK', sal, null))
             ,count(decode(job,'SALESMAN', sal, null))
            ,sum(decode(job,'SALESMAN', sal, null))
   FROM emp;      
   
sum(decode패턴) - 자주나옴   
   
 SELECT 
            sum(decode(job, 'CLERK', sal, null))
            ,sum(decode(job,'SALESMAN', sal, null))
            ,sum(decode(job, 'CLERK', null, 'SALESMAN', null, sal)) etc_sal
            , sum(sal)
   FROM emp;         
   
 SELECT
              seq_vc
             ,decode(mod(seq_vc,2),1, words_vc) A
    FROM t_letitbe;
  
 SELECT
              seq_vc
             ,decode(mod(seq_vc,2),0, words_vc) A
    FROM t_letitbe;
    
SELECT
              *
  FROM (
                 SELECT
                              seq_vc
                             ,decode(mod(seq_vc,2),1, words_vc) A
                    FROM t_letitbe  
                UNION ALL
                 SELECT
                              seq_vc
                             ,decode(mod(seq_vc,2),0, words_vc) A
                    FROM t_letitbe               
             )    
             
SELECT
            empno, sum(sal)
  FROM emp;
  
SELECT distinct(deptno) FROM emp;  
  
 SELECT
            deptno, sum(sal)
  FROM emp
 GROUP BY deptno
   
 SELECT
            deptno, sum(sal), max(sal)
  FROM emp
 GROUP BY deptno;
 
  SELECT
            deptno, sal
  FROM emp
 GROUP BY deptno;
 
 -- sal을 GROUP BY절에 추가하여 문법적인 문제를 해결했지만 대신 효과는 사라짐
 
  SELECT
            deptno, sal
  FROM emp
 GROUP BY deptno, sal ;
 
   SELECT
            deptno, sal
  FROM emp;

--max주거나 min주거나 결과에 영향이 없는 건 결국 A컬럼에 대해서 문법적인 문제를 
--해결하는 용도로 사용되었기 때문이다.

SELECT seq_vc, min(A)  as "all_word"
  FROM (SELECT seq_vc,decode(mod(seq_vc,2),1, words_vc) A
                FROM t_letitbe  
                UNION ALL
                SELECT seq_vc ,decode(mod(seq_vc,2),0, words_vc) A
                FROM t_letitbe               
             )  
GROUP BY seq_vc
ORDER BY TO_NUMBER(seq_vc) asc;            

SELECT * FROM test11;

SELECT rownum rno FROM  test11;

SELECT DECODE(rno,1,'1학년', 정원수) FROM dual

SELECT * FROM test11, (
SELECT 1 as "no" FROM dual
UNION ALL 
SELECT 2 FROM dual
UNION ALL 
SELECT 3 FROM dual
UNION ALL 
SELECT 4 FROM dual
)

SELECT b.no as "학년",decode(b.no,1, ,2, ,34
  FROM (
                SELECT * FROM test11 a, (
                SELECT 1  no FROM dual
                UNION ALL 
                SELECT 2  no FROM dual
                UNION ALL 
                SELECT 3 no FROM dual
                UNION ALL 
                SELECT 4 no FROM dual
                ) b
             );
             
             
 SELECT em
   FROM (SELECT empno em FROM emp)          
   
 SELECT * FROM test11;
 
 SELECT rownum rno FROM emp;
 
 SELECT * FROM test11, (SELECT rownum rno FROM dept WHERE rownum  <= 4);  
 
SELECT a.dept, b.rno as "학년", decode(b.rno,1,a.fre, 2, a.sup, 3, a.jun, 4, a.sen) as "정원수"
   FROM  (SELECT dept, fre, sup, jun, sen FROM test11
          WHERE dept = '항공우주공학과'
         )a,(SELECT rownum rno FROM dept WHERE rownum  <= 4               
          	)b
          	
          	
SELECT rownum rno FROM emp;

SELECT rownum rno, MOD(rownum,3) mno FROM emp;        

SELECT rownum "순번"
           , MOD(rownum,3) as "y축좌표값"
           , CEIL(rownum/3) as "로우값"
FROM emp;      

