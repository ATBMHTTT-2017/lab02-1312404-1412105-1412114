ALTER SESSION SET "_Oracle_script" = true;

----------CREATE TABLE
CREATE TABLE Employee_1412105
(
    EmployeeID CHAR(15) PRIMARY KEY,
    EmployeeName varchar2(50),
    EmployeeAddress varchar2(100),
    PhoneNumber VARCHAR(20),
    Email VARCHAR(50),
    Department CHAR(4),
    Branch CHAR(3),
    Salary INT
);

CREATE TABLE Branch_1412105
(
    BranchID CHAR(3) PRIMARY KEY,
    BranchName varchar2(50),
    BranchManager CHAR(15)
);

CREATE TABLE Department_1412105
(
    DepartmentID CHAR(4),
    DepartmentName varchar2(50),
    DepartmentChief CHAR(15),
    ElectedDate DATE,
    EmployeeQuantity INT,
    Branch CHAR(3),
    CONSTRAINT PK_Department PRIMARY KEY (DepartmentID, Branch)
);

CREATE TABLE Projects_1412105
(
    ProjectID CHAR(6) PRIMARY KEY,
    ProjectName varchar2(100),
    Fund INT,
    HoldingDepartment CHAR(4),
    Branch CHAR(3),
    ProjectManager CHAR(15)
);

CREATE TABLE Expenditure_1412105
(
    ExpenditureID CHAR(7) PRIMARY KEY,
    ExpenditureName varchar2(100),
    Amount INT,
    Projects CHAR(6)
);

CREATE TABLE Assignment_1412105
(
    Projects CHAR(6),
    Employee CHAR(15),
    Position varchar2(20),
    SuppliedFund INT,
    CONSTRAINT PK_Assignment PRIMARY KEY(Projects, Employee)
);

------ CREATE CONSTRAINT AND TRIGGER
-- Employee
ALTER TABLE Employee_1412105
ADD CONSTRAINT FK_BelongedDepartment FOREIGN KEY(Department, Branch) REFERENCES Department_1412105(DepartmentID, Branch);

-- Branch
ALTER TABLE Branch_1412105
ADD CONSTRAINT FK_Manager FOREIGN KEY(BranchManager) REFERENCES Employee_1412105(EmployeeID);

-- Department
ALTER TABLE Department_1412105
ADD CONSTRAINT FK_Chief FOREIGN KEY(DepartmentChief) REFERENCES Employee_1412105(EmployeeID);
ALTER TABLE Department_1412105
ADD CONSTRAINT FK_BelongedBranch FOREIGN KEY(Branch) REFERENCES Branch_1412105(BranchID);

-- Project
ALTER TABLE Projects_1412105
ADD CONSTRAINT FK_HoldingDepartment FOREIGN KEY(HoldingDepartment, Branch) REFERENCES Department_1412105(DepartmentID, Branch);

-- Expenditure
ALTER TABLE Expenditure_1412105
ADD CONSTRAINT FK_OfProject FOREIGN KEY(Projects) REFERENCES Projects_1412105(ProjectID);

-- Assignment
ALTER TABLE Assignment_1412105
ADD CONSTRAINT FK_AssignmentOfProject FOREIGN KEY(Projects) REFERENCES Projects_1412105(ProjectID);
ALTER TABLE Assignment_1412105
ADD CONSTRAINT FK_HandlingEmployee FOREIGN KEY(Employee) REFERENCES Employee_1412105(EmployeeID);

---------- INSERT DATA
-- Insert Branch
insert into Branch_1412105 values ('HN', 'Ha Noi', NUll);
insert into Branch_1412105 values ('DN', 'Da Nang', NUll);
insert into Branch_1412105 values ('HCM', 'Ho Chi Minh', NUll);

