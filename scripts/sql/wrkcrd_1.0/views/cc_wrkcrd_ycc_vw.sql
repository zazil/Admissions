CREATE OR REPLACE FORCE VIEW "WRKCRD"."CC_WRKCRD_YCC_VW" ("APPL_ID", "SARRSRC_SBGI_CODE", "STVSBGI_DESC")
AS
  SELECT id appl_id,
    sarrsrc_sbgi_code,
    stvsbgi_desc
  FROM wrkcrd.cc_wrkcrd_appl ,
    saturn.sarrsrc ,
    saturn.stvsbgi
  WHERE sarrsrc_pidm          = pidm
  AND sarrsrc_term_code_entry = term
  AND sarrsrc_appl_no         = appl_no
  AND stvsbgi_code            = sarrsrc_sbgi_code
  AND sarrsrc_activity_date   =
    (SELECT MAX(sarrsrc_activity_date)
    FROM saturn.sarrsrc
    WHERE sarrsrc_pidm          = pidm
    AND sarrsrc_term_code_entry = term
    AND sarrsrc_appl_no         = appl_no
    )
  AND sarrsrc_sbgi_code IN
    (SELECT code FROM cc_wrkcrd_ycc
    );
    
/