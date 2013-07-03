CREATE OR REPLACE FORCE VIEW "WRKCRD"."CC_WRKCRD_BAN_ROLE_VW" ("ID", "VERSION", "AUTHORITY")
AS
  SELECT --*******************************************************************************
    --                               Connecticut College
    --                       Copyright 2011 Connecticut College
    -- ================================================================================
    --   NAME:         wrkcrd.cc_wrkcrd_ban_role_vw
    --   AUTHOR:     David F. Fontaine (dffon), Brian Riley (briley)
    --   VERSION:    8.0
    --   PURPOSE:   This view will pull a Workflow role's ID and name.
    --                     It is used by the Grails processing for the Admissions Workcard process.
    --
    --               CONN database - in schema WRKCRD.
    --               File location -      <Lily/Rose>/$BANNER_HOME/connmods/student/dbprocs/
    --               View Documentation:
    --                        \\Tamarack\Department_Shares\AIS\Technical\CC Development\Student\Admissions\Workcard\--                        xxx_SOLUTION_DOCUMENT.doc.
    --
    --   DEPENDENCIES:
    --                None.
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
    --                     > WORKFLOW.ROLE - Banner WorkFlow table with all WorkFlow roles and the role ID.
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
    --      Version:        1.1
    --      Date:           11/4/2011
    --      Author:         briley
    --      Description:    Added REPLACE on authority to switch spaces to underscores
    --                      and swap out CC and WF and replace them with 'ROLE" in name
    --                      to get spring-security-core to work
    --
    --*******************************************************************************/
    role.id ,
    0 version , -- version field. hardcoded
    'ROLE_'
    || RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(UPPER(role.name), ' ', '_'), 'WF_', ''), 'CC_', ''), '__', '_'), '_') authority -- authority field
  FROM workflow.role
  ORDER BY role.name ASC;
  
/