-- Insert DEPARTMENT
insert into DEPARTMENT_1412105 values ('KT', 'Ke Toan', NUll, TO_DATE('01012000', 'ddmmyyyy'), 10, 'HN');
insert into DEPARTMENT_1412105 values ('KH', 'Ke Hoach', NUll,TO_DATE('02022000', 'ddmmyyyy'), 15, 'HN');
insert into DEPARTMENT_1412105 values ('NS', 'Nhan Su', NUll, TO_DATE('03032000', 'ddmmyyyy'), 5, 'HN');
insert into DEPARTMENT_1412105 values ('KT', 'Ke Toan', NUll, TO_DATE('01012001', 'ddmmyyyy'), 10, 'DN');
insert into DEPARTMENT_1412105 values ('KH', 'Ke Hoach', NUll,TO_DATE('02022001', 'ddmmyyyy'), 15, 'DN');
insert into DEPARTMENT_1412105 values ('NS', 'Nhan Su', NUll, TO_DATE('03032001', 'ddmmyyyy'), 5, 'DN');
insert into DEPARTMENT_1412105 values ('KT', 'Ke Toan', NUll, TO_DATE('01012002', 'ddmmyyyy'), 10, 'HCM');
insert into DEPARTMENT_1412105 values ('KH', 'Ke Hoach', NUll,TO_DATE('02022002', 'ddmmyyyy'), 15, 'HCM');
insert into DEPARTMENT_1412105 values ('NS', 'Nhan Su', NUll, TO_DATE('03032002', 'ddmmyyyy'), 5, 'HCM');

-- Insert EMPLOYEE
insert into EMPLOYEE_1412105 values ('EM01_1412105', 'Nguyen Van A', 'Ha Noi', '0911384853', 'a@gmail.com', 'KT', 'HN', 1000);
insert into EMPLOYEE_1412105 values ('EM02_1412105', 'Nguyen Van B', 'Ha Noi', '0934858433', 'a@gmail.com', 'KT', 'HN', 1100);
insert into EMPLOYEE_1412105 values ('EM03_1412105', 'Nguyen Van C', 'Ha Noi', '0923485243', 'a@gmail.com', 'KT', 'HN', 1400);
insert into EMPLOYEE_1412105 values ('EM04_1412105', 'Nguyen Van D', 'Ha Noi', '0952429421', 'a@gmail.com', 'KT', 'HN', 1600);
insert into EMPLOYEE_1412105 values ('EM05_1412105', 'Nguyen Van E', 'Ha Noi', '01234428312', 'a@gmail.com', 'NS', 'HN', 1200);
insert into EMPLOYEE_1412105 values ('EM06_1412105', 'Nguyen Van F', 'Ha Noi', '0925385282', 'a@gmail.com', 'NS', 'HN', 1200);
insert into EMPLOYEE_1412105 values ('EM07_1412105', 'Nguyen Van F', 'Ha Noi', '0945928428', 'a@gmail.com', 'NS', 'HN', 1800);
insert into EMPLOYEE_1412105 values ('EM08_1412105', 'Nguyen Van G', 'Ha Noi', '0922242384', 'a@gmail.com', 'NS', 'HN', 1100);
insert into EMPLOYEE_1412105 values ('EM09_1412105', 'Nguyen Van H', 'Ha Noi', '01958234234', 'a@gmail.com', 'KH', 'HN', 1000);
insert into EMPLOYEE_1412105 values ('EM10_1412105', 'Nguyen Van I', 'Ha Noi', '0934242855', 'a@gmail.com', 'KH', 'HN', 1200);
insert into EMPLOYEE_1412105 values ('EM11_1412105', 'Nguyen Van K', 'Ha Noi', '01238342342', 'a@gmail.com', 'KH', 'HN', 1200);
insert into EMPLOYEE_1412105 values ('EM12_1412105', 'Nguyen Van F', 'Ha Noi', '01238342342', 'a@gmail.com', 'KH', 'HN', 1200);

