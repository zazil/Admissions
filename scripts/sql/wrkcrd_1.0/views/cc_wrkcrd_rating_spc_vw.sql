CREATE OR REPLACE FORCE VIEW "WRKCRD"."CC_WRKCRD_RATING_SPC_VW" ("APPL_ID", "ID", "STVRATP_DESC", "SARRRAT_RATING")
AS
  SELECT id appl_id ,
    sarrrat_ratp_code id ,
    stvratp_desc ,
    sarrrat_rating
  FROM wrkcrd.cc_wrkcrd_appl ,
    saturn.sarrrat ,
    saturn.stvratp
  WHERE sarrrat_pidm     = pidm
  AND sarrrat_term_code  = term
  AND sarrrat_appl_no    = appl_no
  AND sarrrat_ratp_code IN ('BK', 'FH', 'IH', 'LX', 'RW', 'SA', 'SC', 'SQ', 'SW', 'TN', 'TR', 'VB', 'WP', 'XC', 'AR', 'DA', 'MU', 'TH', 'DV')
  AND stvratp_code       = sarrrat_ratp_code;
  
/