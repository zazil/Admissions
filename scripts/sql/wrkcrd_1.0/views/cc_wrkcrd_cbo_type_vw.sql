CREATE OR REPLACE FORCE VIEW "WRKCRD"."CC_WRKCRD_CBO_TYPE_VW" ("SARRSRC_SBGI_CODE", "STVSBGI_DESC")
AS
  SELECT DISTINCT sarrsrc_sbgi_code,
    stvsbgi_desc
  FROM saturn.sarrsrc ,
    saturn.stvsbgi
  WHERE stvsbgi_code = sarrsrc_sbgi_code
  AND sarrsrc_sbgi_code LIKE 'C%';
  
/