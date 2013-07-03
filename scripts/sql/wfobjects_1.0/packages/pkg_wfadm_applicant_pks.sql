create or replace
PACKAGE                     PKG_WFADM_APPLICANT AS

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
  );

  /* Retrieves the applicant's SSB login id and PIN */
  PROCEDURE P_GET_SSB_LOGIN_CREDS(
    p_pidm              NUMBER,
    p_user_id       OUT VARCHAR2,
    p_pin           OUT VARCHAR2
  );

  /* Retrieves the SARADAP info needed to email the applicant their login info */
  PROCEDURE P_GET_SARADAP_RCPT_INFO(
    p_pidm                NUMBER,
    p_term_code           VARCHAR2,
    p_appl_no             NUMBER,
    p_admt_code       OUT VARCHAR2,
    p_apst_date       OUT VARCHAR2,
    p_sbgi_code       OUT VARCHAR2
  );

  /* Retrieves the default error/testing address */
  PROCEDURE P_GET_DEFAULT_EMAIL(
    p_address   OUT VARCHAR2
  );

	/* Retrieves the most recent decision from SARAPPD */
	PROCEDURE GET_CURRENT_DECISION(
    p_appl_id                 NUMBER,
    p_decision          OUT   VARCHAR2
  );

  /* Updates the Workcard Stage/Status to the specified code
   *			(valid values in WRKCRD.CC_WRKCRD_APPL_STAGE)
   */
  PROCEDURE UPDATE_STAGE(
    p_appl_id                 NUMBER,
    p_stage                   VARCHAR2
  );

  /* Retrieve the Workcard Id from the Pidm, Term, Admt, and Appl # */
  PROCEDURE GET_APPL_ID(
    p_pidm                    NUMBER,
    p_term_code               VARCHAR2,
    p_admit_code              VARCHAR2,
    p_appl_no                 NUMBER,
    p_appl_id           OUT   NUMBER
  );

  /* Retrieve the Pidm, Term, Admt, and Appl # from the workcard Id */
  PROCEDURE GET_PIDM_TERM_ADMT_APPL(
    p_appl_id                 NUMBER,
    p_pidm              OUT   NUMBER,
    p_term_code         OUT   VARCHAR2,
    p_admit_code        OUT   VARCHAR2,
    p_appl_no           OUT   NUMBER
  );

  /* Removes the ratings made -- when the application needs to be reassigned */
  PROCEDURE P_REMOVE_RATINGS(
    p_appl_id                 NUMBER
  );

  /* Gets the Workflow Specific name for the Application Completed Workflow (aka WF2) */
  PROCEDURE P_GET_WFNAME_WRKCRD(
  	p_pidm										NUMBER,
  	p_term										VARCHAR2,
  	p_appl_no									VARCHAR2,
  	p_wf_name						OUT		VARCHAR2
  );

  /* Creates stub cc_wrkcrd records for the specified applicant */
  PROCEDURE P_SEED_APPL(
    p_pidm    NUMBER,
    p_term    VARCHAR2,
    p_admt    VARCHAR2,
    p_appl_no NUMBER
  );

  /* Updates the Workflow Specific name at runtime */
  PROCEDURE P_ENG_WORKFLOW_NAMECHANGE(
    p_id                IN NUMBER,
    p_prefix            IN VARCHAR2,
    p_name              IN OUT VARCHAR2
  );
  
  /* Resync the Admit Code stored in the Workflow table */
  PROCEDURE P_SYNC_SARADAP_WRKCRD(
    p_pidm      IN NUMBER,
    p_term      IN VARCHAR2,
    p_appl_no   IN NUMBER
  );

END PKG_WFADM_APPLICANT;

/