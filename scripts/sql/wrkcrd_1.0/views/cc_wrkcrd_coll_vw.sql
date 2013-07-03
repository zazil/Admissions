CREATE OR REPLACE FORCE VIEW "WRKCRD"."CC_WRKCRD_COLL_VW" ("SORPCOL_PIDM", "SORPCOL_SBGI_CODE", "STVSBGI_DESC", "SOBSBGI_CITY", "SOBSBGI_STAT_CODE", "SOBSBGI_STREET_LINE1", "SOBSBGI_STREET_LINE2", "SOBSBGI_STREET_LINE3", "SOBSBGI_ZIP", "SOBSBGI_NATN_CODE", "STVNATN_NATION")
AS
  SELECT sorpcol_pidm ,
    sorpcol_sbgi_code ,
    stvsbgi_desc ,
    sobsbgi_city ,
    sobsbgi_stat_code ,
    sobsbgi_street_line1 ,
    sobsbgi_street_line2 ,
    sobsbgi_street_line3 ,
    sobsbgi_zip ,
    sobsbgi_natn_code ,
    stvnatn_nation
  FROM saturn.stvnatn ,
    saturn.stvsbgi ,
    saturn.sobsbgi ,
    saturn.sorpcol a
  WHERE stvsbgi_code(+)       = sorpcol_sbgi_code
  AND sobsbgi_sbgi_code(+)    = sorpcol_sbgi_code
  AND stvnatn_code(+)         = sobsbgi_natn_code
  AND a.sorpcol_activity_date =
    (SELECT MAX(sorpcol_activity_date)
    FROM saturn.sorpcol
    WHERE sorpcol_pidm = a.sorpcol_pidm
    );
    
/