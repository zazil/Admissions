CREATE OR REPLACE FORCE VIEW "WRKCRD"."CC_WRKCRD_INTERVIEW_VW" ("SORAPPT_PIDM", "SORAPPT_CTYP_CODE", "STVCTYP_DESC", "SORAPPT_CONTACT_DATE", "SORAPPT_CONTACT_FROM_TIME", "SORAPPT_RSLT_CODE", "STVRSLT_DESC", "SORAPPT_RECR_CODE", "STVRECR_DESC")
AS
  SELECT sorappt_pidm ,
    sorappt_ctyp_code ,
    stvctyp_desc ,
    TO_CHAR(sorappt_contact_date, 'yyyy-mm-dd hh24:mi:ss') sorappt_contact_date ,
    sorappt_contact_from_time ,
    sorappt_rslt_code ,
    (SELECT stvrslt_desc
    FROM saturn.stvrslt
    WHERE stvrslt_code = a.sorappt_rslt_code
    ) stvrslt_desc ,
    sorappt_recr_code ,
    stvrecr_desc
  FROM saturn.stvrecr ,
    saturn.spriden ,
    saturn.sorappt a ,
    saturn.stvctyp
  WHERE stvrecr_code(+)   = a.sorappt_recr_code
  AND spriden_pidm(+)     = a.sorappt_intv_pidm
  AND stvctyp_code        = a.sorappt_ctyp_code
  AND spriden_change_ind IS NULL;
  
/