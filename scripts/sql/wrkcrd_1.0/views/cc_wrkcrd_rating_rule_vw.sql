CREATE OR REPLACE FORCE VIEW "WRKCRD"."CC_WRKCRD_RATING_RULE_VW" ("SARRRCT_RATP_CODE", "SARRRCT_TERM_CODE_EFF", "SARRRCT_MIN_RATING", "SARRRCT_MAX_RATING")
AS
  SELECT sarrrct_ratp_code,
    sarrrct_term_code_eff,
    sarrrct_min_rating,
    sarrrct_max_rating
  FROM saturn.sarrrct;
  
/