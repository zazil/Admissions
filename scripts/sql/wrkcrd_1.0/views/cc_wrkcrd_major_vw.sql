CREATE OR REPLACE FORCE VIEW "WRKCRD"."CC_WRKCRD_MAJOR_VW" ("APPL_ID", "SORLFOS_MAJR_CODE", "STVMAJR_DESC", "SORLFOS_PRIORITY_NO", "SORLCUR_LMOD_CODE")
AS
  SELECT id appl_id ,
    sorlfos_majr_code ,
    stvmajr_desc ,
    sorlfos_priority_no ,
    sorlcur_lmod_code
  FROM saturn.saradap ,
    wrkcrd.cc_wrkcrd_appl ,
    saturn.sorlcur ,
    saturn.sorlfos ,
    saturn.stvmajr
  WHERE saradap_pidm          = pidm
  AND saradap_term_code_entry = term
  AND saradap_appl_no         = appl_no
  AND sorlcur_pidm            = saradap_pidm
  AND sorlfos_pidm            = sorlcur_pidm
  AND sorlfos_lcur_seqno      = sorlcur_seqno
  AND sorlcur_lmod_code       = 'ADMISSIONS'
  AND stvmajr_code            = sorlfos_majr_code
  AND sorlfos_term_code       = saradap_term_code_entry
  ORDER BY sorlfos_priority_no ,
    sorlfos_majr_code;
    
/