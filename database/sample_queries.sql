-- Sample queries for testing the database setup

-- Test query 1: Count all patients
SELECT COUNT(*) as total_patients FROM patients;

-- Test query 2: Recent appointments
SELECT 
    p.first_name || ' ' || p.last_name as patient_name,
    a.appointment_date,
    a.appointment_type,
    a.provider_name
FROM appointments a
JOIN patients p ON a.patient_id = p.patient_id
WHERE a.appointment_date >= date('now', '-30 days')
ORDER BY a.appointment_date DESC;

-- Test query 3: Check for duplicates
SELECT 
    first_name, 
    last_name, 
    dob, 
    COUNT(*) as count
FROM patients
GROUP BY first_name, last_name, dob
HAVING COUNT(*) > 1;