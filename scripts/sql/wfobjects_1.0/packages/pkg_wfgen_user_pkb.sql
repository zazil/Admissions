create or replace
PACKAGE BODY                     PKG_WFGEN_USER AS

    /* Retrieves all of the pidm's name info including Preferred name */
  PROCEDURE P_GET_NAMES(
    p_pidm              NUMBER,
    p_last_name     OUT VARCHAR2,
    p_mi            OUT VARCHAR2,
    p_first_name    OUT VARCHAR2,
    p_full_name_lf  OUT VARCHAR2,
    p_full_name_fl  OUT VARCHAR2,
    p_id            OUT VARCHAR2,
    p_pref_first_name OUT VARCHAR2
  ) AS
  BEGIN

    SELECT  spriden_last_name
            , spriden_mi
            , spriden_first_name
            , spriden_last_name || ', ' || spriden_first_name
            , spriden_first_name || ' ' || spriden_last_name
            , spriden_id
            , decode( spbpers_pref_first_name, null, spriden_first_name, spbpers_pref_first_name )
    INTO    p_last_name
                    , p_mi
            , p_first_name
            , p_full_name_lf
            , p_full_name_fl
            , p_id
            , p_pref_first_name
    FROM    saturn.spriden
            , saturn.spbpers
    WHERE   spriden_pidm        = p_pidm
    AND     spriden_change_ind  IS NULL
    AND     spbpers_pidm        = spriden_pidm;

  END P_GET_NAMES;


  /* Retrieves the number of email addresses for the pidm and type specified */
  PROCEDURE P_GET_EMAIL_COUNT(
    p_pidm                NUMBER,
    p_emal_code           VARCHAR2,
    p_email_addr_cnt  OUT NUMBER
  ) AS
  BEGIN

    SELECT  COUNT(*)
    INTO    p_email_addr_cnt
    FROM    general.goremal
    WHERE   goremal_pidm        = p_pidm
    AND     goremal_emal_code   = p_emal_code
    AND     goremal_status_ind  = 'A';

  END P_GET_EMAIL_COUNT;


  /*
   * Retrieves the email address for the specified PIDM if the DB instance is CONN
     * otherwise it returns the specified alternate email (or aisteam@conncoll.edu if
     * none was provided!)
   */
  PROCEDURE P_GET_EMAIL(
    p_pidm                    NUMBER,
    p_emal_code               VARCHAR2,
    p_alternate_email         VARCHAR2,
    p_address           OUT   VARCHAR2
  ) AS
    CURSOR csr_usr_email(p_user VARCHAR2) IS
      SELECT  goremal_email_address
      FROM    general.gobtpac
              , general.goremal
      WHERE   gobtpac_pidm = goremal_pidm
      AND     goremal_preferred_ind   = 'Y'
      AND     goremal_status_ind      = 'A'
      AND     gobtpac_external_user   = LOWER(p_user);

    CURSOR csr_email IS
      SELECT  goremal_email_address
      FROM    general.goremal
      WHERE   goremal_pidm = p_pidm
      AND     goremal_emal_code= p_emal_code
      AND     goremal_status_ind = 'A';

    v_db     VARCHAR2(50);
    v_pidm   NUMBER;
    v_address VARCHAR2(200);
  BEGIN

    v_db := ORA_DATABASE_NAME();

    IF v_db != 'CONN' AND v_db != 'CONN.WORLD' THEN

      --If an alternate email address was not supplied
      IF p_alternate_email = '' OR p_alternate_email IS NULL THEN

        IF csr_usr_email%ISOPEN THEN
          CLOSE csr_usr_email;
        END IF;

        OPEN csr_usr_email(USER);
        FETCH csr_usr_email INTO p_address;

        --If no email was found for the user (WFAUTO, CONNMAN, etc.) then use
        --default AISTeam
        IF csr_usr_email%NOTFOUND THEN
          v_address := 'aisteam@conncoll.edu';
        END IF;

        CLOSE csr_usr_email;
      ELSE
        v_address := p_alternate_email;
      END IF;

    ELSE
      --We're in production so return the real email address!
      IF csr_email%ISOPEN THEN
        CLOSE csr_email;
      END IF;

      OPEN csr_email;
      FETCH csr_email INTO v_address;

      --If no email was found for the user (WFAUTO, CONNMAN, etc.) then use
      --default AISTeam
      IF csr_email%NOTFOUND THEN
        v_address := 'aisteam@conncoll.edu';
      END IF;

      CLOSE csr_email;
      
      SELECT v_address INTO p_address FROM dual;

    END IF;

  END P_GET_EMAIL;

END PKG_WFGEN_USER; 

/