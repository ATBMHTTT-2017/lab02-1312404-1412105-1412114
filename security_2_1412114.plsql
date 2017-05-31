---------------------------------------INSERT ON TABLE ASSIGNMENT
----- Create store procedure insert assignmrnt include encryption suppliedfund abtribute and add digital signature
PROCEDURE INSERT_ASSIGNMENT_1412105
create or replace
(
  P_PROJECTS VARCHAR2,
  P_EMPLOYEE NVARCHAR2,
  P_POSITION NVARCHAR2,
  P_SUPPLIEDFUND INT
)
AUTHID CURRENT_USER
IS
  P_SUPPLIEDFUND_INPUT RAW(128);
  SUPPLIEDFUND_ENCRYPT_DATA RAW(128);
  PUBLIC_KEY RAW(128);
  HASH_DATA RAW(128);
  SIGNATURE_DATA RAW(256);
  check_role NUMBER;
  PARENT_NOT_FOUND EXCEPTION;
  PRAGMA EXCEPTION_INIT(PARENT_NOT_FOUND, -2291);
BEGIN
    --Only DBA can insert employee
    SELECT COUNT(*)
    INTO check_role
    FROM user_role_privs
    WHERE granted_role = 'PROJECTMANAGER';
    IF (check_role = 1)
        THEN
            IF (P_SUPPLIEDFUND IS NULL)
                THEN
                    INSERT INTO EMPLOYEE_1412105 ( PROJECTS, EMPLOYEE , POSITION, SUPPLIEDFUND, SIGNATURE)
                    VALUES (P_PROJECTS, P_EMPLOYEE , P_POSITION, NULL, NULL);
            ELSE
              BEGIN
                PUBLIC_KEY := UTL_RAW.CAST_TO_RAW(CONVERT(P_EMPLOYEEID || P_PRỌECTS, 'AL32UTF8', 'WE8MSWIN1252'));
                P_SUPPLIEDFUND_INPUT := UTL_RAW.CAST_FROM_NUMBER(P_SUPPLIEDFUND);
                SUPPLIEDFUND_ENCRYPT_DATA := DBMS_CRYPTO.ENCRYPT(P_SUPPLIEDFUND_INPUT, 4353, PUBLIC_KEY);
                HASH_DATA := DBMS_CRYPTO.HASH (SUPPLIEDFUND_ENCRYPT_DATA, 1);
                SIGNATURE_DATA := DBMS_CRYPTO.ENCRYPT(HASH_DATA, 4353, CAST_TO_RAW('PRIVETE_KEY'));
                INSERT INTO EMPLOYEE_1412105 ( PROJECTS, EMPLOYEE , POSITION, SUPPLIEDFUND, SIGNATURE)
                VALUES (P_PROJECTS, P_EMPLOYEE , P_POSITION, P_SUPPLIEDFUND, SIGNATURE_DATA);
                -- Insert Data
                IF (SQL%ROWCOUNT != 0)
                  THEN
                     DBMS_OUTPUT.PUT_LINE(TO_Char(SQL%ROWCOUNT)||' rows affected.');
                COMMIT;
                END IF;
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
END INSERT_ASSIGNMENT_1412105;


---------------------------------------UPDATE ON TABLE ASSIGNMENT
----- Create store procedure insert assignmrnt include encryption suppliedfund abtribute and add digital signature
CREATE OR REPLACE
PROCEDURE Update_Assignment_1412105
( P_PROJECTS VARCHAR2,
  P_EMPLOYEE NVARCHAR2,
  P_POSITION NVARCHAR2,
  P_SUPPLIEDFUND INT
)
AUTHID CURRENT_USER
IS
    P_SUPPLIEDFUND_INPUT RAW(128);
    SUPPLIEDFUND_ENCRYPT_DATA RAW(128);
    PUBLIC_KEY RAW(128);
    HASH_DATA RAW(128);
    SIGNATURE_DATA RAW(256);
    check_role NUMBER;
    PARENT_NOT_FOUND EXCEPTION;
    PRAGMA EXCEPTION_INIT(PARENT_NOT_FOUND, -2291);
