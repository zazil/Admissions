create or replace
PACKAGE BODY          "CC_WRKCRD_EMAIL_PKG" AS

  /*
   * Procedures used by Workflow to interact with cc_wrkcrd_email table
   *
   * TODO: Move this procedure to WFOBJECTS, provide necessary roles,
   *       update Workflow to reflect changed schema
   */

  PROCEDURE UPDATE_SENT_ON(
    p_id        NUMBER
  ) AS
  BEGIN
    UPDATE  cc_wrkcrd_email
    SET     sent_on = SYSDATE
    WHERE   appl_id = p_id
    AND     sent_on IS NULL
    AND     id = (SELECT  MAX(em.id)
                  FROM    cc_wrkcrd_email em
                  WHERE   em.appl_id = p_id
                  AND     em.sent_on IS NULL);
  END UPDATE_SENT_ON;


  PROCEDURE GET_CURRENT(
    p_id        NUMBER,
    p_subject   OUT VARCHAR2,
    p_message   OUT VARCHAR2,
    p_sender    OUT VARCHAR2,
    p_recipient OUT VARCHAR2
  ) AS
    v_missing VARCHAR2(200) := '';
  BEGIN
    SELECT  (SELECT  email_alternate
             FROM    cc_wrkcrd_settings)
            , CASE WHEN per.goremal_email_address IS NOT NULL THEN
                per.goremal_email_address
              ELSE
                (SELECT email_alternate FROM wrkcrd.cc_wrkcrd_settings)
              END recipient
            , em.subject
            , em.message
    INTO    p_sender
            , p_recipient
            , p_subject
            , p_message
    FROM    wrkcrd.cc_wrkcrd_appl app
            , wrkcrd.cc_wrkcrd_email em
            , wrkcrd.cc_wrkcrd_person_vw per
    WHERE   app.id = em.appl_id
    AND     app.pidm = per.spriden_pidm
    AND     app.id = p_id
    AND     em.id = (SELECT MAX(id)
                     FROM   wrkcrd.cc_wrkcrd_email
                     WHERE  appl_id = app.id
                     AND    sent_on IS NULL);

    --Check for NULLs because it will break Workflow!
    IF p_subject IS NULL OR p_subject = '' THEN
      v_missing := 'subject, ';
      p_subject := '';
    END IF;
    IF p_message IS NULL OR p_message = '' THEN
      v_missing := 'message, ';
      p_message := '';
    END IF;
    IF p_sender IS NULL OR p_sender = '' THEN
      v_missing := 'sender, ';
      p_sender := '';
    END IF;
    IF p_recipient IS NULL OR p_recipient = '' THEN
      v_missing := 'recipient, ';
      p_recipient := '';
    END IF;

    --If any values were NULL or empty send the message to the admin email!
    IF v_missing != '' THEN
      SELECT  email_alternate, email_alternate
      INTO    p_sender, p_recipient
      FROM    cc_wrkcrd_settings;

      p_subject := 'ADM Workflow - Missing ' || v_missing;
      p_message := 'sender - ' || p_sender || CHR(13) || CHR(10) ||
                   'recipient - ' || p_recipient || CHR(13) || CHR(10) ||
                   'subject - ' || p_subject || CHR(13) || CHR(10) ||
                   'body - ' || p_message;
    END IF;

  END GET_CURRENT;

END CC_WRKCRD_EMAIL_PKG;

/