USE campus;
SHOW TABLES;

-- 1. How do you retrieve the names and ages of all patients from the patients table?
SELECT 
    *
FROM
    healthcare_dataset;

-- 2. Write a query to find all patients admitted in the year 2024.
SELECT 
    Name, `Date of Admission`
FROM
    healthcare_dataset
WHERE
    EXTRACT(YEAR FROM `Date of Admission`) = 2024;

-- 3. How do you find the average billing amount grouped by age?
WITH CTE AS (
    SELECT Name, Age, `Billing Amount` AS billing_amount,
    CASE WHEN Age BETWEEN 18 AND 35 THEN 'Young_adults'
         WHEN Age BETWEEN 36 AND 55 THEN 'Mid_age_adults'
         ELSE 'Older_adults' END AS AgeGroup
    FROM healthcare_dataset
)
SELECT AgeGroup, ROUND(AVG(billing_amount), 2) AS AVG_billingAmount FROM CTE GROUP BY AgeGroup;

-- 4. Write a query to list all distinct blood types from the patient’s table.
SELECT DISTINCT
    `Blood Type`
FROM
    healthcare_dataset
ORDER BY `Blood Type`

-- 5. Write a query to display the number of male and female patients in the patients’ table.
SELECT Gender, COUNT(*) AS patients_count FROM healthcare_dataset GROUP BY Gender;

-- 6. Retrieve all patients who were admitted for 'Emergency' type admissions.
SELECT * FROM healthcare_dataset WHERE `Admission Type` = 'Emergency';

-- 7. Write a query to find all patients whose name starts with the letter 'L'.
SELECT * FROM healthcare_dataset WHERE LEFT(Name, 1) = 'L';

-- 8. How do you order the patients by their discharge date in descending order?
-- (Assuming you want a query here)
SELECT * FROM healthcare_dataset ORDER BY `Discharge Date` DESC;

-- 9. Write a query to find all patients who have been treated by the doctor 'Matthew Smith'.
SELECT * FROM healthcare_dataset WHERE Doctor = 'Matthew Smith';

-- 10. Write a query to calculate the total billing amount for each patient.
SELECT Name, ROUND(`Billing Amount`, 2) AS total_bill FROM healthcare_dataset GROUP BY Name ORDER BY total_bill DESC;

-- 11. How do you find the count of patients admitted with each medical condition?
SELECT `Medical Condition`, COUNT(*) AS total_count FROM healthcare_dataset GROUP BY `Medical Condition`;

-- 12. Write a query to display patients along with their admission duration (difference between discharge date and admission date).
SELECT Name, DATEDIFF(`Discharge Date`, `Date of Admission`) AS admission_duration FROM healthcare_dataset GROUP BY Name;

-- 13. How do you find the top 5 hospitals with the highest number of admissions?
SELECT Hospital, COUNT(*) AS No_of_admissions FROM healthcare_dataset GROUP BY Hospital ORDER BY No_of_admissions DESC LIMIT 5;

-- 14. Write a query to find all patients admitted for more than 10 days.
SELECT Name FROM (SELECT Name, DATEDIFF(`Discharge Date`, `Date of Admission`) AS admission_duration FROM healthcare_dataset) AS subquery WHERE admission_duration > 10 ORDER BY Name;

-- 15. How do you retrieve patients whose billing amount exceeds the average billing amount?
SELECT Name, ROUND(`Billing Amount`, 2) AS billing_amount FROM healthcare_dataset WHERE `Billing Amount` > (SELECT AVG(`Billing Amount`) FROM healthcare_dataset);

-- 16. Write a query to find the total number of 'Emergency' admissions by each doctor.
SELECT Doctor, COUNT(*) AS Emergency_admissions FROM healthcare_dataset WHERE `Admission Type` = 'Emergency' GROUP BY Doctor;

-- 17. How do you find all patients whose blood type is 'A+' or 'B-' and are above the age of 60?
SELECT Name, `Blood Type`, Age FROM healthcare_dataset WHERE `Blood Type` IN ('A+', 'B-') AND Age > 60;

-- 18. Write a query to update the insurance provider for a specific patient.
UPDATE healthcare_dataset SET `Insurance Provider` = 'Ramesh Singh' WHERE Name = 'Leslie terry';

