-- =====================================================
-- member 테이블 : 회원 관련 기능 SQL (MySQL 기준)
-- 컬럼/데이터는 임시로 작성한 예시입니다.
-- =====================================================

-- -----------------------------------------------------
-- 0. 테이블 생성
-- -----------------------------------------------------
DROP TABLE IF EXISTS member;

CREATE TABLE member (
    member_id   BIGINT       NOT NULL AUTO_INCREMENT COMMENT '회원 번호(PK)',
    login_id    VARCHAR(50)  NOT NULL                COMMENT '로그인 아이디',
    password    VARCHAR(255) NOT NULL                COMMENT '비밀번호(SHA-256 해시)',
    name        VARCHAR(50)  NOT NULL                COMMENT '이름',
    email       VARCHAR(100) NOT NULL                COMMENT '이메일',
    phone       VARCHAR(20)      NULL                COMMENT '휴대폰 번호',
    birth_date  DATE             NULL                COMMENT '생년월일',
    address     VARCHAR(255)     NULL                COMMENT '주소',
    status      VARCHAR(10)  NOT NULL DEFAULT 'ACTIVE' COMMENT '회원 상태(ACTIVE / WITHDRAWN)',
    created_at  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '가입일시',
    updated_at  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',
    PRIMARY KEY (member_id),
    UNIQUE KEY uk_member_login_id (login_id),
    UNIQUE KEY uk_member_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='회원';


-- -----------------------------------------------------
-- 1. 회원 INSERT (회원가입)
-- -----------------------------------------------------
INSERT INTO member (login_id, password, name, email, phone, birth_date, address)
VALUES ('hong123', SHA2('hong1234!', 256), '홍길동', 'hong@example.com', '010-1234-5678', '1995-03-15', '서울특별시 강남구 테헤란로 1');

INSERT INTO member (login_id, password, name, email, phone, birth_date, address)
VALUES ('kim456', SHA2('kim5678@', 256), '김철수', 'kim@example.com', '010-2345-6789', '1998-07-22', '경기도 성남시 분당구 판교로 2');

INSERT INTO member (login_id, password, name, email, phone, birth_date, address)
VALUES ('lee789', SHA2('lee9012#', 256), '이영희', 'lee@example.com', '010-3456-7890', '2000-11-05', '부산광역시 해운대구 해운대로 3');


-- -----------------------------------------------------
-- 2. 회원 SELECT (내정보보기)
--    비밀번호는 조회 대상에서 제외
-- -----------------------------------------------------
SELECT member_id,
       login_id,
       name,
       email,
       phone,
       birth_date,
       address,
       created_at,
       updated_at
  FROM member
 WHERE login_id = 'hong123'
   AND status   = 'ACTIVE';


-- -----------------------------------------------------
-- 3. 회원 UPDATE (내정보수정)
--    아이디/비밀번호를 제외한 개인정보 수정
-- -----------------------------------------------------
UPDATE member
   SET name       = '홍길동',
       email      = 'gildong@example.com',
       phone      = '010-9999-8888',
       address    = '서울특별시 서초구 서초대로 10'
 WHERE login_id = 'hong123'
   AND status   = 'ACTIVE';


-- -----------------------------------------------------
-- 4. 비밀번호 변경
--    현재 비밀번호가 일치할 때만 새 비밀번호로 변경
--    (영향받은 행이 0이면 현재 비밀번호 불일치)
-- -----------------------------------------------------
UPDATE member
   SET password = SHA2('newHong5678!', 256)
 WHERE login_id = 'hong123'
   AND password = SHA2('hong1234!', 256)
   AND status   = 'ACTIVE';


-- -----------------------------------------------------
-- 5. 회원 DELETE (회원 탈퇴)
-- -----------------------------------------------------
-- 5-1. 소프트 삭제 : 상태만 탈퇴로 변경 (데이터 보존)
UPDATE member
   SET status = 'WITHDRAWN'
 WHERE login_id = 'kim456'
   AND password = SHA2('kim5678@', 256)
   AND status   = 'ACTIVE';

-- 5-2. 하드 삭제 : 레코드 실제 삭제
DELETE FROM member
 WHERE login_id = 'lee789'
   AND password = SHA2('lee9012#', 256);
