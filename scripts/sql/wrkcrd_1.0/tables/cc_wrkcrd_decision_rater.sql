CREATE TABLE "WRKCRD"."CC_WRKCRD_DECISION_RATER"
  (
    "APDC_CODE"  VARCHAR2(2 BYTE) NOT NULL ENABLE,
    "START_TERM" VARCHAR2(10 BYTE) NOT NULL ENABLE,
    "END_TERM"   VARCHAR2(10 BYTE),
    CONSTRAINT "CC_WRKCRD_DECISION_RATER_PK" PRIMARY KEY ("APDC_CODE") USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645 PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT) TABLESPACE "CC_DEVELOPMENT" ENABLE
  )
  SEGMENT CREATION IMMEDIATE PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING STORAGE
  (
    INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645 PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT
  )
  TABLESPACE "CC_DEVELOPMENT" ;
  
INSERT INTO "WRKCRD"."CC_WRKCRD_DECISION_RATER" (APDC_CODE, START_TERM) VALUES ('R+', '201190');	
INSERT INTO "WRKCRD"."CC_WRKCRD_DECISION_RATER" (APDC_CODE, START_TERM) VALUES ('A-', '201190');
INSERT INTO "WRKCRD"."CC_WRKCRD_DECISION_RATER" (APDC_CODE, START_TERM) VALUES ('A+', '201190');
INSERT INTO "WRKCRD"."CC_WRKCRD_DECISION_RATER" (APDC_CODE, START_TERM) VALUES ('AA', '201190');
INSERT INTO "WRKCRD"."CC_WRKCRD_DECISION_RATER" (APDC_CODE, START_TERM) VALUES ('AI', '201190');
INSERT INTO "WRKCRD"."CC_WRKCRD_DECISION_RATER" (APDC_CODE, START_TERM) VALUES ('AP', '201190');
INSERT INTO "WRKCRD"."CC_WRKCRD_DECISION_RATER" (APDC_CODE, START_TERM) VALUES ('DF', '201190');
INSERT INTO "WRKCRD"."CC_WRKCRD_DECISION_RATER" (APDC_CODE, START_TERM) VALUES ('DP', '201190');
INSERT INTO "WRKCRD"."CC_WRKCRD_DECISION_RATER" (APDC_CODE, START_TERM) VALUES ('RJ', '201190');
INSERT INTO "WRKCRD"."CC_WRKCRD_DECISION_RATER" (APDC_CODE, START_TERM) VALUES ('RL', '201190');
INSERT INTO "WRKCRD"."CC_WRKCRD_DECISION_RATER" (APDC_CODE, START_TERM) VALUES ('RP', '201190');
INSERT INTO "WRKCRD"."CC_WRKCRD_DECISION_RATER" (APDC_CODE, START_TERM) VALUES ('RS', '201190');
INSERT INTO "WRKCRD"."CC_WRKCRD_DECISION_RATER" (APDC_CODE, START_TERM) VALUES ('W+', '201190');
INSERT INTO "WRKCRD"."CC_WRKCRD_DECISION_RATER" (APDC_CODE, START_TERM) VALUES ('WF', '201190');
INSERT INTO "WRKCRD"."CC_WRKCRD_DECISION_RATER" (APDC_CODE, START_TERM) VALUES ('WL', '201190');
INSERT INTO "WRKCRD"."CC_WRKCRD_DECISION_RATER" (APDC_CODE, START_TERM) VALUES ('CM', '201190');
INSERT INTO "WRKCRD"."CC_WRKCRD_DECISION_RATER" (APDC_CODE, START_TERM) VALUES ('DI', '201190');
INSERT INTO "WRKCRD"."CC_WRKCRD_DECISION_RATER" (APDC_CODE, START_TERM) VALUES ('WI', '201190');
INSERT INTO "WRKCRD"."CC_WRKCRD_DECISION_RATER" (APDC_CODE, START_TERM) VALUES ('WB', '201190');
INSERT INTO "WRKCRD"."CC_WRKCRD_DECISION_RATER" (APDC_CODE, START_TERM) VALUES ('WM', '201190');
INSERT INTO "WRKCRD"."CC_WRKCRD_DECISION_RATER" (APDC_CODE, START_TERM) VALUES ('CA', '201190');
INSERT INTO "WRKCRD"."CC_WRKCRD_DECISION_RATER" (APDC_CODE, START_TERM) VALUES ('W-', '201190');
COMMIT;
/