insert into EMPLOYEE_1412105 values ('EM13_1412105', 'Nguyen Van M', 'Da Nang', '0958828293', 'a@gmail.com', 'KT', 'DN', 1300);
insert into EMPLOYEE_1412105 values ('EM14_1412105', 'Nguyen Van N', 'Da Nang', '0934284292', 'a@gmail.com', 'KT', 'DN', 1500);
insert into EMPLOYEE_1412105 values ('EM15_1412105', 'Nguyen Van P', 'Da Nang', '01645932002', 'a@gmail.com', 'KT', 'DN', 1500);
insert into EMPLOYEE_1412105 values ('EM16_1412105', 'Nguyen Van Q', 'Da Nang', '0912395231', 'a@gmail.com', 'KT', 'DN', 1700);
insert into EMPLOYEE_1412105 values ('EM17_1412105', 'Nguyen Van X', 'Da Nang', '0923481113', 'a@gmail.com', 'NS', 'DN', 1600);
insert into EMPLOYEE_1412105 values ('EM18_1412105', 'Nguyen Van Y', 'Da Nang', '0953428810', 'a@gmail.com', 'NS', 'DN', 1100);
insert into EMPLOYEE_1412105 values ('EM19_1412105', 'Nguyen Van Z', 'Da Nang', '01994248191', 'a@gmail.com', 'NS', 'DN', 1900);
insert into EMPLOYEE_1412105 values ('EM20_1412105', 'Nguyen Van KA', 'Da Nang', '01679523222', 'a@gmail.com', 'NS', 'DN', 1900);
insert into EMPLOYEE_1412105 values ('EM21_1412105', 'Nguyen Van YN', 'Da Nang', '0911194215', 'a@gmail.com', 'KH', 'DN', 900);
insert into EMPLOYEE_1412105 values ('EM22_1412105', 'Nguyen Van TB', 'Da Nang', '0993241344', 'a@gmail.com', 'KH', 'DN', 1000);
insert into EMPLOYEE_1412105 values ('EM23_1412105', 'Nguyen Van IU', 'Da Nang', '0985925200', 'a@gmail.com', 'KH', 'DN', 700);
insert into EMPLOYEE_1412105 values ('EM24_1412105', 'Nguyen Van UD', 'Da Nang', '0969345821', 'a@gmail.com', 'KH', 'DN', 1300);

insert into EMPLOYEE_1412105 values ('EM25_1412105', 'Nguyen Van XA', 'Ho Chi Minh', '0911384853', 'a@gmail.com', 'KT', 'HCM', 1000);
insert into EMPLOYEE_1412105 values ('EM26_1412105', 'Nguyen Van CA', 'Ho Chi Minh', '0911384853', 'a@gmail.com', 'KT', 'HCM', 1400);
insert into EMPLOYEE_1412105 values ('EM27_1412105', 'Nguyen Van EA', 'Ho Chi Minh', '0911384853', 'a@gmail.com', 'KT', 'HCM', 1200);
insert into EMPLOYEE_1412105 values ('EM28_1412105', 'Nguyen Van DA', 'Ho Chi Minh', '0911384853', 'a@gmail.com', 'KT', 'HCM', 1100);
insert into EMPLOYEE_1412105 values ('EM29_1412105', 'Nguyen Van RA', 'Ho Chi Minh', '0911384853', 'a@gmail.com', 'NS', 'HCM', 1600);
insert into EMPLOYEE_1412105 values ('EM30_1412105', 'Nguyen Van GA', 'Ho Chi Minh', '0911384853', 'a@gmail.com', 'NS', 'HCM', 1500);
insert into EMPLOYEE_1412105 values ('EM31_1412105', 'Nguyen Van WA', 'Ho Chi Minh', '0911384853', 'a@gmail.com', 'NS', 'HCM', 1600);
insert into EMPLOYEE_1412105 values ('EM32_1412105', 'Nguyen Van HA', 'Ho Chi Minh', '0911384853', 'a@gmail.com', 'NS', 'HCM', 1900);
insert into EMPLOYEE_1412105 values ('EM33_1412105', 'Nguyen Van QA', 'Ho Chi Minh', '0911384853', 'a@gmail.com', 'KH', 'HCM', 1500);
insert into EMPLOYEE_1412105 values ('EM34_1412105', 'Nguyen Van HA', 'Ho Chi Minh', '0911384853', 'a@gmail.com', 'KH', 'HCM', 1000);
insert into EMPLOYEE_1412105 values ('EM35_1412105', 'Nguyen Van BA', 'Ho Chi Minh', '0911384853', 'a@gmail.com', 'KH', 'HCM', 900);
insert into EMPLOYEE_1412105 values ('EM36_1412105', 'Nguyen Van RA', 'Ho Chi Minh', '0911384853', 'a@gmail.com', 'KH', 'HCM', 700);

--Insert PROJECT
insert into PROJECTS_1412105 values ('2017A1', 'Runing tracking',3500000,'KH','HN','EM09_1412105');
insert into PROJECTS_1412105 values ('2017A2', 'Share accidents application',2300000,'KH','HCM','EM33_1412105');
insert into PROJECTS_1412105 values ('2017A3', 'Cloud application',1500000,'KH','DN', 'EM21_1412105');
insert into PROJECTS_1412105 values ('2017B1', 'Salary increase',NULL,'NS','HN','EM07_1412105');
insert into PROJECTS_1412105 values ('2017B2', 'Staff cuts off',55000,'NS','DN','EM18_1412105');
insert into PROJECTS_1412105 values ('2017C1', 'Report 2017A1 Project',NULL,'KT','HN','EM25_1412105');
insert into PROJECTS_1412105 values ('2017C2', 'Report 2017A3 Project',NULL,'KT','DN','EM14_1412105');
insert into PROJECTS_1412105 values ('2017C3', 'Buy machine in quarter 2',2255000,'KT','HCM','EM26_1412105');

