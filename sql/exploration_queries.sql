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

-- 4. Number of applications and average property value by age group
SELECT 
	applicant_age,
    COUNT(*) AS number_of_applications,
    CAST(AVG(property_value) as decimal(10,0)) AS avg_property_value
FROM
    cali_2022
GROUP BY applicant_age
ORDER BY number_of_applications DESC;

-- 5. Loan approval rate with and without pre-approval
SELECT 
    preapproval,
    SUM(CASE
        WHEN action_taken = 1 THEN 1
        ELSE 0
    END) / COUNT(*) AS approval_rate
FROM
    cali_2022
GROUP BY preapproval;

-- 6. Loan approval rate by income bracket and race
SELECT 
    applicant_ethnicity_1,
    CASE 
        WHEN income < 50000 THEN 'Low income'
        WHEN income BETWEEN 50000 AND 100000 THEN 'Middle income'
        ELSE 'High income'
    END AS income_group,
    COUNT(CASE WHEN action_taken = 1 THEN 1 END) * 100.0 / COUNT(*) AS success_rate
FROM cali_2022
WHERE income IS NOT NULL
GROUP BY applicant_ethnicity_1, income_group
ORDER BY applicant_ethnicity_1, income_group;

-- 7. Proportion of approved loan amount by county
SELECT 
    county_code,
    SUM(CASE WHEN action_taken = 1 THEN loan_amount ELSE 0 END) AS approved_loan_amount,
    SUM(loan_amount) AS total_loan_amount,
    SUM(CASE WHEN action_taken = 1 THEN loan_amount ELSE 0 END) * 100.0 / SUM(loan_amount) AS percent_approved
FROM cali_2022
GROUP BY county_code
ORDER BY approved_loan_amount DESC;

-- 8. Average applicant interest rate by credit score type
SELECT 
    applicant_credit_score_type,
    AVG(interest_rate) AS avg_interest_rate
FROM
    cali_2022
GROUP BY applicant_credit_score_type
ORDER BY avg_interest_rate DESC;
-- 8. 
