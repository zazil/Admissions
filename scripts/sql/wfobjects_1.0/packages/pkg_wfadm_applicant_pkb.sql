create or replace
PACKAGE BODY                                         PKG_WFADM_APPLICANT AS

/*
 *  ----------------------------------------------------------------------------
 *                              Connecticut College
 *
 *                      Copyright 2011 Connecticut College
 *  ============================================================================
 *  NAME:     PKG_WFADM_APPLICANT
 *  AUTHOR:   Brian Riley (briley)
 *  VERSION:  1.0.0
 *
 *  PURPOSE: 	This package provides data access functions to Admissions applicant
 *						specific Workflows.
 *
 *						WF Models:			ADM_SARADAP Application_Complete
 *														ADM_New SARADAP Application_Received
 *
 *						WF Events:			CC_ADM_APPL_CMPLT
 *														CC_ADM_APPL_RCVD
 *
 *						WF Processes:		ADM Application Complete
 *														ADM_New_Application_Received
 *
 *  DEPENDENCIES:
 *						SATURN.SARADAP - 									Select the application info
 *						SATURN.SARAPPD -									Select the most recent deicision code
 *						SATURN.SARWAAD - 									Select the SSB active dates for applicants
 *						SATURN.SPRIDEN -									Select the applicant's spriden Id
 *						GENERAL.GOBTPAC - 								Select applicant's banner Id and PIN
 *						GENERAL.GORPAUD -									Select applicant's banner Id and PIN
 *
 *           	WORKFLOW.ENG_WORKFLOW -   				Updates the WF Specific Name
 *
 *						WRKCRD.CC_WRKCRD_APPL -						Select and Update to the stage/status column
 *						WRKCRD.CC_WRKCRD_APPL_STAGE -			Select the valid workcard stage/status codes
 *           	WRKCRD.CC_WRKCRD_APPLICATION_VW - Select the workcard info
 *						WRKCRD.CC_WRKCRD_PERSON_VW -			Select the applicant's info
 *						WRKCRD.CC_WRKCRD_RATING - 				Deletes records when appl. is reassigned
 *						WRKCRD.CC_WRKCRD_SETTINGS - 			Select the default email address
 *
 *  ---
 *  REVISIONS:
 *
 */

  /*
   * Retrieves the dates that determine when the application checklist is
   * available online in SSB
   */
  PROCEDURE P_GET_SARWAAD_DATES(
    p_term_code             VARCHAR2,
    p_admit_code            VARCHAR2,
    p_ssb_start_date    OUT VARCHAR2,
    p_ssb_end_date      OUT VARCHAR2
  ) AS
  BEGIN

    SELECT  to_char( trunc( sarwaad_start_date ) )
            , to_char( trunc( sarwaad_end_date ) )
    INTO    p_ssb_start_date
            , p_ssb_end_date
    FROM    saturn.sarwaad
    WHERE   sarwaad_term_code = p_term_code
    AND     sarwaad_admt_code = p_admit_code;

  END P_GET_SARWAAD_DATES;


  /* Retrieves the applicant's SSB login id and PIN */
  PROCEDURE P_GET_SSB_LOGIN_CREDS(
    p_pidm              NUMBER,
    p_user_id       OUT VARCHAR2,
    p_pin           OUT VARCHAR2
  ) AS
  BEGIN

    SELECT  gorpaud_pin
            , spriden_id
    INTO    p_pin
            , p_user_id
    FROM    saturn.spriden
            , general.gobtpac
            , general.gorpaud
    WHERE   gobtpac_pidm          = spriden_pidm
    AND     spriden_change_ind    IS NULL
    AND     gorpaud_pidm          = gobtpac_pidm
    AND     gorpaud_activity_date = gobtpac_activity_date
    AND     gorpaud_chg_ind       = 'P'
    AND     spriden_pidm          = p_pidm;

  END P_GET_SSB_LOGIN_CREDS;


  /* Retrieves the SARADAP info needed to email the applicant their login info */
  PROCEDURE P_GET_SARADAP_RCPT_INFO(
    p_pidm                NUMBER,
    p_term_code           VARCHAR2,
    p_appl_no             NUMBER,
    p_admt_code       OUT VARCHAR2,
    p_apst_date       OUT VARCHAR2,
    p_sbgi_code       OUT VARCHAR2
  ) AS
  BEGIN

    SELECT  saradap_admt_code
            , to_char( to_date( trunc( saradap_apst_date ) ) )
            , saradap_sbgi_code
    INTO    p_admt_code
            , p_apst_date
            , p_sbgi_code
    FROM    saturn.saradap
    WHERE   saradap_pidm            = p_pidm
    AND     saradap_term_code_entry = p_term_code
    AND     saradap_appl_no         = p_appl_no;

  END P_GET_SARADAP_RCPT_INFO;


  /* Retrieves the default error/testing address */
  PROCEDURE P_GET_DEFAULT_EMAIL(
    p_address   OUT VARCHAR2
  ) AS
  BEGIN

    SELECT  email_alternate
    INTO    p_address
    FROM    wrkcrd.cc_wrkcrd_settings;

  END P_GET_DEFAULT_EMAIL;


  /* Retrieves the most recent decision from SARAPPD */
  PROCEDURE GET_CURRENT_DECISION(
    p_appl_id                 NUMBER,
    p_decision          OUT   VARCHAR2
  ) AS
  BEGIN
    SELECT  sarappd_apdc_code
    INTO    p_decision
    FROM    saturn.sarappd
            , wrkcrd.cc_wrkcrd_appl
    WHERE   sarappd_pidm        = pidm
    AND     sarappd_term_code_entry = term
    AND     sarappd_appl_no     = appl_no
    AND     id                  = p_appl_id
    AND     sarappd_apdc_date   = (SELECT MAX(sarappd_apdc_date)
                                   FROM   saturn.sarappd
                                   WHERE  sarappd_pidm            = pidm
                                   AND    sarappd_term_code_entry = term
                                   AND    sarappd_appl_no         = appl_no);

    --Check for NULLs because it will break Workflow!
    IF p_decision IS NULL THEN
      p_decision := 'N/A';
    END IF;

  END GET_CURRENT_DECISION;


  /* Updates the Workcard Stage/Status to the specified code
   *			(valid values in WRKCRD.CC_WRKCRD_APPL_STAGE)
   */
  PROCEDURE UPDATE_STAGE(
    p_appl_id                 NUMBER,
    p_stage                   VARCHAR2
  ) AS
    v_stage VARCHAR2(10);
  BEGIN

    SELECT  id
    INTO    v_stage
    FROM    wrkcrd.cc_wrkcrd_appl_stage
    WHERE   id = p_stage;

    IF v_stage IS NOT NULL THEN
      UPDATE  wrkcrd.cc_wrkcrd_appl
      SET     stage = p_stage
      WHERE   id = p_appl_id;
    END IF;

  END UPDATE_STAGE;


  /* Retrieve the Workcard Id from the Pidm, Term, Admt, and Appl # */
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
    FROM    wrkcrd.cc_wrkcrd_appl
    WHERE   pidm        = p_pidm
    AND     term        = p_term_code
    AND     admit_code  = p_admit_code
    AND     appl_no     = p_appl_no;
  END GET_APPL_ID;


  /* Retrieve the Pidm, Term, Admt, and Appl # from the workcard Id */
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
    FROM    wrkcrd.cc_wrkcrd_appl
    WHERE   id = p_appl_id;
  END GET_PIDM_TERM_ADMT_APPL;


  /* Removes the ratings made -- when the application needs to be reassigned */
  PROCEDURE P_REMOVE_RATINGS(
    p_appl_id                 NUMBER
  ) AS
  BEGIN

    DELETE FROM wrkcrd.cc_wrkcrd_rating WHERE appl_id = p_appl_id;

  END P_REMOVE_RATINGS;


	/* Gets the Workflow Specific name for the Application Completed Workflow (aka WF2) */
  PROCEDURE P_GET_WFNAME_WRKCRD(
  	p_pidm							NUMBER,
  	p_term							VARCHAR2,
  	p_appl_no						VARCHAR2,
  	p_wf_name			OUT		VARCHAR2
  ) AS

  	/* Parameters used to generate the WF specific name */
	  v_id		    VARCHAR(10)	  := '';
	  v_admt		VARCHAR(10)	  := '';
	  v_first       spriden.spriden_first_name%TYPE	  := '';
	  v_last        spriden.spriden_last_name%TYPE   := '';
	  v_eps         VARCHAR(20)   := '';
	  v_ceeb        VARCHAR(20)   := '';
	  v_hs_natn     VARCHAR(5)    := '';
	  v_hs          VARCHAR(200)   := '';
	  v_wf_name     VARCHAR2(500) := '';
  BEGIN

  	--Get the params that will be used to build the WF Specific name
	  SELECT DISTINCT spriden_id
	  				, saradap_admt_code
	          , spriden_first_name
	          , spriden_last_name
	          , CASE WHEN vw_epscode IS NULL THEN ' ' ELSE vw_epscode END vw_epscode
            , CASE WHEN vw_hs_nation IS NULL THEN ' ' ELSE vw_hs_nation END vw_hs_nation
            , CASE WHEN sorhsch_sbgi_code IS NULL THEN ' ' ELSE sorhsch_sbgi_code END sorhsch_sbgi_code
            , CASE WHEN stvsbgi_desc IS NULL THEN ' ' ELSE stvsbgi_desc END stvsbgi_desc
	  INTO    v_id, v_admt, v_first, v_last, v_eps, v_hs_natn, v_ceeb, v_hs
	  FROM    wrkcrd.cc_wrkcrd_application_vw appl
	          , wrkcrd.cc_wrkcrd_person_vw pers
	  WHERE   appl.saradap_pidm = pers.spriden_pidm
	  AND     saradap_pidm = p_pidm
	  AND     saradap_term_code_entry = p_term
	  AND     saradap_appl_no = p_appl_no;


    --Generate the WF Specific name that appears on people's worklists
    v_wf_name := p_term || ' ' || v_admt || ' ' || v_hs_natn || ' ' ||
                 v_eps || ' ' || v_ceeb || ' ' ||
                 v_last || ', ' || v_first || ' ' ||
                 v_id || ' ' || v_hs;

    p_wf_name := REPLACE( v_wf_name, '  ', ' ' );

    --COMMIT;
  END P_GET_WFNAME_WRKCRD;


  /* Creates stub cc_wrkcrd records for the specified applicant */
  PROCEDURE P_SEED_APPL(
    p_pidm    NUMBER,
    p_term    VARCHAR2,
    p_admt    VARCHAR2,
    p_appl_no NUMBER
  ) AS

    /* required because t_adm_appl_cmplt trigger calls this procedure */
    PRAGMA AUTONOMOUS_TRANSACTION;

    CURSOR csr_wrkcrd_appl(
      v_pidm    NUMBER,
      v_term    VARCHAR2,
      v_admt    VARCHAR2,
      v_appl_no NUMBER
    ) IS
      SELECT  *
      FROM    wrkcrd.cc_wrkcrd_appl
      WHERE   pidm = v_pidm
      AND     term = v_term
      AND     admit_code = v_admt
      AND     appl_no = v_appl_no;

    rec_wrkcrd_appl csr_wrkcrd_appl%ROWTYPE;

    v_found   BOOLEAN := false;

  BEGIN
    IF csr_wrkcrd_appl%ISOPEN THEN
      CLOSE csr_wrkcrd_appl;
    END IF;

    OPEN csr_wrkcrd_appl( p_pidm, p_term, p_admt, p_appl_no );
    FETCH csr_wrkcrd_appl INTO rec_wrkcrd_appl;

    v_found := csr_wrkcrd_appl%NOTFOUND;

    CLOSE csr_wrkcrd_appl;

    --If the application does not have a record in wrkcrd.cc_wrkcrd_appl, insert one!
    IF v_found = true THEN

      INSERT INTO wrkcrd.cc_wrkcrd_appl
              (pidm, term, admit_code, appl_no, stage, created_by, created_on)
      VALUES
              ( p_pidm, p_term, p_admt, p_appl_no, 'BEGIN', 'WFOBJECTS', SYSDATE );
      --COMMIT;
    END IF;

  END P_SEED_APPL;


  /* Updates the Workflow Specific name at runtime */
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


  /* Resync the Admit Code stored in the Workflow table */
  PROCEDURE P_SYNC_SARADAP_WRKCRD(
    p_pidm      IN NUMBER,
    p_term      IN VARCHAR2,
    p_appl_no   IN NUMBER
  ) AS
    CURSOR csr_saradap IS
      SELECT  * 
      FROM    saturn.saradap
      WHERE   saradap_pidm            = p_pidm
      AND     saradap_term_code_entry = p_term
      AND     saradap_appl_no         = p_appl_no;
      
    rec_saradap csr_saradap%ROWTYPE;
  BEGIN
  
    IF csr_saradap%ISOPEN THEN
      CLOSE csr_saradap;
    END IF;
    
    OPEN csr_saradap;
    FETCH csr_saradap INTO rec_saradap;
    
    IF csr_saradap%FOUND THEN
      UPDATE  wrkcrd.cc_wrkcrd_appl 
      SET     admit_code = rec_saradap.saradap_admt_code
      WHERE   pidm    = rec_saradap.saradap_pidm
      AND     term    = rec_saradap.saradap_term_code_entry
      AND     appl_no = rec_saradap.saradap_appl_no;
      
      COMMIT;
    END IF;
  
    CLOSE csr_saradap;
    
  END P_SYNC_SARADAP_WRKCRD;

END PKG_WFADM_APPLICANT;

/