--Insert EXPENDITURE
insert into EXPENDITURE_1412105 values ('B2017A1','Funding for Running tracking Project',3500000,'2017A1');
insert into EXPENDITURE_1412105 values ('B2017A2','Funding for Share accidents application',2300000,'2017A2');
insert into EXPENDITURE_1412105 values ('B2017A3','Funding for Cloud application',1500000,'2017A3');
insert into EXPENDITURE_1412105 values ('B2017B2','Vacation allowance for Staff cuts off',55000,'2017B2');
insert into EXPENDITURE_1412105 values ('B2017C3','Funding for buy machine in quarter 2',2255000,'2017B2');

--Insert ASSIGNMENT
insert into ASSIGNMENT_1412105 values ('2017A1','EM10_1412105', NULL, NULL);
insert into ASSIGNMENT_1412105 values ('2017A1','EM09_1412105', NULL, NULL);
insert into ASSIGNMENT_1412105 values ('2017A1','EM03_1412105', NULL, NULL);
--
insert into ASSIGNMENT_1412105 values ('2017A2','EM33_1412105', NULL, NULL);
insert into ASSIGNMENT_1412105 values ('2017A2','EM34_1412105', NULL, NULL);
insert into ASSIGNMENT_1412105 values ('2017A2','EM36_1412105', NULL, NULL);
--
insert into ASSIGNMENT_1412105 values ('2017A3','EM21_1412105', NULL, NULL);
insert into ASSIGNMENT_1412105 values ('2017A3','EM23_1412105', NULL, NULL);
insert into ASSIGNMENT_1412105 values ('2017A3','EM24_1412105', NULL, NULL);
--
insert into ASSIGNMENT_1412105 values ('2017B1','EM07_1412105', NULL, NULL);
insert into ASSIGNMENT_1412105 values ('2017B1','EM05_1412105', NULL, NULL);
--
insert into ASSIGNMENT_1412105 values ('2017B2','EM18_1412105', NULL, NULL);
insert into ASSIGNMENT_1412105 values ('2017B2','EM19_1412105', NULL, NULL);
--
insert into ASSIGNMENT_1412105 values ('2017C1','EM25_1412105', NULL, NULL);
insert into ASSIGNMENT_1412105 values ('2017C1','EM10_1412105', NULL, NULL);
--
insert into ASSIGNMENT_1412105 values ('2017C2','EM14_1412105', NULL, NULL);
insert into ASSIGNMENT_1412105 values ('2017C2','EM23_1412105', NULL, NULL);
--
insert into ASSIGNMENT_1412105 values ('2017C3','EM25_1412105', NULL, NULL);
insert into ASSIGNMENT_1412105 values ('2017C3','EM27_1412105', NULL, NULL);
insert into ASSIGNMENT_1412105 values ('2017C3','EM28_1412105', NULL, NULL);

--Insert Abtribute Foreign KEY
--Update Branch_1412105 table
Update Branch_1412105
Set BranchManager = 'EM02_1412105'
Where BranchID = 'HN';
Update Branch_1412105
Set BranchManager = 'EM13_1412105'
Where BranchID = 'DN';
Update Branch_1412105
Set BranchManager = 'EM25_1412105'
Where BranchID = 'HCM';

--Update Department_1412105 table
Update Department_1412105
Set DepartmentChief = 'EM03_1412105'
Where DepartmentID = 'KT'and Branch = 'HN';
Update Department_1412105
Set DepartmentChief = 'EM05_1412105'
Where DepartmentID = 'NS'and Branch = 'HN';
Update Department_1412105
Set DepartmentChief = 'EM09_1412105'
Where DepartmentID = 'KH'and Branch = 'HN';
Update Department_1412105
Set DepartmentChief = 'EM14_1412105'
Where DepartmentID = 'KT'and Branch = 'DN';
Update Department_1412105
Set DepartmentChief = 'EM17_1412105'
Where DepartmentID = 'NS'and Branch = 'DN';
Update Department_1412105
Set DepartmentChief = 'EM21_1412105'
Where DepartmentID = 'KH'and Branch = 'DN';
Update Department_1412105
Set DepartmentChief = 'EM26_1412105'
Where DepartmentID = 'KT'and Branch = 'HCM';
Update Department_1412105
Set DepartmentChief = 'EM29_1412105'
Where DepartmentID = 'NS'and Branch = 'HCM';
Update Department_1412105
Set DepartmentChief = 'EM33_1412105'
Where DepartmentID = 'KH'and Branch = 'HCM';

