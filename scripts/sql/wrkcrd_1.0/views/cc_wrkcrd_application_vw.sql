CREATE OR REPLACE FORCE VIEW "WRKCRD"."CC_WRKCRD_APPLICATION_VW" ("ID", "SARADAP_PIDM", "SARADAP_TERM_CODE_ENTRY", "SARADAP_ADMT_CODE", "SARADAP_APPL_NO", "SARADAP_APPL_DATE", "STAGE", "READS_COMPLETED", "VW_COUNSELOR", "NEXT_READER", "VW_NATION", "VW_RACE_DESC", "COMMON_APP_ID", "SORHSCH_SBGI_CODE", "STVSBGI_DESC", "VW_HS_CITY", "VW_HS_STATE", "VW_HS_NATION", "VW_HS_NATION_DESC", "VW_HS_REGION", "SORBCHR_BCHR_CODE", "STVBCHR_DESC", "VW_EPSCODE", "SARRSRC_SBGI_CODE", "CBO_DESC", "SARADAP_WRSN_CODE", "SARADAP_SBGI_CODE", "VW_WHERE_ATTENDING", "SORPCOL_SBGI_CODE", "VW_COLL_DESC", "VW_COLL_CITY", "VW_COLL_STATE", "VW_COLL_NATION", "VW_COLL_NATION_DESC", "VW_SHOW_SATR", "VW_SHOW_SAT2", "VW_SHOW_ACT", "VW_SHOW_NONE", "CAREER", "SORHSCH_GRADUATION_DATE", "RANK_WEIGHTED", "SORHSCH_CLASS_RANK", "RANK", "RANK_TYPE", "CLASS_SIZE", "SORHSCH_CLASS_SIZE", "TRUE_SIZE", "GPA_SCALE", "GPA_HIGHEST", "GPA_WEIGHTED", "SORHSCH_GPA", "PERCENT_COLL_BOUND", "SORHSCH_PERCENTILE", "YCC_CODE", "YCC_DESC",
  "FIRST_WORDS")
