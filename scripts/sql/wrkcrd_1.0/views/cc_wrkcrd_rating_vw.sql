CREATE OR REPLACE FORCE VIEW "WRKCRD"."CC_WRKCRD_RATING_VW" ("APPL_ID", "PIDM", "TERM", "ADMIT_CODE", "APPL_NO", "ID", "SUMMARY", "HIGH_SCHOOL", "TESTS", "ACADEMIC", "PERSONAL", "CURRIC_QUAL_IDX", "RATER", "DECISION", "RATED_ON")
AS
  SELECT appl.id appl_id,
    appl.pidm ,
    appl.term ,
    appl.admit_code ,
    appl.appl_no ,
    rate.id ,
    rate.summary ,
    NVL(
    (SELECT MAX(sarrrat_rating)
    FROM saturn.sarrrat
    WHERE sarrrat_ratp_code = 'HSTR'
    AND sarrrat_pidm        = pidm
    AND sarrrat_term_code   = term
    AND sarrrat_appl_no     = appl_no
    AND sarrrat_arol_pidm   = rater
    ), 0) high_school,
    NVL(
    (SELECT MAX(sarrrat_rating)
    FROM saturn.sarrrat
    WHERE sarrrat_ratp_code = 'TEST'
    AND sarrrat_pidm        = pidm
    AND sarrrat_term_code   = term
    AND sarrrat_appl_no     = appl_no
    AND sarrrat_arol_pidm   = rater
    ), 0) tests,
    NVL(
    (SELECT MAX(sarrrat_rating)
    FROM saturn.sarrrat
    WHERE sarrrat_ratp_code = 'ACAD'
    AND sarrrat_pidm        = pidm
    AND sarrrat_term_code   = term
    AND sarrrat_appl_no     = appl_no
    AND sarrrat_arol_pidm   = rater
    ), 0) academic,
    NVL(
    (SELECT MAX(sarrrat_rating)
    FROM saturn.sarrrat
    WHERE sarrrat_ratp_code = 'PERS'
    AND sarrrat_pidm        = pidm
    AND sarrrat_term_code   = term
    AND sarrrat_appl_no     = appl_no
    AND sarrrat_arol_pidm   = rater
    ), 0) personal,
    NVL(
    (SELECT MAX(sarrrat_rating)
    FROM saturn.sarrrat
    WHERE sarrrat_ratp_code = 'CQI'
    AND sarrrat_pidm        = pidm
    AND sarrrat_term_code   = term
    AND sarrrat_appl_no     = appl_no
    AND sarrrat_arol_pidm   = rater
    ), 0) curric_qual_idx,
    CASE
      WHEN rater NOT IN
        (SELECT pidm FROM wrkcrd.cc_wrkcrd_ban_user_vw
        )
      THEN
        (SELECT pidm FROM wrkcrd.cc_wrkcrd_ban_user_vw WHERE username = 'axiom'
        )
      ELSE
        (SELECT pidm FROM wrkcrd.cc_wrkcrd_ban_user_vw WHERE pidm = rate.rater
        )
    END rater ,
    rate.decision ,
    rate.rated_on
  FROM wrkcrd.cc_wrkcrd_appl appl ,
    wrkcrd.cc_wrkcrd_rating rate
  WHERE appl.id = rate.appl_id(+);
  
/