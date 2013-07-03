CREATE OR REPLACE FORCE VIEW "WRKCRD"."CC_WRKCRD_CHKL_VW" ("ID", "SARCHKL_ADMR_CODE", "STVADMR_DESC", "SARCHKL_MANDATORY_IND", "SARCHKL_RECEIVE_DATE", "SARCHKL_COMMENT")
AS
  SELECT id ,
    sarchkl_admr_code ,
    stvadmr_desc ,
    CASE
      WHEN sarchkl_mandatory_ind IS NULL
      THEN 'N'
      ELSE sarchkl_mandatory_ind
    END sarchkl_mandatory_ind,
    sarchkl_receive_date ,
    sarchkl_comment
  FROM saturn.sarchkl ,
    wrkcrd.cc_wrkcrd_appl ,
    saturn.stvadmr
  WHERE sarchkl_admr_code     = stvadmr_code
  AND sarchkl_pidm            = pidm
  AND sarchkl_term_code_entry = term
  AND sarchkl_appl_no         = appl_no;
  
/