AS
  SELECT id ,
    a.saradap_pidm ,
    a.saradap_term_code_entry ,
    a.saradap_admt_code ,
    a.saradap_appl_no ,
    a.saradap_appl_date ,
    stage ,
    reads_completed ,
    (SELECT gobtpac_pidm
    FROM general.gobtpac ,
      saturn.sorainf sor
    WHERE sor.sorainf_pidm    = a.saradap_pidm
    AND sor.sorainf_term_code = a.saradap_term_code_entry
    AND sor.sorainf_seqno     =
      (SELECT MAX(sorainf_seqno)
      FROM saturn.sorainf
      WHERE sorainf_pidm    = sor.sorainf_pidm
      AND sorainf_term_code = sor.sorainf_term_code
      )
    AND sor.sorainf_module = 'A'
    AND gobtpac_pidm       = sor.sorainf_arol_pidm
    ) vw_counselor,
    CASE
      WHEN next_reader IS NULL
      THEN ' '
      ELSE next_reader
    END next_reader ,
    CASE
      WHEN n.stvnatn_nation IS NULL
      THEN 'United States'
      ELSE n.stvnatn_nation
    END vw_nation ,
    '' vw_race_desc , --legacy remove before prod
    CASE
      WHEN common_app_id IS NULL
      THEN ' '
      ELSE common_app_id
    END common_app_id,
    hs.sorhsch_sbgi_code ,
    hs.stvsbgi_desc ,
    hs.sobsbgi_city vw_hs_city,
    hs.sobsbgi_stat_code vw_hs_state,
    hs.sobsbgi_natn_code vw_hs_nation,
    hs.stvnatn_nation vw_hs_nation_desc ,
    CASE
      WHEN hs.sobsbgi_natn_code IS NOT NULL
      THEN
        (SELECT gorsgeo_geod_code
        FROM general.gorsgeo
        WHERE gorsgeo_geor_code LIKE 'ADM%'
        AND gorsgeo_sbgi_code = hs.sorhsch_sbgi_code
        )
      ELSE ''
    END vw_hs_region ,
    hs.sorbchr_bchr_code ,
    hs.stvbchr_desc ,
    hs.vw_epscode ,
    cbo.sarrsrc_sbgi_code ,
    cbo.stvsbgi_desc cbo_desc ,
    a.saradap_wrsn_code ,
    a.saradap_sbgi_code ,
    (SELECT stvsbgi_desc FROM stvsbgi WHERE stvsbgi_code = a.saradap_sbgi_code
    ) vw_where_attending ,
    col.sorpcol_sbgi_code ,
    col.stvsbgi_desc vw_coll_desc,
    col.sobsbgi_city vw_coll_city,
    col.sobsbgi_stat_code vw_coll_state,
    col.sobsbgi_natn_code vw_coll_nation,
    col.stvnatn_nation vw_coll_nation_desc ,
    CASE
      WHEN sabsupl_flag1 = 'Y'
      THEN 1
      ELSE 0
    END vw_show_satr,
    CASE
      WHEN sabsupl_flag2 = 'Y'
      THEN 1
      ELSE 0
    END vw_show_sat2,
    CASE
      WHEN sabsupl_flag3 = 'Y'
      THEN 1
      ELSE 0
    END vw_show_act,
    CASE
      WHEN sabsupl_flag4 = 'Y'
      OR (sabsupl_flag1 != 'Y'
      AND sabsupl_flag2 != 'Y'
      AND sabsupl_flag3 != 'Y')
      THEN 1
      ELSE 0
    END vw_show_none,
    CASE
      WHEN career IS NULL
      THEN ' '
      ELSE career
    END career ,
    hs.sorhsch_graduation_date ,
    CASE
      WHEN rank_weighted IS NULL
      THEN 1
      ELSE rank_weighted
    END rank_weighted ,
    CASE
      WHEN hs.sorhsch_class_rank IS NULL
      THEN 0
      ELSE hs.sorhsch_class_rank
    END sorhsch_class_rank ,
    CASE
      WHEN rank IS NULL
      THEN 0
      ELSE rank
    END rank ,
    rank_type ,
    CASE
      WHEN class_size IS NULL
      THEN 0
      ELSE class_size
    END class_size ,
    CASE
      WHEN hs.sorhsch_class_size IS NULL
      THEN 0
      ELSE hs.sorhsch_class_size
    END sorhsch_class_size ,
    CASE
      WHEN true_size IS NULL
      THEN 0
      ELSE true_size
    END true_size ,
    CASE
      WHEN gpa_scale IS NULL
      THEN 0
      ELSE gpa_scale
    END gpa_scale ,
    CASE
      WHEN gpa_highest IS NULL
      THEN 0
      ELSE gpa_highest
    END gpa_highest ,
    CASE
      WHEN gpa_weighted IS NULL
      THEN 1
      ELSE gpa_weighted
    END gpa_weighted ,
    CASE
      WHEN hs.sorhsch_gpa IS NULL
      THEN ''
      ELSE hs.sorhsch_gpa
    END sorhsch_gpa ,
    CASE
      WHEN percent_coll_bound IS NULL
      THEN 0
      ELSE percent_coll_bound
    END percent_coll_bound ,
    CASE
      WHEN hs.sorhsch_percentile IS NULL
      THEN 0
      ELSE hs.sorhsch_percentile
    END sorhsch_percentile ,
    ycc.sarrsrc_sbgi_code ycc_code,
    ycc.stvsbgi_desc ycc_desc,
    first_words
  FROM saturn.saradap a ,
    cc_wrkcrd_appl ,
    cc_wrkcrd_hs_vw hs ,
    cc_wrkcrd_coll_vw col ,
    cc_wrkcrd_cbo_vw cbo ,
    wrkcrd.cc_wrkcrd_ycc_vw ycc ,
    saturn.sabsupl ,
    saturn.stvnatn n
  WHERE pidm                         = a.saradap_pidm
  AND term                           = a.saradap_term_code_entry
  AND admit_code                     = a.saradap_admt_code
  AND appl_no                        = a.saradap_appl_no
  AND hs.sorhsch_pidm(+)             = a.saradap_pidm
  AND col.sorpcol_pidm(+)            = a.saradap_pidm
  AND ycc.appl_id(+)                 = id
  AND cbo.sarrsrc_pidm(+)            = a.saradap_pidm
  AND cbo.sarrsrc_term_code_entry(+) = a.saradap_term_code_entry
  AND cbo.sarrsrc_appl_no(+)         = a.saradap_appl_no
  AND sabsupl_pidm(+)                = a.saradap_pidm
  AND sabsupl_term_code_entry(+)     = a.saradap_term_code_entry
  AND sabsupl_appl_no(+)             = a.saradap_appl_no
  AND n.stvnatn_code(+)              = sabsupl_natn_code_birth;
  
/