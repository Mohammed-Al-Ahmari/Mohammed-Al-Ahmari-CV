create database CCIT_field_training_sys;
use CCIT_field_training_sys;
CREATE TABLE Person (
  person_id INT AUTO_INCREMENT PRIMARY KEY,
  name   VARCHAR(100) NOT NULL,
  phone  VARCHAR(20),
  email  VARCHAR(255) UNIQUE NOT NULL
);
select * from Person;
CREATE TABLE Department (
  dept_id INT AUTO_INCREMENT PRIMARY KEY,
  dept_name VARCHAR(150) NOT NULL
);
select * from Department;
CREATE TABLE Student (
  student_id INT PRIMARY KEY,          
  major VARCHAR(100) NOT NULL,
  dept_id INT,

  CONSTRAINT fk_student_person
    FOREIGN KEY (student_id) REFERENCES Person(person_id)
    ON UPDATE CASCADE ON DELETE CASCADE,

  CONSTRAINT fk_student_dept
    FOREIGN KEY (dept_id) REFERENCES Department(dept_id)
    ON UPDATE CASCADE ON DELETE SET NULL
);
select * from Student;
CREATE TABLE Supervisor (
  supervisor_id INT PRIMARY KEY,       
  specialization VARCHAR(100),
  dept_id INT,

  CONSTRAINT fk_supervisor_person
    FOREIGN KEY (supervisor_id) REFERENCES Person(person_id)
    ON UPDATE CASCADE ON DELETE CASCADE,

  CONSTRAINT fk_supervisor_dept
    FOREIGN KEY (dept_id) REFERENCES Department(dept_id)
    ON UPDATE CASCADE ON DELETE SET NULL
);
select * from Supervisor;
CREATE TABLE Company (
  company_id INT AUTO_INCREMENT PRIMARY KEY,
  name_ VARCHAR(150) NOT NULL,
  email VARCHAR(255),
  address VARCHAR(255)
);
select * from Company;
CREATE TABLE Company_Branch (
  branch_id INT AUTO_INCREMENT PRIMARY KEY,
  company_id INT NOT NULL,
  branch_name VARCHAR(150) NOT NULL,

  CONSTRAINT fk_branch_company
    FOREIGN KEY (company_id) REFERENCES Company(company_id)
    ON UPDATE CASCADE ON DELETE CASCADE
);
select * from Company;
CREATE TABLE CompanySupervisor (
  company_supervisor_id INT PRIMARY KEY,  -- same as Person.person_id
  company_id INT,

  CONSTRAINT fk_cs_person
    FOREIGN KEY (company_supervisor_id) REFERENCES Person(person_id)
    ON UPDATE CASCADE ON DELETE CASCADE,

  CONSTRAINT fk_cs_company
    FOREIGN KEY (company_id) REFERENCES Company(company_id)
    ON UPDATE CASCADE ON DELETE SET NULL
);
select * from CompanySupervisor;
CREATE TABLE Request (
  request_id INT AUTO_INCREMENT PRIMARY KEY,
  date_submitted DATE NOT NULL,
  status ENUM(
    'Pending',
    'Training_Request_Rejected',
    'Reassign_To_Another_Company',
    'Training_Cannot_Be_Scheduled',
    'Coordinator_Rejected',
    'Student_Assigned_To_Training'
  ) NOT NULL DEFAULT 'Pending',
  duration INT,

  training_plan VARCHAR(255),     -- plan
  branch_id INT,                  -- chosen branch

  student_id INT NOT NULL,
  supervisor_id INT,
  dept_id INT,
  company_id INT,
  
  CONSTRAINT fk_request_student
    FOREIGN KEY (student_id) REFERENCES Student(student_id)
    ON UPDATE CASCADE ON DELETE CASCADE,

  CONSTRAINT fk_request_supervisor
    FOREIGN KEY (supervisor_id) REFERENCES Supervisor(supervisor_id)
    ON UPDATE CASCADE ON DELETE SET NULL,

  CONSTRAINT fk_request_dept
    FOREIGN KEY (dept_id) REFERENCES Department(dept_id)
    ON UPDATE CASCADE ON DELETE SET NULL,

  CONSTRAINT fk_request_company
    FOREIGN KEY (company_id) REFERENCES Company(company_id)
    ON UPDATE CASCADE ON DELETE SET NULL,

  CONSTRAINT fk_request_branch
    FOREIGN KEY (branch_id) REFERENCES Company_Branch(branch_id)
    ON UPDATE CASCADE ON DELETE SET NULL
);
select * from Request;
CREATE TABLE Approval (
  approval_id INT AUTO_INCREMENT PRIMARY KEY,
  request_id INT NOT NULL,

  approver_type ENUM('Company','CompanySupervisor','Supervisor','Department','Coordinator') NOT NULL,
  decision ENUM('Pending','Approved','Rejected') NOT NULL DEFAULT 'Pending',
  decision_date DATE NULL,
  notes VARCHAR(255),

  CONSTRAINT fk_approval_request
    FOREIGN KEY (request_id) REFERENCES Request(request_id)
    ON UPDATE CASCADE ON DELETE CASCADE
);
select * from Approval;
CREATE TABLE Payment (
  payment_id INT AUTO_INCREMENT PRIMARY KEY,
  amount DECIMAL(10,2) NOT NULL,
  date_paid DATE,

  request_id INT NOT NULL,

  CONSTRAINT fk_payment_request
    FOREIGN KEY (request_id) REFERENCES Request(request_id)
    ON UPDATE CASCADE ON DELETE CASCADE
);
select * from Payment;
CREATE TABLE UserAccount (
  user_id INT AUTO_INCREMENT PRIMARY KEY,
  person_id INT NOT NULL UNIQUE,

  ssid VARCHAR(50) NOT NULL UNIQUE,      
  password_hash VARCHAR(255) NOT NULL,   
  role ENUM('Student','Supervisor','CompanySupervisor','Department','Admin','Coordinator') NOT NULL,

  CONSTRAINT fk_user_person
    FOREIGN KEY (person_id) REFERENCES Person(person_id)
    ON UPDATE CASCADE ON DELETE CASCADE
);
select * from UserAccount;
CREATE INDEX idx_request_status ON Request(status);