---------- CREATE USER
-- Create user for Emplyee
grant create session to EM01_1412105 identified by EM01_1412105;
grant create session to EM02_1412105 identified by EM02_1412105;
grant create session to EM03_1412105 identified by EM03_1412105;
grant create session to EM04_1412105 identified by EM04_1412105;
grant create session to EM05_1412105 identified by EM05_1412105;
grant create session to EM06_1412105 identified by EM06_1412105;
grant create session to EM07_1412105 identified by EM07_1412105;
grant create session to EM08_1412105 identified by EM08_1412105;
grant create session to EM09_1412105 identified by EM09_1412105;
grant create session to EM10_1412105 identified by EM10_1412105;
grant create session to EM11_1412105 identified by EM11_1412105;
grant create session to EM12_1412105 identified by EM12_1412105;
grant create session to EM13_1412105 identified by EM13_1412105;
grant create session to EM14_1412105 identified by EM14_1412105;
grant create session to EM15_1412105 identified by EM15_1412105;
grant create session to EM16_1412105 identified by EM16_1412105;
grant create session to EM17_1412105 identified by EM17_1412105;
grant create session to EM18_1412105 identified by EM18_1412105;
grant create session to EM19_1412105 identified by EM19_1412105;
grant create session to EM20_1412105 identified by EM20_1412105;
grant create session to EM21_1412105 identified by EM21_1412105;
grant create session to EM22_1412105 identified by EM22_1412105;
grant create session to EM23_1412105 identified by EM23_1412105;
grant create session to EM24_1412105 identified by EM24_1412105;
grant create session to EM25_1412105 identified by EM25_1412105;
grant create session to EM26_1412105 identified by EM26_1412105;
grant create session to EM27_1412105 identified by EM27_1412105;
grant create session to EM28_1412105 identified by EM28_1412105;
grant create session to EM29_1412105 identified by EM29_1412105;
grant create session to EM30_1412105 identified by EM30_1412105;
grant create session to EM31_1412105 identified by EM31_1412105;
grant create session to EM32_1412105 identified by EM32_1412105;
grant create session to EM33_1412105 identified by EM33_1412105;
grant create session to EM34_1412105 identified by EM34_1412105;
grant create session to EM35_1412105 identified by EM35_1412105;
grant create session to EM36_1412105 identified by EM36_1412105;

-- Create user  for ProjectManager
grant create session to PM01_1412105 identified by PM01_1412105;
grant create session to PM02_1412105 identified by PM02_1412105;
grant create session to PM03_1412105 identified by PM03_1412105;
grant create session to PM04_1412105 identified by PM04_1412105;
grant create session to PM05_1412105 identified by PM05_1412105;

-- Create user for DepartmentChief
grant create session to DC01_1412105 identified by DC01_1412105;
grant create session to DC02_1412105 identified by DC02_1412105;
grant create session to DC03_1412105 identified by DC03_1412105;
grant create session to DC04_1412105 identified by DC04_1412105;
grant create session to DC05_1412105 identified by DC05_1412105;

-- Create user for BranchManager
grant create session to BM01_1412105 identified by BM01_1412105;
grant create session to BM02_1412105 identified by BM02_1412105;
grant create session to BM03_1412105 identified by BM03_1412105;
grant create session to BM04_1412105 identified by BM04_1412105;
grant create session to BM05_1412105 identified by BM05_1412105;

-- Create user for Director
grant create session to D01_1412105 identified by D01_1412105;
grant create session to D02_1412105 identified by D02_1412105;
grant create session to D03_1412105 identified by D03_1412105;
grant create session to D04_1412105 identified by D04_1412105;
grant create session to D05_1412105 identified by D05_1412105;

---------- CREATE ROLE AND GRANT ROLE TO USER
----Create ROLE
create role Employee_1412105;
create role DepartmentChief_1412105;
create role BranchManager_1412105;
create role Director_1412105;
create role ProjectManager_1412105;

