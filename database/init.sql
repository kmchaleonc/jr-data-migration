-- Healthcare Data Migration Interview Database
-- Simulated oncology registry data

-- Drop existing tables if they exist
DROP TABLE IF EXISTS patients;
DROP TABLE IF EXISTS appointments;
DROP TABLE IF EXISTS diagnoses;
DROP TABLE IF EXISTS treatments;
DROP TABLE IF EXISTS legacy_patients;
DROP TABLE IF EXISTS new_patients;
DROP TABLE IF EXISTS migration_audit;

-- Create main tables
CREATE TABLE patients (
    patient_id INTEGER PRIMARY KEY,
    mrn VARCHAR(20) UNIQUE,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    dob DATE,
    ssn VARCHAR(11),
    gender VARCHAR(10),
    phone VARCHAR(20),
    email VARCHAR(100),
    address VARCHAR(200),
    city VARCHAR(50),
    state VARCHAR(2),
    zip VARCHAR(10),
    created_date TIMESTAMP,
    modified_date TIMESTAMP
);

CREATE TABLE appointments (
    appointment_id INTEGER PRIMARY KEY,
    patient_id INTEGER,
    appointment_date DATE,
    appointment_type VARCHAR(50),
    provider_name VARCHAR(100),
    department VARCHAR(50),
    status VARCHAR(20),
    notes TEXT,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
);

CREATE TABLE diagnoses (
    diagnosis_id INTEGER PRIMARY KEY,
    patient_id INTEGER,
    diagnosis_code VARCHAR(20),
    diagnosis_desc VARCHAR(200),
    diagnosis_date DATE,
    stage VARCHAR(10),
    primary_site VARCHAR(100),
    histology_code VARCHAR(10),
    behavior VARCHAR(20),
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
);

CREATE TABLE treatments (
    treatment_id INTEGER PRIMARY KEY,
    patient_id INTEGER,
    treatment_type VARCHAR(50),
    treatment_date DATE,
    treatment_desc VARCHAR(200),
    physician_name VARCHAR(100),
    facility VARCHAR(100),
    outcome VARCHAR(50),
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
);

-- Legacy table for migration exercises
CREATE TABLE legacy_patients (
    id INTEGER PRIMARY KEY,
    med_rec_num VARCHAR(20),
    patient_name VARCHAR(100),
    birth_date VARCHAR(20), -- Intentionally inconsistent format
    social_sec VARCHAR(15),
    sex VARCHAR(1),
    phone_number VARCHAR(30),
    diagnosis_codes VARCHAR(200), -- Comma-separated
    stage_old INTEGER, -- Uses numeric staging
    last_visit VARCHAR(20)
);

-- New table structure for migration
CREATE TABLE new_patients (
    patient_id INTEGER PRIMARY KEY AUTOINCREMENT,
    mrn VARCHAR(20) UNIQUE NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    dob DATE NOT NULL,
    ssn VARCHAR(11),
    gender VARCHAR(10),
    phone VARCHAR(20),
    stage_new VARCHAR(5), -- Uses Roman numerals
    migrated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    migration_source VARCHAR(50)
);

