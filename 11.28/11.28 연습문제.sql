-- 연습문제 사용 테이블 -> SW_DESIGN, EXAM_PAPER
-- EXAM_PAPER 테이블 -> EXAM_NO -> 수험번호 넣기
-- ㄴ> DAP1,2,3,4 -> 정답 넣고 비교하기.
-- ㄴ> right_answer -> 정답 맞으면 여기 카운트 틀리면 wrong_answer 카운트


SELECT * FROM EXAM_PAPER;

SELECT * FROM SW_DESIGN;

SELECT
	DECODE(d_no,1, dap)
FROM SW_DESIGN;

SELECT
	DECODE(d_no,1, dap), DECODE(d_no,2, dap), DECODE(d_no,3, dap), DECODE(d_no,4, dap)
 FROM SW_DESIGN;

-- 위 결과를 한 행으로 담기
SELECT
	CEIL(d_no/4), DECODE(d_no,1, dap), DECODE(d_no,2, dap), DECODE(d_no,3, dap), DECODE(d_no,4, dap)
 FROM SW_DESIGN;

SELECT
-- dap 하나만 있고 나머지는 다 null이기때문에 sum, min, max 뭐든 상관없다.
	  SUM(DECODE(d_no,1, dap))
	, SUM(DECODE(d_no,2, dap)) 
	, SUM(DECODE(d_no,3, dap))
	, SUM(DECODE(d_no,4, dap))
 FROM SW_DESIGN
GROUP BY CEIL(d_no/4);

SELECT
-- dap 하나만 있고 나머지는 다 null이기때문에 sum, min, max 뭐든 상관없다.
	  SUM(DECODE(d_no,1, dap)) d1
	, SUM(DECODE(d_no,2, dap)) d2
	, SUM(DECODE(d_no,3, dap)) d3
	, SUM(DECODE(d_no,4, dap)) d4
 FROM SW_DESIGN
GROUP BY CEIL(d_no/4);

-- select into에 담기 위해 인라인뷰로 깔끔하게 만들기

SELECT 
	d1,d2,d3,d4 INTO d1,d2,d3,d4
 FROM (
	 SELECT
		  SUM(DECODE(d_no,1, dap)) d1
		, SUM(DECODE(d_no,2, dap)) d2
		, SUM(DECODE(d_no,3, dap)) d3
		, SUM(DECODE(d_no,4, dap)) d4
	 FROM SW_DESIGN
	GROUP BY CEIL(d_no/4);
 	)

-- 한명일 때 
CREATE OR REPLACE PROCEDURE proc_account1(p_examno in varchar2, msg out varchar2)
IS 
	u1 NUMBER(1) :=0; -- 수험생이 입력한 1번 답안
	u2 NUMBER(1) :=0; -- 수험생이 입력한 2번 답안
	u3 NUMBER(1) :=0; -- 수험생이 입력한 3번 답안
	u4 NUMBER(1) :=0; -- 수험생이 입력한 4번 답안
	r1 NUMBER(3) :=0; -- 수험생이 맞춘 정답 수
	d_no NUMBER(3) :=1; --문제번호를 담기
	w1 NUMBER(3) :=0; -- 수험생이 틀린 정답 수
	jdap NUMBER(2) :=0; -- 커서에서 꺼낸 값 담기
	-- 정답을 커서로
	CURSOR dap_cur IS
	SELECT dap FROM SW_DESIGN;
BEGIN 
	open dap_cur;
    SELECT  dap1, dap2, dap3, dap4 INTO u1, u2, u3, u4
      FROM exam_paper
     where exam_no  = p_examno;
    loop
        fetch dap_cur into jdap;
        exit when dap_cur%notfound;
        if d_no=1 then
            if jdap = u1 then
                r1 := r1 +1;
            else
                w1 := w1 + 1;
            end if;
        elsif d_no=2 then
            if jdap = u2 then
                r1 := r1 +1;
            else
                w1 := w1 + 1;
            end if;     
        elsif d_no=3 then
            if jdap = u3 then
                r1 := r1 +1;
            else
                w1 := w1 + 1;
            end if;   
        elsif d_no=4 then
            if jdap = u4 then
                r1 := r1 +1;
            else
               w1 := w1 + 1;
            end if;                                          
        end if;        
        d_no := d_no + 1;
    end loop;
    close dap_cur;
    msg :='정답 : '||r1|| ' 오답 : '||w1;
    update exam_paper
          set right_answer = r1,
                 wrong_answer = w1
    where exam_no = p_examno;
    commit;
end;


-- sqlpluse 에서 확인
-- variable msg varchar2(300)
-- exec proc_accout1('2023112811', :msg)

DECLARE
    msg VARCHAR2(300);
BEGIN
    proc_account1('2023112811', msg);
    DBMS_OUTPUT.PUT_LINE(msg);
END;

SELECT * FROM EXAM_PAPER;

-- proc_account2 여러명 한번에

CREATE OR REPLACE PROCEDURE proc_account2(p_examno IN varchar2)
IS 
	u1 NUMBER (1) :=0; -- 수험생이 입력한 1번 답안
	u2 NUMBER (1) :=0; -- 수험생이 입력한 2번 답안
	u3 NUMBER (1) :=0; -- 수험생이 입력한 3번 답안
	u4 NUMBER (1) :=0; -- 수험생이 입력한 4번 답안
	d1 NUMBER (1) :=0; -- 1번 정답
	d2 NUMBER (1) :=0; -- 2번 정답
	d3 NUMBER (1) :=0; -- 3번 정답
	d4 NUMBER (1) :=0; -- 4번 정답
	r1 NUMBER (3) :=0; -- 수험생이 맞춘 정답 수
	w1 NUMBER (3) :=0; -- 수험생이 틀린 정답 수
BEGIN 
	
END;



