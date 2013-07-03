CREATE OR REPLACE FORCE VIEW "WRKCRD"."CC_WRKCRD_DECISION_VW" ("APPL_ID", "SARAPPD_SEQ_NO", "SARAPPD_APDC_DATE", "SARAPPD_APDC_CODE", "STVAPDC_DESC", "STVAPDC_APPL_INACT", "LATEST")
AS
  SELECT id appl_id ,
    sarappd_seq_no ,
    sarappd_apdc_date ,
    sarappd_apdc_code ,
    stvapdc_desc ,
    CASE
      WHEN stvapdc_appl_inact IS NULL
      THEN 0
      ELSE 1
    END stvapdc_appl_inact ,
    CASE
      WHEN sarappd_seq_no =
        (SELECT MAX(b.sarappd_seq_no)
        FROM saturn.sarappd b
        WHERE b.sarappd_pidm          = pidm
        AND b.sarappd_term_code_entry = term
        AND b.sarappd_appl_no         = appl_no
        )
      THEN 1
      ELSE 0
    END latest
  FROM wrkcrd.cc_wrkcrd_appl ,
    saturn.sarappd ,
    saturn.stvapdc
  WHERE sarappd_pidm          = pidm
  AND sarappd_term_code_entry = term
  AND sarappd_appl_no         = appl_no
  AND stvapdc_code            = sarappd_apdc_code;
  
/