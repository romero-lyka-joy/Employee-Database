-- What is the average training cost for employees in each job title?
SELECT
	job_title,
	ROUND((AVG(training_cost)), 2) AS  avg_training_cost
FROM employees
JOIN tnd
ON employees.emp_id = tnd.emp_id
GROUP BY job_title
ORDER BY avg_training_cost DESC


-- What is the average training cost for each department?
SELECT
	department_type,
	ROUND((AVG(training_cost)), 2) AS  avg_training_cost
FROM employees
JOIN tnd
ON employees.emp_id = tnd.emp_id
GROUP BY department_type
ORDER BY avg_training_cost DESC

-- What is the average training cost for each training program?
SELECT
	training_program,
	COUNT(emp_id) as number_of_trainees,
	ROUND((AVG(training_cost)),2) total_training_cost,
	ROUND(((ROUND((AVG(training_cost)),2)) /(COUNT(emp_id))),2) AS avg_cost_per_employee
FROM tnd
GROUP BY training_program
ORDER BY avg_cost_per_employee DESC

--Training Outcomes based on Training Program
SELECT 
    training_program,
	CAST(((SUM(CASE WHEN training_outcome = 'Passed' THEN 1 ELSE 0 END)) * 100.0 / COUNT(*)) AS DECIMAL(10, 2)) as num_of_passed,
	CAST(((SUM(CASE WHEN training_outcome = 'Failed' THEN 1 ELSE 0 END)) * 100.0 / COUNT(*)) AS DECIMAL(10, 2)) as num_of_failed,
	CAST(((SUM(CASE WHEN training_outcome = 'Completed' THEN 1 ELSE 0 END)) * 100.0 / COUNT(*)) AS DECIMAL(10, 2)) as num_of_completed,
	CAST(((SUM(CASE WHEN training_outcome = 'Incomplete' THEN 1 ELSE 0 END)) * 100.0 / COUNT(*)) AS DECIMAL(10, 2)) as num_of_inc
FROM tnd
GROUP BY training_program;

--Training Outcomes Based on Department
SELECT 
    department_type,
	CAST(((SUM(CASE WHEN training_outcome = 'Passed' THEN 1 ELSE 0 END)) * 100.0 / COUNT(*)) AS DECIMAL(10, 2)) as rate_of_passed,
	CAST(((SUM(CASE WHEN training_outcome = 'Failed' THEN 1 ELSE 0 END)) * 100.0 / COUNT(*)) AS DECIMAL(10, 2)) as rate_of_failed,
	CAST(((SUM(CASE WHEN training_outcome = 'Completed' THEN 1 ELSE 0 END)) * 100.0 / COUNT(*)) AS DECIMAL(10, 2)) as rate_of_completed,
	CAST(((SUM(CASE WHEN training_outcome = 'Incomplete' THEN 1 ELSE 0 END)) * 100.0 / COUNT(*)) AS DECIMAL(10, 2)) as rate_of_incomplete
FROM tnd
JOIN employees ON tnd.emp_id = employees.emp_id
GROUP BY department_type;

-- Average Training Outcomes per Employee Rating
SELECT 
    current_employee_rating,
    CAST(((SUM(CASE WHEN training_outcome = 'Passed' THEN 1 ELSE 0 END)) * 100.0 / COUNT(*)) AS DECIMAL(10, 2)) AS rate_of_passed,
    CAST(((SUM(CASE WHEN training_outcome = 'Failed' THEN 1 ELSE 0 END)) * 100.0 / COUNT(*)) AS DECIMAL(10, 2)) AS rate_of_failed,
    CAST(((SUM(CASE WHEN training_outcome = 'Completed' THEN 1 ELSE 0 END)) * 100.0 / COUNT(*)) AS DECIMAL(10, 2)) AS rate_of_completed,
    CAST(((SUM(CASE WHEN training_outcome = 'Incomplete' THEN 1 ELSE 0 END)) * 100.0 / COUNT(*)) AS DECIMAL(10, 2)) AS rate_of_incomplete
FROM tnd
JOIN employees ON tnd.emp_id = employees.emp_id
GROUP BY current_employee_rating
ORDER BY current_employee_rating DESC 

