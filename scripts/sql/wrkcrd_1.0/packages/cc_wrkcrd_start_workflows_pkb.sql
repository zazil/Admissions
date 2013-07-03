create or replace
PACKAGE BODY        CC_WRKCRD_START_WORKFLOWS
AS

  c_package   VARCHAR(50) := 'CC_WRKCRD_START_WORKFLOWS'; 
  c_version   VARCHAR(10) := '1.0';

  PROCEDURE p_process_completed_apps IS
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

      /* Standard WF Engine Parameters */
      v_params        gokparm.t_parameterlist;
      v_event_code    gtveqnm.gtveqnm_code%TYPE;

      /* This MUST match the event name in GTVEQNM!!! */
      v_event_name    gtveqnm.gtveqnm_code%TYPE := 'CC_ADM_APPL_CMPLT';

      v_pidm          saradap.saradap_pidm%TYPE;
      v_term          saradap.saradap_term_code_entry%TYPE;
      v_admt          saradap.saradap_admt_code%TYPE;
      v_no            saradap.saradap_appl_no%TYPE;

      v_id            spriden.spriden_id%TYPE;
      v_first         spriden.spriden_first_name%TYPE;
      v_last          spriden.spriden_last_name%TYPE;

      v_wf_name       VARCHAR2(500)   := '';

      v_counter       NUMBER          := 0;          -- counter for records processed
      v_err_cntr      NUMBER          := 0;          -- counter for records skipped

      v_appl_chk      NUMBER          := 0;          -- check to see if appl exists in wrkcrd table
      
      g_log           utl_file.file_type;
      v_addr          VARCHAR2(100)   := '';

      /* cursor to fetch records from saradap input table
          that are not already processed (wrkcrd.cc_tmp_trg_replacement)
          and whose admit type and term are active */
      CURSOR  cur_saradapFetch
      IS
         SELECT saradap_pidm
                    ,saradap_term_code_entry
                    ,saradap_admt_code
                    ,saradap_appl_no
                    ,saradap_apst_code
         FROM   saturn.saradap
         WHERE UPPER(saradap_apst_code) = 'C'
         AND      saradap_pidm NOT IN
                    (SELECT cc_wrkcrd_wf_proc.pidm
                     FROM    wrkcrd.cc_wrkcrd_wf_proc
                    )
        AND SYSDATE >= (SELECT  start_date
                        FROM    wrkcrd.cc_wrkcrd_term_admt_defs
                        WHERE   term = saradap_term_code_entry
                        AND     admt = saradap_admt_code)
        AND SYSDATE <= (SELECT  end_date
                        FROM    wrkcrd.cc_wrkcrd_term_admt_defs
                        WHERE   term = saradap_term_code_entry
                        AND     admt = saradap_admt_code);

    BEGIN

      --Open the log
      g_log := cc_util.open_log_for_append( c_package );

      --Rerieve the email address that we will send the log info and errors to
      SELECT es_email INTO v_addr FROM wrkcrd.cc_wrkcrd_settings;
      
      --If the address is null or blank use ES@CONNCOLL.EDU
      IF v_addr IS NULL OR v_addr = '' THEN
        v_addr := 'brian.riley@conncoll.edu';
      END IF;

      FOR rec_saradapFetch IN cur_saradapFetch
      LOOP
        EXIT WHEN cur_saradapFetch%NOTFOUND;

        v_appl_chk := 0;

        v_pidm     :=  rec_saradapFetch.saradap_pidm;
        v_term     :=  rec_saradapFetch.saradap_term_code_entry;
        v_admt     :=  rec_saradapFetch.saradap_admt_code;
        v_no       :=  rec_saradapFetch.saradap_appl_no;

        BEGIN
          --Get the applicant's Spriden info for logging purposes
          SELECT  spriden_id, spriden_first_name, spriden_last_name
          INTO    v_id, v_first, v_last
          FROM    saturn.spriden
          WHERE   spriden_pidm = v_pidm
          AND			spriden_change_ind IS NULL;
        
          --First verify that the application is in the workcard table
          SELECT  count(*)
          INTO    v_appl_chk
          FROM    wrkcrd.cc_wrkcrd_appl
          WHERE   pidm    = v_pidm
          AND     term    = v_term
          AND     appl_no = v_no;
          
          IF v_appl_chk <= 0 THEN
            --It isn't there so add the record
            INSERT INTO cc_wrkcrd_appl (pidm, term, admit_code, 
                                        appl_no, stage, created_by, 
                                        created_on, reads_completed, 
                                        true_size, percent_coll_bound)
            VALUES (v_pidm, v_term, v_admt, v_no, 
                    'BEGIN', 308395, sysdate, 0, 0, 0);
            
            --Commit it immediately because the WF name relies on this!
            COMMIT;
                        
          ELSE
            --See if the Admit Code is correct if not, update it!
            SELECT  count(*)
            INTO    v_appl_chk
            FROM    wrkcrd.cc_wrkcrd_appl
            WHERE   pidm        = v_pidm
            AND     term        = v_term
            AND     admit_code  = v_admt
            AND     appl_no     = v_no;
          
            IF v_appl_chk <= 0 THEN
              UPDATE  wrkcrd.cc_wrkcrd_appl
              SET     admit_code  = v_admt
              WHERE   pidm        = v_pidm
              AND     term        = v_term
              AND     appl_no     = v_no;
            
              --Commit it immediately because the WF name relies on this!  
              COMMIT;
            END IF;
          END IF;
                      
          --Create the applicant's PIN (will be skipped if they already have one)
          connman.cc_pins.create_applicant_pin( v_pidm );
  
          --Get the params that will be used to build the WF Specific name
          wfobjects.pkg_wfadm_applicant.p_get_wfname_wrkcrd( v_pidm, v_term, v_no, v_wf_name );
  
          --If the WF Specific name was not returned by the function just us the Pidm, Term, Admt, and Appl #
          IF v_wf_name = '' THEN
              v_wf_name := v_term || ' ' || v_admt || ' ' || v_no || ' ' || v_pidm;
          END IF;
  
          /* If Workflow is enabled */
          IF goksyst.f_isSystemLinkEnabled( 'WORKFLOW' ) THEN

            v_event_code := substr( gokevnt.f_checkevent( 'WORKFLOW', v_event_name ), 1, 20 );

            /* If the WF Event exists we can proceed */
            IF v_event_code != 'NULL' THEN

                /* The first 3 parameters MUST be in this order for WF!!! */
                v_params(1).param_value := v_event_name;
                v_params(2).param_value := 'Banner';
                v_params(3).param_value := v_wf_name;
                v_params(4).param_value := v_pidm;
                v_params(5).param_value := v_term;
                v_params(6).param_value := v_admt;
                v_params(7).param_value := v_no;

              gokparm.send_param_list( v_event_code, v_params );
            END IF;
          END IF;

          /* Insert the record into the processed apps table so it doesn't get 
             picked up again by accident! */
          INSERT INTO  wrkcrd.cc_wrkcrd_wf_proc (pidm, proc_date)
          VALUES (v_pidm, SYSDATE);

          COMMIT;
          
        EXCEPTION
          WHEN OTHERS THEN
            ROLLBACK;
            
            DBMS_OUTPUT.put_line ('EXCEPTION: Unable to kick off Workflow. SQLERRM: '|| SQLERRM);
            DBMS_OUTPUT.put_line ('SQLCODE: '|| SQLCODE);
            DBMS_OUTPUT.put_line ('Current PIDM: '|| TO_CHAR(v_pidm));            
            DBMS_OUTPUT.put_line ('Current Banner ID: '|| v_id);
            DBMS_OUTPUT.put_line ('Current Name: '|| v_last || ', ' || v_first);
            DBMS_OUTPUT.put_line ('Skipping applicant and continuing onto the next ...');
            
            cc_util.quick_exception_log( g_log, c_package, c_version,
                              'p_process_completed_apps',
                              'Failure trying  to start worflow for: pidm-' || v_pidm ||
                              ', bannerId-' || v_id || ', name-' || v_last || ', ' || v_first);
                              
            v_err_cntr := v_err_cntr + 1;
        END;
                   
        /* initialize fields to reprocess new records... */
        v_pidm        :=  NULL;
        v_term        :=  NULL;
        v_admt        :=  NULL;
        v_no          :=  NULL;
        v_wf_name     :=  NULL;

        v_counter := v_counter +1;
      END LOOP;

      DBMS_OUTPUT.put_line ('Process complete');
      DBMS_OUTPUT.put_line ('Records processed: '|| v_counter);

      cc_util.quick_log(g_log, c_package, c_version, 'p_process_completed_apps',
                    'Process complete!   Workflows started: ' || v_counter ||
                    '    Unable to start (see errors above): ' || v_err_cntr);
      
      utl_file.fclose( g_log );
      
      cc_util.email(c_package, v_addr, 'admissions@conncoll.edu', 
                      'PROCESS COMPLETE: p_process_completed_apps',
                      'The process that kicks off Workflows for completed applications has' ||
                      ' completed successfully.' || chr(13) || chr(10) ||
                      '        Workflows started: ' || v_counter || chr(13) || chr(10) ||
                      '        Unable to start: ' || v_err_cntr || chr(13) || chr(10) ||
                      chr(13) || chr(10) || chr(13) || chr(10) ||
                      'See the log file in /SCT/banjobs/[INSTANCE]/ for further details');  


    EXCEPTION
      WHEN OTHERS THEN
        ROLLBACK;
        
        DBMS_OUTPUT.put_line ('FATAL EXCEPTION RAISED: Unable to finish kicking off Workflows. SQLERRM: '|| SQLERRM);
        DBMS_OUTPUT.put_line ('SQLCODE: '|| SQLCODE);
        DBMS_OUTPUT.put_line ('Current PIDM: '|| v_pidm);
        DBMS_OUTPUT.put_line ('Current Banner ID: '|| v_id);
        DBMS_OUTPUT.put_line ('Current Name: '|| v_last || ', ' || v_first);
        DBMS_OUTPUT.put_line ('Process aborted');
        DBMS_OUTPUT.put_line ('Records already processed before error: '|| v_counter);
        
        cc_util.quick_exception_log( g_log, c_package, c_version,
                              'p_process_completed_apps',
                              'Failure trying  to start worflow for: pidm-' || v_pidm ||
                              ', bannerId-' || v_id || ', name-' || v_last || ', ' || v_first);

        utl_file.fclose( g_log );
        
        cc_util.email(c_package, v_addr, 'admissions@conncoll.edu', 
                      'FATAL ERROR: CC_WRKCRD_WF_PROC.P_PROCESS_COMPLETED_APPS',
                      'A fatal exception, ' || SQLCODE || ' : ' || SQLERRM || ', has occured.' ||
                      chr(13) || chr(10) || chr(13) || chr(10) ||
                      'See the log file in /SCT/banjobs/[INSTANCE]/ for further details');

    END p_process_completed_apps;

END CC_WRKCRD_START_WORKFLOWS;

/