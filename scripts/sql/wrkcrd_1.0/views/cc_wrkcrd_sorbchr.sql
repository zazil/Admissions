CREATE OR REPLACE FORCE VIEW "WRKCRD"."CC_WRKCRD_SORBCHR" ("SORBCHR_SBGI_CODE", "SORBCHR_BCHR_CODE")
AS
  SELECT a.sorbchr_sbgi_code ,
    MAX(a.sorbchr_bchr_code) sorbchr_bchr_code
  FROM saturn.sorbchr a
  WHERE a.sorbchr_activity_date =
    (SELECT MAX(sorbchr_activity_date)
    FROM saturn.sorbchr
    WHERE a.sorbchr_bchr_code = sorbchr_bchr_code
    AND a.sorbchr_sbgi_code   = sorbchr_sbgi_code
    )
  GROUP BY a.sorbchr_sbgi_code;
  
/