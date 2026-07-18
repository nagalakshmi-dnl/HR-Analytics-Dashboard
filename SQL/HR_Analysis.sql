CREATE DATABASE hr_analytics;

USE hr_analytics;

SELECT DATABASE();

/* Check Total Records*/ 

SELECT COUNT(*) AS Total_Records
FROM hr_employee_data;

/*Check Table Structure*/

DESCRIBE hr_employee_data;

/*Preview the Data*/

SELECT *
FROM hr_employee_data
LIMIT 10;

/*check the date format*/

SELECT JoiningDate, LastLeaveDate
FROM hr_employee_data
LIMIT 10;

/*Convert the Date Columns*/

ALTER TABLE hr_employee_data
MODIFY COLUMN JoiningDate DATE;

ALTER TABLE hr_employee_data
MODIFY COLUMN LastLeaveDate DATE;

DESCRIBE hr_employee_data;

/*Check Data Quality*/

/*Check for NULL values*/

SELECT
SUM(EmployeeID IS NULL) AS EmployeeID,
SUM(Name IS NULL) AS Name,
SUM(Gender IS NULL) AS Gender,
SUM(Age IS NULL) AS Age,
SUM(Department IS NULL) AS Department,
SUM(JobRole IS NULL) AS JobRole,
SUM(EducationLevel IS NULL) AS EducationLevel,
SUM(JoiningDate IS NULL) AS JoiningDate,
SUM(Country IS NULL) AS Country,
SUM(MonthlySalary IS NULL) AS MonthlySalary,
SUM(ProjectsHandled IS NULL) AS ProjectsHandled,
SUM(TrainingHours IS NULL) AS TrainingHours,
SUM(PerformanceRating IS NULL) AS PerformanceRating,
SUM(AttritionRisk IS NULL) AS AttritionRisk
FROM hr_employee_data;

/*Check Duplicate Employee IDs*/

SELECT EmployeeID,
COUNT(*) AS Duplicate_Count
FROM hr_employee_data
GROUP BY EmployeeID
HAVING COUNT(*) > 1;

/*Verify Distinct Departments*/

SELECT DISTINCT Department
FROM hr_employee_data
ORDER BY Department;

/*Verify Attrition Values*/

SELECT AttritionRisk,
COUNT(*) AS Employees
FROM hr_employee_data
GROUP BY AttritionRisk;

/*Employee Distribution by Department*/

SELECT Department,
COUNT(*) AS Employees
FROM hr_employee_data
GROUP BY Department
ORDER BY Employees DESC;


/*Gender Distribution*/

SELECT Gender,
COUNT(*) AS Employees
FROM hr_employee_data
GROUP BY Gender;

/*Average Salary by Department*/

SELECT Department,
ROUND(AVG(MonthlySalary),2) AS Avg_Salary
FROM hr_employee_data
GROUP BY Department
ORDER BY Avg_Salary DESC;

/*Average Performance Rating by Department*/

SELECT Department,
ROUND(AVG(PerformanceRating),2) AS Avg_Performance
FROM hr_employee_data
GROUP BY Department
ORDER BY Avg_Performance DESC;

/*Attrition by Department*/

SELECT
Department,
SUM(CASE WHEN AttritionRisk='Yes' THEN 1 ELSE 0 END) AS Attrition_Count,
COUNT(*) AS Total_Employees,
ROUND(
SUM(CASE WHEN AttritionRisk='Yes' THEN 1 ELSE 0 END)
*100.0/COUNT(*),2
) AS Attrition_Rate
FROM hr_employee_data
GROUP BY Department
ORDER BY Attrition_Rate DESC;

/*Average Work-Life Balance*/

SELECT
ROUND(AVG(WorkLifeBalanceScore),2) AS Avg_WorkLifeBalance
FROM hr_employee_data;

/*Average Customer Satisfaction*/

SELECT
ROUND(AVG(CustomerSatisfaction),2) AS Avg_CustomerSatisfaction
FROM hr_employee_data;

/*Average Years at Company*/

SELECT
ROUND(AVG(YearsAtCompany),2) AS Avg_Years
FROM hr_employee_data;

/*Create SQL Features for Power BI*/

/*Create Age Group*/

ALTER TABLE hr_employee_data
ADD COLUMN AgeGroup VARCHAR(20);

SET SQL_SAFE_UPDATES = 0;

UPDATE hr_employee_data
SET AgeGroup =
CASE
    WHEN Age < 25 THEN 'Under 25'
    WHEN Age BETWEEN 25 AND 34 THEN '25-34'
    WHEN Age BETWEEN 35 AND 44 THEN '35-44'
    WHEN Age BETWEEN 45 AND 54 THEN '45-54'
    ELSE '55+'
END
WHERE EmployeeID IS NOT NULL;

SELECT AgeGroup, COUNT(*)
FROM hr_employee_data
GROUP BY AgeGroup;

/*Create Salary Band*/

ALTER TABLE hr_employee_data
ADD COLUMN SalaryBand VARCHAR(20);

UPDATE hr_employee_data
SET SalaryBand =
CASE
    WHEN MonthlySalary < 5000 THEN 'Low'
    WHEN MonthlySalary BETWEEN 5000 AND 8000 THEN 'Medium'
    ELSE 'High'
END;

SELECT SalaryBand, COUNT(*)
FROM hr_employee_data
GROUP BY SalaryBand;

/*Create Performance Category*/

ALTER TABLE hr_employee_data
ADD COLUMN PerformanceCategory VARCHAR(20);

UPDATE hr_employee_data
SET PerformanceCategory =
CASE
    WHEN PerformanceRating <= 2 THEN 'Low'
    WHEN PerformanceRating = 3 THEN 'Average'
    ELSE 'High'
END;

SELECT PerformanceCategory, COUNT(*)
FROM hr_employee_data
GROUP BY PerformanceCategory;

/*Extract Joining Year*/

ALTER TABLE hr_employee_data
ADD COLUMN JoiningYear INT;

UPDATE hr_employee_data
SET JoiningYear = YEAR(JoiningDate);

SELECT JoiningYear, COUNT(*)
FROM hr_employee_data
GROUP BY JoiningYear
ORDER BY JoiningYear;

/*Extract Joining Month*/

ALTER TABLE hr_employee_data
ADD COLUMN JoiningMonth VARCHAR(15);

UPDATE hr_employee_data
SET JoiningMonth = MONTHNAME(JoiningDate);

SELECT JoiningMonth, COUNT(*)
FROM hr_employee_data
GROUP BY JoiningMonth;

/*Employee Tenure Group*/

ALTER TABLE hr_employee_data
ADD COLUMN TenureGroup VARCHAR(20);

UPDATE hr_employee_data
SET TenureGroup =
CASE
    WHEN YearsAtCompany < 2 THEN '0-2 Years'
    WHEN YearsAtCompany BETWEEN 2 AND 5 THEN '2-5 Years'
    WHEN YearsAtCompany BETWEEN 6 AND 10 THEN '6-10 Years'
    ELSE '10+ Years'
END
WHERE EmployeeID IS NOT NULL;

SELECT TenureGroup, COUNT(*)
FROM hr_employee_data
GROUP BY TenureGroup
ORDER BY
CASE TenureGroup
    WHEN '0-2 Years' THEN 1
    WHEN '2-5 Years' THEN 2
    WHEN '6-10 Years' THEN 3
    ELSE 4
END;

/*Final Structure Check*/

DESCRIBE hr_employee_data;

SET SQL_SAFE_UPDATES = 1;