BEGIN
    -- Check role of user
    SELECT COUNT(*)
    INTO check_role
    FROM user_role_privs
    WHERE granted_role = 'DBA';
    IF (check_role = 1)
        THEN
            -- Encrypt Suppliedfund by Public key of Employee (Emulator).
            PUBLIC_KEY := UTL_RAW.CAST_TO_RAW(CONVERT(P_EMPLOYEE || P_PROJECTS /*Simulate public key of employee*/, 'AL32UTF8', 'WE8MSWIN1252'));
            P_SUPPLIEDFUND_INPUT := UTL_RAW.CAST_FROM_NUMBER(P_SUPPLIEDFUND);
            SUPPLIEDFUND_ENCRYPT_DATA := DBMS_CRYPTO.ENCRYPT(P_SUPPLIEDFUND_INPUT, 4353, PUBLIC_KEY);
            -- Create digital signature by privete key of projectmanager (Emulator)
            HASH_DATA := DBMS_CRYPTO.HASH (SUPPLIEDFUND_ENCRYPT_DATA, 1);
            SIGNATURE_DATA := DBMS_CRYPTO.ENCRYPT(HASH_DATA, 4353, UTL_RAW.CAST_TO_RAW('PRIVETE_KEY'/*Simulate privete key of ProjectManager*/));
            -- Insert Data
            UPDATE ATBMHTTT_LAB02.ASSIGNMENT_1412105
            SET
            PROJECTS = P_PROJECTS,
            EMPLOYEE = P_EMPLOYEE,
            POSITION = P_POSITION,
            SUPPLIEDFUND = SUPPLIEDFUND_ENCRYPT_DATA,
            SIGNATURE = SIGNATURE_DATA
            WHERE  PROJECTS = P_PROJECTS AND EMPLOYEE = P_EMPLOYEE;
               IF (SQL%ROWCOUNT = 0)
                 THEN
                   DBMS_OUTPUT.PUT_LINE(TO_Char(SQL%ROWCOUNT)||' rows affected. Please check input data');
               ELSE
                   DBMS_OUTPUT.PUT_LINE(TO_Char(SQL%ROWCOUNT)||' rows affected.');
               END IF;
           COMMIT;
    ELSE
        dbms_output.put_line('Sorry process return errors, Please check privileges...!');
    END IF;
END Update_Assignment_1412105;

---------------------------------------INSERT ON TABLE ASSIGNMENT
--------- Create function check digital signature, view and policy on view to see data of assignment TABLE
---- Create function check digital signature

create or replace
FUNCTION  CHECK_SIGNATURE_1412105 (PROJECTS VARCHAR2, SUPPLIEDFUND RAW, SIGNATURE RAW)
RETURN VARCHAR2
AUTHID CURRENT_USER
IS
    HASH_DATA RAW (128);
    SIGNATURE_CHECK RAW(256);
    PRIVETE_KEY VARCHAR2(15);
BEGIN
    -- Simulate public key of ProjectManager
    SELECT PROJECTMANAGER
    INTO PRIVETE_KEY
    FROM PROJECTS_1412105
    WHERE PROJECTID = PROJECTS;
    IF (PRIVETE_KEY IS NOT NULL)
    THEN
        HASH_DATA := DBMS_CRYPTO.HASH(SUPPLIEDFUND, 1);
        SIGNATURE_CHECK := DBMS_CRYPTO.ENCRYPT(HASH_DATA, 4353, UTL_RAW.CAST_TO_RAW(PRIVETE_KEY/*Simulate public key of ProjectManager*/));
        IF (SIGNATURE_CHECK = SIGNATURE)
           THEN
               RETURN 'CORRECT';
           ELSE
            RETURN 'INCORRECT';
        END IF;
    ELSE
       dbms_output.put_line('You do not participate in any project..!');
    END IF;
END CHECK_SIGNATURE_1412105;

---- Create view

CREATE OR REPLACE
VIEW Assignment_View_1412105
AS
SELECT PROJECTS,
    EMPLOYEE,
    POSITION,
    UTL_RAW.CAST_TO_NUMBER(DBMS_CRYPTO.DECRYPT(SUPPLIEDFUND, 4353, UTL_RAW.CAST_TO_RAW(CONVERT(EMPLOYEE || PROJECTS /*Simulate privete key of employee*/, 'AL32UTF8', 'WE8MSWIN1252')))) as SUPPLIEDFUND,
    ATBMHTTT_LAB02.CHECK_SIGNATURE_1412105 (PROJECTS, SUPPLIEDFUND, SIGNATURE) as SIGNATURE
FROM ATBMHTTT_LAB02.Assignment_1412105.

---- Create function_policy
CREATE OR REPLACE
FUNCTION ProjectManager_ViewSuppliedfund_1412105(p_schema VARCHAR2, p_object VARCHAR2)
  RETURN VARCHAR2
  AUTHID CURRENT_USER
  IS
    UserID VARCHAR2 (200);
    F_Project VARCHAR2 (6);
    temp NUMBER;
BEGIN
    UserID := SYS_CONTEXT('USERENV','SESSION_USER');
    SELECT count(*)
    INTO temp
    FROM user_role_privs
    WHERE granted_role = 'PROJECTMANAGER_1412105';
        IF (temp != 0)
            THEN
                RETURN 'Employee = '''||UserID||'''';
        ELSE
            BEGIN
                SELECT PROJECTID
                INTO F_PROJECT
                FROM ATBMHTTT_LAB02.PROJECTS_1412105
                WHERE PROJECTMANAGER = USERID;
                RETURN 'PROJECTS = '''||F_PROJECT||'''';
            END;
        END IF;
END Employee_ViewSalary_1412105;
-- Create policy on view Assignment_View_1412105 with ProjectManager_ViewSuppliedfund_1412105 function_policy
BEGIN
    dbms_rls.add_policy
    (
      object_schema => 'Atbmhttt_lab02',
      object_name => 'Assignment_View_1412105',
      policy_name => 'assignment_View_Policy',
      function_schema => 'Atbmhttt_lab02',
      policy_function => 'ProjectManager_ViewSuppliedfund_1412105',
      sec_relevant_cols => 'Suppliedfund',
      statement_types => 'select'
    );
END;
