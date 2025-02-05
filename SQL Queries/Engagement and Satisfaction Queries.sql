-- Engagement, Satisfaction and Work-Life Balance Based on Employee Status (All Employees)
SELECT
	employee_status,
	AVG(engagement_score) AS avg_engagement_score,
	AVG(satisfaction_score) AS avg_satisfaction_score,
	AVG(worklifebalance_score) AS avg_worklifebalance_score
FROM engagement
JOIN employees	ON engagement.emp_id = employees.emp_id
GROUP BY employee_status;

-- What is the average engagement score, satisfaction score, and work life balance score for each month? (All Employees)
SELECT
	DATENAME(MONTH, survey_date) AS month,
	AVG(engagement_score) AS avg_engagement_score,
	AVG(satisfaction_score) AS avg_satisfaction_score,
	AVG(worklifebalance_score) AS avg_worklifebalance_score
FROM engagement
JOIN employees ON engagement.emp_id = employees.emp_id
GROUP BY DATENAME(MONTH, survey_date), MONTH(survey_date)
ORDER BY MONTH(survey_date);


-- Engagement, Satisfaction and Work-Life Balance Based on Employee Type
SELECT
	employee_type,
	AVG(engagement_score) AS avg_engagement_score,
	AVG(satisfaction_score) AS avg_satisfaction_score,
	AVG(worklifebalance_score) AS avg_worklifebalance_score
FROM engagement
JOIN employees	ON engagement.emp_id = employees.emp_id
WHERE employee_status = 'Active'
GROUP BY employee_type;


-- Engagement, Satisfaction and Work-Life Balance Based on Race (Active Employeesd)
SELECT
	race,
	AVG(engagement_score) AS avg_engagement_score,
	AVG(satisfaction_score) AS avg_satisfaction_score,
	AVG(worklifebalance_score) AS avg_worklifebalance_score
FROM engagement
JOIN employees	ON engagement.emp_id = employees.emp_id
WHERE employee_status = 'Active'
GROUP BY race;

-- Engagement, Satisfaction and Work-Life Balance Based on Tenure (All Employees)
SELECT
	DATEDIFF(year,start_date, ISNULL(exit_date,GETDATE())) as tenure,
	AVG(engagement_score) AS avg_engagement_score,
	AVG(satisfaction_score) AS avg_satisfaction_score,
	AVG(worklifebalance_score) AS avg_worklifebalance_score
FROM employees
JOIN engagement ON employees.emp_id = engagement.emp_id
GROUP BY DATEDIFF(year,start_date, ISNULL(exit_date,GETDATE()));

-- Engagement, Satisfaction and Work-Life Balance Based on Division (Active Employees)
SELECT
	division,
	AVG(engagement_score) AS avg_engagement_score,
	AVG(satisfaction_score) AS avg_satisfaction_score,
	AVG(worklifebalance_score) AS avg_worklifebalance_score
FROM engagement
JOIN employees	ON engagement.emp_id = employees.emp_id
WHERE employee_status = 'Active'
GROUP BY division;

-- Engagement, Satisfaction and Work-Life Balance Based on Termination Type
SELECT
	termination_type,
	AVG(engagement_score) AS avg_engagement_score,
	AVG(satisfaction_score) AS avg_satisfaction_score,
	AVG(worklifebalance_score) AS avg_worklifebalance_score
FROM engagement
JOIN employees	ON engagement.emp_id = employees.emp_id
GROUP BY termination_type;

--Total tally per score range
SELECT
	CASE 
		WHEN (engagement_score + satisfaction_score + worklifebalance_score) BETWEEN 0 AND 5 THEN '0-5'
		WHEN (engagement_score + satisfaction_score + worklifebalance_score) BETWEEN 6 AND 10 THEN '6-10'
		WHEN (engagement_score + satisfaction_score + worklifebalance_score) BETWEEN 11 AND 15 THEN '11-15'
		ELSE 'Others'
	END AS overall_score,
	COUNT(*) AS tally
FROM engagement
GROUP BY
	CASE 
		WHEN (engagement_score + satisfaction_score + worklifebalance_score) BETWEEN 0 AND 5 THEN '0-5'
		WHEN (engagement_score + satisfaction_score + worklifebalance_score) BETWEEN 6 AND 10 THEN '6-10'
		WHEN (engagement_score + satisfaction_score + worklifebalance_score) BETWEEN 11 AND 15 THEN '11-15'
		ELSE 'Others'
	END
ORDER BY tally DESC;

--Tally of Engagement Scores (Bin)
SELECT 
    CASE 
        WHEN engagement_score BETWEEN 0 AND 1 THEN '0-1'
        WHEN engagement_score BETWEEN 2 AND 3 THEN '2-3'
        WHEN engagement_score BETWEEN 4 AND 5 THEN '4-5'
        ELSE 'Others'
    END AS engagement_score,
    COUNT(*) AS tally,
    CAST((COUNT(*) * 100.0) / SUM(COUNT(*)) OVER () AS DECIMAL(10, 2)) AS percentage
FROM engagement
GROUP BY
    CASE 
        WHEN engagement_score BETWEEN 0 AND 1 THEN '0-1'
        WHEN engagement_score BETWEEN 2 AND 3 THEN '2-3'
        WHEN engagement_score BETWEEN 4 AND 5 THEN '4-5'
        ELSE 'Others'
    END
ORDER BY tally DESC;

--Tally of Satisfaction Scores (Bin)
SELECT
	CASE 
		WHEN satisfaction_score BETWEEN 0 AND 1 THEN '0-1'
		WHEN satisfaction_score BETWEEN 2 AND 3 THEN '2-3'
		WHEN satisfaction_score BETWEEN 4 AND 5 THEN '4-5'
		ELSE 'Others'
	END AS satisfaction_score,
	COUNT(*) AS tally,
	CAST(((COUNT(*) * 100.00) / SUM (COUNT(*)) OVER()) AS DECIMAL(10,2)) AS percentage
FROM engagement
GROUP BY
	CASE 
		WHEN satisfaction_score BETWEEN 0 AND 1 THEN '0-1'
		WHEN satisfaction_score BETWEEN 2 AND 3 THEN '2-3'
		WHEN satisfaction_score BETWEEN 4 AND 5 THEN '4-5'
		ELSE 'Others'
	END
ORDER BY tally DESC;

--Tally of Work-life Balance Scores (Bin)
SELECT 
    CASE 
        WHEN worklifebalance_score BETWEEN 0 AND 1 THEN '0-1'
        WHEN worklifebalance_score BETWEEN 2 AND 3 THEN '2-3'
        WHEN worklifebalance_score BETWEEN 4 AND 5 THEN '4-5'
        ELSE 'Others'
    END AS worklifebalance_score,
    COUNT(*) AS tally,
    CAST((COUNT(*) * 100.0) / SUM(COUNT(*)) OVER () AS DECIMAL(10, 2)) AS percentage
FROM engagement
GROUP BY
    CASE 
        WHEN worklifebalance_score BETWEEN 0 AND 1 THEN '0-1'
        WHEN worklifebalance_score BETWEEN 2 AND 3 THEN '2-3'
        WHEN worklifebalance_score BETWEEN 4 AND 5 THEN '4-5'
        ELSE 'Others'
    END
ORDER BY tally DESC;