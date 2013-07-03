DECLARE
    v_lob CLOB;
    v_message VARCHAR2(5000);
BEGIN
	
	CREATE TABLE "WRKCRD"."CC_WRKCRD_SETTINGS"
	  (
	    "INSTANCE"              VARCHAR2(10 BYTE) NOT NULL ENABLE,
	    "EMAIL_ALTERNATE"       VARCHAR2(500 BYTE) NOT NULL ENABLE,
	    "WORKFLOW_WSDL"         VARCHAR2(500 BYTE) NOT NULL ENABLE,
	    "WORKFLOW_WS_USER"      VARCHAR2(20 BYTE) NOT NULL ENABLE,
	    "WORKFLOW_WS_PWD"       VARCHAR2(20 BYTE) NOT NULL ENABLE,
	    "INCOM_DFLT_EMAIL_SUBJ" VARCHAR2(200 BYTE),
	    "INCOM_DFLT_EMAIL_MSG" CLOB,
	    "LOGGING_ON"     NUMBER DEFAULT 0,
	    "LOGGING_ENTITY" VARCHAR2(30 BYTE),
	    "VALID_YEAR_MIN" NUMBER,
	    "VALID_YEAR_MAX" NUMBER,
	    "ES_EMAIL"       VARCHAR2(100 CHAR),
	    "WRKCRD_URL"     VARCHAR2(500 CHAR)
	  )
	  SEGMENT CREATION IMMEDIATE PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING STORAGE
	  (
	    INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645 PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT
	  )
	  TABLESPACE "CC_DEVELOPMENT" LOB
	  (
	    "INCOM_DFLT_EMAIL_MSG"
	  )
	  STORE AS BASICFILE "SYS_LOB0000227889C00010$$"
	  (
	    TABLESPACE "CC_DEVELOPMENT" ENABLE STORAGE IN ROW CHUNK 8192 PCTVERSION 10 NOCACHE LOGGING STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645 PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
	  ) ;
  
 
    /* Set the system default settings */
    INSERT INTO "WRKCRD"."CC_WRKCRD_SETTINGS" (INSTANCE, EMAIL_ALTERNATE, WORKFLOW_WSDL, WORKFLOW_WS_USER, WORKFLOW_WS_PWD,
                           INCOM_DFLT_EMAIL_SUBJ, INCOM_DFLT_EMAIL_MSG, LOGGING_ON, LOGGING_ENTITY, VALID_YEAR_MIN,
                           VALID_YEAR_MAX, ES_EMAIL, WRKCRD_URL)
        VALUES ('DEV', 'admission@conncoll.edu', 
            'http://http://testinb.conncoll.edu:7787//wfdev/ws/services/WorkflowWS/v1_1',
            'wfwebservices', 'password', 'Application to Connecticut College - missing materials',
            EMPTY_CLOB(), 0, 'ALL', '2006', '2012', 'adm.workflow@conncoll.edu', 
            'http://localhost:8080/Admissions/application/wrkcrd');
    COMMIT;


    v_message := 'Dear [First], ' || chr(13) || chr(10) ||
                  chr(13) || chr(10) ||
                  'In the process of reviewing your application, we noticed that the materials noted below are still missing from your file:' || chr(13) || chr(10) ||
                  chr(13) || chr(10) ||
                  'Common Application {please submit electronically via www.commonapp.org}' || chr(13) || chr(10) ||
                  'Supplement to the Common Application {please submit electronically via www.commonapp.org}' || chr(13) || chr(10) ||
                  'Secondary School Report' || chr(13) || chr(10) ||
                  'Counselor Recommendation' || chr(13) || chr(10) ||
                  'High School Transcript' || chr(13) || chr(10) ||
                  'Senior Year Grades' || chr(13) || chr(10) ||
                  '1 Teacher Recommendation' || chr(13) || chr(10) ||
                  '2 Teacher Recommendations' || chr(13) || chr(10) ||
                  'SAT Critical Reading Scores' || chr(13) || chr(10) ||
                  '2 SAT Subject Tests' || chr(13) || chr(10) ||
                  '1 SAT Subject Test' || chr(13) || chr(10) ||
                  'ACT' || chr(13) || chr(10) ||
                  'TOEFL or IELTS Score' || chr(13) || chr(10) ||
                  'Certification of Finances' || chr(13) || chr(10) ||
                  'Early Decision Agreement with appropriate signatures' || chr(13) || chr(10) ||
                  chr(13) || chr(10) ||
                  'Please have these material(s) sent to our office as soon as possible via your Common Application online account, or by fax (860-439-4301), e-mail (admission@conncoll.edu) or postal mail. If you do not intend to complete your application and wish to withdraw from consideration, please e-mail us to let us know.' || chr(13) || chr(10) ||
                  chr(13) || chr(10) ||
                  'Sincerely,' || chr(13) || chr(10) ||
                  chr(13) || chr(10) ||
                  'Martha C. Merrill ''84' || chr(13) || chr(10) ||
                  'Dean of Admission ' || '&' || ' Financial Aid';

      SELECT incom_dflt_email_msg 
      INTO    v_lob 
      FROM    wrkcrd.cc_wrkcrd_settings
      FOR UPDATE;
  
      --Write the message to the CLOB
      dbms_lob.open( v_lob, dbms_lob.LOB_READWRITE );
      dbms_lob.writeappend( v_lob, length(v_message), v_message ); 
      dbms_lob.close( v_lob );
    COMMIT;
END;
/