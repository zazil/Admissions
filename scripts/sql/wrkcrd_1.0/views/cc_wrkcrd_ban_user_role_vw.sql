CREATE OR REPLACE FORCE VIEW "WRKCRD"."CC_WRKCRD_BAN_USER_ROLE_VW" ("USER_ID", "ROLE_ID")
AS
  SELECT cc_wrkcrd_ban_user_vw.pidm user_id ,
    role_assignment.role_id
  FROM workflow.role_assignment ,
    wrkcrd.cc_wrkcrd_ban_user_vw
  WHERE role_assignment.user_id = cc_wrkcrd_ban_user_vw.id
  AND role_assignment.role_id  IN
    (SELECT id FROM workflow.role
    )
  ORDER BY role_assignment.role_id;
  
/