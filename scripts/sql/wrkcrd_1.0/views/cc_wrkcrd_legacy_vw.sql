CREATE OR REPLACE FORCE VIEW "WRKCRD"."CC_WRKCRD_LEGACY_VW" ("SARADAP_PIDM", "SORFOLK_RELT_CODE", "SPBPERS_LGCY_CODE", "SORFOLK_PARENT_NAME_SUFFIX", "SORFOLK_PARENT_LAST", "SORFOLK_PARENT_NAME_PREFIX", "SORFOLK_PARENT_FIRST", "SORFOLK_PARENT_MI", "SORFOLK_PARENT_DEGREE", "SORFOLK_ACTIVITY_DATE")
AS
  SELECT saradap_pidm ,
    sorfolk_relt_code ,
    spbpers_lgcy_code ,
    sorfolk_parent_name_suffix ,
    sorfolk_parent_last ,
    sorfolk_parent_name_prefix ,
    sorfolk_parent_first ,
    sorfolk_parent_mi ,
    sorfolk_parent_degree,
    sorfolk_activity_date
  FROM wrkcrd.cc_wrkcrd_application_vw ,
    saturn.sorfolk ,
    saturn.spbpers
  WHERE sorfolk_pidm         = saradap_pidm
  AND spbpers_pidm           = sorfolk_pidm
  AND spbpers_lgcy_code     IS NOT NULL
  AND sorfolk_parent_degree IS NOT NULL;
  
/