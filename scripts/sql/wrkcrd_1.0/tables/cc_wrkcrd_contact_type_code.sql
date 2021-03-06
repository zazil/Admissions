CREATE TABLE "WRKCRD"."CC_WRKCRD_CONTACT_TYPE_CODE"
  (
    "CODE" VARCHAR2(20 BYTE) NOT NULL ENABLE,
    "TYPE" VARCHAR2(20 BYTE) NOT NULL ENABLE,
    CONSTRAINT "CC_WRKCRD_CONTACT_TYPE_CO_PK" PRIMARY KEY ("CODE") USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645 PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT) TABLESPACE "CC_DEVELOPMENT" ENABLE
  )
  SEGMENT CREATION IMMEDIATE PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING STORAGE
  (
    INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645 PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT
  )
  TABLESPACE "CC_DEVELOPMENT" ;
  
INSERT INTO "WRKCRD"."CC_WRKCRD_CONTACT_TYPE_CODE" (CODE, TYPE) VALUES ('AAR', 'REFERAL');
INSERT INTO "WRKCRD"."CC_WRKCRD_CONTACT_TYPE_CODE" (CODE, TYPE) VALUES ('ABC', 'SEARCH');
INSERT INTO "WRKCRD"."CC_WRKCRD_CONTACT_TYPE_CODE" (CODE, TYPE) VALUES ('ABK', 'OFFICE');
INSERT INTO "WRKCRD"."CC_WRKCRD_CONTACT_TYPE_CODE" (CODE, TYPE) VALUES ('ACH', 'REFERAL');
INSERT INTO "WRKCRD"."CC_WRKCRD_CONTACT_TYPE_CODE" (CODE, TYPE) VALUES ('ACI', 'PERSONAL');
INSERT INTO "WRKCRD"."CC_WRKCRD_CONTACT_TYPE_CODE" (CODE, TYPE) VALUES ('ACL', 'PERSONAL');
INSERT INTO "WRKCRD"."CC_WRKCRD_CONTACT_TYPE_CODE" (CODE, TYPE) VALUES ('ACS', 'PERSONAL');
INSERT INTO "WRKCRD"."CC_WRKCRD_CONTACT_TYPE_CODE" (CODE, TYPE) VALUES ('ACT', 'OFFICE');
INSERT INTO "WRKCRD"."CC_WRKCRD_CONTACT_TYPE_CODE" (CODE, TYPE) VALUES ('ACV', 'PERSONAL');
INSERT INTO "WRKCRD"."CC_WRKCRD_CONTACT_TYPE_CODE" (CODE, TYPE) VALUES ('ACY', 'OFFICE');
INSERT INTO "WRKCRD"."CC_WRKCRD_CONTACT_TYPE_CODE" (CODE, TYPE) VALUES ('ADV', 'PERSONAL');
INSERT INTO "WRKCRD"."CC_WRKCRD_CONTACT_TYPE_CODE" (CODE, TYPE) VALUES ('AEF', 'SEARCH');
INSERT INTO "WRKCRD"."CC_WRKCRD_CONTACT_TYPE_CODE" (CODE, TYPE) VALUES ('AEM', 'INCOMING');
INSERT INTO "WRKCRD"."CC_WRKCRD_CONTACT_TYPE_CODE" (CODE, TYPE) VALUES ('AER', 'REFERAL');
INSERT INTO "WRKCRD"."CC_WRKCRD_CONTACT_TYPE_CODE" (CODE, TYPE) VALUES ('AEU', 'SEARCH');
INSERT INTO "WRKCRD"."CC_WRKCRD_CONTACT_TYPE_CODE" (CODE, TYPE) VALUES ('AEX', 'PERSONAL');
INSERT INTO "WRKCRD"."CC_WRKCRD_CONTACT_TYPE_CODE" (CODE, TYPE) VALUES ('AFC', 'REFERAL');
INSERT INTO "WRKCRD"."CC_WRKCRD_CONTACT_TYPE_CODE" (CODE, TYPE) VALUES ('AFN', 'OFFICE');
INSERT INTO "WRKCRD"."CC_WRKCRD_CONTACT_TYPE_CODE" (CODE, TYPE) VALUES ('AFR', 'PERSONAL');
INSERT INTO "WRKCRD"."CC_WRKCRD_CONTACT_TYPE_CODE" (CODE, TYPE) VALUES ('AFY', 'OFFICE');
INSERT INTO "WRKCRD"."CC_WRKCRD_CONTACT_TYPE_CODE" (CODE, TYPE) VALUES ('AGD', 'INCOMING');
INSERT INTO "WRKCRD"."CC_WRKCRD_CONTACT_TYPE_CODE" (CODE, TYPE) VALUES ('AGE', 'PERSONAL');
INSERT INTO "WRKCRD"."CC_WRKCRD_CONTACT_TYPE_CODE" (CODE, TYPE) VALUES ('AGT', 'PERSONAL');
INSERT INTO "WRKCRD"."CC_WRKCRD_CONTACT_TYPE_CODE" (CODE, TYPE) VALUES ('AHV', 'PERSONAL');
INSERT INTO "WRKCRD"."CC_WRKCRD_CONTACT_TYPE_CODE" (CODE, TYPE) VALUES ('AIE', 'SEARCH');
INSERT INTO "WRKCRD"."CC_WRKCRD_CONTACT_TYPE_CODE" (CODE, TYPE) VALUES ('AJO', 'PERSONAL');
INSERT INTO "WRKCRD"."CC_WRKCRD_CONTACT_TYPE_CODE" (CODE, TYPE) VALUES ('ALV', 'PERSONAL');
INSERT INTO "WRKCRD"."CC_WRKCRD_CONTACT_TYPE_CODE" (CODE, TYPE) VALUES ('AMF', 'PERSONAL');
INSERT INTO "WRKCRD"."CC_WRKCRD_CONTACT_TYPE_CODE" (CODE, TYPE) VALUES ('AML', 'INCOMING');
INSERT INTO "WRKCRD"."CC_WRKCRD_CONTACT_TYPE_CODE" (CODE, TYPE) VALUES ('AMN', 'SEARCH');
INSERT INTO "WRKCRD"."CC_WRKCRD_CONTACT_TYPE_CODE" (CODE, TYPE) VALUES ('AMS', 'PERSONAL');
INSERT INTO "WRKCRD"."CC_WRKCRD_CONTACT_TYPE_CODE" (CODE, TYPE) VALUES ('ANA', 'OFFICE');
INSERT INTO "WRKCRD"."CC_WRKCRD_CONTACT_TYPE_CODE" (CODE, TYPE) VALUES ('ANN', 'OFFICE');
INSERT INTO "WRKCRD"."CC_WRKCRD_CONTACT_TYPE_CODE" (CODE, TYPE) VALUES ('ANR', 'OFFICE');
INSERT INTO "WRKCRD"."CC_WRKCRD_CONTACT_TYPE_CODE" (CODE, TYPE) VALUES ('ANS', 'OFFICE');
INSERT INTO "WRKCRD"."CC_WRKCRD_CONTACT_TYPE_CODE" (CODE, TYPE) VALUES ('ANY', 'OFFICE');
INSERT INTO "WRKCRD"."CC_WRKCRD_CONTACT_TYPE_CODE" (CODE, TYPE) VALUES ('AOH', 'PERSONAL');
INSERT INTO "WRKCRD"."CC_WRKCRD_CONTACT_TYPE_CODE" (CODE, TYPE) VALUES ('AOL', 'INCOMING');
INSERT INTO "WRKCRD"."CC_WRKCRD_CONTACT_TYPE_CODE" (CODE, TYPE) VALUES ('AOS', 'PERSONAL');
INSERT INTO "WRKCRD"."CC_WRKCRD_CONTACT_TYPE_CODE" (CODE, TYPE) VALUES ('AOV', 'PERSONAL');
INSERT INTO "WRKCRD"."CC_WRKCRD_CONTACT_TYPE_CODE" (CODE, TYPE) VALUES ('AOY', 'PERSONAL');
INSERT INTO "WRKCRD"."CC_WRKCRD_CONTACT_TYPE_CODE" (CODE, TYPE) VALUES ('APH', 'INCOMING');
INSERT INTO "WRKCRD"."CC_WRKCRD_CONTACT_TYPE_CODE" (CODE, TYPE) VALUES ('APP', 'INCOMING');
INSERT INTO "WRKCRD"."CC_WRKCRD_CONTACT_TYPE_CODE" (CODE, TYPE) VALUES ('APZ', 'REFERAL');
INSERT INTO "WRKCRD"."CC_WRKCRD_CONTACT_TYPE_CODE" (CODE, TYPE) VALUES ('ARF', 'REFERAL');
INSERT INTO "WRKCRD"."CC_WRKCRD_CONTACT_TYPE_CODE" (CODE, TYPE) VALUES ('ARP', 'OFFICE');
INSERT INTO "WRKCRD"."CC_WRKCRD_CONTACT_TYPE_CODE" (CODE, TYPE) VALUES ('ASC', 'INCOMING');
INSERT INTO "WRKCRD"."CC_WRKCRD_CONTACT_TYPE_CODE" (CODE, TYPE) VALUES ('ASD', 'PERSONAL');
INSERT INTO "WRKCRD"."CC_WRKCRD_CONTACT_TYPE_CODE" (CODE, TYPE) VALUES ('ASR', 'SEARCH');
INSERT INTO "WRKCRD"."CC_WRKCRD_CONTACT_TYPE_CODE" (CODE, TYPE) VALUES ('AST', 'REFERAL');
INSERT INTO "WRKCRD"."CC_WRKCRD_CONTACT_TYPE_CODE" (CODE, TYPE) VALUES ('AUP', 'INCOMING');
INSERT INTO "WRKCRD"."CC_WRKCRD_CONTACT_TYPE_CODE" (CODE, TYPE) VALUES ('AWW', 'INCOMING');
INSERT INTO "WRKCRD"."CC_WRKCRD_CONTACT_TYPE_CODE" (CODE, TYPE) VALUES ('AX1', 'PERSONAL');
INSERT INTO "WRKCRD"."CC_WRKCRD_CONTACT_TYPE_CODE" (CODE, TYPE) VALUES ('AX2', 'PERSONAL');
INSERT INTO "WRKCRD"."CC_WRKCRD_CONTACT_TYPE_CODE" (CODE, TYPE) VALUES ('AXA', 'INCOMING');
INSERT INTO "WRKCRD"."CC_WRKCRD_CONTACT_TYPE_CODE" (CODE, TYPE) VALUES ('AXN', 'OFFICE');
INSERT INTO "WRKCRD"."CC_WRKCRD_CONTACT_TYPE_CODE" (CODE, TYPE) VALUES ('AXY', 'OFFICE');
INSERT INTO "WRKCRD"."CC_WRKCRD_CONTACT_TYPE_CODE" (CODE, TYPE) VALUES ('AYR', 'PERSONAL');
COMMIT;
/