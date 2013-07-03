CREATE OR REPLACE FORCE VIEW "WRKCRD"."CC_WRKCRD_CONTACT_TYPE_CODE_VW" ("TYPE", "CODE", "STVCTYP_DESC")
AS
  SELECT type ,
    code ,
    stvctyp_desc
  FROM wrkcrd.cc_wrkcrd_contact_type_code ,
    saturn.stvctyp
  WHERE code = stvctyp_code;
  
/