----Grant role to user
-- Grant role to Employee_1412105
grant Employee_1412105 to EM01_1412105;
grant Employee_1412105 to EM02_1412105;
grant Employee_1412105 to EM03_1412105;
grant Employee_1412105 to EM04_1412105;
grant Employee_1412105 to EM05_1412105;
grant Employee_1412105 to EM06_1412105;
grant Employee_1412105 to EM07_1412105;
grant Employee_1412105 to EM08_1412105;
grant Employee_1412105 to EM09_1412105;
grant Employee_1412105 to EM10_1412105;
grant Employee_1412105 to EM11_1412105;
grant Employee_1412105 to EM12_1412105;
grant Employee_1412105 to EM13_1412105;
grant Employee_1412105 to EM14_1412105;
grant Employee_1412105 to EM15_1412105;
grant Employee_1412105 to EM16_1412105;
grant Employee_1412105 to EM17_1412105;
grant Employee_1412105 to EM18_1412105;
grant Employee_1412105 to EM19_1412105;
grant Employee_1412105 to EM20_1412105;
grant Employee_1412105 to EM21_1412105;
grant Employee_1412105 to EM22_1412105;
grant Employee_1412105 to EM23_1412105;
grant Employee_1412105 to EM24_1412105;
grant Employee_1412105 to EM25_1412105;
grant Employee_1412105 to EM26_1412105;
grant Employee_1412105 to EM27_1412105;
grant Employee_1412105 to EM28_1412105;
grant Employee_1412105 to EM29_1412105;
grant Employee_1412105 to EM30_1412105;
grant Employee_1412105 to EM31_1412105;
grant Employee_1412105 to EM32_1412105;
grant Employee_1412105 to EM33_1412105;
grant Employee_1412105 to EM34_1412105;
grant Employee_1412105 to EM35_1412105;
grant Employee_1412105 to EM36_1412105;

--Grant role to BranchManager_1412105
grant BranchManager_1412105 to BM01_1412105;
grant BranchManager_1412105 to BM02_1412105;
grant BranchManager_1412105 to BM03_1412105;
grant BranchManager_1412105 to BM04_1412105;
grant BranchManager_1412105 to BM05_1412105;
grant BranchManager_1412105 to EM03_1412105;
grant BranchManager_1412105 to EM09_1412105;
grant BranchManager_1412105 to EM05_1412105;
grant BranchManager_1412105 to EM14_1412105;
grant BranchManager_1412105 to EM21_1412105;
grant BranchManager_1412105 to EM17_1412105;
grant BranchManager_1412105 to EM26_1412105;
grant BranchManager_1412105 to EM33_1412105;
grant BranchManager_1412105 to EM29_1412105;

--Grant role to BranchManager
grant DepartmentChief_1412105 to DC01_1412105;
grant DepartmentChief_1412105 to DC02_1412105;
grant DepartmentChief_1412105 to DC03_1412105;
grant DepartmentChief_1412105 to DC04_1412105;
grant DepartmentChief_1412105 to DC05_1412105;
grant DepartmentChief_1412105 to EM02_1412105;
grant DepartmentChief_1412105 to EM13_1412105;
grant DepartmentChief_1412105 to EM25_1412105;

--Grant role to Director_1412105
grant Director_1412105 to D01_1412105;
grant Director_1412105 to D02_1412105;
grant Director_1412105 to D03_1412105;
grant Director_1412105 to D04_1412105;
grant Director_1412105 to D05_1412105;
grant Director_1412105 to EM01_1412105;

--Grant role to ProjectManager_1412105
grant ProjectManager_1412105 to PM01_1412105;
grant ProjectManager_1412105 to PM02_1412105;
grant ProjectManager_1412105 to PM03_1412105;
grant ProjectManager_1412105 to PM04_1412105;
grant ProjectManager_1412105 to PM05_1412105;
grant ProjectManager_1412105 to EM09_1412105;
grant ProjectManager_1412105 to EM33_1412105;
grant ProjectManager_1412105 to EM18_1412105;
grant ProjectManager_1412105 to EM25_1412105;
grant ProjectManager_1412105 to EM14_1412105;
grant ProjectManager_1412105 to EM26_1412105;
grant ProjectManager_1412105 to EM21_1412105;
grant ProjectManager_1412105 to EM07_1412105;
