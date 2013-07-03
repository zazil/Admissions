--===============================================================
--===============================================================

-- Remove unnecessary objects

--===============================================================
--===============================================================

DROP TRIGGER WRKCRD.CC_WRKCRD_LOG_ID_TRIGGER;
DROP SEQUENCE WRKCRD.CC_WRKCRD_LOG_SEQUENCE;
DROP PUBLIC SYNONYM CC_WRKCRD_LOG;
DROP TABLE WRKCRD.CC_WRKCRD_LOG;

ALTER TABLE WRKCRD.CC_WRKCRD_SETTINGS
	DROP COLUMN LOGGING_ON;
ALTER TABLE WRKCRD.CC_WRKCRD_SETTINGS
	DROP COLUMN LOGGING_ENTITY;
	
--===============================================================
--===============================================================

-- Column data type switches for compatibility with WebFOCUS

--===============================================================
--===============================================================
	
	
--===============================================================
--===============================================================

-- Updates to existing Views

--===============================================================
--===============================================================

CREATE OR REPLACE VIEW "WRKCRD"."CC_WRKCRD_CONTACT_VW"
AS
  SELECT 'FIRST' vw_type ,
    sorcont_pidm || sorcont_ctyp_code || TO_CHAR(sorcont_contact_date, 'yyyymmdd') contact_id ,
    sorcont_pidm ,
    sorcont_ctyp_code ,
    stvctyp_desc ,
    sorcont_contact_date
  FROM saturn.sorcont a ,
    saturn.stvctyp
  WHERE stvctyp_code         = a.sorcont_ctyp_code
  AND a.sorcont_contact_date =
    (SELECT MIN(b.sorcont_contact_date)
     FROM   sorcont b
     WHERE  a.sorcont_pidm = b.sorcont_pidm)

UNION ALL

  SELECT  t.type vw_type ,
          sorcont_pidm || sorcont_ctyp_code || EXTRACT(YEAR FROM sorcont_contact_date) || EXTRACT(MONTH FROM sorcont_contact_date) || EXTRACT(DAY FROM sorcont_contact_date) || t.type contact_id ,
          sorcont_pidm ,
          sorcont_ctyp_code ,
          stvctyp_desc ,
          sorcont_contact_date
  FROM    saturn.sorcont a ,
          wrkcrd.cc_wrkcrd_contact_type_code t ,
          saturn.stvctyp
  WHERE   sorcont_ctyp_code = t.code
  AND     stvctyp_code      = sorcont_ctyp_code;

-- ***************************************************************


CREATE OR REPLACE VIEW "WRKCRD"."CC_WRKCRD_INTERVIEW_VW"
  AS 
  SELECT sorappt_pidm ,
    sorappt_pidm || sorappt_ctyp_code || TO_CHAR(sorappt_contact_date, 'yyyymmdd') interview_id ,
    sorappt_ctyp_code ,
    stvctyp_desc ,
    TO_CHAR(sorappt_contact_date, 'yyyy-mm-dd hh24:mi:ss') sorappt_contact_date ,
    sorappt_contact_from_time ,
    sorappt_rslt_code ,
    (SELECT stvrslt_desc
     FROM   saturn.stvrslt
     WHERE  stvrslt_code = a.sorappt_rslt_code) stvrslt_desc ,
    sorappt_recr_code ,
    stvrecr_desc
  FROM saturn.stvrecr ,
    saturn.spriden ,
    saturn.sorappt a ,
    saturn.stvctyp
  WHERE stvrecr_code(+)   = a.sorappt_recr_code
  AND spriden_pidm(+)     = a.sorappt_intv_pidm
  AND stvctyp_code        = a.sorappt_ctyp_code
  AND spriden_change_ind IS NULL;

-- ***************************************************************

CREATE OR REPLACE VIEW "WRKCRD"."CC_WRKCRD_LEGACY_VW"
  AS
  SELECT saradap_pidm ,
    saradap_pidm || sorfolk_relt_code || sorfolk_parent_last || sorfolk_parent_first || TO_CHAR(sorfolk_activity_date, 'yyyymmdd') legacy_id ,
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

