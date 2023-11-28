-- 테이블 생성

CREATE TABLE SCOTT.SW_DESIGN
(
  D_NO      NUMBER(4),
  SUB_CD    NUMBER(4)                           NOT NULL,
  QUESTION  VARCHAR2(500 BYTE)                  NOT NULL,
  ANSWER1   VARCHAR2(1000 BYTE)                 NOT NULL,
  ANSWER2   VARCHAR2(1000 BYTE)                 NOT NULL,
  ANSWER3   VARCHAR2(1000 BYTE)                 NOT NULL,
  ANSWER4   VARCHAR2(1000 BYTE)                 NOT NULL,
  D_POINT   NUMBER(3)                           DEFAULT 0,
  DAP       NUMBER(1)                           DEFAULT 0
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE UNIQUE INDEX SCOTT.DESIGN_NO_PK ON SCOTT.SW_DESIGN
(D_NO)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           );

ALTER TABLE SCOTT.SW_DESIGN ADD (
  CONSTRAINT DESIGN_NO_PK
  PRIMARY KEY
  (D_NO)
  USING INDEX SCOTT.DESIGN_NO_PK
  ENABLE VALIDATE);
  
 -- 테이블 데이터
 
 D_NO,SUB_CD,QUESTION,ANSWER1,ANSWER2,ANSWER3,ANSWER4,D_POINT,DAP
1,1001,다음 중 소프트웨어설계원칙으로 부적합한 것을 고르시오.,1)설계변경이 용이하도록 구조화해야 한다.,2)한 함수 안에 특정 기능을 수행하는데 필요한 자료만을 사용하도록 규제해서는 안된다.,3)설계는 분석모델까지 추적이 가능해야 한다.,4)제작되는 과정에서 품질평가를 해야하며 결정된 후에 평가해서는 안된다.,25,2
2,1001,다음은 소프트웨어 설계에 대한 정의이다. 틀린 설명을 고르시오.,1)요구사항 분석단계에서 규명된 필수기능을 어떻게 구현할 수 있는가에 대한 방법을 명시한다.,2)데이터구조 및 프로그램 구조 인터페이스 프로시저 등을 표현하는 다단계 과정이다.,3)물리적 구현이 가능하도록 device나 process 시스템을 추상적으로 정의해야 한다.,4)응집력있고  잘 표현된 프로그램을 개발하기 위해서는 상위수준에서는 부분들의 연관관계에 중점을 두고 하위 수준에서는 논리적 연산에 중점을 둔다.,25,3
3,1001,다음 중 설계 프로세스에 해당하지 않는 것을 고르시오.,1)아키텍쳐 설계  ,2)DB설계,3)컴포넌트설계,4)메인시스템 설계,25,4
4,1001,다음 중에서 추상화에 대해 올바른 설명을 고르시오.,1)구체적 데이터의 내부구조를 외부에 알리지 않으면서 데이터를 사용하는데 필요한 함수만을 알려주는 기법이다.,2)소프트웨어를 기능단위로 분해한 것을 말한다.,3)일명 블랙박스화라고도 하며 모듈간의 불필요한 상호작용을 제거한다.,4)소프트웨어 구성요소와 외부와의 관계를 표현하는 시스템의 구조나 구조체를 말한다.,25,1


-- 테이블 생성
CREATE TABLE SCOTT.EXAM_PAPER
(
  EXAM_NO       VARCHAR2(10 BYTE),
  DAP1          NUMBER(5)                       DEFAULT 0,
  DAP2          NUMBER(5)                       DEFAULT 0,
  DAP3          NUMBER(5)                       DEFAULT 0,
  DAP4          NUMBER(5)                       DEFAULT 0,
  RIGHT_ANSWER  NUMBER(5)                       DEFAULT 0,
  WRONG_ANSWER  NUMBER(5)                       DEFAULT 0
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
MONITORING;


CREATE UNIQUE INDEX SCOTT.PAPER_NO_PK ON SCOTT.EXAM_PAPER
(EXAM_NO)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           );

ALTER TABLE SCOTT.EXAM_PAPER ADD (
  CONSTRAINT PAPER_NO_PK
  PRIMARY KEY
  (EXAM_NO)
  USING INDEX SCOTT.PAPER_NO_PK
  ENABLE VALIDATE);
