CREATE OR REPLACE FORCE VIEW "WRKCRD"."CC_WRKCRD_DECISION_RATER_VW" ("STVAPDC_CODE", "STVAPDC_DESC", "START_TERM", "END_TERM")
AS
  SELECT stvapdc_code ,
    stvapdc_desc ,
    start_term ,
    end_term
  FROM saturn.stvapdc ,
    wrkcrd.cc_wrkcrd_decision_rater
  WHERE stvapdc_code = apdc_code;
  
/