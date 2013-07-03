CREATE OR REPLACE FORCE VIEW "WRKCRD"."CC_WRKCRD_CONTACT_VW" ("VW_TYPE", "SORCONT_PIDM", "SORCONT_CTYP_CODE", "STVCTYP_DESC", "SORCONT_CONTACT_DATE")
AS
  SELECT 'FIRST' vw_type ,
    sorcont_pidm ,
    sorcont_ctyp_code ,
    stvctyp_desc ,
    sorcont_contact_date
  FROM saturn.sorcont a ,
    saturn.stvctyp
  WHERE stvctyp_code         = a.sorcont_ctyp_code
  AND a.sorcont_contact_date =
    (SELECT MIN(b.sorcont_contact_date)
    FROM sorcont b
    WHERE a.sorcont_pidm = b.sorcont_pidm
    )
  UNION ALL
  SELECT t.type vw_type ,
    sorcont_pidm ,
    sorcont_ctyp_code ,
    stvctyp_desc ,
    sorcont_contact_date
  FROM saturn.sorcont a ,
    wrkcrd.cc_wrkcrd_contact_type_code t ,
    saturn.stvctyp
  WHERE sorcont_ctyp_code = t.code
  AND stvctyp_code        = sorcont_ctyp_code;
  
/