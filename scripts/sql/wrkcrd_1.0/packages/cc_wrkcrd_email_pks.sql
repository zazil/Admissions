create or replace
PACKAGE          "CC_WRKCRD_EMAIL_PKG" AS

  /*
   * Procedures used by Workflow to interact with cc_wrkcrd_email table
   *
   * TODO: Move these procedures to WFOBJECTS.PKG_WFADM_APPLICANT,
   * 	   provide necessary roles, update Workflow to reflect changed schema
   */

  PROCEDURE UPDATE_SENT_ON(
    p_id        NUMBER
  );

  PROCEDURE GET_CURRENT(
    p_id        NUMBER,
    p_subject   OUT VARCHAR2,
    p_message   OUT VARCHAR2,
    p_sender    OUT VARCHAR2,
    p_recipient OUT VARCHAR2
  );

END CC_WRKCRD_EMAIL_PKG;

/