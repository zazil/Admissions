CREATE OR REPLACE FORCE VIEW "WRKCRD"."CC_WRKCRD_TEST_TYPE_VW" ("STVTESC_CODE", "STVTESC_DESC", "STVTESC_MIN_VALUE", "STVTESC_MAX_VALUE", "VW_TYPE", "STVTESC_DATA_TYPE")
AS
  SELECT stvtesc_code ,
    stvtesc_desc ,
    stvtesc_min_value ,
    stvtesc_max_value ,
    CASE
      WHEN stvtesc_code LIKE 'SAT%'
      THEN 'SAT'
      WHEN LENGTH( stvtesc_code ) = 2
      THEN 'SUBJ'
      WHEN stvtesc_code = 'ACT'
      THEN 'COMP'
      WHEN stvtesc_code LIKE 'ACT%'
      AND LENGTH( stvtesc_code ) > 2
      THEN 'ACT'
      WHEN stvtesc_code LIKE 'TFL%'
      OR stvtesc_code LIKE 'IE%'
      THEN 'TFL'
      ELSE 'AP'
    END vw_type ,
    stvtesc_data_type
  FROM saturn.stvtesc,
    wrkcrd.cc_wrkcrd_test_type
  WHERE stvtesc_code = code;
  
/