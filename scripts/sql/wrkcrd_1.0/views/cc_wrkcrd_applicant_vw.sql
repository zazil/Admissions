CREATE OR REPLACE FORCE VIEW "WRKCRD"."CC_WRKCRD_APPLICANT_VW" ("SPRIDEN_PIDM", "SPBPERS_SEX", "SPBPERS_CITZ_CODE")
AS
  SELECT DISTINCT spriden_pidm ,
    spbpers_sex ,
    spbpers_citz_code
  FROM saturn.spriden ,
    saturn.spbpers
  WHERE spriden_pidm      = spbpers_pidm(+)
  AND spriden_change_ind IS NULL;
  
/