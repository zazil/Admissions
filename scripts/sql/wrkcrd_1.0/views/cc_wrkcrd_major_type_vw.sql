CREATE OR REPLACE FORCE VIEW "WRKCRD"."CC_WRKCRD_MAJOR_TYPE_VW" ("STVMAJR_CODE", "STVMAJR_DESC")
AS
  SELECT stvmajr_code,
    stvmajr_desc
  FROM stvmajr
  WHERE stvmajr_valid_major_ind = 'Y';
  
/