CREATE SEQUENCE "WRKCRD"."CC_WRKCRD_APPL_SEQUENCE" MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 5841 CACHE 20 NOORDER NOCYCLE ;

CREATE TABLE "WRKCRD"."CC_WRKCRD_APPL"
  (
    "ID"            NUMBER NOT NULL ENABLE,
    "PIDM"          NUMBER NOT NULL ENABLE,
    "TERM"          VARCHAR2(6 BYTE) NOT NULL ENABLE,
    "ADMIT_CODE"    VARCHAR2(6 BYTE),
    "COMMON_APP_ID" VARCHAR2(20 BYTE),
    "CAREER"        VARCHAR2(200 BYTE),
    "CLASS_SIZE"    NUMBER DEFAULT 0,
    "RANK_WEIGHTED" FLOAT(126) DEFAULT 0,
    "GPA_HIGHEST" FLOAT(126) DEFAULT 0,
    "FIRST_WORDS" VARCHAR2(200 BYTE),
    "RANK_TYPE"   VARCHAR2(20 BYTE),
    "RANK" FLOAT(126) DEFAULT 0,
    "GPA_SCALE" FLOAT(126) DEFAULT 0,
    "GPA_WEIGHTED" FLOAT(126) DEFAULT 0,
    "APPL_NO"     NUMBER NOT NULL ENABLE,
    "STAGE"       VARCHAR2(20 BYTE) DEFAULT 'BEGIN' NOT NULL ENABLE,
    "NEXT_READER" VARCHAR2(20 BYTE),
    "CREATED_BY"  VARCHAR2(20 BYTE),
    "CREATED_ON" DATE DEFAULT SYSDATE,
    "UPDATED_BY" VARCHAR2(20 BYTE),
    "UPDATED_ON" DATE,
    "READS_COMPLETED" NUMBER DEFAULT 0 NOT NULL ENABLE,
    "TRUE_SIZE"       NUMBER DEFAULT 0,
    "PERCENT_COLL_BOUND" FLOAT(126) DEFAULT 0,
    CONSTRAINT "CC_WRKCRD_APPL_PK" PRIMARY KEY ("ID") USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645 PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT) TABLESPACE "CC_DEVELOPMENT" ENABLE,
    CONSTRAINT "CC_WRKCRD_APPL_STAGE_FK" FOREIGN KEY ("STAGE") REFERENCES "WRKCRD"."CC_WRKCRD_APPL_STAGE" ("ID") ENABLE
  )
  SEGMENT CREATION IMMEDIATE PCTFREE 10 PCTUSED 0 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING STORAGE
  (
    INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645 PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT
  )
  TABLESPACE "CC_DEVELOPMENT" ;
CREATE INDEX "WRKCRD"."CC_WRKCRD_APPL_PIDM_IDX" ON "WRKCRD"."CC_WRKCRD_APPL"
  (
    "TERM",
    "PIDM",
    "ADMIT_CODE",
    "COMMON_APP_ID",
    "ID"
  )
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS STORAGE
  (
    INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645 PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT
  )
  TABLESPACE "CC_DEVELOPMENT" ;
CREATE UNIQUE INDEX "WRKCRD"."CC_WRKCRD_APPL_PK" ON "WRKCRD"."CC_WRKCRD_APPL"
  (
    "ID"
  )
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS STORAGE
  (
    INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645 PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT
  )
  TABLESPACE "CC_DEVELOPMENT" ;
CREATE OR REPLACE TRIGGER "WRKCRD"."CC_WRKCRD_APPL_ID_TRIGGER" BEFORE
  INSERT ON WRKCRD.CC_WRKCRD_APPL REFERENCING NEW AS NEW FOR EACH ROW BEGIN
  SELECT CC_WRKCRD_APPL_SEQUENCE.nextval INTO :NEW.ID FROM dual;
END;
/
ALTER TRIGGER "WRKCRD"."CC_WRKCRD_APPL_ID_TRIGGER" ENABLE;
/