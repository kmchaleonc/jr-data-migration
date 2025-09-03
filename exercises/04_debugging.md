# Exercise 4: Debugging

## Task
This query is supposed to find all cancer patients with upcoming appointments who haven't been seen in over 60 days, but it has several errors. Find and fix the issues.

## Broken Query
```sql
SELECT 
    p.first_name + ' ' + p.last_name AS patient_name,
    d.diagnosis_desc,
    a.appointment_date,
    MAX(a2.appointment_date) AS last_visit
FROM patient p
JOIN diagnoses d ON p.patient_id = d.patient_id
JOIN appointments a ON p.patient_id = a.patient_id
LEFT JOIN appointments a2 ON p.patient_id = a2.patient_id
WHERE a.appointment_date > GETDATE()
    AND a.status = 'Scheduled'
    AND a2.appointment_date < DATEADD(day, -60, GETDATE())
    AND a2.status = 'Completed'
GROUP BY p.first_name, p.last_name
ORDER BY a.appointment_date;
```