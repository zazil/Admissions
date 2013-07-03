CREATE OR REPLACE FORCE VIEW "WRKCRD"."CC_WRKCRD_ATTRIBUTES_VW" ("STVATTS_CODE", "STVATTS_DESC")
AS
  SELECT stvatts_code ,
    stvatts_desc
  FROM saturn.stvatts
  WHERE stvatts_code LIKE 'A%';
  
/