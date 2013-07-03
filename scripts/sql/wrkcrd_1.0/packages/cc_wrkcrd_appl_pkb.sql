create or replace
PACKAGE BODY        CC_WRKCRD_APPL_PKG AS

  FUNCTION CC_WRKCRD_WF_UPDATE(
      p_appl_id               NUMBER,
      p_next_reader           VARCHAR2 := 'briley',

      p_common_app_id         VARCHAR2,
      p_financial_aid         VARCHAR2,
      p_load_date             DATE,
      p_term                  VARCHAR2,
      p_type                  VARCHAR2,
      p_status                VARCHAR2,
      p_career_interest       VARCHAR2,

      p_school_ceeb           VARCHAR2,
      p_school_name           VARCHAR2,
      p_school_type           VARCHAR2,
      p_school_eps            VARCHAR2,
      p_graduation_date       DATE,

      p_banner_class_size     NUMBER,
      p_optional_class_size   NUMBER,

      p_banner_class_rank     NUMBER,
      p_optional_class_rank   NUMBER,
      p_rank_type             VARCHAR2,
      p_weighted_rank         NUMBER,

      p_banner_gpa            VARCHAR2,
      p_gpa_scale             NUMBER,
      p_highest_gpa           NUMBER,
      p_weighted_gpa          NUMBER,

      p_class_percent_college_bound NUMBER,
      p_class_percentile      NUMBER
  ) RETURN NUMBER IS
  BEGIN

    UPDATE  wrkcrd.cc_wrkcrd_appl
    SET     stage = p_status
            , next_reader = p_next_reader
    WHERE   id = p_appl_id;

    RETURN SQL%ROWCOUNT;

  END CC_WRKCRD_WF_UPDATE;


  PROCEDURE GET_CURRENT_DECISION(
    p_appl_id                 NUMBER,
    p_decision          OUT   VARCHAR2
  ) AS

    CURSOR csr_decision IS
      SELECT  sarappd_apdc_code
      FROM    saturn.sarappd
              , cc_wrkcrd_appl
      WHERE   sarappd_pidm        = pidm
      AND     sarappd_term_code_entry = term
      AND     sarappd_appl_no     = appl_no
      AND     id                  = p_appl_id
      AND     sarappd_apdc_date   = (SELECT MAX(sarappd_apdc_date)
                                     FROM   saturn.sarappd
                                     WHERE  sarappd_pidm            = pidm
                                     AND    sarappd_term_code_entry = term
                                     AND    sarappd_appl_no         = appl_no);
  BEGIN

    IF csr_decision%ISOPEN THEN
      CLOSE csr_decision;
    END IF;

    OPEN csr_decision;
    FETCH csr_decision INTO p_decision;

    --Check for NULLs because it will break Workflow!
    IF SQL%ROWCOUNT <= 0 THEN
      p_decision := 'N/A';
    END IF;

  END GET_CURRENT_DECISION;

  PROCEDURE UPDATE_STAGE(
    p_appl_id                 NUMBER,
    p_stage                   VARCHAR2
  ) AS
    v_stage VARCHAR2(10);
  BEGIN

    SELECT  id
    INTO    v_stage
    FROM    cc_wrkcrd_appl_stage
    WHERE   id = p_stage;

    IF v_stage IS NOT NULL THEN
      UPDATE  cc_wrkcrd_appl
      SET     stage = p_stage
      WHERE   id = p_appl_id;
    END IF;

  END UPDATE_STAGE;

  PROCEDURE UPDATE_READ_COUNT(
    p_appl_id                 NUMBER
  ) AS
    v_readCnt  NUMBER;
  BEGIN

    SELECT  reads_completed
    INTO    v_readCnt
    FROM    cc_wrkcrd_appl
    WHERE   id = p_appl_id;

    IF v_readCnt > 0 THEN
      UPDATE  cc_wrkcrd_appl
      SET     reads_completed = v_readCnt - 1
      WHERE   id = p_appl_id;
    END IF;

  END UPDATE_READ_COUNT;


  PROCEDURE GET_APPL_ID(
    p_pidm                    NUMBER,
    p_term_code               VARCHAR2,
    p_admit_code              VARCHAR2,
    p_appl_no                 NUMBER,
    p_appl_id           OUT   NUMBER
  ) AS
  BEGIN
    SELECT  id
    INTO    p_appl_id
    FROM    cc_wrkcrd_appl
    WHERE   pidm        = p_pidm
    AND     term        = p_term_code
    AND     admit_code  = p_admit_code
    AND     appl_no     = p_appl_no;
  END GET_APPL_ID;


  PROCEDURE GET_PIDM_TERM_ADMT_APPL(
    p_appl_id                 NUMBER,
    p_pidm              OUT   NUMBER,
    p_term_code         OUT   VARCHAR2,
    p_admit_code        OUT   VARCHAR2,
    p_appl_no           OUT   NUMBER
  )AS
  BEGIN
    SELECT  pidm
            , term
            , admit_code
            , appl_no
    INTO    p_pidm
            , p_term_code
            , p_admit_code
            , p_appl_no
    FROM    cc_wrkcrd_appl
    WHERE   id = p_appl_id;
  END GET_PIDM_TERM_ADMT_APPL;


  PROCEDURE P_REMOVE_RATINGS(
    p_appl_id                 NUMBER
  ) AS
    CURSOR csr_appl IS
      SELECT  pidm, term, appl_no
      FROM    wrkcrd.cc_wrkcrd_appl
      WHERE   id = p_appl_id;

    rec_appl csr_appl%ROWTYPE;
  BEGIN

    IF csr_appl%ISOPEN THEN
      CLOSE csr_appl;
    END IF;

    OPEN csr_appl;

    FETCH csr_appl INTO rec_appl;

    DELETE FROM wrkcrd.cc_wrkcrd_rating WHERE appl_id = p_appl_id;

    DELETE FROM saturn.sarrrat
    WHERE sarrrat_pidm        = rec_appl.pidm
    AND   sarrrat_term_code   = rec_appl.term
    AND   sarrrat_appl_no     = rec_appl.appl_no
    AND   sarrrat_radm_code   = 'RDR';

    --Reset the reading counter
    update_read_count( p_appl_id );

    CLOSE csr_appl;

  END P_REMOVE_RATINGS;


  PROCEDURE P_ENG_WORKFLOW_NAMECHANGE(
    p_id                IN NUMBER,
    p_prefix            IN VARCHAR2,
    p_name              IN OUT VARCHAR2
  ) AS
    v_name VARCHAR2(500);
  BEGIN
    v_name := p_prefix || ' - ' || p_name;

    UPDATE  workflow.eng_workflow
    SET     name = v_name
    WHERE   id = p_id;

    p_name := v_name;

  END P_ENG_WORKFLOW_NAMECHANGE;

END CC_WRKCRD_APPL_PKG;

/