CREATE TABLE migration_audit (
    audit_id INTEGER PRIMARY KEY AUTOINCREMENT,
    table_name VARCHAR(50),
    record_id INTEGER,
    action VARCHAR(20),
    status VARCHAR(20),
    error_message TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert sample data
-- Patients with various data quality issues
INSERT INTO patients (patient_id, mrn, first_name, last_name, dob, ssn, gender, phone, email, address, city, state, zip, created_date, modified_date) VALUES
(1, 'MRN001', 'John', 'Smith', '1965-03-15', '123-45-6789', 'Male', '(555) 123-4567', 'john.smith@email.com', '123 Main St', 'Philadelphia', 'PA', '19101', '2024-01-15 08:00:00', '2024-01-15 08:00:00'),
(2, 'MRN002', 'Maria', 'Garcia', '1972-07-22', '234-56-7890', 'Female', '555-234-5678', 'mgarcia@email.com', '456 Oak Ave', 'Philadelphia', 'PA', '19102', '2024-01-20 09:15:00', '2024-01-20 09:15:00'),
(3, 'MRN003', 'Robert', 'Johnson', '1958-11-03', '345-67-8901', 'Male', '555.345.6789', 'rjohnson@email.com', '789 Pine Rd', 'Philadelphia', 'PA', '19103', '2024-02-01 10:30:00', '2024-02-01 10:30:00'),
(4, 'MRN004', 'Sarah', 'Williams', '1980-05-18', NULL, 'Female', '555-456-7890', NULL, '321 Elm St', 'Camden', 'NJ', '08101', '2024-02-10 11:45:00', '2024-02-10 11:45:00'),
(5, 'MRN005', 'David', 'Brown', '1969-09-30', '456-78-9012', 'Male', '(555)567-8901', 'dbrown@email.com', '654 Maple Dr', 'Philadelphia', 'PA', '19104', '2024-02-15 13:00:00', '2024-02-15 13:00:00'),
-- Duplicate entry (same person, different MRN)
(6, 'MRN006', 'John', 'Smith', '1965-03-15', '123-45-6789', 'Male', '(555) 123-4567', 'j.smith@email.com', '123 Main Street', 'Philadelphia', 'PA', '19101', '2024-02-20 14:15:00', '2024-02-20 14:15:00'),
(7, 'MRN007', 'Lisa', 'Davis', '1975-12-08', '567-89-0123', 'Female', NULL, 'ldavis@email.com', '987 Cedar Ln', 'Philadelphia', 'PA', '19105', '2024-03-01 15:30:00', '2024-03-01 15:30:00'),
(8, 'MRN008', 'Michael', 'Wilson', '1962-04-25', '678-90-1234', 'Male', '555-678-9012', 'mwilson@email.com', '147 Birch Ave', 'Philadelphia', 'PA', '19106', '2024-03-05 16:45:00', '2024-03-05 16:45:00'),
(9, 'MRN009', 'Jennifer', 'Martinez', '1968-08-14', '', 'Female', '555-789-0123', 'jmartinez@email.com', '258 Spruce St', 'Philadelphia', 'PA', '19107', '2024-03-10 08:00:00', '2024-03-10 08:00:00'),
(10, 'MRN010', 'James', 'Anderson', '1955-06-20', '789-01-2345', 'Male', '555-890-1234', NULL, '369 Willow Way', 'Philadelphia', 'PA', '19108', '2024-03-15 09:15:00', '2024-03-15 09:15:00');

-- Appointments (recent and historical)
INSERT INTO appointments (appointment_id, patient_id, appointment_date, appointment_type, provider_name, department, status, notes) VALUES
(1, 1, '2025-08-15', 'Follow-up', 'Dr. Anderson', 'Oncology', 'Completed', 'Routine follow-up'),
(2, 1, '2025-08-01', 'Chemotherapy', 'Dr. Anderson', 'Oncology', 'Completed', 'Cycle 3'),
(3, 2, '2025-08-20', 'Consultation', 'Dr. Brown', 'Oncology', 'Scheduled', NULL),
(4, 3, '2025-08-10', 'Radiation', 'Dr. Chen', 'Radiation Oncology', 'Completed', 'Session 5 of 10'),
(5, 3, '2025-07-15', 'Radiation', 'Dr. Chen', 'Radiation Oncology', 'Completed', 'Session 1 of 10'),
(6, 4, '2025-08-25', 'Surgery Consult', 'Dr. Davis', 'Surgical Oncology', 'Scheduled', 'Pre-op evaluation'),
(7, 5, '2025-06-01', 'Follow-up', 'Dr. Anderson', 'Oncology', 'No Show', NULL),
(8, 6, '2025-08-18', 'Lab Work', 'Nurse Johnson', 'Laboratory', 'Completed', 'CBC, CMP'),
(9, 7, '2025-08-22', 'Follow-up', 'Dr. Brown', 'Oncology', 'Scheduled', NULL),
(10, 8, '2025-07-30', 'Consultation', 'Dr. Anderson', 'Oncology', 'Completed', 'Initial consultation');

-- Diagnoses with various cancer types and stages
INSERT INTO diagnoses (diagnosis_id, patient_id, diagnosis_code, diagnosis_desc, diagnosis_date, stage, primary_site, histology_code, behavior) VALUES
(1, 1, 'C50.9', 'Breast cancer, unspecified', '2024-01-15', 'IIA', 'Breast', '8500/3', 'Malignant'),
(2, 2, 'C25.9', 'Pancreatic cancer', '2024-01-20', 'III', 'Pancreas', '8140/3', 'Malignant'),
(3, 3, 'C61', 'Prostate cancer', '2024-02-01', 'IIB', 'Prostate', '8140/3', 'Malignant'),
(4, 4, 'C18.9', 'Colon cancer', '2024-02-10', 'I', 'Colon', '8140/3', 'Malignant'),
(5, 5, 'C34.1', 'Lung cancer, upper lobe', '2024-02-15', 'IIIA', 'Lung', '8070/3', 'Malignant'),
(6, 6, 'C50.9', 'Breast cancer, unspecified', '2024-02-20', 'IIA', 'Breast', '8500/3', 'Malignant'),
(7, 8, 'C67.9', 'Bladder cancer', '2024-03-05', 'II', 'Bladder', '8120/3', 'Malignant'),
(8, 10, 'C15.9', 'Esophageal cancer', '2024-03-15', 'IVA', 'Esophagus', '8070/3', 'Malignant');

-- Legacy data with inconsistent formats
INSERT INTO legacy_patients (id, med_rec_num, patient_name, birth_date, social_sec, sex, phone_number, diagnosis_codes, stage_old, last_visit) VALUES
(1, 'MRN001', 'Smith, John', '03/15/1965', '123-45-6789', 'M', '(555) 123-4567', 'C50.9,C51.0', 2, '08/15/2025'),
(2, 'MRN002', 'Garcia, Maria', '07-22-1972', '234567890', 'F', '555.234.5678', 'C25.9', 3, '2025-08-20'),
(3, 'MRN-003', 'Johnson, Robert', '11/03/58', '345-67-8901', 'M', '5553456789', 'C61', 2, '08/10/25'),
(4, 'MRN004', 'Williams, Sarah', '1980-05-18', NULL, 'F', '555-456-7890', 'C18.9', 1, '2025-08-25'),
(5, 'MRN005', 'Brown, David', '09/30/1969', '456789012', 'M', '(555)567-8901', 'C34.1', 3, 'August 1, 2025'),
-- Duplicate with different formatting
(6, 'MRN-001-B', 'Smith, John', '03/15/1965', '123456789', 'M', '555-123-4567', 'C50.9', 2, '08/18/2025'),
-- Bad data
(7, '', 'Davis, Lisa', '12/08/1975', '567-89-0123', 'F', '', 'C44.9', NULL, ''),
(8, 'MRN008', 'Wilson, Michael', 'Apr 25, 1962', '67890-1234', 'M', '555.678.9012', '', 2, '07/30/2025');

-- Create indexes for performance
CREATE INDEX idx_patients_mrn ON patients(mrn);
CREATE INDEX idx_patients_ssn ON patients(ssn);
CREATE INDEX idx_appointments_patient ON appointments(patient_id);
CREATE INDEX idx_appointments_date ON appointments(appointment_date);
CREATE INDEX idx_diagnoses_patient ON diagnoses(patient_id);