CREATE OR REPLACE FORCE VIEW "WRKCRD"."CC_WRKCRD_DECISION_ALL_VW" ("STVAPDC_CODE", "STVAPDC_DESC")
AS
  SELECT DISTINCT stvapdc_code , stvapdc_desc FROM saturn.stvapdc;
  
/