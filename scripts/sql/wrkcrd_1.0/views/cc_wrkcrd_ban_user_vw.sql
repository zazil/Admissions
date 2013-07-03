CREATE OR REPLACE FORCE VIEW "WRKCRD"."CC_WRKCRD_BAN_USER_VW" ("PIDM", "USERNAME", "PASSWORD", "ACCOUNT_EXPIRED", "ACCOUNT_LOCKED", "ENABLED", "PASSWORD_EXPIRED", "ID", "VERSION")
AS
  SELECT --*******************************************************************************
    --                               Connecticut College
    --                       Copyright 2011 Connecticut College
    -- ================================================================================
    --   NAME:         wrkcrd.cc_wrkcrd_ban_user_vw
    --   AUTHOR:     David F. Fontaine (dffon), Brian Riley (briley)
    --   VERSION:    8.0
    --   PURPOSE:   This view will pull a user's Banner account status, Workflow user ID, and PIDM. Only Banner users with
    --                     an open or expired account will be fetched.
    --                     It is used by the Grails processing for the Admissions Workcard process.
    --
    --               CONN database - in schema WRKCRD.
    --               File location -      <Lily/Rose>/$BANNER_HOME/connmods/student/dbprocs/
    --               View Documentation:
    --                        \\Tamarack\Department_Shares\AIS\Technical\CC Development\Student\Admissions\Workcard\--                        xxx_SOLUTION_DOCUMENT.doc.
    --
    --   DEPENDENCIES:
    --                View assumes Banner security will be maintained in the table BANSECR.CC_DBA_USERS.
    --
    --                View developed using:
    --                    > Language: SQL, PL/SQL
    --                    > Database: Oracle v. 11g
    --                    > Banner Student v. 8.5
    --                    > Banner Workflow
    --
    --   UPDATES COMPLETED:
    --                     > none.
    --
    --   TABLES USED:
    --                     > BANSECR.CC_DBA_USERS - Banner security view of Oracle user accounts. fetch username.
    --                     > GENERAL.GOBTPAC - Banner third party access table - fetch PIDM of user.
    --                     > WORKFLOW.WFUSER - Banner WorkFlow table with all WorkFlow users. fetch Workflow user ID.
    --
    --   ERROR REPORTING AND OUTPUT:
    --                      > none.
    --
    --   EXCEPTIONS:
    --                      > none.
    --   REVISIONS:
    --      Version:       1.0
    --      Date:          10/26/2011
    --      Author:        David F. Fontaine, Brian Riley
    --      Description: Initial version.
    --
    --*******************************************************************************/
    gobtpac_pidm pidm,
    LOWER(cc_dba_users.username) username ,
    ' ' password , -- password field. hardcoded
    DECODE(cc_dba_users.account_status ,'EXPIRED', 1 ,'EXPIRED '
    ||'&'
    ||' LOCKED', 1 ,'EXPIRED(GRACE)', 1 ,'EXPIRED '
    ||'&'
    ||' LOCKED(TIMED)', 1 ,0) account_expired ,
    DECODE(cc_dba_users.account_status ,'LOCKED', 1 ,'EXPIRED '
    ||'&'
    ||' LOCKED', 1 ,'LOCKED(TIMED)', 1 ,'EXPIRED '
    ||'&'
    ||' LOCKED(TIMED)', 1 ,0) account_locked ,
    DECODE(cc_dba_users.account_status ,'LOCKED', 1 ,'LOCKED(TIMED)', 1 ,'EXPIRED '
    ||'&'
    ||' LOCKED(TIMED)', 1 ,1) enabled ,
    DECODE(cc_dba_users.account_status ,'EXPIRED', 1 ,'EXPIRED '
    ||'&'
    ||' LOCKED', 1 ,'EXPIRED(GRACE)', 1 ,'EXPIRED '
    ||'&'
    ||' LOCKED(TIMED)', 1 ,0) password_expired ,
    wfuser.id -- wfuser.id field
    ,
    0 version -- version field. hardcoded
  FROM bansecr.cc_dba_users ,
    general.gobtpac ,
    workflow.wfuser
  WHERE LOWER(cc_dba_users.username) = gobtpac_external_user (+)
  AND gobtpac_external_user          = wfuser.logon;
  
/