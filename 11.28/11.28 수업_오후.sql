-- 삭제
CREATE OR REPLACE procedure proc_deptDelete(p_deptno IN number)
is
begin
    delete from dept where deptno = p_deptno;
    commit;
end;
/

BEGIN
    proc_deptDelete(51);
END;

-- 입력

CREATE OR REPLACE procedure proc_deptInsert(p_deptno IN number , p_dname IN varchar2, p_loc IN varchar2)
is
begin
    insert into dept(deptno, dname, loc) values(p_deptno, p_dname, p_loc);
    commit;
end;
/

DECLARE
    p_dname VARCHAR2(300);
    p_loc VARCHAR2(300);
BEGIN
    proc_deptInsert(51, '운영부', '강원');
END;

SELECT * FROM DEPT; 

CREATE OR REPLACE procedure proc_deptInsert2(p_deptno IN number , p_dname IN varchar2, p_loc IN varchar2)
is
begin
    insert into dept(deptno, dname, loc) select 51, '운영부','강원' from dual;
    commit;
end;
/

CREATE OR REPLACE procedure proc_deptInsert3(p_deptno IN number , p_dname IN varchar2, p_loc IN varchar2)
is
begin
    insert into dept(deptno, dname, loc) select p_deptno, p_dname,p_loc from dual;
    commit;
end;
/

-- 수정

CREATE OR REPLACE procedure proc_deptUpdate(p_deptno IN number , p_dname IN varchar2, p_loc IN varchar2)
is
begin
    UPDATE dept
        set dname = p_dname
               ,loc = p_loc
        WHERE deptno = p_deptno;
    commit;
end;
/

DECLARE
    p_dname VARCHAR2(300);
    p_loc VARCHAR2(300);
BEGIN
    proc_deptUpdate(51, '운영부', '서울');
END;

DECLARE
   p_dname VARCHAR2(300);
   p_loc VARCHAR2(300);
BEGIN
    proc_deptUpdate(53, 'DBA', '인천');
END;

-- in 을 쓰면 50 이거나 51이거나 53 중에 있는거 전부 찾는것
SELECT * FROM dept WHERE  DEPTNO IN (50, 51, 53);

-- 전처리와 후처리
-- deptno 가 50이 있으면 deptno 하지만 없으면 -1 출력
SELECT
	NVL((SELECT deptno FROM dept WHERE deptno = 50), -1)
 FROM 