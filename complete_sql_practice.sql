--Part 1: Basic SELECT & Filtering
--👉 Focus: retrieving data, filtering, sorting.
--1. List all employees
select * from Employees;

--2. Show only names
select FirstName,LastName from Employees;

--3. Find employees who work in the IT department.
select * from Departments where DepartmentName = 'IT';

--4. Get employees whose salary is greater than 50,000.
select * from Employees where Salary > 50000;

--5. Show employees hired after 2020-01-01.
select * from Employees where HireDate > '2020-01-01';

--6.Show unique DepartmentID values from Employees.
select distinct DepartmentID as unique_deptid from Employees;

--7. List employees ordered by Salary descending (highest first).
select * from Employees order by Salary desc;

--8.  Show employees whose salary is between 45,000 and 70,000.
select * from Employees where Salary between 45000 and 70000;

--Part 2: Aggregates & Grouping
--👉 Focus: COUNT, SUM, AVG, MIN, MAX, GROUP BY, HAVING
--1.Find total number of employees.
select count(*) as total_emp from Employees;

--2.Get average salary of all employees.
select avg(Salary) as avg_salary from Employees;

--3.Find maximum salary in the company.
select max(Salary) as max_salary from Employees;

--4.Find minimum salary in the company.
select min(Salary) as min_salary from Employees;

--5.Find the sum of all salaries.
select sum(Salary) as total_salary from Employees;

--6.Count how many employees in each department.
select DepartmentID,count(*) as emp_dept from Employees
group by DepartmentID;

--7.Show department and its average salary.
select DepartmentID,avg(Salary) as avg_salary from Employees
group by DepartmentID;

select dept.DepartmentName,avg(emp.Salary) as avg_salary from Departments as dept 
inner join Employees as emp on 
dept.DepartmentID = emp.DepartmentID
group by dept.DepartmentName;

--8.Show departments where average salary > 60,000.
select DepartmentID,AVG(Salary) as avg_salary from Employees  group by DepartmentID
having avg(Salary) > 60000;

--Part 3: Joins
--👉 Focus: combining data from multiple tables.
--Tables: Employees, Departments, Projects

--1.Join Employees with Departments to show FirstName, LastName, DepartmentName.
select emp.FirstName,emp.LastName,dept.DepartmentName from Employees as emp 
inner join Departments as dept on
dept.DepartmentID = emp.DepartmentID

--2. Join Employees and EmployeeProjects to show employee name, project ID, and role.
select emp.FirstName,emp.LastName,empj.ProjectID,empj.Role from Employees as emp 
inner join EmployeeProjects as empj on
empj.EmployeeID = emp.EmployeeID;

--3.Show employee name, project name, department name.
select emp.FirstName,emp.LastName,empj.Role,dept.DepartmentName,pj.ProjectName from Employees as emp 
inner join EmployeeProjects as empj on
empj.EmployeeID = emp.EmployeeID
inner join Departments as dept on
dept.DepartmentID = emp.DepartmentID
join Projects as pj on
pj.ProjectID = empj.ProjectID;

--4.Show employees not assigned to any project.
select emp.* from Employees as emp 
left join EmployeeProjects as empj on
empj.EmployeeID = emp.EmployeeID
where empj.ProjectID is null;

--5.Show department names that have no employees.
select dept.DepartmentName from Employees as emp 
left join Departments as dept on
dept.DepartmentID = emp.DepartmentID
where emp.EmployeeID is  null;

--6.Show project name, budget, department name.
select pj.ProjectName,pj.Budget,dept.DepartmentName from Departments as dept
 join Projects as pj on
dept.DepartmentID = pj.DepartmentID;

--7.How many employees are working on each project?
select pj.ProjectName,count(emp.EmployeeID) as emp_projrcts from Employees as emp 
join EmployeeProjects as empj on
empj.EmployeeID = emp.EmployeeID
left join Projects as pj on
pj.ProjectID= empj.ProjectID
group by pj.ProjectName;

--8.Show employees who belong to departments located in Mumbai
select CONCAT(emp.FirstName,' ',LastName) as full_name,dept.Location from Employees as emp 
left join Departments as dept on
dept.DepartmentID = emp.DepartmentID
where dept.Location = 'Mumbai';

