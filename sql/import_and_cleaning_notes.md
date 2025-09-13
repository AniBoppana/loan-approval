Dataset: HMDA 2022 (California subset)
--> Filtered with loan_type: Conventional, FHA, VA & loan_purpose: Home purchase, refinancing
Format: CSV (~320 MB)
Link: https://ffiec.cfpb.gov/data-browser/data/2022?category=states&items=CA&loan_types=1,2,3&loan_purposes=1,2

[Raw Sample](/../data/raw_sample.numbers)
[Processed Sample](/../data/processed_sample.numbers)

Import Method: MySQL (direct import with LOAD DATA LOCAL INFILE)
Reason: MySQL Workbench Table Import Wizard was too slow for ~800k rows, estimated 2 hour upload time
Steps:
1. Created table with predefined schema
2. Used command:
  LOAD DATA LOCAL INFILE '/path/to/hmda_ca_2022.csv'
  INTO TABLE cali_2022
  FIELDS TERMINATED BY ',' 
  ENCLOSED BY '"'
  LINES TERMINATED BY '\n'
  IGNORE 1 ROWS;
3. Verified quality of import and accuracy of pre-filtering (loan_type & loan_purpose)

4. Mapped numerical values to appropriate text for readability with the following create and insert code

  CREATE TABLE loan_type_lookup (
      loan_type INT PRIMARY KEY,
      loan_type_name VARCHAR(100)
  );
  
  INSERT INTO loan_type_lookup VALUES
  (1, 'Conventional'),
  (2, 'FHA-insured'),
  (3, 'VA-guaranteed'),
  (4, 'RHS/FSA-guaranteed');
  
  CREATE TABLE loan_purpose_lookup (
      loan_purpose INT PRIMARY KEY,
      loan_purpose_name VARCHAR(100)
  );
  
  INSERT INTO loan_purpose_lookup VALUES
  (1, 'Home purchase'),
  (2, 'Home improvement'),
  (31, 'Refinancing'),
  (32, 'Cash-out refinancing'),
  (4, 'Other purpose'),
  (5, 'Not applicable');
  
  CREATE TABLE action_taken_lookup (
      action_taken INT PRIMARY KEY,
      action_name VARCHAR(100)
  );
  
  INSERT INTO action_taken_lookup VALUES
  (1, 'Loan originated'),
  (2, 'Application approved but not accepted'),
  (3, 'Application denied'),
  (4, 'Application withdrawn by applicant'),
  (5, 'File closed for incompleteness'),
  (6, 'Purchased loan'),
  (7, 'Preapproval request denied'),
  (8, 'Preapproval request approved but not accepted');
  
  CREATE TABLE occupancy_type_lookup (
      occupancy_type INT PRIMARY KEY,
      occupancy_name VARCHAR(100)
  );
  
  INSERT INTO occupancy_type_lookup VALUES
  (1, 'Principal residence'),
  (2, 'Second residence'),
  (3, 'Investment property');
  
  CREATE TABLE construction_method_lookup (
      construction_method INT PRIMARY KEY,
      construction_name VARCHAR(100)
  );
  
  INSERT INTO construction_method_lookup VALUES
  (1, 'Site-built'),
  (2, 'Manufactured home');
  
  CREATE TABLE purchaser_type_lookup (
      purchaser_type INT PRIMARY KEY,
      purchaser_name VARCHAR(100)
  );
  
  INSERT INTO purchaser_type_lookup VALUES
  (0, 'Not applicable'),
  (1, 'Fannie Mae'),
  (2, 'Ginnie Mae'),
  (3, 'Freddie Mac'),
  (4, 'Farmer Mac'),
  (5, 'Private securitizer'),
  (6, 'Commercial bank, savings bank, or savings association'),
  (71, 'Credit union, mortgage company, or finance company'),
  (72, 'Life insurance company'),
  (8, 'Affiliate institution'),
  (9, 'Other type of purchaser');
  
  CREATE TABLE preapproval_lookup (
      preapproval INT PRIMARY KEY,
      preapproval_name VARCHAR(100)
  );
  
  INSERT INTO preapproval_lookup VALUES
  (1, 'Preapproval requested'),
  (2, 'Preapproval not requested');
  
  CREATE TABLE credit_score_type_lookup (
      applicant_credit_score_type INT PRIMARY KEY,
      credit_score_name VARCHAR(100)
  );
  
  INSERT INTO credit_score_type_lookup VALUES
  (1, 'Equifax Beacon 5.0'),
  (2, 'Experian Fair Isaac'),
  (3, 'FICO Risk Score Classic 04'),
  (4, 'FICO Risk Score Classic 98'),
  (5, 'VantageScore 2.0'),
  (6, 'VantageScore 3.0'),
  (7, 'More than one credit scoring model'),
  (8, 'Other credit scoring model'),
  (9, 'Not applicable'),
  (1111, 'Exempt');

5. Created columns in cali_2022 and used the following joins

  ALTER TABLE cali_2022
      ADD COLUMN loan_type_name VARCHAR(100),
      ADD COLUMN loan_purpose_name VARCHAR(100),
      ADD COLUMN action_name VARCHAR(100),
      ADD COLUMN occupancy_name VARCHAR(100),
      ADD COLUMN construction_name VARCHAR(100),
      ADD COLUMN purchaser_name VARCHAR(100),
      ADD COLUMN preapproval_name VARCHAR(100),
      ADD COLUMN credit_score_name VARCHAR(100);
  
  UPDATE cali_2022 c
  JOIN loan_type_lookup l ON c.loan_type = l.loan_type
  SET c.loan_type_name = l.loan_type_name;
  
  UPDATE cali_2022 c
  JOIN loan_purpose_lookup p ON c.loan_purpose = p.loan_purpose
  SET c.loan_purpose_name = p.loan_purpose_name;
  
  UPDATE cali_2022 c
  JOIN action_taken_lookup a ON c.action_taken = a.action_taken
  SET c.action_name = a.action_name;
  
  UPDATE cali_2022 c
  JOIN occupancy_type_lookup o ON c.occupancy_type = o.occupancy_type
  SET c.occupancy_name = o.occupancy_name;
  
  UPDATE cali_2022 c
  JOIN construction_method_lookup m ON c.construction_method = m.construction_method
  SET c.construction_name = m.construction_name;
  
  UPDATE cali_2022 c
  JOIN purchaser_type_lookup pt ON c.purchaser_type = pt.purchaser_type
  SET c.purchaser_name = pt.purchaser_name;
  
  UPDATE cali_2022 c
  JOIN preapproval_lookup pr ON c.preapproval = pr.preapproval
  SET c.preapproval_name = pr.preapproval_name;
  
  UPDATE cali_2022 c
  JOIN credit_score_type_lookup cs ON c.applicant_credit_score_type = cs.applicant_credit_score_type
  SET c.credit_score_name = cs.credit_score_name;

  6. Final cleanup steps
- Removed rows with county_name IS NULL; ~20k rows deleted
- Mapped values like applicant sex and age
- Converted numeric columns stored as text (like debt_to_income_ratio) to NULL if invalid
- Handled special placeholder values: derived_msa_md = 99999 & applicant_age = 8888/9999 → NULL
- Created midpoint values for ranges in numeric fields (debt_to_income_ratio, applicant_age)
