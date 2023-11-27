-- 예외처리에 관한 프로시저

CREATE OR REPLACE PROCEDURE proc_exception1
IS 
	n_i NUMBER(5);
BEGIN 
	n_i := 0;
	n_i := '김유신';
  EXCEPTION
  	WHEN invalid_number THEN
  		dbms_output.put_line('잘못된 숫자값에 대한 에러');
  	WHEN value_error THEN
  		dbms_output.put_line('잘못된 데이터값에 대한 에러');
  	WHEN OTHERS THEN
  		dbms_output.put_line('잘못된 숫자나 데이터값은 아닌 에러');
END;
/

BEGIN
	proc_exception1;
END;
/

CREATE OR REPLACE PROCEDURE proc_errormsg
IS 
-- 변수 선언부
	err_num NUMBER;
	err_msg varchar2(300);
	n_i number(5);
BEGIN 
-- 프로그램 코딩부
	n_i := 120/0;
	EXCEPTION
		WHEN OTHERS THEN
			err_num := SQLCODE;
			err_msg := substr(SQLERRM, 1, 100);
			dbms_OUTPUT.put_line('에러코드: '|| err_num);
			dbms_OUTPUT.put_line('에러메시지: '|| err_msg);
END;
/

BEGIN
	proc_errormsg;
END;
/

-- 강제로 예외를 일으키는 예제

CREATE OR REPLACE PROCEDURE proc_raise
IS 
-- 선언부
 	user_excep EXCEPTION; -- 사용자정의 예외객체
BEGIN 
	raise user_excep;
	EXCEPTION
		WHEN user_excep THEN
			dbms_output.put_line('Raise를 이용한 사용자 예외처리 방법');
		WHEN OTHERS THEN
			dbms_output.put_line('그 외 예외 처리');
END;
/

BEGIN
	proc_raise;
END;
/

-- DDL -> 구조정의하는 언어. ALTER, CREATE, DROP -> 메모리 세그먼트를 사용하지 않음 -> 속도가 빠르다.
-- DML -> SELECT(GET 방식), INSERT(POST 방식), UPDATE(PUT 방식), DELETE - CRUD


CREATE OR REPLACE PROCEDURE proc_loop1(dan IN NUMBER)
IS 
	n_i NUMBER(2);
BEGIN 
	-- 파라미터에 선언된 변수는 재정의 불가함.
	n_i :=0;
	dbms_output.put_line(dan||'단을 출력합니다.');
END;
/

BEGIN
	proc_loop1(1);
END;
/

CREATE OR REPLACE PROCEDURE proc_loop2(dan IN NUMBER)
IS 
	n_i NUMBER(2);
BEGIN 
	-- 파라미터에 선언된 변수는 재정의 불가함.
	n_i :=0;
	dbms_output.put_line(dan||'단을 출력합니다.');
	LOOP
		dbms_output.put_line(dan||'*'||n_i||'='||(dan*n_i));
		n_i := n_i +1;
		IF n_i > 9 THEN
			EXIT;
		END IF;
	END LOOP;
END;
/

BEGIN
	proc_loop2(2);
END;
/

-- 1부터 10까지 세면서 짝수의 합

CREATE OR REPLACE PROCEDURE proc_hap4
IS 
	n_i NUMBER(2);
	n_hap NUMBER(2);
BEGIN 
	n_i := 1;
	n_hap := 0; 
	LOOP
		n_i := n_i+1;
		IF MOD(n_i, 2) = 0
		THEN
		n_hap := n_hap + n_i;
		END IF;
		EXIT WHEN n_i = 11;
	END LOOP;
	dbms_output.put_line('짝수의 합은: '||n_hap);
END;
/

BEGIN
	proc_hap4;
END;
/

-- 사원번호를 입력받아서 그 사원이 속한 부서의 평균급여보다 많이 받고있으면
-- 10%인상, 적거나 같게 받고있으면 20% 인상하여 테이블을 업데이트 하는 프로시저를 작성하시오.

SELECT * FROM EMP;
SELECT EMPNO FROM EMP; -- 사원번호
SELECT * FROM EMP WHERE EMPNO = 7566; -- 사원번호

CREATE OR REPLACE PROCEDURE proc_emp_sal(p_empno IN NUMBER, msg OUT varchar2)
IS 
	ename varchar2(30) := '';
	sal NUMBER(7) := 0;
	avg_sal NUMBER(10,2) := 0;
	rate NUMBER(5,2) := 0;
BEGIN 
	SELECT ename, sal INTO ename, sal
	 FROM EMP
	WHERE  empno = p_empno;

	SELECT avg(sal) INTO avg_sal
	 FROM EMP
	WHERE deptno = (SELECT deptno FROM emp WHERE empno = p_empno); 
 IF
	sal > avg_sal 
	 THEN
	 rate := 1.1;
	ELSE
	 rate := 1.2; 	
 END IF;
  UPDATE EMP 
  	SET sal = sal * rate
  WHERE empno = p_empno;
 COMMIT;
msg := ename||'사원의'||sal||'급여가'||rate||'인상분으로'||sal*rate||'으로 인상되었습니다.';
END;
/

DECLARE
    msg VARCHAR2(300);
BEGIN
    proc_emp_sal(7566, msg);
    DBMS_OUTPUT.PUT_LINE(msg);
END;
/

-- 다음 문제 -> 커서를 사용하여..
-- 부서번호를 입력받아서 그 부서의 평균급여 보다 많이 받는 사원은
-- 10%인상을 하고 적게 받는 사원은 20%인상을 적용하여
-- 급여정보를 수정하는 프로시저를 작성하시오.

CREATE OR REPLACE PROCEDURE proc_empcursor(rc_emp OUT sys_refcursor)
IS
BEGIN 
	OPEN rc_emp
	FOR SELECT empno, ename, sal, hiredate FROM emp;
END;
/

-- ref커서 사용할 때, sqlpluse 명령문
-- variable r_emp refcursor
-- exec proc_empcursor(:r_emp)  -> 변수 앞에 : 필요
-- print r_emp;

-- 다음단계는 내일..!

CREATE OR REPLACE PROCEDURE proc_login1(p_id IN varchar2, p_pw IN varchar2, r_name OUT varchar2, r_status OUT NUMBER)
IS 
BEGIN 
	SELECT nvl((SELECT m_id FROM MEMBER1 WHERE m_id=p_id), -1) INTO r_status
	 FROM dual;
END;

-- 위에도 내일..!