create or replace
PACKAGE        CC_WRKCRD_START_WORKFLOWS AS
	/*
     *  ----------------------------------------------------------------------------
     *                              Connecticut College
     *
     *                      Copyright 2011 Connecticut College
     *  ============================================================================
     *  NAME:     WRKCRD.CC_WRKCRD_START_WORKFLOWS
     *  AUTHOR:   Brian Riley (briley)
     *  VERSION:  1.0.0
     *
     *  PURPOSE:     This package kicks off the Application Complete Workflow which drives.
     *               the Admissions workcard process.
     *
     *                        WF Model:            ADM_SARADAP Application_Complete
     *                        WF Event:            CC_ADM_APPL_CMPLT
     *                        WF Process:          ADM Application Complete
     *
     *  DEPENDENCIES:
     *               WFOBJECTS.PKG_WFADM_APPLICANT -   Calls the P_GET_WFNAME_WRKCRD procedure
     *                                                 to get the WF Specific Name
     *
     *               WRKCRD.CC_WRKCRD_APPL -           Inserts a new record into the main
     *                                                 Workcard if one is missing
     *
     *               GENERAL.GTVEQNM -                 WF Event Table
     *               BANINST1.GOKPARM / GOKSYST / GOKEVNT - Standard Events needed to update WF
     *
     *  ---
     *  REVISIONS:
     *
     */

  PROCEDURE p_process_completed_apps;

END CC_WRKCRD_START_WORKFLOWS;

/