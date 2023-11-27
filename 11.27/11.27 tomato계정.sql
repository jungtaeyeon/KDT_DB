CREATE TABLE TOMATO.MEMBER
(
  MEM_NO    NUMBER(5) constraints mem_no_pk primary key,
  MEM_ID    VARCHAR2(10 BYTE)                   NOT NULL,
  MEM_PW    VARCHAR2(10 BYTE)                   NOT NULL,
  MEM_NAME  VARCHAR2(30 BYTE)                   NOT NULL,
  MEM_HP    VARCHAR2(20 BYTE)
);

SELECT * FROM MEMBER;

INSERT INTO MEMBER (MEM_NO, MEM_ID, MEM_PW, MEM_NAME, MEM_HP)
VALUES (1, 'tomato', '1111', '토마토', '010-1111-1111');

INSERT INTO MEMBER (MEM_NO, MEM_ID, MEM_PW, MEM_NAME, MEM_HP)
VALUES (2, 'kiwi', '2222', '키위', '010-2222-2222');

INSERT INTO MEMBER (MEM_NO, MEM_ID, MEM_PW, MEM_NAME, MEM_HP)
VALUES (3, 'apple', '3333', '사과', '010-3333-3333');
COMMIT;

--------------------------------------------------------------------------------------------------

CREATE TABLE TOMATO.QNA
(
  QNA_NO       NUMBER(5) constraints qna_no_pk primary key,
  QNA_TITLE    VARCHAR2(200 BYTE)               NOT NULL,
  QNA_CONTENT  VARCHAR2(4000 BYTE),
  QNA_HIT      NUMBER(5),
  QNA_DATE     VARCHAR2(20 BYTE),
  MEM_NO       NUMBER(5)
);

SELECT * FROM QNA;
COMMIT;

--------------------------------------------------------------------------------------------------

CREATE TABLE TOMATO.QNA_COMMENT
(
  QC_NO       NUMBER(5) constraints qc_no_pk primary key,
  QC_CONTENT  VARCHAR2(4000 BYTE),
  QC_DATE     VARCHAR2(20 BYTE),
  QNA_NO      NUMBER(5)
);

SELECT * FROM QNA_COMMENT;

COMMIT;

--------------------------------------------------------------------------------------------------
-- 작성자의 이름을 보고싶다.

SELECT 
	qna_title, qna_content, mem_name
 FROM QNA q, MEMBER m
WHERE qna.MEM_NO = member.MEM_NO;

SELECT 
	qna_title, qna_content, mem_name
 FROM QNA q NATURAL JOIN MEMBER m

-- 댓글이 존재하는 데이터 가져오기

 SELECT 
	qna_title, qna_content, mem_name, qc_content
 FROM QNA , "MEMBER" , QNA_COMMENT qc
WHERE qna.MEM_NO = MEMBER.MEM_NO
	AND qna.QNA_NO = qc.QNA_NO;

-- 댓글이 없는것도 보고싶다.
-- outer join -> 더 보이고싶은쪽에 (+) 를 붙인다.

 SELECT 
	qna_title, qna_content, mem_name, qc_content
 FROM QNA , "MEMBER" , QNA_COMMENT qc
WHERE qna.MEM_NO = MEMBER.MEM_NO
	AND qna.QNA_NO = qc.QNA_NO(+);

--------------------------------------------------------------------------------------------------