-- ***************************************************************

CREATE INDEX WRKCRD.CC_WRKCRD_LEGACY_VW_IDX 
ON SATURN.SORFOLK (sorfolk_pidm, sorfolk_relt_code, sorfolk_parent_last, sorfolk_parent_first, sorfolk_activity_date)
COMPUTE STATISTICS;

-- ***************************************************************

CREATE OR REPLACE VIEW "WRKCRD"."CC_WRKCRD_TEST_VW"
  AS
  SELECT DISTINCT id appl_id,
    id || sortest_tesc_code || (SELECT TO_CHAR(MAX(c.sortest_test_date), 'yyyymmdd') 
                                             FROM   saturn.sortest c 
                                             WHERE  c.sortest_pidm = a.sortest_pidm
                                             AND    c.sortest_tesc_code = a.sortest_tesc_code
                                             AND    c.sortest_test_score = a.sortest_test_score
                                    ) test_id ,
    a.sortest_tesc_code ,
    (SELECT MAX(c.sortest_test_date) 
     FROM   saturn.sortest c 
     WHERE  c.sortest_pidm = a.sortest_pidm
     AND    c.sortest_tesc_code = a.sortest_tesc_code
     AND    c.sortest_test_score = a.sortest_test_score
    ) sortest_test_date ,
    stvtesc_desc ,
    a.sortest_test_score ,
    stvtesc_min_value ,
    stvtesc_max_value ,
    CASE 
      WHEN stvtesc_code LIKE 'SAT%' THEN
        'SAT'
      WHEN length( stvtesc_code ) = 2 THEN
        'SUBJ'
      WHEN stvtesc_code = 'ACT' THEN
        'COMP'
      WHEN stvtesc_code LIKE 'ACT%' AND length( stvtesc_code ) > 2 THEN
        'ACT'
      WHEN stvtesc_code LIKE 'TFL%' OR stvtesc_code LIKE 'IE%' THEN
        'TFL'
      ELSE
        'AP'
    END vw_type ,
    stvtesc_data_type
  FROM saturn.sortest a ,
    saturn.stvtesc ,
    wrkcrd.cc_wrkcrd_appl
  WHERE pidm               = sortest_pidm
  AND a.sortest_tesc_code  = stvtesc_code
  AND a.sortest_tesc_code IN (SELECT code FROM wrkcrd.cc_wrkcrd_test_type)
  AND a.sortest_test_score =
    (SELECT MAX(b.sortest_test_score)
    FROM saturn.sortest b
    WHERE a.sortest_tesc_code = b.sortest_tesc_code
    AND a.sortest_pidm        = b.sortest_pidm
    );

-- ***************************************************************

CREATE OR REPLACE VIEW "WRKCRD"."CC_WRKCRD_MAJOR_VW"
  AS
  SELECT id appl_id ,
    id || sorlfos_majr_code major_id ,
    sorlfos_majr_code ,
    stvmajr_desc ,
    sorlfos_priority_no ,
    sorlcur_lmod_code
  FROM saturn.saradap ,
    wrkcrd.cc_wrkcrd_appl ,
    saturn.sorlcur ,
    saturn.sorlfos ,
    saturn.stvmajr
  WHERE saradap_pidm          = pidm
  AND saradap_term_code_entry = term
  AND saradap_appl_no         = appl_no
  AND sorlcur_pidm            = saradap_pidm
  AND sorlfos_pidm            = sorlcur_pidm
  AND sorlfos_lcur_seqno      = sorlcur_seqno
  AND sorlcur_lmod_code       = 'ADMISSIONS'
  AND stvmajr_code            = sorlfos_majr_code
  AND sorlfos_term_code       = saradap_term_code_entry
  ORDER BY sorlfos_priority_no ,
    sorlfos_majr_code;

-- ***************************************************************

