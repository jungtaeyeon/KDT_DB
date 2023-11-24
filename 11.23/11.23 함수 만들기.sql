-- 사용자 정의 함수 만들기! DDL문

-- 만들어진 함수를 수정하려면 OR REPLACE
-- 함수 FUNCTION

CREATE OR REPLACE FUNCTION func_crate(pdate varchar2)
RETURN NUMBER 
IS
	tmp NUMBER;
BEGIN  -- BEGIN과 END 사이에 실행문
	tmp :=0;
	SELECT crate INTO tmp
		FROM test02
	WHERE cdate = (SELECT MAX(cdate) FROM test02
					WHERE cdate < pdate);
	RETURN tmp;
END;