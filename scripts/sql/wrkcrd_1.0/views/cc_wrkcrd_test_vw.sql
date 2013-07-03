CREATE OR REPLACE FORCE VIEW "WRKCRD"."CC_WRKCRD_TEST_VW" ("APPL_ID", "SORTEST_TESC_CODE", "SORTEST_TEST_DATE", "STVTESC_DESC", "SORTEST_TEST_SCORE", "STVTESC_MIN_VALUE", "STVTESC_MAX_VALUE", "VW_TYPE", "STVTESC_DATA_TYPE")
AS
  SELECT DISTINCT id appl_id,
    a.sortest_tesc_code ,
    (SELECT MAX(c.sortest_test_date)
    FROM saturn.sortest c
    WHERE c.sortest_pidm     = a.sortest_pidm
    AND c.sortest_tesc_code  = a.sortest_tesc_code
    AND c.sortest_test_score = a.sortest_test_score
    ) sortest_test_date ,
    stvtesc_desc ,
    a.sortest_test_score ,
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
  FROM saturn.sortest a ,
    saturn.stvtesc ,
    wrkcrd.cc_wrkcrd_appl
  WHERE pidm               = sortest_pidm
  AND a.sortest_tesc_code  = stvtesc_code
  AND a.sortest_tesc_code IN
    (SELECT code FROM wrkcrd.cc_wrkcrd_test_type
    )
  AND a.sortest_test_score =
    (SELECT MAX(b.sortest_test_score)
    FROM saturn.sortest b
    WHERE a.sortest_tesc_code = b.sortest_tesc_code
    AND a.sortest_pidm        = b.sortest_pidm
    );
    
/