CREATE OR REPLACE VIEW "WRKCRD"."CC_WRKCRD_FA_VW"
  AS 
  SELECT id appl_id ,
    id || sorints_ints_code fa_id ,
    sorints_ints_code code ,
    stvints_desc descr
  FROM saturn.sorints ,
    wrkcrd.cc_wrkcrd_appl ,
    saturn.stvints
  WHERE sorints_pidm = pidm
  AND stvints_code = sorints_ints_code;
  
-- ***************************************************************
  
CREATE OR REPLACE VIEW "WRKCRD"."CC_WRKCRD_ETHNICITY_VW" 
  AS 
  SELECT id appl_id ,
    id || spbpers_ethn_code eth_id ,
    spbpers_ethn_code code ,
    stvethn_desc descr
  FROM saturn.spbpers ,
    wrkcrd.cc_wrkcrd_appl ,
    saturn.stvethn
  WHERE spbpers_pidm = pidm
  AND stvethn_code = spbpers_ethn_code
UNION ALL
  SELECT id appl_id ,
    id || gorprac_race_cde eth_id ,
    gorprac_race_cde code ,
    gorrace_desc descr
  FROM general.gorprac ,
    wrkcrd.cc_wrkcrd_appl ,
    general.gorrace
  WHERE gorprac_pidm   = pidm
  AND gorrace_race_cde = gorprac_race_cde;

-- ***************************************************************

CREATE OR REPLACE VIEW "WRKCRD"."CC_WRKCRD_DECISION_VW" 
  AS 
  SELECT id appl_id ,
    id || sarappd_seq_no || sarappd_apdc_code || TO_CHAR(sarappd_apdc_date, 'yyyymmdd') dec_id ,
    sarappd_seq_no ,
    sarappd_apdc_date ,
    sarappd_apdc_code ,
    stvapdc_desc ,
    CASE WHEN stvapdc_appl_inact IS NULL THEN 0 ELSE 1 END stvapdc_appl_inact ,
    CASE
      WHEN sarappd_seq_no =
        (SELECT MAX(b.sarappd_seq_no)
        FROM saturn.sarappd b
        WHERE b.sarappd_pidm          = pidm
        AND b.sarappd_term_code_entry = term
        AND b.sarappd_appl_no         = appl_no
        )
      THEN 1
      ELSE 0
    END latest
  FROM wrkcrd.cc_wrkcrd_appl ,
    saturn.sarappd ,
    saturn.stvapdc
  WHERE sarappd_pidm          = pidm
  AND sarappd_term_code_entry = term
  AND sarappd_appl_no         = appl_no
  AND stvapdc_code            = sarappd_apdc_code;
  
-- ***************************************************************

CREATE OR REPLACE VIEW "WRKCRD"."CC_WRKCRD_CHKL_VW"
  AS 
  SELECT id ,
    id || sarchkl_admr_code || TO_CHAR(sarchkl_receive_date, 'yyyymmdd') chk_id ,
    sarchkl_admr_code ,
    stvadmr_desc ,
    CASE WHEN sarchkl_mandatory_ind IS NULL THEN 'N' ELSE sarchkl_mandatory_ind END sarchkl_mandatory_ind,
    sarchkl_receive_date ,
    sarchkl_comment
  FROM saturn.sarchkl ,
    wrkcrd.cc_wrkcrd_appl ,
    saturn.stvadmr
  WHERE sarchkl_admr_code     = stvadmr_code
  AND sarchkl_pidm            = pidm
  AND sarchkl_term_code_entry = term
  AND sarchkl_appl_no         = appl_no;
  
-- ***************************************************************

CREATE OR REPLACE VIEW "WRKCRD"."CC_WRKCRD_ATTRIBUTES_VW" 
  AS 
  SELECT id,
    id || stvatts_code attr_id ,
    stvatts_code ,
    stvatts_desc
  FROM saturn.saraatt ,
    wrkcrd.cc_wrkcrd_appl ,
    saturn.stvatts
  WHERE saraatt_pidm       = pidm
  AND saraatt_term_code    = term
  AND saraatt_appl_no      = appl_no
  AND stvatts.stvatts_code = saraatt_atts_code
  AND saraatt_atts_code LIKE 'A%';
  
