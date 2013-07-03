CREATE OR REPLACE FORCE VIEW "WRKCRD"."CC_WRKCRD_SEARCH_VW" ("ID", "COMMON_APP_ID", "PIDM", "TERM", "ADMIT_CODE", "APPL_NO", "STAGE", "SPRIDEN_ID", "SPRIDEN_FIRST_NAME", "SPRIDEN_LAST_NAME", "STVSBGI_DESC", "SOBSBGI_NATN_CODE", "STVNATN_NATION", "VW_EPSCODE", "SORHSCH_SBGI_CODE", "VW_DECISION", "VW_COUNSELOR")
AS
  SELECT DISTINCT id ,
    common_app_id ,
    pidm ,
    term ,
    admit_code ,
    appl_no ,
    stage ,
    spriden_id ,
    spriden_first_name ,
    spriden_last_name ,
    hs.stvsbgi_desc ,
    sobsbgi_natn_code ,
    hs.stvnatn_nation ,
    hs.vw_epscode ,
    hs.sorhsch_sbgi_code ,
    (SELECT b.sarappd_apdc_code
    FROM wrkcrd.cc_wrkcrd_decision_vw b
    WHERE b.appl_id    = id
    AND sarappd_seq_no =
      (SELECT MAX(c.sarappd_seq_no)
      FROM wrkcrd.cc_wrkcrd_decision_vw c
      WHERE c.appl_id = b.appl_id
      )
    ) vw_decision ,
    (SELECT gobtpac_external_user
    FROM general.gobtpac ,
      saturn.sorainf d
    WHERE d.sorainf_pidm    = pidm
    AND d.sorainf_term_code = term
    AND d.sorainf_module    = 'A'
    AND d.sorainf_seqno     =
      (SELECT MAX(e.sorainf_seqno)
      FROM saturn.sorainf e
      WHERE e.sorainf_pidm    = d.sorainf_pidm
      AND e.sorainf_term_code = d.sorainf_term_code
      )
    AND gobtpac_pidm = d.sorainf_arol_pidm
    ) vw_counselor
  FROM wrkcrd.cc_wrkcrd_appl ,
    wrkcrd.cc_wrkcrd_hs_vw hs ,
    saturn.spriden
  WHERE hs.sorhsch_pidm   = pidm
  AND spriden_pidm        = pidm
  AND spriden_change_ind IS NULL;
  
/