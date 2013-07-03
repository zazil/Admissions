CREATE OR REPLACE FORCE VIEW "WRKCRD"."CC_WRKCRD_LEGACY_TYPE_VW" ("STVRELT_CODE", "STVRELT_DESC")
AS
  SELECT stvrelt_code,
    stvrelt_desc
  FROM saturn.stvrelt
  WHERE stvrelt_code IN
    (SELECT code FROM wrkcrd.cc_wrkcrd_legacy_type
    );
    
/