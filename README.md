# Hospital Management Database

Relational database schema for managing doctors, patients, medicines, and billing. Implements composite and multivalued attributes, foreign key constraints, and cascading rules. Includes a SQL view to automatically calculate billing amounts per line item for each patient.

## Built With

- [MySQL](https://www.mysql.com/) - relational database management system

## Getting Started

### Prerequisites

Make sure you have MySQL installed, then open your MySQL client (MySQL Workbench, DBeaver, or terminal).

### Usage

1. Clone the repo
```
git clone https://github.com/meniarallouchi/hospital-management-db
```

2. Open `hospitaldb.sql` in your MySQL client

3. Run the script, it will automatically:
   - Create the `HospitalDB` database
   - Create all tables
   - Insert sample data
   - Create the billing view

You can also run it from the terminal:
```
mysql -u root -p < hospitaldb.sql
```

## Schema Overview

Table                   | Description
------------------------|---------------------------------------------------------------
`Doctor`                | Stores doctor info with composite name (First, Middle, Last)
`DoctorQualification`   | Multivalued attribute, each doctor's qualifications
`DoctorSpecialization`  | Multivalued attribute, each doctor's specializations
`Patient`               | Stores patient info with composite address (Locality, TownCity)
`Medicine`              | Stores medicine codes, prices, and quantities
`Bill`                  | M:N relationship between patients and medicines

## How It Works

1. Each **Doctor** can have multiple qualifications and specializations stored in separate tables
2. Each **Patient** is assigned to one doctor via a foreign key
3. **Bills** link patients to medicines, storing quantity and price at time of purchase
4. Cascading rules ensure data stays consistent — deleting a doctor sets the patient's FK to NULL, deleting a patient or medicine removes related bill records
5. The `PatientBillSummary` view calculates `Quantity × Price` for each line item automatically

## View

```sql
CREATE VIEW PatientBillSummary AS
SELECT 
    Patient_id,
    Code,
    Quantity,
    Price,
    (Quantity * Price) AS Total
FROM Bill;
```
