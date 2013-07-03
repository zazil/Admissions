CREATE OR REPLACE FORCE VIEW "WRKCRD"."CC_WRKCRD_FAMILY_VW" ("APPL_ID", "ID", "TYPE", "SCHOOL", "OCCUPATION", "DEGREE", "TO_DATE", "GRADE_LEVEL", "CREATED_BY", "CREATED_DATE", "UPDATE_BY", "UPDATE_DATE")
AS
  SELECT appl_id ,
    id ,
    type ,
    school ,
    occupation ,
    degree ,
    to_date ,
    grade_level ,
    CASE
      WHEN created_by IN ('AXIOM')
      THEN
        (SELECT pidm FROM wrkcrd.cc_wrkcrd_ban_user_vw WHERE username = 'axiom'
        )
      ELSE
        (SELECT pidm FROM wrkcrd.cc_wrkcrd_ban_user_vw WHERE pidm = created_by
        )
    END created_by ,
    created_date ,
    CASE
      WHEN update_by IN ('AXIOM')
      THEN
        (SELECT pidm FROM wrkcrd.cc_wrkcrd_ban_user_vw WHERE username = 'axiom'
        )
      ELSE
        (SELECT pidm FROM wrkcrd.cc_wrkcrd_ban_user_vw WHERE pidm = update_by
        )
    END update_by ,
    update_date
  FROM wrkcrd.cc_wrkcrd_relation;
  
/