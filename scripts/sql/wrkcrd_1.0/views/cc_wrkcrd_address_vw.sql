CREATE OR REPLACE FORCE VIEW "WRKCRD"."CC_WRKCRD_ADDRESS_VW" ("ADDRESS_ID", "SPRADDR_PIDM", "SPRADDR_ATYP_CODE", "SPRADDR_STREET_LINE1", "SPRADDR_STREET_LINE2", "SPRADDR_STREET_LINE3", "SPRADDR_CITY", "SPRADDR_STAT_CODE", "SPRADDR_ZIP", "VW_NATION", "VW_PHONE")
AS
  SELECT DISTINCT to_number(spraddr_pidm
    || ASCII(spraddr_atyp_code)) address_id ,
    spraddr_pidm ,
    spraddr_atyp_code ,
    spraddr_street_line1 ,
    spraddr_street_line2 ,
    spraddr_street_line3 ,
    spraddr_city ,
    spraddr_stat_code ,
    spraddr_zip ,
    CASE
      WHEN stvnatn_nation IS NULL
      THEN 'United States'
      ELSE stvnatn_nation
    END vw_nation ,
    CASE
      WHEN sprtele_intl_access IS NOT NULL
      THEN sprtele_intl_access
      ELSE TO_CHAR(sprtele_phone_area
        || sprtele_phone_number
        || sprtele_phone_ext)
    END vw_phone
  FROM cc_wrkcrd_applicant_vw ,
    saturn.spraddr a ,
    saturn.sprtele ,
    saturn.stvnatn
  WHERE spraddr_pidm         = spriden_pidm
  AND sprtele_pidm(+)        = a.spraddr_pidm
  AND stvnatn_code(+)        = a.spraddr_natn_code
  AND sprtele_atyp_code(+)   = a.spraddr_atyp_code
  AND sprtele_addr_seqno(+)  = a.spraddr_seqno
  AND sprtele_primary_ind(+) = 'Y'
  AND a.spraddr_status_ind  IS NULL
  AND a.spraddr_from_date   <= SYSDATE
  AND a.spraddr_from_date    =
    (SELECT MAX(b.spraddr_from_date)
    FROM saturn.spraddr b
    WHERE a.spraddr_pidm      = b.spraddr_pidm
    AND a.spraddr_atyp_code   = b.spraddr_atyp_code
    AND b.spraddr_status_ind IS NULL
    AND b.spraddr_from_date  <= SYSDATE
    );
/