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

-- 2. Average loan approval by county code
SELECT 
    CAST(AVG(loan_amount) as decimal(10,2)) AS average_loan_amount, county_code
FROM
    cali_2022
GROUP BY county_code
ORDER BY average_loan_amount DESC;

-- 3. Interest rate distribution by action taken on loan application
SELECT 
    action_taken,
    MIN(interest_rate) AS min_interest_rate,
    MAX(interest_rate) AS max_interest_rate,
    AVG(interest_rate) AS average_interest_rate
FROM
    cali_2022
GROUP BY action_taken
ORDER BY average_interest_rate;
