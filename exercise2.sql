-- LINK : https://en.wikibooks.org/wiki/SQL_Exercises/Employee_management
-- 2.1 Select the last name of all employees.
SELECT Employees.LastName
from Employees;
-- 2.2 Select the last name of all employees, without duplicates.
SELECT DISTINCT Employees.Name
from Employees;
-- 2.3 Select all the data of employees whose last name is "Smith".
SELECT *
from Employees
WHERE LastName = 'Smith';
-- 2.4 Select all the data of employees whose last name is "Smith" or "Doe".
SELECT *
from Employees
WHERE LastName IN ('Smith', 'Doe');
-- 2.5 Select all the data of employees that work in department 14.
SELECT *
FROM Employees
WHERE Department = 14;
-- 2.6 Select all the data of employees that work in department 37 or department 77.
SELECT *
FROM Employees
WHERE Department IN (37, 77);
-- 2.7 Select all the data of employees whose last name begins with an "S".
SELECT *
FROM Employees
WHERE LastName regexp '^S.*';
-- 2.8 Select the sum of all the departments' budgets.
SELECT SUM(Departments.Budget)
from Departments;
-- 2.9 Select the number of employees in each department (you only need to show the department code and the number of employees).
SELECT count(1) as num_of_employees, Employees.Department
from Employees
GROUP BY Department;
-- 2.10 Select all the data of employees, including each employee's department's data.
SELECT *
from Employees E
         left join sql_exercise.Departments D on D.Code = E.Department;
-- 2.11 Select the name and last name of each employee, along with the name and budget of the employee's department.
SELECT E.Name, E.LastName, D.Budget, D.Name
from Employees E
         left join sql_exercise.Departments D on D.Code = E.Department;
-- 2.12 Select the name and last name of employees working for departments with a budget greater than $60,000.
SELECT E.Name, E.LastName, D.Budget, D.Name
from Employees E
         left join sql_exercise.Departments D on D.Code = E.Department
WHERE D.Budget >= 60000;
-- 2.13 Select the departments with a budget larger than the average budget of all the departments.
SELECT D2.*
FROM Departments D2
         left join (SELECT AVG(D.Budget) as budget_avg
                    from Departments D) t on True
Where D2.Budget > t.budget_avg;
-- 2.14 Select the names of departments with more than two employees.
SELECT D.*
from Departments D
         left join (select E.Department, count(1) as head_count from Employees E group by E.Department) t
                   on D.Code = t.Department
where head_count > 2;
-- 2.15 Very Important - Select the name and last name of employees working for departments with second lowest budget.
select E.Name, E.LastName
from Employees E
         left join
     (select rank() over (order by D.Budget) as budget_rand, D.Code
      from Departments D) t on E.Department = t.Code
WHERE t.budget_rand = 2;
-- 2.16  Add a new department called "Quality Assurance", with a budget of $40,000 and departmental code 11.
-- And Add an employee called "Mary Moore" in that department, with SSN 847-21-9811.
INSERT INTO Departments (Code, Name, Budget)
VALUES (11, 'Quality Assurance', 40000);
INSERT INTO Employees (SSN, Name, LastName, Department)
VALUES (847219811, 'Mary', 'Moore', 11);
-- 2.17 Reduce the budget of all departments by 10%.
UPDATE Departments
SET Budget = Budget * 0.9
WHERE TRUE;
-- 2.18 Reassign all employees from the Research department (code 77) to the IT department (code 14).
UPDATE Employees
SET Department = 14
WHERE Department = 77;
-- 2.19 Delete from the table all employees in the IT department (code 14).
DELETE
FROM Employees
WHERE Department = 14;
-- 2.20 Delete from the table all employees who work in departments with a budget greater than or equal to $60,000.
DELETE
FROM Employees E
WHERE E.Department IN (SELECT Code
                       from Departments
                       WHERE Budget >= 60000);


-- 2.21 Delete from the table all employees.