--Part 4: Subqueries
--👉 Focus: using queries inside queries.
--Tables: Employees, Projects, Departments

--1. Find employees earning more than average salary.
select CONCAT(FirstName,' ',LastName) as full_name,Salary from Employees where Salary >(
select AVG(Salary) as avg_salary from Employees);

--2.Find employees with the highest salary in each department.
select emp.FirstName,emp.LastName,emp.Salary,emp.DepartmentID from Employees as emp
 where emp.Salary = (select MAX(emp2.Salary) as highest_salary from Employees as emp2
 where emp.DepartmentID = emp2.DepartmentID
) order by Salary desc;

--3.Show employees working in the department with the highest project budget.
select emp.* From  Employees as emp 
where emp.DepartmentID = (select top 1 dept.DepartmentID from Departments
 as dept 
 join Projects as pj on
 pj.DepartmentID = dept.DepartmentID
group by dept.DepartmentID
order by SUM(pj.Budget) desc
);

--4.Show employees not present in Salaries.
select * from Employees as emp
where emp.EmployeeID not in (
select sal.EmployeeID from Salaries as sal)

--5.Find employees working in departments that manage more than one project.
select emp.*,empj.Role,pj.ProjectName from  Employees as emp
join EmployeeProjects as empj on
empj.EmployeeID = emp.EmployeeID
join Projects as pj on 
pj.ProjectID = empj.ProjectID
where emp.DepartmentID in (select dept.DepartmentID from Departments as dept
join Projects as pj on
pj.DepartmentID = dept.DepartmentID
group by dept.DepartmentID
having COUNT(pj.ProjectID) > 1
)order by pj.ProjectName;

--6.Show employees whose salary is greater than all employees in Human Resources.
select emp.*,dept.DepartmentName from Employees as emp
join Departments as dept on 
dept.DepartmentID = emp.DepartmentID
where emp.Salary > all (
select emp2.Salary from Employees as emp2
join Departments as dept on 
dept.DepartmentID = emp.DepartmentID
where dept.DepartmentName = 'Human Resources'
) order by emp.Salary desc;

--7.Find employees whose salary is in the top 3 overall.
select * from Employees as emp 
where emp.Salary  in(
select distinct top 3 Salary from Employees
order by Salary desc
)order by emp.Salary desc;

--8.Find employees hired before the earliest hire date in IT.
select emp.* from Employees as emp
where emp.HireDate < (
select min(emp2.HireDate) as earliest_hiredate from Employees as emp2
join Departments as dept on dept.DepartmentID = emp2.DepartmentID
where dept.DepartmentName = 'IT'
) order by emp.Salary desc;

--Part 5: CRUD (Insert, Update, Delete)
--👉 Focus: modifying data.
--Tables: Employees, Departments, Projects, EmployeeProjects, Salaries

--1.Insert new employee → Add Arjun singh to IT with salary 55,000.
insert into Employees(EmployeeID,FirstName,LastName,DepartmentID,Salary,HireDate)
values (12,'Arjun','singh',1,62500,'2023-03-11')

--2.Insert new department → Add Legal department in Pune.
insert into Departments(DepartmentID,DepartmentName,Location)
values (7,'Legal','Pune')

--3.Update salary → Increase salary by 10% for IT employees.
update Employees set Salary = cast(Salary*1.10 as int)
where DepartmentID = 1

--4.Update project budget → Change Ad Campaign budget to 1,000,000.
update Projects set Budget = 1000000
where ProjectName = 'Ad Campaign'

--5.Update department name → Rename HR → Human Resources.
update Departments set DepartmentName = 'Human Resources'
where DepartmentName = 'HR'

--6.Delete old employees → Remove employees hired before 2018.
delete from Employees where HireDate = '2018-01-01';

--7.Delete low-budget projects → Delete projects with budget < 300,000.
delete from Projects where Budget < 300000

--8.Delete empty departments → Delete departments with no employees and no projects.
delete dept from Departments as dept
left join Employees as emp on emp.DepartmentID = dept.DepartmentID
left join Projects as pj on pj.DepartmentID = dept.DepartmentID
where emp.EmployeeID is null and pj.ProjectID is null

--Part 6: Data Cleaning
--👉 Focus: fixing inconsistent data.
--Tables: Employees, Departments, EmployeeProjects

