CREATE OR REPLACE FORCE VIEW "WRKCRD"."CC_WRKCRD_APPL_ATTRS_VW" ("ID", "STVATTS_CODE")
AS
  SELECT id,
    stvatts_code
  FROM saturn.saraatt ,
    wrkcrd.cc_wrkcrd_appl ,
    saturn.stvatts
  WHERE saraatt_pidm       = pidm
  AND saraatt_term_code    = term
  AND saraatt_appl_no      = appl_no
  AND stvatts.stvatts_code = saraatt_atts_code
  AND saraatt_atts_code LIKE 'A%';
/