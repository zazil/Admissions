create or replace
PACKAGE BODY        CC_WRKCRD_BANNER_API_PKG AS
  /*
   * Package intended to manage UPDATE/INSERT/DELETE functionality
   * with Banner baseline tables
   *
   * Many of these functions are currently stored within the Domain
   * objects themselves under /src/groovy or in the Hibernate hbm.xml
   * files in /grails-app/conf
   *
   * TODO: Need to move all harcoded SQL from the code to this package!
   */

  CURSOR csr_appl(
    p_id                NUMBER      := 0,
    p_pidm              NUMBER      := 0,
    p_term              VARCHAR2    := '',
    p_appl_no           NUMBER      := 0,
    p_admt_code         VARCHAR2    := ''
  ) IS
    SELECT  id,
            pidm,
            term,
            appl_no,
            admit_code
    FROM    wrkcrd.cc_wrkcrd_appl
    WHERE   (     pidm        = p_pidm
              AND term        = p_term
              AND appl_no     = p_appl_no
              AND admit_code  = p_admt_code)
    OR      id = p_id;

  /* These Cursors should return 1 record only! */
  CURSOR csr_attribute(
    p_pidm              NUMBER,
    p_term              VARCHAR2,
    p_appl_no           NUMBER,
    p_atts_code         VARCHAR2
  ) IS
    SELECT  *
    FROM    saturn.saraatt
    WHERE   saraatt_pidm        = p_pidm
    AND     saraatt_term_code   = p_term
    AND     saraatt_appl_no     = p_appl_no
    AND     saraatt_atts_code   = p_atts_code
    FOR UPDATE;

  rec_attribute   saturn.saraatt%ROWTYPE;

  -- ---------------------------------------------------------

  PROCEDURE P_PREFERRED_NAME_SAVE(
    p_pidm              NUMBER,
    p_pref_first_name   VARCHAR2,
    p_result        OUT VARCHAR2
  ) AS
  BEGIN

    -- Call BANINST1.DML_SPBPERS (only updating the pref_first_name!)
    select 'TODO: update the preferred name' into p_result from dual;
  END;

  -- ---------------------------------------------------------

  PROCEDURE P_EMAIL_SAVE(
    p_pidm              NUMBER,
    p_emal_code         VARCHAR2,
    p_email_address     VARCHAR2,
    p_result        OUT VARCHAR2
  ) AS
  BEGIN

    -- Call BANINST1.DML_GOREMAL
    select 'TODO: insert/update the email' into p_result from dual;
  END;

  PROCEDURE P_EMAIL_DELETE(
    p_pidm              NUMBER,
    p_emal_code         VARCHAR2,
    p_result        OUT VARCHAR2
  ) AS
  BEGIN

    -- Call BANINST1.DML_GOREMAL
    select 'TODO: delete the email' into p_result from dual;
  END;

  -- ---------------------------------------------------------

  PROCEDURE P_ADDRESS_SAVE(
    p_pidm              NUMBER,
    p_atyp_code         VARCHAR2,
    p_street_line1      VARCHAR2,
    p_street_line2      VARCHAR2,
    p_street_line3      VARCHAR2,
    p_city              VARCHAR2,
    p_stat_code         VARCHAR2,
    p_zip               VARCHAR2,
    p_natn_code         VARCHAR2,
    p_result        OUT VARCHAR2
  ) AS
  BEGIN

    -- Call BANINST1.DML_SPRADDR
    select 'TODO: insert/update the address' into p_result from dual;
  END;

  PROCEDURE P_ADDRESS_DELETE(
    p_pidm              NUMBER,
    p_atyp_code         VARCHAR2,
    p_result        OUT VARCHAR2
  ) AS
  BEGIN

    -- Call BANINST1.DML_SPRADDR
    select 'TODO: delete the address' into p_result from dual;
  END;

  -- ---------------------------------------------------------

  PROCEDURE P_TELEPHONE_SAVE(
    p_pidm              NUMBER,
    p_tele_code         VARCHAR2,
    p_phone_area        VARCHAR2,
    p_phone_number      VARCHAR2,
    p_phone_ext         VARCHAR2,
    p_sprtele_intl_access VARCHAR2,
    p_result        OUT VARCHAR2
  ) AS
  BEGIN

    -- Call BANINST1.DML_SPRTELE
    select 'TODO: insert/update the phone number' into p_result from dual;
  END;

  PROCEDURE P_TELEPHONE_DELETE(
    p_pidm              NUMBER,
    p_tele_code         VARCHAR2,
    p_result        OUT VARCHAR2
  ) AS
  BEGIN

    -- Call BANINST1.DML_SPRTELE
    select 'TODO: delete the phone number' into p_result from dual;
  END;

  -- ---------------------------------------------------------

  PROCEDURE P_LEGACY_SAVE(
    p_pidm              NUMBER,
    p_relt_code         VARCHAR2,
    p_parent_last       VARCHAR2,
    p_parent_first      VARCHAR2,
    p_parent_mi         VARCHAR2,
    p_parent_name_prefix VARCHAR2,
    p_parent_name_suffix VARCHAR2,
    p_atyp_code         VARCHAR2,
    p_parent_degree     VARCHAR2,
    p_result        OUT VARCHAR2
  ) AS
  BEGIN

    -- insert/update the legacy in SORFOLK and SPBPERS (LGCY_CODE only!)
    select 'TODO: insert/update the legacy' into p_result from dual;
  END;

  PROCEDURE P_LEGACY_DELETE(
    p_pidm              NUMBER,
    p_relt_code         VARCHAR2,
    p_atyp_code         VARCHAR2,
    p_parent_last       VARCHAR2,
    p_parent_first      VARCHAR2,
    p_result        OUT VARCHAR2
  ) AS
  BEGIN

    -- delete the record from SORFOLK but NOT SPBPERS!
    select 'TODO: delete the legacy' into p_result from dual;
  END;

  -- ---------------------------------------------------------

  PROCEDURE P_ATTRIBUTE_SAVE(
    p_pidm              NUMBER,
    p_term              VARCHAR2,
    p_appl_no           NUMBER,
    p_atts_code         VARCHAR2,
    p_result        OUT VARCHAR2
  ) AS
  BEGIN

    IF csr_attribute%ISOPEN THEN
      CLOSE csr_attribute;
    END IF;

    OPEN csr_attribute( p_pidm, p_term, p_appl_no, p_atts_code );

    /*
     * Since the only values in the table are the FK to saradap and the
     * code, we only need to INSERT.
     */
    IF csr_attribute%ROWCOUNT = 0 THEN

      INSERT INTO saturn.saraatt
        (saraatt_activity_date, saraatt_appl_no, saraatt_atts_code,
         saraatt_pidm, saraatt_term_code)
      VALUES
        (SYSDATE, p_appl_no, p_atts_code, p_pidm, p_term);

      COMMIT;

      p_result := 'OK';
    END IF;

    CLOSE csr_attribute;

  END;

  PROCEDURE P_ATTRIBUTE_DELETE(
    p_pidm              NUMBER,
    p_term              VARCHAR2,
    p_appl_no           NUMBER,
    p_atts_code         VARCHAR2,
    p_result        OUT VARCHAR2
  ) AS
  BEGIN

    IF csr_attribute%ISOPEN THEN
      CLOSE csr_attribute;
    END IF;

    OPEN csr_attribute( p_pidm, p_term, p_appl_no, p_atts_code );

    -- If the attribute was found then delete it
    IF csr_attribute%ROWCOUNT = 1 THEN

      -- delete the attribute from SARAATT
      DELETE FROM saraatt WHERE CURRENT OF csr_attribute;

      p_result := 'OK';
    END IF;

    CLOSE csr_attribute;
  END;

  -- ---------------------------------------------------------

  PROCEDURE P_INTERVIEW_SAVE(
    p_pidm              NUMBER,
    p_contact_date      DATE,
    p_ctyp_code         VARCHAR2,
    p_contact_from_time NUMBER,
    p_rslt_code         VARCHAR2,
    p_recr_code         VARCHAR2,
    p_result        OUT VARCHAR2
  ) AS
  BEGIN

    -- insert or delete the contact in SORAPPT depending on whether or not it
    -- already exists
    select 'TODO: insert/update the interview accordingly' into p_result from dual;
  END;

  PROCEDURE P_INTERVIEW_DELETE(
    p_pidm              NUMBER,
    p_contact_date      DATE,
    p_ctyp_code         VARCHAR2,
    p_recr_code         VARCHAR2,
    p_result        OUT VARCHAR2
  ) AS
  BEGIN

    -- delete the record from SORAPPT
    select 'TODO: delete the interview' into p_result from dual;
  END;

  -- ---------------------------------------------------------

  PROCEDURE P_CONTACT_SAVE(
    p_pidm              NUMBER,
    p_ctyp_code         VARCHAR2,
    p_contact_date      DATE,
    p_result        OUT VARCHAR2
  ) AS
  BEGIN

    --insert the record from SORCONT (no need to UPDATE this one
    select 'TODO: insert the contact' into p_result from dual;
  END;

  PROCEDURE P_CONTACT_DELETE(
    p_pidm              NUMBER,
    p_ctyp_code         VARCHAR2,
    p_result        OUT VARCHAR2
  ) AS
  BEGIN

    -- Delete the record from SORCONT
    select 'TODO: delete the contact' into p_result from dual;
  END;

  -- ---------------------------------------------------------

  PROCEDURE P_DECISION_INSERT(
    p_appl_id           NUMBER,
    p_apdc_code         VARCHAR2,
    p_rater             VARCHAR2,
    p_ret           OUT VARCHAR2
  ) AS

    CURSOR csr_cc_wrkcrd_appl IS
      SELECT  pidm,
              term,
              appl_no
      FROM    wrkcrd.cc_wrkcrd_appl
      WHERE   id = p_appl_id;

    CURSOR csr_next_sarappd_seq_no(
      p_pidm    NUMBER,
      p_term    VARCHAR2,
      p_appl_no NUMBER
    ) IS
      SELECT  MAX(sarappd_seq_no)
      FROM    saturn.sarappd
      WHERE   sarappd_pidm              = p_pidm
      AND     sarappd_term_code_entry   = p_term
      AND     sarappd_appl_no           = p_appl_no;

    v_next_seq_no       NUMBER;

    rec_sarappd         saturn.sarappd%ROWTYPE;
    rec_cc_wrkcrd_appl  csr_cc_wrkcrd_appl%ROWTYPE;
  BEGIN
    IF csr_cc_wrkcrd_appl%ISOPEN THEN
      CLOSE csr_cc_wrkcrd_appl;
    END IF;

    OPEN csr_cc_wrkcrd_appl;
    FETCH csr_cc_wrkcrd_appl INTO rec_cc_wrkcrd_appl;

    IF csr_cc_wrkcrd_appl%FOUND THEN

      IF csr_next_sarappd_seq_no%ISOPEN THEN
        CLOSE csr_next_sarappd_seq_no;
      END IF;

      OPEN csr_next_sarappd_seq_no(rec_cc_wrkcrd_appl.pidm, rec_cc_wrkcrd_appl.term, rec_cc_wrkcrd_appl.appl_no);
      FETCH csr_next_sarappd_seq_no INTO v_next_seq_no;

      IF csr_next_sarappd_seq_no%FOUND THEN
        v_next_seq_no := v_next_seq_no + 1;
      ELSE
        v_next_seq_no := 1;
      END IF;

      CLOSE csr_next_sarappd_seq_no;

      rec_sarappd.sarappd_pidm            := rec_cc_wrkcrd_appl.pidm;
      rec_sarappd.sarappd_term_code_entry := rec_cc_wrkcrd_appl.term;
      rec_sarappd.sarappd_appl_no         := rec_cc_wrkcrd_appl.appl_no;
      rec_sarappd.sarappd_seq_no          := v_next_seq_no;
      rec_sarappd.sarappd_apdc_date       := SYSDATE;
      rec_sarappd.sarappd_apdc_code       := p_apdc_code;
      rec_sarappd.sarappd_maint_ind       := 'U';
      rec_sarappd.sarappd_activity_date   := SYSDATE;
      rec_sarappd.sarappd_user            := p_rater;
      rec_sarappd.sarappd_data_origin     := 'WRKCRD';

      baninst1.dml_sarappd.p_insert( rec_sarappd, p_ret );

      COMMIT;

    END IF;

    CLOSE csr_cc_wrkcrd_appl;

  END P_DECISION_INSERT;


END CC_WRKCRD_BANNER_API_PKG;

/