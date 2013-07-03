CREATE OR REPLACE FORCE VIEW "WRKCRD"."CC_WRKCRD_ETHNICITY_VW" ("APPL_ID", "CODE", "DESCR")
AS
  SELECT id appl_id ,
    spbpers_ethn_code code ,
    stvethn_desc descr
  FROM saturn.spbpers ,
    wrkcrd.cc_wrkcrd_appl ,
    saturn.stvethn
  WHERE spbpers_pidm = pidm
  AND stvethn_code   = spbpers_ethn_code
  UNION ALL
  SELECT id appl_id ,
    gorprac_race_cde code ,
    gorrace_desc descr
  FROM general.gorprac ,
    wrkcrd.cc_wrkcrd_appl ,
    general.gorrace
  WHERE gorprac_pidm   = pidm
  AND gorrace_race_cde = gorprac_race_cde;
  
/