-- ***************************************************************

CREATE OR REPLACE VIEW "WRKCRD"."CC_WRKCRD_YCC_VW"
  AS 
  SELECT id appl_id,
    id || sarrsrc_sbgi_code ycc_id ,
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
  AND sarrsrc_sbgi_code IN (SELECT code FROM cc_wrkcrd_ycc);
  
-- ***************************************************************

CREATE OR REPLACE VIEW "WRKCRD"."CC_WRKCRD_FAMILY_VW"
AS
  SELECT appl_id ,
    id ,
    type ,
    school ,
    occupation ,
    birth_country ,
    degree ,
    to_date ,
    grade_level ,
    CASE
      WHEN created_by IN ('AXIOM')
      THEN
        (SELECT pidm FROM wrkcrd.cc_wrkcrd_ban_user_vw WHERE username = 'axiom'
        )
      ELSE
        (SELECT pidm FROM wrkcrd.cc_wrkcrd_ban_user_vw WHERE pidm = created_by
        )
    END created_by ,
    created_date ,
    CASE
      WHEN update_by IN ('AXIOM')
      THEN
        (SELECT pidm FROM wrkcrd.cc_wrkcrd_ban_user_vw WHERE username = 'axiom'
        )
      ELSE
        (SELECT pidm FROM wrkcrd.cc_wrkcrd_ban_user_vw WHERE pidm = update_by
        )
    END update_by ,
    update_date
  FROM wrkcrd.cc_wrkcrd_relation;
  
-- ***************************************************************

CREATE OR REPLACE VIEW "WRKCRD"."CC_WRKCRD_APPLICATION_VW"
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
    AND sor.sorainf_seqno     = (SELECT MAX(sorainf_seqno) FROM saturn.sorainf
                                 WHERE sorainf_pidm = sor.sorainf_pidm
                                 AND sorainf_term_code = sor.sorainf_term_code)
    AND sor.sorainf_module    = 'A'
    AND gobtpac_pidm      = sor.sorainf_arol_pidm
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
    (SELECT stvsbgi_desc FROM stvsbgi
     WHERE stvsbgi_code = a.saradap_sbgi_code) vw_where_attending ,
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
    first_words,
    NVL(ap_count, 0) ap_count,
    NVL(ap_limit, 0) ap_limit,
    NVL(honors_count, 0) honors_count,
    NVL(honors_limit, 0) honors_limit,
    art_interest,
    music_focus,
    art_focus,
    url,
    CASE WHEN other_country IS NOT NULL THEN 
      (SELECT stvnatn_nation FROM saturn.stvnatn WHERE stvnatn_code = other_country)
    ELSE 
      ''
    END other_country,
    CASE WHEN birth_country IS NOT NULL THEN 
      (SELECT stvnatn_nation FROM saturn.stvnatn WHERE stvnatn_code = birth_country)
    ELSE 
      ''
    END birth_country,
    alien_reg_date,
    alien_reg_nbr,
    visa_type
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
  
-- ***************************************************************
  
--===============================================================
--===============================================================
-- New values for lookup tables
--===============================================================
--===============================================================

insert into wrkcrd.cc_wrkcrd_note_identifier (id, type, description) values ('Art', 'TR', 'Arts');
insert into wrkcrd.cc_wrkcrd_note_identifier (id, type, description) values ('Foreign', 'TR', 'Foreign Language');
insert into wrkcrd.cc_wrkcrd_note_identifier (id, type, description) values ('Social', 'TR', 'Social Studies');

insert into wrkcrd.cc_wrkcrd_decision_rater (apdc_code, start_term) values ('RE', '201310');
insert into wrkcrd.cc_wrkcrd_decision_rater (apdc_code, start_term) values ('CI', '201310');