---------------------------------------INSERT ON TABLE EMPLOYEE
----- Create store procedure insert Employee include encryption salary abtribute
CREATE OR REPLACE
PROCEDURE ATBMHTTT_LAB02.INSERT_EMPLOYEE_1412105
(
  P_EMPLOYEEID VARCHAR2,
  P_EMPLOYEENAME NVARCHAR2,
  P_EMPLOYEEADDRESS NVARCHAR2,
  P_PHONENUMBER VARCHAR2,
  P_EMAIL VARCHAR2,
  P_DEPARTMENT VARCHAR2,
  P_BRANCH VARCHAR2,
  P_SALARY INT
)
AUTHID CURRENT_USER
IS
  P_SALARY_INPUT RAW(128);
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
            PUBLIC_KEY := UTL_RAW.CAST_TO_RAW(CONVERT(P_EMPLOYEEID || '1412105', 'AL32UTF8', 'WE8MSWIN1252'));
            P_SALARY_INPUT := UTL_RAW.CAST_FROM_NUMBER(P_SALARY);
            ENCRYPT_DATA := DBMS_CRYPTO.ENCRYPT(P_SALARY_INPUT, 4353, PUBLIC_KEY);
            -- Insert Data
            INSERT INTO ATBMHTTT_LAB02.EMPLOYEE_1412105 (EMPLOYEEID, EMPLOYEENAME, EMPLOYEEADDRESS, PHONENUMBER, EMAIL, DEPARTMENT, BRANCH, SALARY)
            VALUES (P_EMPLOYEEID, P_EMPLOYEENAME, P_EMPLOYEEADDRESS, P_PHONENUMBER, P_EMAIL, P_DEPARTMENT, P_BRANCH, ENCRYPT_DATA);
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
END ATBMHTTT_LAB02.INSERT_EMPLOYEE_1412105;


---------------------------------------UPDATE ON TABLE EMPLOYEE
----- Store procedure to Update salary include encryption salary abtribute.
CREATE OR REPLACE
PROCEDURE ATBMHTTT_LAB02.Update_Employee (EmployeeID_input varchar2, Salary_input INT)
AUTHID CURRENT_USER
AS
    raw_salary_input RAW(128);
    encrypted_raw_salary RAW(128);
    decrypted_raw_salary RAW(128);
    raw_key RAW(128);
    check_role NUMBER;
    check_encrypt VARCHAR2;
BEGIN
    -- Check role of user
    SELECT count(*)
    INTO temp
    FROM user_role_privs
    WHERE granted_role = 'DBA';
    IF (temp = 1)
    THEN
        -- Key:= EmployeeID || '1412105'
        raw_key := UTL_RAW.CAST_TO_RAW(CONVERT(EmployeeID_input || '1412105', 'AL32UTF8', 'WE8MSWIN1252'));
        -- Convert salary from integer to raw
        raw_salary_input := UTL_RAW.CAST_FROM_NUMBER (salary_input);
        -- Encrypts salary
        encrypted_raw_salary := DBMS_CRYPTO.ENCRYPT(raw_salary_input, 4353, raw_key);
             UPDATE ATBMHTTT_LAB02.EMPLOYEE_1412105
             SET salary = encrypted_raw_salary
             WHERE EmployeeID = EmployeeID_input;
             IF (SQL%ROWCOUNT = 0)
               THEN
                 DBMS_OUTPUT.PUT_LINE(TO_Char(SQL%ROWCOUNT)||' rows affected. Please check input data');
             ELSE
                 DBMS_OUTPUT.PUT_LINE(TO_Char(SQL%ROWCOUNT)||' rows affected.');
             END IF;
             COMMIT;
    ELSE
        DBMS_OUTPUT.PUT_LINE('Sorry process return errors, Please check privileges...!');
    END IF;
END ATBMHTTT_LAB02.Update_Employee;

--------------------------------------------------------------
---------------------------------------SELECT ON TABLE EMPLOYEE
----- Create view to each employee can see thier salary
CREATE OR REPLACE
VIEW ATBMHTTT_LAB02.Employee_View_1412105
AS
SELECT EmployeeID,
    EmployeeName,
    EmployeeAddress ,
    PhoneNumber ,
    Email ,
    Department ,
    Branch ,
    UTL_RAW.CAST_TO_NUMBER(SYS.DBMS_CRYPTO.DECRYPT(Salary, 4353, UTL_RAW.CAST_TO_RAW(CONVERT(EMPLOYEEID ||'1412105', 'AL32UTF8', 'WE8MSWIN1252')))) as Salary
FROM ATBMHTTT_LAB02.Employee_1412105;

----- Create funtion policy to each employee can see their data and data of employee same Department.
----- Not grant view to DBA.
-- View Salary
CREATE OR REPLACE
FUNCTION ATBMHTTT_LAB02.Employee_ViewSalary_1412105(p_schema VARCHAR2, p_object VARCHAR2)
  RETURN VARCHAR2
  AUTHID CURRENT_USER
  IS
    UserID VARCHAR2 (200);
    temp NUMBER;
BEGIN
    UserID := SYS_CONTEXT('USERENV','SESSION_USER');
    SELECT count(*)
    INTO temp
    FROM user_role_privs
    WHERE granted_role = 'EMPLOYEE_1412105';
        IF (temp != 0)
            THEN
                RETURN 'EmployeeID = '''||UserID||'''';
        END IF;
END ATBMHTTT_LAB02.Employee_ViewSalary_1412105;

-- Create policy on view Employee_View_1412105 with Employee_ViewSalary function_schema
BEGIN
    dbms_rls.add_policy
    (
      object_schema => 'Atbmhttt_lab02',
      object_name => 'Employee_View_1412105',
      policy_name => 'Employee_View_Policy',
      function_schema => 'Atbmhttt_lab02',
      policy_function => 'Employee_ViewSalary',
      sec_relevant_cols => 'Salary',
      statement_types => 'select'
    );
END;
