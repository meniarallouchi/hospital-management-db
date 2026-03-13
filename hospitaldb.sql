/* =========================================
   CREATE DATABASE
========================================= */

DROP DATABASE IF EXISTS HospitalDB;
CREATE DATABASE HospitalDB;
USE HospitalDB;


/* =========================================
   DOCTOR TABLE
   - Name is composite (First, Middle, Last)
========================================= */

CREATE TABLE Doctor (
    Doctor_id INT PRIMARY KEY,
    First VARCHAR(50) NOT NULL,
    Middle VARCHAR(50),
    Last VARCHAR(50) NOT NULL
);


/* =========================================
   DOCTOR QUALIFICATION (Multivalued)
========================================= */

CREATE TABLE DoctorQualification (
    Doctor_id INT,
    Qualification VARCHAR(100),
    PRIMARY KEY (Doctor_id, Qualification),
    FOREIGN KEY (Doctor_id)
        REFERENCES Doctor(Doctor_id)
        ON DELETE CASCADE
);


/* =========================================
   DOCTOR SPECIALIZATION (Multivalued)
========================================= */

CREATE TABLE DoctorSpecialization (
    Doctor_id INT,
    Specialization VARCHAR(100),
    PRIMARY KEY (Doctor_id, Specialization),
    FOREIGN KEY (Doctor_id)
        REFERENCES Doctor(Doctor_id)
        ON DELETE CASCADE
);


/* =========================================
   PATIENT TABLE
   - Address is composite (Locality, TownCity)
   - Age is derived (NOT stored)
   - 1:N relationship → Doctor_id as FK
========================================= */

CREATE TABLE Patient (
    Patient_id INT PRIMARY KEY,
    DOB DATE NOT NULL,
    Locality VARCHAR(100),
    TownCity VARCHAR(100),
    Doctor_id INT,
    FOREIGN KEY (Doctor_id)
        REFERENCES Doctor(Doctor_id)
        ON DELETE SET NULL
);


/* =========================================
   MEDICINE TABLE
========================================= */

CREATE TABLE Medicine (
    Code INT PRIMARY KEY,
    Price DECIMAL(10,2) NOT NULL,
    Quantity INT NOT NULL
);


/* =========================================
   BILL TABLE (M:N Relationship)
========================================= */

CREATE TABLE Bill (
    Patient_id INT,
    Code INT,
    Quantity INT NOT NULL,
    Price DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (Patient_id, Code),
    FOREIGN KEY (Patient_id)
        REFERENCES Patient(Patient_id)
        ON DELETE CASCADE,
    FOREIGN KEY (Code)
        REFERENCES Medicine(Code)
        ON DELETE CASCADE
);


/* =========================================
   INSERT SAMPLE DATA
========================================= */

/* Doctors */
INSERT INTO Doctor VALUES (1, 'Ali', 'M', 'Ben Salah');
INSERT INTO Doctor VALUES (2, 'Sara', NULL, 'Trabelsi');


/* Doctor Qualifications */
INSERT INTO DoctorQualification VALUES (1, 'MD');
INSERT INTO DoctorQualification VALUES (1, 'PhD');
INSERT INTO DoctorQualification VALUES (2, 'MD');


/* Doctor Specializations */
INSERT INTO DoctorSpecialization VALUES (1, 'Cardiology');
INSERT INTO DoctorSpecialization VALUES (1, 'Internal Medicine');
INSERT INTO DoctorSpecialization VALUES (2, 'Dermatology');


/* Patients */
INSERT INTO Patient VALUES (101, '1995-06-15', 'Lac 1', 'Tunis', 1);
INSERT INTO Patient VALUES (102, '2000-03-10', 'Menzah 6', 'Tunis', 2);


/* Medicines */
INSERT INTO Medicine VALUES (5001, 25.50, 100);
INSERT INTO Medicine VALUES (5002, 10.00, 200);
INSERT INTO Medicine VALUES (5003, 5.75, 150);


/* Bills */
INSERT INTO Bill VALUES (101, 5001, 2, 25.50);
INSERT INTO Bill VALUES (101, 5002, 1, 10.00);
INSERT INTO Bill VALUES (102, 5003, 3, 5.75);


/* =========================================
   OPTIONAL: VIEW FOR TOTAL BILL
========================================= */

CREATE VIEW PatientBillSummary AS
SELECT 
    Patient_id,
    Code,
    Quantity,
    Price,
    (Quantity * Price) AS Total
FROM Bill;