CREATE OR REPLACE FORCE VIEW "WRKCRD"."CC_WRKCRD_CBO_VW" ("SARRSRC_PIDM", "SARRSRC_TERM_CODE_ENTRY", "SARRSRC_APPL_NO", "SARRSRC_SBGI_CODE", "STVSBGI_DESC")
AS
  SELECT a.sarrsrc_pidm ,
    a.sarrsrc_term_code_entry ,
    a.sarrsrc_appl_no ,
    a.sarrsrc_sbgi_code ,
    stvsbgi_desc
  FROM saturn.sarrsrc a ,
    saturn.stvsbgi
  WHERE stvsbgi_code = a.sarrsrc_sbgi_code
  AND a.sarrsrc_sbgi_code LIKE 'C%'
  AND a.sarrsrc_sbgi_code =
    (SELECT MIN(b.sarrsrc_sbgi_code)
    FROM sarrsrc b
    WHERE b.sarrsrc_pidm          = a.sarrsrc_pidm
    AND b.sarrsrc_term_code_entry = a.sarrsrc_term_code_entry
    AND b.sarrsrc_appl_no         = a.sarrsrc_appl_no
    AND b.sarrsrc_sbgi_code LIKE 'C%'
    AND b.sarrsrc_activity_date =
      (SELECT MAX(sarrsrc_activity_date)
      FROM sarrsrc
      WHERE sarrsrc_pidm          = b.sarrsrc_pidm
      AND sarrsrc_term_code_entry = b.sarrsrc_term_code_entry
      AND sarrsrc_appl_no         = b.sarrsrc_appl_no
      AND sarrsrc_sbgi_code LIKE 'C%'
      )
    );
    
/