-- 19. Write a query to find the top 3 most common medical conditions among all patients.
SELECT `Medical Condition`, COUNT(*) AS patient_count FROM healthcare_dataset GROUP BY `Medical Condition` ORDER BY patient_count DESC LIMIT 3;

-- 20. How do you calculate the monthly admission count for each hospital?
SELECT Hospital, MONTHNAME(`Date of Admission`) AS month, COUNT(*) AS admission_count FROM healthcare_dataset GROUP BY Hospital, month ORDER BY admission_count DESC;

-- 21. Write a query to find the patient(s) with the highest billing amount, including ties.
SELECT Name, ROUND(`Billing Amount`, 0) AS Billing_amount FROM (SELECT Name, ROUND(`Billing Amount`, 0) AS Billing_amount, DENSE_RANK() OVER (ORDER BY ROUND(`Billing Amount`, 0) DESC) AS rnk FROM healthcare_dataset) AS highest_billing WHERE rnk = 1;

-- 22. How do you find the average length of stay for patients grouped by their medical condition?
WITH CTE AS (SELECT Name, `Medical Condition`, ABS(DATEDIFF(`Date of Admission`, `Discharge Date`)) AS stay FROM healthcare_dataset)
SELECT Medical_Condition, ROUND(AVG(stay), 0) AS avg_stay_Days FROM CTE GROUP BY Medical_Condition;

-- 23. Write a query to identify trends in patient admission types over the last 5 years.
-- (Assuming you want a query here, add details if needed)

-- 24. How do you find all patients who were prescribed 'Paracetamol' but have inconclusive test results?
SELECT Name, Age, Medication, `Test Results` FROM healthcare_dataset WHERE Medication = 'Paracetamol' AND `Test Results` = 'Inconclusive';

-- 25. Write a query to determine which doctor has the highest patient recovery rate (patients discharged within 7 days).
WITH CTE AS (SELECT Name, Doctor, `Date of Admission`, `Discharge Date`, ABS(DATEDIFF(`Date of Admission`, `Discharge Date`)) AS duration FROM healthcare_dataset)
SELECT Doctor, COUNT(Name) AS within_7days FROM CTE WHERE duration < 7 GROUP BY Doctor ORDER BY within_7days DESC LIMIT 3;

-- 26. How do you calculate the average billing amount per medical condition and find conditions with above-average billing?
SELECT Medication, ROUND(AVG(`Billing Amount`), 2) AS AVG_billingAmount FROM healthcare_dataset GROUP BY Medication HAVING AVG_billingAmount > (SELECT AVG(`Billing Amount`) FROM healthcare_dataset);

-- 27. Write a query to display the number of patients with different blood types admitted each month.
SELECT `Blood Type` AS Blood_type, MONTHNAME(`Date of Admission`) AS month, COUNT(*) AS Patient_count FROM healthcare_dataset GROUP BY Blood_type, month ORDER BY Blood_type, month;

-- 28. How do you identify the top 5 insurance providers by the total amount billed?
SELECT `Insurance Provider`, CONCAT(ROUND(SUM(`Billing Amount`) / 1000000, 2), ' Million') AS `Total billing Amount` FROM healthcare_dataset GROUP BY `Insurance Provider` ORDER BY `Total billing Amount` DESC LIMIT 5;

-- 29. Write a query to find patients who have been readmitted within 30 days of their discharge date.
WITH CTE AS (
    SELECT Name, `Date of Admission`, `Discharge Date`, LEAD(`Date of Admission`) OVER (PARTITION BY Name ORDER BY `Date of Admission`) AS next_admission_date FROM healthcare_dataset
)
SELECT Name, DATEDIFF(next_admission_date, `Discharge Date`) AS within_days FROM CTE WHERE next_admission_date IS NOT NULL AND DATEDIFF(next_admission_date, `Discharge Date`) BETWEEN 0 AND 30;

-- 30. Write a query to determine which doctor has handled the highest number of 'Emergency' admissions in the past year.
WITH AVG_duration AS (
    SELECT AVG(DATEDIFF(`Discharge Date`, `Date of Admission`)) AS AVGadmission_duration FROM healthcare_dataset
)
SELECT Name, DATEDIFF(`Discharge Date`, `Date of Admission`) AS admitted_duration FROM healthcare_dataset, AVG_duration WHERE DATEDIFF(`Discharge Date`, `Date of Admission`) > 1.5 * AVGadmission_duration;
