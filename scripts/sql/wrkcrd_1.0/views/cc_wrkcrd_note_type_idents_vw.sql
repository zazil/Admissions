CREATE OR REPLACE FORCE VIEW "WRKCRD"."CC_WRKCRD_NOTE_TYPE_IDENTS_VW" ("TYPE_ID", "IDENTIFIER_ID")
AS
  SELECT note.id type_id,
    ident.id identifier_id
  FROM wrkcrd.cc_wrkcrd_note_type note ,
    wrkcrd.cc_wrkcrd_note_identifier ident
  WHERE note.id = ident.type;
  
/