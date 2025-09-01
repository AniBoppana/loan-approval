-- 1. Loan approval rate by ethnicity 
SELECT 
    applicant_ethnicity_1,
    SUM(CASE
        WHEN action_taken = 1 THEN 1
        ELSE 0
    END) * 1.0 / COUNT(*) AS approval_rate,
    COUNT(*) AS total_applications
FROM
    cali_2022
GROUP BY applicant_ethnicity_1;
