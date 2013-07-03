CREATE OR REPLACE FORCE VIEW "WRKCRD"."CC_WRKCRD_NOTES_VW" ("APPL_ID", "PIDM", "TERM", "ADMIT_CODE", "APPL_NO", "ID", "TYPE", "IDENTIFIER", "IDENTIFIER_DESC", "CONTENT", "CREATED_BY", "CREATED_DATE", "UPDATE_BY", "UPDATE_DATE")
AS
  SELECT appl.id appl_id,
    appl.pidm ,
    appl.term ,
    appl.admit_code ,
    appl.appl_no ,
    note.id ,
    note.type ,
    note.identifier ,
    (SELECT description
    FROM wrkcrd.cc_wrkcrd_note_identifier
    WHERE id = note.identifier
    ) identifier_desc ,
    note.content ,
    CASE
      WHEN note.created_by = 'AXIOM'
      THEN
        (SELECT pidm FROM wrkcrd.cc_wrkcrd_ban_user_vw WHERE username = 'axiom'
        )
      ELSE
        (SELECT pidm FROM wrkcrd.cc_wrkcrd_ban_user_vw WHERE pidm = note.created_by
        )
    END created_by ,
    note.created_date ,
    CASE
      WHEN note.update_by = 'AXIOM'
      THEN
        (SELECT pidm FROM wrkcrd.cc_wrkcrd_ban_user_vw WHERE username = 'axiom'
        )
      ELSE
        (SELECT pidm FROM wrkcrd.cc_wrkcrd_ban_user_vw WHERE pidm = note.update_by
        )
    END update_by ,
    note.update_date
  FROM wrkcrd.cc_wrkcrd_appl appl ,
    wrkcrd.cc_wrkcrd_notes note
  WHERE appl.id      = note.appl_id
  AND note.type NOT IN ('LANG', 'ACT', 'CRSE')
  UNION ALL
  SELECT appl.id appl_id,
    appl.pidm ,
    appl.term ,
    appl.admit_code ,
    appl.appl_no ,
    note.id ,
    note.type ,
    REPLACE(REPLACE(REPLACE(note.identifier, 'W,', ''), 'R,', ''), 'S,', '') identifier ,
    (SELECT description
    FROM wrkcrd.cc_wrkcrd_note_identifier
    WHERE id = note.identifier
    ) identifier_desc ,
    note.content ,
    CASE
      WHEN note.created_by = 'AXIOM'
      THEN
        (SELECT pidm FROM wrkcrd.cc_wrkcrd_ban_user_vw WHERE username = 'axiom'
        )
      ELSE
        (SELECT pidm FROM wrkcrd.cc_wrkcrd_ban_user_vw WHERE pidm = note.created_by
        )
    END created_by ,
    note.created_date ,
    CASE
      WHEN note.update_by = 'AXIOM'
      THEN
        (SELECT pidm FROM wrkcrd.cc_wrkcrd_ban_user_vw WHERE username = 'axiom'
        )
      ELSE
        (SELECT pidm FROM wrkcrd.cc_wrkcrd_ban_user_vw WHERE pidm = note.update_by
        )
    END update_by ,
    note.update_date
  FROM wrkcrd.cc_wrkcrd_appl appl ,
    wrkcrd.cc_wrkcrd_notes note
  WHERE appl.id = note.appl_id
  AND note.type = 'LANG'
  UNION ALL
  SELECT appl.id appl_id,
    appl.pidm ,
    appl.term ,
    appl.admit_code ,
    appl.appl_no ,
    note.id ,
    note.type ,
    REPLACE(REPLACE(REPLACE(note.identifier, 'W,', ''), 'R,', ''), 'S,', '') identifier ,
    (SELECT description
    FROM wrkcrd.cc_wrkcrd_note_identifier
    WHERE id = note.identifier
    ) identifier_desc ,
    note.content ,
    CASE
      WHEN note.created_by = 'AXIOM'
      THEN
        (SELECT pidm FROM wrkcrd.cc_wrkcrd_ban_user_vw WHERE username = 'axiom'
        )
      ELSE
        (SELECT pidm FROM wrkcrd.cc_wrkcrd_ban_user_vw WHERE pidm = note.created_by
        )
    END created_by ,
    note.created_date ,
    CASE
      WHEN note.update_by = 'AXIOM'
      THEN
        (SELECT pidm FROM wrkcrd.cc_wrkcrd_ban_user_vw WHERE username = 'axiom'
        )
      ELSE
        (SELECT pidm FROM wrkcrd.cc_wrkcrd_ban_user_vw WHERE pidm = note.update_by
        )
    END update_by ,
    note.update_date
  FROM wrkcrd.cc_wrkcrd_appl appl ,
    wrkcrd.cc_wrkcrd_notes note
  WHERE appl.id        = note.appl_id
  AND note.identifier IN
    (SELECT id FROM cc_wrkcrd_note_identifier
    )
  AND note.type = 'ACT'
  UNION ALL
  SELECT appl.id appl_id,
    appl.pidm ,
    appl.term ,
    appl.admit_code ,
    appl.appl_no ,
    note.id ,
    note.type ,
    REPLACE(REPLACE(REPLACE(note.identifier, 'W,', ''), 'R,', ''), 'S,', '') identifier ,
    (SELECT description
    FROM wrkcrd.cc_wrkcrd_note_identifier
    WHERE id = note.identifier
    ) identifier_desc ,
    note.content ,
    CASE
      WHEN note.created_by = 'AXIOM'
      THEN
        (SELECT pidm FROM wrkcrd.cc_wrkcrd_ban_user_vw WHERE username = 'axiom'
        )
      ELSE
        (SELECT pidm FROM wrkcrd.cc_wrkcrd_ban_user_vw WHERE pidm = note.created_by
        )
    END created_by ,
    note.created_date ,
    CASE
      WHEN note.update_by = 'AXIOM'
      THEN
        (SELECT pidm FROM wrkcrd.cc_wrkcrd_ban_user_vw WHERE username = 'axiom'
        )
      ELSE
        (SELECT pidm FROM wrkcrd.cc_wrkcrd_ban_user_vw WHERE pidm = note.update_by
        )
    END update_by ,
    note.update_date
  FROM wrkcrd.cc_wrkcrd_appl appl ,
    wrkcrd.cc_wrkcrd_notes note
  WHERE appl.id     = note.appl_id
  AND note.content IS NOT NULL
  AND note.type     = 'CRSE';
  
/