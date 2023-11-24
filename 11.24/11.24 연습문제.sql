-- temp 테이블의 사원이름을 한 행에 사번, 성명을 3명씩 보여주시오

SELECT * FROM temp;

SELECT rownum rno FROM temp;

SELECT rownum rno, emp_name FROM temp;

-- 1,2,3이 모두 1이 출력되도록 한다. - 왜냐면 3개 이름은 모두 첫 줄에 출력해야 하니까.

SELECT 
	rno, ceil(rno/3) cno
 FROM (SELECT rownum rno FROM temp)

SELECT 
	rno, ceil(rno/3) cno, mod(rno,3) mno
	, emp_name
 FROM (SELECT rownum rno, emp_name FROM temp)
 
SELECT 
	CEIL(rno/3) cno
 FROM (SELECT rownum rno, emp_name FROM temp)
GROUP BY CEIL(rno/3)
ORDER BY cno;

SELECT '김길동', '홍길동', '박문수' FROM DUAL 
UNION ALL
SELECT '정도령', '이순신', '지문덕' FROM DUAL
UNION ALL
SELECT '강감찬', '설까치', '연흥부' FROM DUAL;

decode(MOD(rno,3),1 '김길동' ) --> rno를 3으로 나눈 나머지가 1일때 '김길동'

SELECT 
	CEIL(rno/3) cno
	, MAX(DECODE(MOD(rno,3),1, MOD(rno,3))) d1
	, MAX(DECODE(MOD(rno,3),2, MOD(rno,3))) d2
	, MAX(DECODE(MOD(rno,3),0, MOD(rno,3))) d3
 FROM (SELECT rownum rno, emp_name FROM temp)
GROUP BY CEIL(rno/3)
ORDER BY cno;

SELECT 
	CEIL(rno/3) cno
	, DECODE(MOD(rno,3),1, emp_name) d1
	, DECODE(MOD(rno,3),2, emp_name) d2
	, DECODE(MOD(rno,3),0, emp_name) d3
 FROM (SELECT rownum rno, emp_name FROM temp);

SELECT 
	CEIL(rno/3) cno
	, MAX(DECODE(MOD(rno,3),1, emp_name)) d1
	, MAX(DECODE(MOD(rno,3),2, emp_name)) d2
	, MAX(DECODE(MOD(rno,3),0, emp_name)) d3
 FROM (SELECT rownum rno, emp_name FROM temp)
GROUP BY CEIL(rno/3)
ORDER BY cno;

SELECT 
	CEIL(rno/3) cno
	, MAX(DECODE(MOD(rno,3),1, emp_id||'-'||emp_name)) d1
	, MAX(DECODE(MOD(rno,3),2, emp_id||'-'||emp_name)) d2
	, MAX(DECODE(MOD(rno,3),0, emp_id||'-'||emp_name)) d3
 FROM (SELECT rownum rno, emp_id, emp_name FROM temp)
GROUP BY CEIL(rno/3)
ORDER BY cno;

-- 한 행에 5명씩!

SELECT 
	CEIL(rno/5) cno
	, MAX(DECODE(MOD(rno,5),1, emp_id||'-'||emp_name)) d1
	, MAX(DECODE(MOD(rno,5),2, emp_id||'-'||emp_name)) d2
	, MAX(DECODE(MOD(rno,5),3, emp_id||'-'||emp_name)) d3
	, MAX(DECODE(MOD(rno,5),4, emp_id||'-'||emp_name)) d4
	, MAX(DECODE(MOD(rno,5),0, emp_id||'-'||emp_name)) d5
 FROM (SELECT rownum rno, emp_id, emp_name FROM temp)
GROUP BY CEIL(rno/5)
ORDER BY cno;
 