--Average Training Outcomes Per Job Title
SELECT 
    job_title,
    CAST(((SUM(CASE WHEN training_outcome = 'Passed' THEN 1 ELSE 0 END)) * 100.0 / COUNT(*)) AS DECIMAL(10, 2)) AS rate_of_passed,
	CAST(((SUM(CASE WHEN training_outcome = 'Failed' THEN 1 ELSE 0 END)) * 100.0 / COUNT(*)) AS DECIMAL(10, 2)) AS rate_of_failed,
	CAST(((SUM(CASE WHEN training_outcome = 'Completed' THEN 1 ELSE 0 END)) * 100.0 / COUNT(*)) AS DECIMAL(10, 2)) AS rate_of_completed,
    CAST(((SUM(CASE WHEN training_outcome = 'Incomplete' THEN 1 ELSE 0 END)) * 100.0 / COUNT(*)) AS DECIMAL(10, 2)) AS rate_of_incomplete
FROM tnd
JOIN employees ON tnd.emp_id = employees.emp_id
GROUP BY job_title
ORDER BY rate_of_failed DESC
-----Notable observation: IT Manager Infra has the highest failed rate and 0 passing rate


--Avg rating of IT Managers
SELECT
	AVG(current_employee_rating) as avg_rating_of_it_manager
FROM employees
WHERE job_title = 'IT Manager - Infra'
-----Their current average employee rating is 3.


--More about the training programs IT Managers went through
SELECT
	training_program,
	trainer,
	training_duration,
	CAST (training_cost AS DECIMAL(10,2)) as training_cost,
	employees.emp_id,
	training_date,
	current_employee_rating,
	performance_score,
	training_outcome
FROM tnd
JOIN employees ON tnd.emp_id = employees.emp_id
WHERE job_title = 'IT Manager - Infra'
ORDER BY training_program


--President & CEO + CIO
SELECT
	job_title,
	first_name,
	last_name,
	training_program,
	trainer,
	training_duration,
	CAST (training_cost AS DECIMAL(10,2)) as training_cost,
	employees.emp_id,
	training_date,
	current_employee_rating,
	performance_score,
	training_outcome
FROM tnd
JOIN employees ON tnd.emp_id = employees.emp_id
WHERE job_title = 'President & CEO' OR job_title = 'CIO' 
ORDER BY training_program

--Compare the training outcomes of External versus Internal Training
SELECT
	training_type,
    CAST(((SUM(CASE WHEN training_outcome = 'Passed' THEN 1 ELSE 0 END)) * 100.0 / COUNT(*)) AS DECIMAL(10, 2)) AS rate_of_passed,
	CAST(((SUM(CASE WHEN training_outcome = 'Failed' THEN 1 ELSE 0 END)) * 100.0 / COUNT(*)) AS DECIMAL(10, 2)) AS rate_of_failed,
	CAST(((SUM(CASE WHEN training_outcome = 'Completed' THEN 1 ELSE 0 END)) * 100.0 / COUNT(*)) AS DECIMAL(10, 2)) AS rate_of_completed,
    CAST(((SUM(CASE WHEN training_outcome = 'Incomplete' THEN 1 ELSE 0 END)) * 100.0 / COUNT(*)) AS DECIMAL(10, 2)) AS rate_of_incomplete
FROM tnd
GROUP BY training_type

--Compare the training outcomes between 2022 and 2023
SELECT
	YEAR(training_date) as year,
	CAST(((SUM(CASE WHEN training_outcome = 'Passed' THEN 1 ELSE 0 END)) * 100.0 / COUNT(*)) AS DECIMAL(10, 2)) AS rate_of_passed,
	CAST(((SUM(CASE WHEN training_outcome = 'Failed' THEN 1 ELSE 0 END)) * 100.0 / COUNT(*)) AS DECIMAL(10, 2)) AS rate_of_failed,
	CAST(((SUM(CASE WHEN training_outcome = 'Completed' THEN 1 ELSE 0 END)) * 100.0 / COUNT(*)) AS DECIMAL(10, 2)) AS rate_of_completed,
    CAST(((SUM(CASE WHEN training_outcome = 'Incomplete' THEN 1 ELSE 0 END)) * 100.0 / COUNT(*)) AS DECIMAL(10, 2)) AS rate_of_incomplete
FROM tnd
GROUP BY YEAR(training_date)