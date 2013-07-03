CREATE OR REPLACE FORCE VIEW "WRKCRD"."CC_WRKCRD_HS_VW" ("SORHSCH_PIDM", "SORHSCH_SBGI_CODE", "STVSBGI_DESC", "SOBSBGI_NATN_CODE", "STVNATN_NATION", "SOBSBGI_CITY", "SOBSBGI_STAT_CODE", "SORBCHR_BCHR_CODE", "STVBCHR_DESC", "VW_EPSCODE", "SORHSCH_GRADUATION_DATE", "SORHSCH_CLASS_RANK", "SORHSCH_CLASS_SIZE", "SORHSCH_GPA", "SORHSCH_PERCENTILE", "VW_HS_REGION")
AS
  SELECT sorhsch_pidm ,
    sorhsch_sbgi_code ,
    stvsbgi_desc ,
    sobsbgi_natn_code ,
    stvnatn_nation ,
    sobsbgi_city ,
    sobsbgi_stat_code ,
    sorbchr_bchr_code ,
    stvbchr_desc ,
    (SELECT baninst1.f_epsccode(sobsbgi_stat_code, sobsbgi_zip, sobsbgi_cnty_code )
    FROM saturn.sobsbgi
    WHERE sobsbgi_sbgi_code = sorhsch_sbgi_code
    ) vw_epscode ,
    sorhsch_graduation_date ,
    CASE
      WHEN sorhsch_class_rank IS NULL
      THEN 0
      ELSE sorhsch_class_rank
    END sorhsch_class_rank ,
    CASE
      WHEN sorhsch_class_size IS NULL
      THEN 0
      ELSE sorhsch_class_size
    END sorhsch_class_size ,
    CASE
      WHEN sorhsch_gpa IS NULL
      THEN '0'
      ELSE sorhsch_gpa
    END sorhsch_gpa ,
    CASE
      WHEN sorhsch_percentile IS NULL
      THEN 0
      ELSE sorhsch_percentile
    END sorhsch_percentile,
    CASE
      WHEN sobsbgi_natn_code IS NOT NULL
      THEN
        (SELECT gorsgeo_geod_code
        FROM general.gorsgeo
        WHERE gorsgeo_geor_code LIKE 'ADM%'
        AND gorsgeo_sbgi_code = h.sorhsch_sbgi_code
        )
      ELSE ''
    END vw_hs_region
  FROM saturn.sorhsch h ,
    saturn.stvsbgi ,
    saturn.sobsbgi ,
    wrkcrd.cc_wrkcrd_sorbchr ,
    saturn.stvbchr ,
    saturn.stvnatn
  WHERE h.sorhsch_activity_date =
    (SELECT MAX(b.sorhsch_activity_date)
    FROM saturn.sorhsch b
    WHERE b.sorhsch_pidm = h.sorhsch_pidm
    )
  AND sobsbgi_sbgi_code(+)    = h.sorhsch_sbgi_code
  AND stvsbgi_code(+)         = h.sorhsch_sbgi_code
  AND sorbchr_sbgi_code(+)    = h.sorhsch_sbgi_code
  AND stvbchr_code(+)         = sorbchr_bchr_code
  AND stvnatn.stvnatn_code(+) = sobsbgi_natn_code;
  
/