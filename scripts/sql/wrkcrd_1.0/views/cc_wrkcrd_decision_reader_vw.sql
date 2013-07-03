CREATE OR REPLACE FORCE VIEW "WRKCRD"."CC_WRKCRD_DECISION_READER_VW" ("APDC_CODE", "STVAPDC_DESC", "START_TERM", "END_TERM")
AS
  SELECT apdc_code ,
    stvapdc_desc ,
    start_term ,
    end_term
  FROM wrkcrd.cc_wrkcrd_decision_rdr ,
    saturn.stvapdc
  WHERE apdc_code = stvapdc_code;
  
/