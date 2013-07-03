CREATE OR REPLACE FORCE VIEW "WRKCRD"."CC_WRKCRD_INT_TYPE_VW" ("STVCTYP_CODE", "STVCTYP_DESC")
AS
  SELECT stvctyp_code,
    stvctyp_desc
  FROM saturn.stvctyp,
    wrkcrd.cc_wrkcrd_interview_type
  WHERE stvctyp_code = code;
  
/