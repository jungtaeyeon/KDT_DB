declare
a number(5);
begin
dbms_output.put_line('hello oracle');
dbms_output.put_line('오늘은'||to_char(sysdate,'YYYY-MM-DD')||'입니다.');
end;
/

-- Procedure created
-- in->외부로 내보낼 수 있음
-- is 와 begin 사이에 선언한다.
-- := ->초기화 / 
create or replace procedure proc_hello(x IN NUMBER,msg OUT VARCHAR2)
IS
a number(5):=0;
begin
dbms_output.put_line('hello oracle');
dbms_output.put_line('오늘은'||to_char(sysdate,'YYYY-MM-DD')||'입니다.');
end;
/

-- proc_hello 프로시저 호출

BEGIN
	proc_hello(0);
END;
/

--1부터 10까지 합 구하는 프로시저

CREATE OR REPLACE PROCEDURE proc_hap(num IN NUMBER, msg OUT varchar2)
IS
	n_i number(5);
	n_hap number(5);
BEGIN 
	n_i :=0; -- 디비버에서는 위에서 초기화를 못해서 에 0을 초기화 해줘야 한다..
	n_hap :=0; 
	FOR n_i IN 1..10 LOOP
	  n_hap := n_hap + n_i;
	END LOOP;
	msg := '1부터 10까지의 합은 '||n_hap||'입니다.';
END;
/

-- proc_hap 프로시저 호출
DECLARE
    result_msg VARCHAR2(100);
BEGIN
    proc_hap(1, result_msg);
    DBMS_OUTPUT.PUT_LINE(result_msg);
END;
/

-- sqlplus 에서 확인방법
-- SQL> variable msg varchar2(100);
-- SQL> exec proc_hello(1,:msg);
-- SQL> print msg;

-- 입력한 숫자(num) 부터 입력한 숫자(num2) 까지 합해주는 프로시저 

CREATE OR REPLACE PROCEDURE proc_hap1(num IN NUMBER, num2 IN NUMBER, msg OUT varchar2)
IS
	n_i number(5);
	n_hap number(5);
BEGIN 
	n_hap :=0;
	FOR n_i IN num..num2 LOOP
	  n_hap := n_hap + n_i;
	END LOOP;
	msg := '1부터 10까지의 합은 '||n_hap||'입니다.';
END;
/

-- proc_hap1 프로시저 호출
DECLARE
    result_msg VARCHAR2(100);
BEGIN
    proc_hap(1, 100, result_msg);
    DBMS_OUTPUT.PUT_LINE(result_msg);
END;
/


--1부터 100까지 세면서 5의 배수의 합

CREATE OR REPLACE PROCEDURE proc_hap2(num IN NUMBER, msg OUT varchar2)
IS 
	n_i NUMBER(5);
	n_hap NUMBER(5);
BEGIN 
	n_hap :=0;
	FOR n_i IN 1..100 LOOP
	  IF 
	  	MOD(n_i, 5) = 0 THEN
	  	n_hap := n_hap + n_i;
	  END IF;
	END LOOP;
	msg := '1부터 100까지에서 5의 배수의 합은 '||n_hap||'입니다.';
END;
/

-- proc_hap2 프로시저 호출
DECLARE
    result_msg VARCHAR2(100);
BEGIN
    proc_hap2(0, result_msg);
    DBMS_OUTPUT.PUT_LINE(result_msg);
END;
/

-- 1~100 까지 5의 배수일 때 fizz 출력 / 7의 배수일 때 buzz 출력
-- 5,7의 공배수일 때 fizzbuzz 출력
-- LOOP 끝나기 전 exit when n_i > 50;를 추가하면 51까지 나오고 루프 탈출

CREATE OR REPLACE PROCEDURE proc_hap3(msg IN varchar2)
IS 
n_i NUMBER(5);
BEGIN
	FOR n_i IN 1..100 LOOP
		IF MOD(n_i,5) = 0 
		THEN
		  dbms_output.put_line('fizz');
		ELSIF MOD(n_i,7) = 0 
		THEN
		  dbms_output.put_line('buzz');
		ELSIF MOD(n_i,35) = 0
		THEN
		   dbms_output.put_line('fizzbuzz');
		ELSE 
		  dbms_output.put_line(n_i);
		END IF;
	exit when n_i > 50;
	END LOOP;
END;
/

-- proc_hap3 프로시저 호출

BEGIN
    proc_hap3('');
END;
/

-- 연습문제 
-- t_worktime테이블 데이터의 작업시간이 짧게 걸리는 시간 순서대로 1부터 15까지의 순위를 매겨서 출력하시오.

SELECT * FROM t_worktime;

SELECT 
	 workcd_vc,time_nu
	 ,rank() OVER (order by time_nu) rank
 FROM t_worktime;

-- 3등까지만 보자

SELECT rownum rno,workcd_vc,time_nu FROM t_worktime
 WHERE rownum < 4;

SELECT
       *
  FROM (
       SELECT rownum rno,workcd_vc,time_nu FROM t_worktime
       WHERE rownum < 4
       )a,
       (
       SELECT rownum rno,workcd_vc,time_nu FROM t_worktime
       WHERE rownum < 4
       )b;
      
SELECT
       a.rno, b.workcd_vc, b.time_nu
  FROM (
       SELECT rownum rno,workcd_vc,time_nu FROM t_worktime
       WHERE rownum < 4
       )a,
       (
       SELECT rownum rno,workcd_vc,time_nu FROM t_worktime
       WHERE rownum < 4
       )b;
      
SELECT
       a.workcd_vc,a.time_nu,count(b.workcd_vc)
  FROM (
       SELECT rownum rno,workcd_vc,time_nu FROM t_worktime
       WHERE rownum < 4
       )a,
       (
       SELECT rownum rno,workcd_vc,time_nu FROM t_worktime
       WHERE rownum < 4
       )b
 WHERE a.time_nu >= b.time_nu
 GROUP BY a.workcd_vc,a.time_nu
 ORDER BY time_nu;


