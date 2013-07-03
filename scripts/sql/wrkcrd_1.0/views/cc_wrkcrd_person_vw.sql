CREATE OR REPLACE FORCE VIEW "WRKCRD"."CC_WRKCRD_PERSON_VW" ("SPRIDEN_PIDM", "SPRIDEN_ID", "GOBTPAC_EXTERNAL_USER", "SPBPERS_NAME_PREFIX", "SPRIDEN_FIRST_NAME", "SPRIDEN_MI", "SPRIDEN_LAST_NAME", "SPBPERS_NAME_SUFFIX", "VW_PREF_FIRST_NAME", "GOREMAL_EMAIL_ADDRESS")
AS
  SELECT spriden_pidm ,
    spriden_id ,
    gobtpac_external_user ,
    spbpers_name_prefix ,
    spriden_first_name ,
    spriden_mi ,
    spriden_last_name ,
    spbpers_name_suffix ,
    CASE
      WHEN spbpers_pref_first_name IS NULL
      THEN spriden_first_name
      ELSE spbpers_pref_first_name
    END vw_pref_first_name ,
    (SELECT MAX(g.goremal_email_address) --protect against pulling both EH and CP with same timestamp!
    FROM general.goremal g
    WHERE g.goremal_pidm        = spriden_pidm
    AND g.goremal_status_ind    = 'A'
    AND g.goremal_emal_code    IN ('EH', 'CP')
    AND g.goremal_activity_date =
      (SELECT MAX(gm.goremal_activity_date)
      FROM general.goremal gm
      WHERE gm.goremal_pidm     = g.goremal_pidm
      AND gm.goremal_status_ind = 'A'
      AND gm.goremal_emal_code IN ('EH', 'CP')
      )
    AND ROWNUM = 1
    ) goremal_email_address
  FROM saturn.spriden ,
    general.gobtpac ,
    saturn.spbpers
  WHERE gobtpac_pidm      = spriden_pidm
  AND spbpers_pidm(+)     = spriden_pidm
  AND spriden_change_ind IS NULL;
  
/