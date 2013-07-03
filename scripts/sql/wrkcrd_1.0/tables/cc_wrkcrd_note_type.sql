CREATE TABLE "WRKCRD"."CC_WRKCRD_NOTE_TYPE"
  (
    "ID"          VARCHAR2(10 BYTE) NOT NULL ENABLE,
    "DESCRIPTION" VARCHAR2(50 BYTE) NOT NULL ENABLE,
    "MAX_ENTRIES" NUMBER DEFAULT 1,
    CONSTRAINT "CC_WRKCRD_NOTE_TYPE_PK" PRIMARY KEY ("ID") USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645 PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT) TABLESPACE "CC_DEVELOPMENT" ENABLE
  )
  SEGMENT CREATION IMMEDIATE PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING STORAGE
  (
    INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645 PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT
  )
  TABLESPACE "CC_DEVELOPMENT" ;
  
INSERT INTO "WRKCRD"."CC_WRKCRD_NOTE_TYPE" (ID, DESCRIPTION, MAX_ENTRIES) VALUES ('LANG', 'Language', 2);
INSERT INTO "WRKCRD"."CC_WRKCRD_NOTE_TYPE" (ID, DESCRIPTION, MAX_ENTRIES) VALUES ('CRSE', 'Senior course grades', 999);
INSERT INTO "WRKCRD"."CC_WRKCRD_NOTE_TYPE" (ID, DESCRIPTION, MAX_ENTRIES) VALUES ('12', 'Senior year grades', 1);
INSERT INTO "WRKCRD"."CC_WRKCRD_NOTE_TYPE" (ID, DESCRIPTION, MAX_ENTRIES) VALUES ('DATERR', 'Data error message to Op Staff', 999);
INSERT INTO "WRKCRD"."CC_WRKCRD_NOTE_TYPE" (ID, DESCRIPTION, MAX_ENTRIES) VALUES ('ES', 'Essay notes', 1);
INSERT INTO "WRKCRD"."CC_WRKCRD_NOTE_TYPE" (ID, DESCRIPTION, MAX_ENTRIES) VALUES ('FAM', 'Family notes', 1);
INSERT INTO "WRKCRD"."CC_WRKCRD_NOTE_TYPE" (ID, DESCRIPTION, MAX_ENTRIES) VALUES ('GC', 'Guidance counselor notes', 1);
INSERT INTO "WRKCRD"."CC_WRKCRD_NOTE_TYPE" (ID, DESCRIPTION, MAX_ENTRIES) VALUES ('INCOM', 'Incomplete message to Op Staff', 999);
INSERT INTO "WRKCRD"."CC_WRKCRD_NOTE_TYPE" (ID, DESCRIPTION, MAX_ENTRIES) VALUES ('INT', 'Interview notes', 1);
INSERT INTO "WRKCRD"."CC_WRKCRD_NOTE_TYPE" (ID, DESCRIPTION, MAX_ENTRIES) VALUES ('NO2', 'Short response', 1);
INSERT INTO "WRKCRD"."CC_WRKCRD_NOTE_TYPE" (ID, DESCRIPTION, MAX_ENTRIES) VALUES ('RSK', 'Risk Advisory', 1);
INSERT INTO "WRKCRD"."CC_WRKCRD_NOTE_TYPE" (ID, DESCRIPTION, MAX_ENTRIES) VALUES ('TR', 'Teacher recommendations', 999);
INSERT INTO "WRKCRD"."CC_WRKCRD_NOTE_TYPE" (ID, DESCRIPTION, MAX_ENTRIES) VALUES ('TSPT', 'Transcript notes', 1);
INSERT INTO "WRKCRD"."CC_WRKCRD_NOTE_TYPE" (ID, DESCRIPTION, MAX_ENTRIES) VALUES ('YCC', 'Why Connecticut College', 1);
INSERT INTO "WRKCRD"."CC_WRKCRD_NOTE_TYPE" (ID, DESCRIPTION, MAX_ENTRIES) VALUES ('ACT', 'Extracurricular activities', 999);
INSERT INTO "WRKCRD"."CC_WRKCRD_NOTE_TYPE" (ID, DESCRIPTION, MAX_ENTRIES) VALUES ('S-INC', 'Incomplete message to Op Staff', 999);
INSERT INTO "WRKCRD"."CC_WRKCRD_NOTE_TYPE" (ID, DESCRIPTION, MAX_ENTRIES) VALUES ('OTH', 'General notes', 999);
COMMIT;
/