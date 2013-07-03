CREATE OR REPLACE FORCE VIEW "WRKCRD"."CC_WRKCRD_FA_VW" ("APPL_ID", "CODE", "DESCR")
AS
  SELECT id appl_id ,
    sorints_ints_code code ,
    stvints_desc descr
  FROM saturn.sorints ,
    wrkcrd.cc_wrkcrd_appl ,
    saturn.stvints
  WHERE sorints_pidm = pidm
  AND stvints_code   = sorints_ints_code;
  
/