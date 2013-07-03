CREATE OR REPLACE FORCE VIEW "WRKCRD"."CC_WRKCRD_TERM_TYPE_VW" ("SARADAP_TERM_CODE_ENTRY", "STVTERM_DESC")
AS
  SELECT DISTINCT saradap_term_code_entry,
    stvterm_desc
  FROM saturn.saradap,
    saturn.stvterm,
    wrkcrd.cc_wrkcrd_appl
  WHERE stvterm_code = saradap_term_code_entry
  AND term           = saradap_term_code_entry;
  
/