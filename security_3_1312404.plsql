---------------------------------------INSERT ON TABLE EXPENDITURE
----- Create store procedure insert Expenditure
create or replace
PROCEDURE INSERT_EXPENDITURE_1312404
(
  P_EXPENDITUREID VARCHAR2,
  P_EXPENDITURENAME NVARCHAR2,
  P_AMOUNT INT,
  P_CONSUMINGPROJECT VARCHAR2
)
AUTHID CURRENT_USER
IS
  P_AMOUNT_INPUT RAW(128);
  ENCRYPT_DATA RAW(128);
  PUBLIC_KEY RAW(128);
  check_role NUMBER;
  PARENT_NOT_FOUND EXCEPTION;
  PRAGMA EXCEPTION_INIT(PARENT_NOT_FOUND, -2291);
BEGIN
    --Only DBA can insert employee
    SELECT COUNT(*)
    INTO check_role
    FROM user_role_privs
    WHERE granted_role = 'DBA';
    IF (check_role = 1)
        THEN
          BEGIN
            PUBLIC_KEY := UTL_RAW.CAST_TO_RAW(CONVERT(P_EXPENDITURE || '1312404', 'AL32UTF8', 'WE8MSWIN1252'));
            P_AMOUNT_INPUT := UTL_RAW.CAST_FROM_NUMBER(P_AMOUNT);
            ENCRYPT_DATA := DBMS_CRYPTO.ENCRYPT(P_AMOUNT_INPUT, 4353, PUBLIC_KEY);
            -- Insert Data
            INSERT INTO EXPENDITURE_1412105 (EXPENDITUREID, EXPENDITURENAME, AMOUNT, CONSUMINGPROJECT)
            VALUES (P_EXPENDITUREID, P_EXPENDITURENAME, ENCRYPT_DATA, P_CONSUMINGPROJECT);
            COMMIT;
            -- Catch Exception
            EXCEPTION
                WHEN DUP_VAL_ON_INDEX THEN
                DBMS_OUTPUT.PUT_LINE('INSERT failed because duplicate primary key');
                WHEN VALUE_ERROR THEN
                DBMS_OUTPUT.PUT_LINE('INSERT failed because value error');
                WHEN PARENT_NOT_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('INSERT failed because department or branch not exists');
          END;
    ELSE
       dbms_output.put_line('Sorry process return errors, Please check privileges...!');
    END IF;
END INSERT_EXPENDITURE_1312404;


---------------------------------------UPDATE ON TABLE EXPENDITURE
CREATE OR REPLACE
PROCEDURE PM_UPDATE_EXPENDITURE (EXPENDITURE_INPUT varchar2, AMOUNT_INPUT INT)
AUTHID CURRENT_USER
AS
    AMOUNT_INPUT_RAW RAW(128);
    ENCRYPT_AMOUNT RAW(128);
    DECRYPT_AMOUNT RAW(128);
    PUBLIC_KEY RAW(128);
    check_role NUMBER;
    CHECK_ENCRYPT VARCHAR2;
BEGIN
    -- Check role of user
    SELECT count(*)
    INTO temp
    FROM user_role_privs
    WHERE granted_role = 'DBA';
    IF (temp = 1)
    THEN
        -- Key:= EmployeeID || '1412105'
        PUBLIC_KEY := UTL_RAW.CAST_TO_RAW(CONVERT(EXPENDITURE_INPUT || '1312404', 'AL32UTF8', 'WE8MSWIN1252'));
        -- Convert salary from integer to raw
        AMOUNT_INPUT_RAW := UTL_RAW.CAST_FROM_NUMBER (AMOUNT_INPUT);
        -- Encrypts salary
        ENCRYPT_AMOUNT := DBMS_CRYPTO.ENCRYPT(AMOUNT_INPUT_RAW, 4353, PUBLIC_KEY);
        -- Decrypts encrypted_raw_salary
        DECRYPT_AMOUNT := DBMS_CRYPTO.DECRYPT(ENCRYPT_AMOUNT, 4353, PUBLIC_KEY);
        -- Convert to Salary_input
        CHECK_ENCRYPT := CONVERT(UTL_RAW.CAST_TO_VARCHAR2(DECRYPT_AMOUNT), 'WE8MSWIN1252','AL32UTF8');
        -- check encryption result with salary_input
        IF (AMOUNT_INPUT = CHECK_ENCRYPT)
            THEN
                UPDATE EXPENDITURE_1412105
                SET AMOUNT = ENCRYPT_AMOUNT
                WHERE EXPENDITUREID = EXPENDITURE_INPUT;
                COMMIT;
        ELSE
            dbms_output.put_line('Sorry process return errors..!');
        END IF;
    ELSE
        dbms_output.put_line('Sorry process return errors, Please check privileges...!');
    END IF;
END PM_UPDATE_EXPENDITURE;

--------------------------------------------------------------
---------------------------------------SELECT ON TABLE EXPENDITURE
----- Create view to each projectmanager can see thier amount
CREATE OR REPLACE VIEW EXPENDITURE_VIEW_1312404 AS
SELECT EXPENDITUREID,
       EXPENDITURENAME,
       UTL_RAW.CAST_TO_NUMBER(SYS.DBMS_CRYPTO.DECRYPT(AMOUNT, 4353, UTL_RAW.CAST_TO_RAW(CONVERT(EXPENDITUREID ||'1312404', 'AL32UTF8', 'WE8MSWIN1252')))) as AMOUNT,
       CONSUMINGPROJECT
FROM temp_Expenditure_1412105;

----- Create funtion policy to each projectmanager can see their data.
----- Not grant view to DBA.
-- View Amount
create or replace
function Expenditure_ViewAmount(p_schema varchar2, p_object varchar2)
  return varchar2
  authid current_user
  is
    UserID varchar2(200);
    temp number;
  begin
    UserID := SYS_CONTEXT('USERENV','SESSION_USER');
    select count(*)
    into temp
    from user_role_privs
    where granted_role = 'ProjectManager_1412105';
    if(temp != 0)
    then
        return 'ProjectManager = '''||UserID||'''';
    end if;
end Expenditure_ViewAmount;

-- Create policy on view Expenditure_View_1312404 with Expenditure_ViewAmount function_schema
begin
dbms_rls.add_policy
(
  object_schema => 'Atbmhttt_lab02',
  object_name => 'Expenditure_View_1312404',
  policy_name => 'Expenditure_View_Policy',
  function_schema => 'Atbmhttt_lab02',
  policy_function => 'Expenditure_ViewAmount',
  sec_relevant_cols => 'Amount',
  statement_types => 'select'
);
end;



----
