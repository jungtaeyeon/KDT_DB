 -- 트리거 
 -- 호출할 필요 없이 자동으로 실행이 된다. - 자동으로 동기화 할 때 사용가능
 -- 트리거는 비활성화 또는 활성화 할 수 있다. - 왜냐면 자동으로 실행되니까
ALTER TRIGGER 트리거명 disable | enable;
 
-- 트리거를 재컴파일 할 수 있다.
ALTER TRIGGER 트리거명 compile;

-- 트리거 삭제하기
DROP TRIGGER 트리거명;

-- 프로시저와 트리거 비교하기
-- 공통점: pl/sql문을 사용한다.
-- 차이점: 
-- execute명령어로 실행 - 반해서 생성 후 자동실행(활성화 또는 비활성화 가능)
-- commit, rollback 실행가능 - 반해서 실행안됨

-- 트리거의 응용범위
-- 보안 - 테이블에 대한 변경을 제한할 수 있다.
-- 감시 - 데이터 사용에 대한 감시를 할 수 있다.
-- 데이터무결성 보장할 수 있다.
-- 테이블 복제 - 동기화 처리 가능
-- 연속적인 작업 수행

 CREATE OR REPLACE TRIGGER trg_dept
 Before
  UPDATE OR DELETE OR INSERT ON dept
DECLARE
  msg varchar2(200) :='';
BEGIN
  IF updating THEN
  	dbms_output.put_line('===> Update');
  END IF;
 IF deleting THEN
 	dbms_output.put_line('===> Delete');
 END IF;
IF inserting THEN
	dbms_output.put_line('===> Insert');
END IF;
END;

ALTER TRIGGER trg_dept disable;
ALTER TRIGGER trg_dept enable;


-- 트리거를 이용한 동기화 복제, 유지...

CREATE TABLE dept_copy AS
SELECT * FROM dept;

CREATE OR REPLACE TRIGGER trg_deptcopy
AFTER -- INSERT OR UPDATE OR DELETE 후에
INSERT OR UPDATE OR DELETE ON dept
FOR EACH ROW -- old와 new를 쓰려면 반드시 써야한다.
BEGIN 
	IF inserting THEN 
		INSERT INTO DEPT_COPY(deptno, dname, loc)
		VALUES(:NEW.deptno, :NEW.dname, :NEW.loc);
	ELSIF updating THEN
		UPDATE DEPT_COPY 
		SET dname = :NEW.dname, loc = :NEW.loc
		WHERE deptno = :OLD.deptno;
	ELSIF deleting THEN
		DELETE FROM DEPT_COPY 
		WHERE deptno = :OLD.deptno;
	END IF;
END;

ALTER TRIGGER trg_deptcopy disable;
ALTER TRIGGER trg_deptcopy enable;


-- 테스트 시나리오 -> 데이터 복제 트리거 적용 여부 확인하기
INSERT INTO dept(deptno, dname, loc) VALUES(70, '전산과', '서울');

SELECT * FROM dept_copy;
SELECT * FROM dept;

UPDATE dept SET loc = '포항' WHERE deptno = 70;

SELECT * FROM dept_copy;

DELETE FROM dept WHERE deptno = 70;

SELECT * FROM dept_copy;
SELECT * FROM dept;