create or replace
PACKAGE        CC_WRKCRD_BANNER_API_PKG AS

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

  -- ---------------------------------------------------------

  PROCEDURE P_PREFERRED_NAME_SAVE(
    p_pidm              NUMBER,
    p_pref_first_name   VARCHAR2,
    p_result        OUT VARCHAR2
  );

  -- ---------------------------------------------------------

  PROCEDURE P_EMAIL_SAVE(
    p_pidm              NUMBER,
    p_emal_code         VARCHAR2,
    p_email_address     VARCHAR2,
    p_result        OUT VARCHAR2
  );

  PROCEDURE P_EMAIL_DELETE(
    p_pidm              NUMBER,
    p_emal_code         VARCHAR2,
    p_result        OUT VARCHAR2
  );

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
  );

  PROCEDURE P_ADDRESS_DELETE(
    p_pidm              NUMBER,
    p_atyp_code         VARCHAR2,
    p_result        OUT VARCHAR2
  );

  -- ---------------------------------------------------------

  PROCEDURE P_TELEPHONE_SAVE(
    p_pidm              NUMBER,
    p_tele_code         VARCHAR2,
    p_phone_area        VARCHAR2,
    p_phone_number      VARCHAR2,
    p_phone_ext         VARCHAR2,
    p_sprtele_intl_access VARCHAR2,
    p_result        OUT VARCHAR2
  );

  PROCEDURE P_TELEPHONE_DELETE(
    p_pidm              NUMBER,
    p_tele_code         VARCHAR2,
    p_result        OUT VARCHAR2
  );

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
  );

  PROCEDURE P_LEGACY_DELETE(
    p_pidm              NUMBER,
    p_relt_code         VARCHAR2,
    p_atyp_code         VARCHAR2,
    p_parent_last       VARCHAR2,
    p_parent_first      VARCHAR2,
    p_result        OUT VARCHAR2
  );

  -- ---------------------------------------------------------

  PROCEDURE P_ATTRIBUTE_SAVE(
    p_pidm              NUMBER,
    p_term              VARCHAR2,
    p_appl_no           NUMBER,
    p_atts_code         VARCHAR2,
    p_result        OUT VARCHAR2
  );

  PROCEDURE P_ATTRIBUTE_DELETE(
    p_pidm              NUMBER,
    p_term              VARCHAR2,
    p_appl_no           NUMBER,
    p_atts_code         VARCHAR2,
    p_result        OUT VARCHAR2
  );

  -- ---------------------------------------------------------

  PROCEDURE P_INTERVIEW_SAVE(
    p_pidm              NUMBER,
    p_contact_date      DATE,
    p_ctyp_code         VARCHAR2,
    p_contact_from_time NUMBER,
    p_rslt_code         VARCHAR2,
    p_recr_code         VARCHAR2,
    p_result        OUT VARCHAR2
  );

  PROCEDURE P_INTERVIEW_DELETE(
    p_pidm              NUMBER,
    p_contact_date      DATE,
    p_ctyp_code         VARCHAR2,
    p_recr_code         VARCHAR2,
    p_result        OUT VARCHAR2
  );

  -- ---------------------------------------------------------

  PROCEDURE P_CONTACT_SAVE(
    p_pidm              NUMBER,
    p_ctyp_code         VARCHAR2,
    p_contact_date      DATE,
    p_result        OUT VARCHAR2
  );

  PROCEDURE P_CONTACT_DELETE(
    p_pidm              NUMBER,
    p_ctyp_code         VARCHAR2,
    p_result        OUT VARCHAR2
  );

  -- ---------------------------------------------------------

  PROCEDURE P_DECISION_INSERT(
    p_appl_id           NUMBER,
    p_apdc_code         VARCHAR2,
    p_rater             VARCHAR2,
    p_ret           OUT VARCHAR2
  );

END CC_WRKCRD_BANNER_API_PKG;

/