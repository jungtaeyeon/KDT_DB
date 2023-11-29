-- 로우레벨에 있는 값을 컬럼레벨로 옮겨서 출력하기
--UI솔루션 + 

-- 변수선언 - 기준, 초기화, 위치 
--구현해 보기

SELECT 1, 2, 3 FROM dual;

SELECT 1 FROM dual
UNION  ALL
SELECT 2 FROM dual;

UI/View계층
출력되는 디자인 패턴 - 테이블구조 그대로 출력되는 경우은 없다

구조를 변경하면서 출력하기 - 인라인뷰

SELECT
	*
 FROM sw_design;
   
SELECT dap FROM sw_design;

2=2 r1:= r1+1;
3=3 r1:=r1 +1;
4=1 w1:=w1+1;
1=1  r1:=r1+1;

SELECT 1, 2, 3 FROM sw_design;


SELECT ceil(d_no/4) FROM sw_design
GROUP BY ceil(d_no/4);


SELECT ceil(d_no/4), 2,3 FROM sw_design
GROUP BY ceil(d_no/4);

--파싱과정을 통과해야만 테스트가 가능하다

SELECT 
              min(decode(d_no,1,dap))
           ,  min(decode(d_no,2,dap))
           ,  min(decode(d_no,3,dap))
           ,  min(decode(d_no,4,dap)) 
   FROM sw_design
GROUP BY ceil(d_no/4);


SELECT 
              min(decode(d_no,1,dap))
           ,  min(decode(d_no,2,dap))
           ,  min(decode(d_no,3,dap))
           ,  min(decode(d_no,4,dap)) 
           INTO d1, d2, d3, d4
   FROM sw_design
GROUP BY ceil(d_no/4);

LOOP
    fetch paper_cur into vexam_no, u1, u2, u3, u4;
    exit when paper_cur%notfound;
    if u1 = d1 then
        r1:=r1+1;
    else
        w1:=w1+1;
    end if;
END LOOP;

commit;

r1:= 0;
w1: =0;

    cursor paper_cur is
    select exam_no, dap1, dap2, dap3, dap4 from  exam_paper;
    
    fetch paper_cur into vexam_no, u1, u2, u3, u4

    update exam_paper
          set right_answer = r1,
                 wrong_answer = w1
    where exam_no = vexam_no;
    
   
   
   -- 11.28 연습문제 2
   CREATE OR REPLACE procedure SCOTT.proc_account2
is
    vexam_no varchar2(10);
--수험생이 입력한 1번 답안
    u1 number(1):=0;
--수험생이 입력한 2번 답안    
    u2 number(1):=0;
--수험생이 입력한 3번 답안    
    u3 number(1):=0;
--수험생이 입력한 4번 답안    
    u4 number(1):=0;
    --1번 정답
    d1 number(1):=0;
    --2번 정답
    d2 number(1):=0;
    --3번 정답  
    d3 number(1):=0;
    --4번 정답
    d4 number(1):=0;
--수험생이 맞춘 정답 수를 담음    
    r1 number(3):=0;
--수험생이 틀린 수를 담음        
    w1 number(3):=0;
    cursor paper_cur is
    select exam_no, dap1, dap2, dap3, dap4 from  exam_paper;
begin
    SELECT 
                  min(decode(d_no,1,dap))
               ,  min(decode(d_no,2,dap))
               ,  min(decode(d_no,3,dap))
               ,  min(decode(d_no,4,dap)) 
               INTO d1, d2, d3, d4
       FROM sw_design
    GROUP BY ceil(d_no/4);
    open paper_cur;
    --3명 수험생 채점 진행
    loop
        fetch  paper_cur into vexam_no, u1,u2,u3,u4;
        --무한루프에 대한 방어 코드 작성하기
        exit when paper_cur%notfound;--학생수만큼 반복된다 - 3바퀴를 돈다
        if u1 = d1 then
            r1:=r1+1;
        else
            w1:=w1+1;
        end if; 
        if u2 = d2 then
            r1:=r1+1;
        else
            w1:=w1+1;
        end if;    
        if u3 = d3 then
            r1:=r1+1;
        else
            w1:=w1+1;
        end if;    
        if u4 = d4 then
            r1:=r1+1;
        else
            w1:=w1+1;
        end if;   
        update exam_paper
              set right_answer = r1,
                     wrong_answer = w1
        where exam_no = vexam_no;     
        commit;
        r1:=0;
        w1:=0;                                   
    end loop;
    close paper_cur;
end;
/


CREATE OR REPLACE procedure SCOTT.proc_login1(p_id in varchar2, p_pw in varchar2, r_name out varchar2,  r_status out varchar2)
is
begin
    select nvl((select  mem_id from member where  mem_id=p_id),'-1') into r_status
        from dual;
end;
/