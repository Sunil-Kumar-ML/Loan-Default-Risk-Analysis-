CREATE DATABASE loanProject;
USE loanProject;

-- Q1A. WHAT IS THE OVERALL DEFAULT RATE? --

SELECT
	COUNT(*) AS total_loans,
    SUM(defaulted) as total_defaults,
    ROUND(SUM(defaulted)/COUNT(*)*100, 2) AS default_percent
FROM loan_applications;


-- Q1B. HOW DOES THE DEFAULT RATE BREAK DOWN BY CREDIT SCORE RANGE (eg. 520-599, 600-649, 650-699, 700-749, 750+) --

SELECT
	CASE
		WHEN bp.credit_score BETWEEN 520 AND 599 THEN '520-599'
        WHEN bp.credit_score BETWEEN 600 AND 649 THEN '600-649'
        WHEN bp.credit_score BETWEEN 650 AND 699 THEN '650-699'
        WHEN bp.credit_score BETWEEN 700 AND 749 THEN '700-749'
        WHEN bp.credit_score >= 750 THEN '750+'
        ELSE 'Below 520'
        END AS credit_score_bucket,
	COUNT(*) AS total_loans,
    SUM(defaulted) as total_defaults,
    ROUND(SUM(defaulted)/COUNT(*)*100, 2) AS default_percent
    FROM loan_applications la
    JOIN borrower_profiles bp
    ON la.borrower_id = bp.borrower_id
    GROUP BY credit_score_bucket
    ORDER BY credit_score_bucket;
    

-- Q2A. IS THERE A RELATIONSHIP BETWEEN A BORROWER'S DEBT-TO-INCOME (DTI) RATIO AND THE LIKELIHOOD OF DEFAULTING? --

SELECT
	CASE 
		WHEN dti_ratio < 20 THEN '0-19'
        WHEN dti_ratio BETWEEN 20 and 29 THEN '20-29'
        WHEN dti_ratio BETWEEN 30 and 39 THEN '30-39'
        WHEN dti_ratio BETWEEN 40 and 49 THEN '40-49'
        ELSE '50+'
        END AS dti_ratio_bucket,
	COUNT(*) AS total_loans,
    SUM(defaulted) as total_defaults,
    ROUND(SUM(defaulted)/COUNT(*)*100, 2) AS default_percent
FROM loan_applications
GROUP BY dti_ratio_bucket
ORDER BY dti_ratio_bucket;


-- Q3A. WHICH LOAN PURPOSES HAVE THE HIGHEST DEFAULT RATES? --

SELECT
	loan_purpose,
    COUNT(*) AS total_loans,
    SUM(defaulted) as total_defaults,
    ROUND(SUM(defaulted)/COUNT(*)*100, 2) AS default_percent
FROM loan_applications
GROUP BY loan_purpose
ORDER BY default_percent DESC;


-- Q3B. DOES THE AVERAGE LOAN AMOUNT DIFFER SIGNIFICANTLY BETWEEN DEFAULTED AND NON-DEFAULTED LOANS? --

SELECT
	defaulted,
    COUNT(*) AS total_loans,
    ROUND(AVG(loan_amount),0) AS avg_loan_amount,
    MIN(loan_amount) AS min_loan,
    MAX(loan_amount) AS max_loan
FROM loan_applications
GROUP BY defaulted;

-- Q4A. HOW DO EMPLOYMENT STATUS AFFECT DEFAULT RISK? --

SELECT
	bp.employment_status,
    COUNT(*) AS total_loans,
    SUM(defaulted) as total_defaults,
    ROUND(SUM(defaulted)/COUNT(*)*100, 2) AS default_percent
FROM loan_applications la
JOIN borrower_profiles bp
ON la.borrower_id = bp.borrower_id
GROUP BY employment_status
ORDER BY default_percent DESC;


-- Q4B. HOW DO YEARS EMPLOYED AFFECT DEFUALT RISK? --

SELECT
	CASE
		WHEN bp.years_employed < 2 THEN '< 2 years'
        WHEN bp.years_employed BETWEEN 2 AND 5 THEN '2-5 years'
        WHEN bp.years_employed BETWEEN 6 AND 10 THEN '6-10 years'
        ELSE '10+ years'
		END AS employment_tenure,
	COUNT(*) AS total_loans,
    SUM(defaulted) as total_defaults,
    ROUND(SUM(defaulted)/COUNT(*)*100, 2) AS default_percent
FROM loan_applications la
JOIN borrower_profiles bp
ON la.borrower_id = bp.borrower_id
GROUP BY employment_tenure
ORDER BY
	CASE employment_tenure
		WHEN '< 2 years' THEN 1
        WHEN '2-5 years' THEN 2
        WHEN '6-10 years' THEN 3
        WHEN '10+ years' THEN 4
        ELSE 5
		END ASC;
        

-- Q4C. ARE BORROWERS WITH LESS THAN 2 YEARS OF EMPLOYMENT MORE LIKELY TO DEFAULT? -- 

SELECT
	CASE
		WHEN bp.years_employed <2 THEN '< 2 years'
        ELSE '2+ years'
        END AS employment_group,
	COUNT(*) AS total_loans,
    SUM(defaulted) as total_defaults,
    ROUND(SUM(defaulted)/COUNT(*)*100, 2) AS default_percent
FROM loan_applications la
JOIN borrower_profiles bp
ON la.borrower_id = bp.borrower_id
GROUP BY employment_group
ORDER BY employment_group;