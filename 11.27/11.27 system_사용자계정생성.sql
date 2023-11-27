-- 사용자 계정 생성하기

CREATE USER tomato IDENTIFIED BY tomaot;

-- 사용자 계정으로 커넥션 허용하기

GRANT CONNECT, resource TO tomato;

GRANT CREATE SEQUENCE TO tomato;

-- 테이블 생성 권한

GRANT UNLIMITED TABLESPACE TO tomato;

GRANT CREATE TABLE TO tomato WITH admin OPTION;

-- 뷰를 만들 수 있는 권한

GRANT CREATE VIEW TO tomato;

-- 계정 비밀번호 바꾸기

ALTER USER tomato IDENTIFIED BY tomato;
