CREATE OR REPLACE VIEW "WRKCRD"."CC_WRKCRD_ATTRIBUTES_LKP_VW" 
AS 
  SELECT DISTINCT
    stvatts_code ,
    stvatts_desc
  FROM saturn.stvatts
  WHERE stvatts_code LIKE 'A%';    
  
CREATE OR REPLACE PUBLIC SYNONYM CC_WRKCRD_ATTRIBUTES_LKP_VW FOR WRKCRD.CC_WRKCRD_ATTRIBUTES_LKP_VW;

CREATE INDEX WRKCRD.WRKCRD_SARRSRC_IDX ON saturn.sarrsrc (sarrsrc_sbgi_code);
CREATE INDEX WRKCRD.WRKCRD_STVSBGI_IDX ON saturn.stvsbgi (stvsbgi_code, stvsbgi_desc);
CREATE INDEX WRKCRD.WRKCRD_STVTESC_IDX ON saturn.stvtesc (stvtesc_code, stvtesc_desc, stvtesc_min_value, stvtesc_max_value, stvtesc_data_type);
CREATE INDEX WRKCRD.WRKCRD_SORTEST_IDX ON saturn.sortest (sortest_tesc_code, sortest_test_date, sortest_test_score, sortest_pidm);
CREATE INDEX WRKCRD.WRKCRD_SPBPERS_IDX ON saturn.spbpers (spbpers_pidm, spbpers_sex, spbpers_citz_code);
CREATE INDEX WRKCRD.WRKCRD_SPBPERS_SORFOLK_IDX ON saturn.spbpers (spbpers_pidm, spbpers_lgcy_code);
CREATE INDEX WRKCRD.WRKCRD_SORFOLK_IDX ON saturn.sorfolk (sorfolk_pidm, sorfolk_relt_code, sorfolk_parent_name_suffix, sorfolk_parent_last, sorfolk_parent_name_prefix, sorfolk_parent_first, sorfolk_parent_mi, sorfolk_parent_degree, sorfolk_activity_date);
CREATE INDEX WRKCRD.WRKCRD_SARRRAT_IDX ON saturn.sarrrat (sarrrat_pidm, sarrrat_ratp_code, sarrrat_term_code, sarrrat_appl_no, sarrrat_arol_pidm);
CREATE INDEX WRKCRD.WRKCRD_SARRRCT_IDX ON saturn.sarrrct (sarrrct_ratp_code, sarrrct_term_code_eff, sarrrct_min_rating, sarrrct_max_rating);
CREATE INDEX WRKCRD.WRKCRD_STVRECR_IDX ON saturn.stvrecr (stvrecr_code, stvrecr_desc);

CREATE INDEX WRKCRD.WRKCRD_WFUSER_IDX ON workflow.wfuser (logon, id);
CREATE INDEX WRKCRD.WRKCRD_WFROLE_IDX ON workflow.role (id, name);

CREATE INDEX WRKCRD.WRKCRD_HSTR_IDX ON wrkcrd.cc_wrkcrd_index_hstr_ind (id, cqi, grades, rating);
CREATE INDEX WRKCRD.WRKCRD_RATING_IDX ON wrkcrd.cc_wrkcrd_rating (appl_id, id, rater, decision, rated_on);
CREATE INDEX WRKCRD.WRKCRD_NOTES_IDX ON wrkcrd.cc_wrkcrd_notes (appl_id, id, type, identifier, update_by, update_date);
CREATE INDEX WRKCRD.WRKCRD_RELATION_IDX ON wrkcrd.cc_wrkcrd_relation (id, appl_id, type, created_by);