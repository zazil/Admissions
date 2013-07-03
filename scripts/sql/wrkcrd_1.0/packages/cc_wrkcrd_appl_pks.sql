create or replace
PACKAGE        CC_WRKCRD_APPL_PKG AS

  /*
   * Procedures used by Workflow to interact with WRKCRD tables
   *
   * TODO: Move these procedures to WFOBJECTS.PKG_WFADM_APPLICANT,
   * 	   provide necessary roles, update Workflow to reflect changed schema
   */

  FUNCTION CC_WRKCRD_WF_UPDATE(
      p_appl_id               NUMBER,
      p_next_reader           VARCHAR2 := 'briley',

      p_common_app_id         VARCHAR2,
      p_financial_aid         VARCHAR2,
      p_load_date             DATE,
      p_term                  VARCHAR2,
      p_type                  VARCHAR2,
      p_status                VARCHAR2,
      p_career_interest       VARCHAR2,

      p_school_ceeb           VARCHAR2,
      p_school_name           VARCHAR2,
      p_school_type           VARCHAR2,
      p_school_eps            VARCHAR2,
      p_graduation_date       DATE,

      p_banner_class_size     NUMBER,
      p_optional_class_size   NUMBER,

      p_banner_class_rank     NUMBER,
      p_optional_class_rank   NUMBER,
      p_rank_type             VARCHAR2,
      p_weighted_rank         NUMBER,

      p_banner_gpa            VARCHAR2,
      p_gpa_scale             NUMBER,
      p_highest_gpa           NUMBER,
      p_weighted_gpa          NUMBER,

      p_class_percent_college_bound NUMBER,
      p_class_percentile      NUMBER
  ) RETURN NUMBER;

  PROCEDURE GET_CURRENT_DECISION(
    p_appl_id                 NUMBER,
    p_decision          OUT   VARCHAR2
  );

  PROCEDURE UPDATE_STAGE(
    p_appl_id                 NUMBER,
    p_stage                   VARCHAR2
  );

  PROCEDURE UPDATE_READ_COUNT(
    p_appl_id                 NUMBER
  );

  PROCEDURE GET_APPL_ID(
    p_pidm                    NUMBER,
    p_term_code               VARCHAR2,
    p_admit_code              VARCHAR2,
    p_appl_no                 NUMBER,
    p_appl_id           OUT   NUMBER
  );

  PROCEDURE GET_PIDM_TERM_ADMT_APPL(
    p_appl_id                 NUMBER,
    p_pidm              OUT   NUMBER,
    p_term_code         OUT   VARCHAR2,
    p_admit_code        OUT   VARCHAR2,
    p_appl_no           OUT   NUMBER
  );

  PROCEDURE P_REMOVE_RATINGS(
    p_appl_id                 NUMBER
  );

  PROCEDURE P_ENG_WORKFLOW_NAMECHANGE(
    p_id                IN NUMBER,
    p_prefix            IN VARCHAR2,
    p_name              IN OUT VARCHAR2
  );

END CC_WRKCRD_APPL_PKG;

/