--1.Fill missing salaries → Set salary = 30,000 if NULL.
update Employees set Salary = 30000
where Salary is null

--2.Standardize names → Make FirstName capitalized (Amit, not AMIT).
update Employees set FirstName = CONCAT(
UPPER(LEFT(FirstName,1)),LOWER(right(FirstName,LEN(FirstName)-1)))

--3.Remove spaces → Trim spaces from DepartmentName.
update Departments set DepartmentName = TRIM(DepartmentName)

--4.Fix future dates → Replace HireDate with today if it’s in the future.
update Employees set HireDate = CAST(GETDATE() as date)
where HireDate >  CAST(GETDATE() as date)

--5.Fill missing roles → Replace NULL/blank roles in EmployeeProjects with 'Unknown'.
update EmployeeProjects set Role = 'Unknown'
where role is null

--6.Remove duplicates in Salaries → Keep only the first record.
with rs as (
select *,
ROW_NUMBER() over(partition by EmployeeID,OldSalary,NewSalary,ChangeDate order by SalaryID ) as n
from Salaries
)
delete from rs where n > 1;

--7.Check salary validity → Ensure no employee has salary < 0
select * from Employees
where Salary < 0;

--8.Check hours validity → Ensure no project assignment has negative HoursWorked.
select * from EmployeeProjects 
where HoursWorked < 0;

--Part 7 (Window Functions Basics – 8 questions)

--1.Assign row numbers to employees by hire date.
select *,
ROW_NUMBER() over( order by HireDate ) as rn
from Employees

--2.Rank employees in each department by salary.
select *,
RANK()over(partition by DepartmentID order by Salary)as rn
from Employees

--3.Show top 2 highest paid employees per department.
select top 2 * from (
select *,
RANK()over(partition by DepartmentID order by Salary desc)as rn
from Employees
)t
where rn <= 2
order by DepartmentID,Salary desc;

--4.Calculate running total of salaries ordered by hire date.
select *,sum(Salary) over(order by HireDate) as total_Salary
From Employees

--5.Show average salary per department using AVG() OVER(PARTITION BY ...).
select *,avg(Salary)over(partition by DepartmentID )as avg_salary 
from Employees

--6.Find each employee’s salary vs department average.
select *,avg(Salary)over(partition by DepartmentID )as avg_salary,
Salary - avg(Salary)over(partition by DepartmentID )as diff 
from Employees

--7.Use LAG() to find salary difference compared to previous employee.
select *,lag(Salary)over(partition by DepartmentID order by HireDate)as prev_salary,
Salary - lag(Salary)over(partition by DepartmentID order by HireDate)as diff 
from Employees

--8.Use LEAD() to see next employee’s salary in hire order.
select *,lead(Salary)over(partition by DepartmentID order by HireDate)as upcoming_salary
from Employees

--Part 8 (Interview-style Advanced – 8 questions)

--1.Show employees who earn above department average.
select * from(
select *,AVG(Salary) over(partition by DepartmentID ) as avg_Salary
from Employees) t
where Salary > avg_Salary

--2.Divide employees into salary bands (Low/Medium/High) using CASE.
select *,
case
when Salary < 40000 then 'low'
when Salary between 40000 and 70000 then 'medium'
else 'high'
end as salary_band
from Employees

--3.Find 2nd highest salary in each department.
select top 2 * from(
select *,
RANK()over(partition by DepartmentID order by Salary desc) as rn
from Employees
)t
where rn = 2

--4.Find employees with same salary (duplicates).
select emp.* from Employees as emp 
join(
select Salary from Employees
group by Salary
having COUNT(*) >1)d
on emp.Salary = d.Salary

--5.Get cumulative count of employees by hire year.
select hireyear,
 employee_year,
sum(employee_year)over(order by hireyear) as cumulative_count from(
select YEAR(HireDate) as hireyear,
count(*) as employee_year
from Employees 
group by  YEAR(HireDate)
)t
order by hireyear desc;

--6.Find highest salary per department using MAX() OVER().
select * ,
MAX(Salary)over(partition by DepartmentID) as max_Salary
from Employees

--7.Rank departments by average salary.
select DepartmentID,AVG(Salary) as avg_salary,
rank()over( order by avg(salary) desc) as dept_rank
from Employees
group by DepartmentID;

