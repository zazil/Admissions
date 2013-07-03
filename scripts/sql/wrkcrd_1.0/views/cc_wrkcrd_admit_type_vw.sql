CREATE OR REPLACE FORCE VIEW "WRKCRD"."CC_WRKCRD_ADMIT_TYPE_VW" ("SARADAP_ADMT_CODE", "STVADMT_DESC")
AS
  SELECT DISTINCT saradap_admt_code,
    stvadmt_desc
  FROM saturn.saradap,
    saturn.stvadmt
  WHERE stvadmt_code = saradap_admt_code;
/