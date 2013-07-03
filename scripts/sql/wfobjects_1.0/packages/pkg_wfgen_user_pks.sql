create or replace
PACKAGE           PKG_WFGEN_USER AS

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
  );

    /* Retrieves the number of email addresses for the pidm and type specified */
  PROCEDURE P_GET_EMAIL_COUNT(
    p_pidm                NUMBER,
    p_emal_code           VARCHAR2,
    p_email_addr_cnt  OUT NUMBER
  );
    
    /* 
   * Retrieves the email address for the specified PIDM if the DB instance is CONN
     * otherwise it returns the specified alternate email (or aisteam@conncoll.edu if 
     * none was provided!) 
   */
    PROCEDURE P_GET_EMAIL(
    p_pidm                    NUMBER,
    p_emal_code               VARCHAR2,
    p_alternate_email         VARCHAR2 := '',
    p_address           OUT   VARCHAR2
  );
  
END PKG_WFGEN_USER; 

/