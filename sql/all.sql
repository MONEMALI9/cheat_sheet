use Company_SD;
use ITI;
use AdventureWorks2012;
use [SD32-Company];
select * from EMPLOYEE;
select FNAME,LNAME,SALARY,DNO from EMPLOYEE;
select PNAME,PLOCATION,DNUM from PROJECT;
select  FNAME+' '+LNAME as "name" ,SALARY=SALARY*0.10 from EMPLOYEE;
select SSN,FNAME+' '+LNAME as "name" from EMPLOYEE where salary >1000;
select SSN,FNAME+' '+LNAME as "name" from EMPLOYEE where salary >10000;
select FNAME+' '+LNAME as "name" from EMPLOYEE Where SEX='f';
select DNUM,DNAME FROM DEPARTMENTS where MGRSSN=968574;
select PNAME,PNUMBER,PLOCATION FROM PROJECT WHERE DNUM=1;


--/*1. Display the Department id, name and id and the name of its manager.

select Dnum,DNAME ,Fname  from  Departments  INNER JOIN employee  ON MGRSSN = SSN;
--2. Display the name of the departments and the name of the projects under its control.
select DNAME ,PNAME  from  Departments D  INNER JOIN Project P  ON D.DNUM = P.DNUM;
--3. Display the full data about all the dependence associated with the name of the employee they depend on him/her.
SELECT E.FNAME,D.* FROM Employee E INNER JOIN Dependent D ON D.ESSN=E.SSN; 
--4. Display the Id, name and location of the projects in Cairo or Alex city.

SELECT * FROM Project WHERE City IN ('cairo','alex');
--5. Display the Projects full data of the projects with a name starts with "a" letter.
SELECT * FROM Project WHERE pname like 'a%';
--6. display all the employees in department 30 whose salary from 1000 to 2000 LE monthly
select *from Employee where Dno=30 and Salary between 1000 and 2000;
--7. Retrieve the names of all employees in department 10 who works more than or equal10 hours per week on "AL Rabwah" project.
SELECT "FNAME"+"LNAME" AS 'FULL NAME' FROM  Employee INNER JOIN Project ON Dnum =10 AND Pname='AL Rabwah' INNER JOIN Works_for ON Hours>=10;
--8. Find the names of the employees who directly supervised with Kamel Mohamed.

SELECT fname ,lname FROM Employee where Superssn=(select ssn from Employee where fname='kamel'and Lname='mohamed') 
select CONCAT(e1.fname,' ',e1.lname) as 'fullname'
from Employee e1 inner join Employee e2
on e2.fname='kamel'and e2.Lname='mohamed' and e2.ssn=e1.superssn;
--9. Retrieve the names of all employees and the names of the projects they are working on, sorted by the project name.

select fname,lname ,pname from Employee inner join Works_for on ssn=ESSn inner join Project on pno=Pnumber order by Pname;
--10. For each project located in Cairo City , find the project number, the controlling department name ,the department manager last name ,address and birthdate.

select city,pnumber,dname,lname,address,bdate from Project p inner join Departments d on p.city='cairo'and d.dnum=p.dnum inner join Employee on MGRSSN=ssn;
--11. Display All Data of the mangers
select * from Employee e inner join Departments d on d.mgrssn = e.SSN;
--12. Display All Employees data and the data of their dependents even if they have no dependents */

SELECT E.*,D.* 
FROM Employee E 
full outer JOIN Dependent D 
ON D.ESSN=E.SSN; 
insert  into Employee (Fname,Lname,SSN,Bdate,address,Sex,salary,superssn,Dno) values ('mohamed','atef','102672',5/9/1997,'haram','m',3000,112233,30);
insert  into Employee (Fname,Lname,SSN,Bdate,address,Sex,salary,superssn,Dno) values ('mohamed','atef','102672',5/9/1997,'haram','m',3000,112233,30);
update employee set salary=Salary*1.20 where ssn=102672;



--1.	Display (Using Union Function)
--a.	 The name and the gender of the dependence that's gender is Female and depending on Female Employee.
--b.	 And the male dependence that depends on Male Employee.

SELECT Dependent_name ,CONCAT(FNAME,' ',LNAME) as 'employee name'
FROM Dependent d,Employee e
WHERE d.SEX='F'and e.Sex='F'
union
SELECT Dependent_name ,CONCAT(FNAME,' ',LNAME)as 'employee name'
FROM Dependent d,Employee e
WHERE d.SEX='m'and e.Sex='m'


--2.	For each project, list the project name and the total hours per week (for all employees) spent on that project.


--SELECT FNAME,LNAME, PNAME ,SUM(HOURS)  FROM Employee INNER JOIN Works_for ON ESSN=SSN INNER JOIN PROJECT ON PNO=PNUMBER GROUP BY PNAME;

SELECT PNAME ,SUM(HOURS) AS 'TOTAL HOURS'  
FROM  Works_for INNER JOIN PROJECT
ON PNO=PNUMBER 
GROUP BY PNAME;


--3.	Display the data of the department which has the smallest employee ID over all employees' ID.
SELECT min(e.ssn),d.dnum,d.dname
FROM departmentS d inner join Employee e
on d.dnum=e.dno
group by dnum,dname;
--4.	For each department, retrieve the department name and the maximum, minimum and average salary of its employees.
select dname ,AVG(salary)as 'average salary',min(salary) as 'min value',max(salary) as 'max value'
from Departments inner join Employee on dnum=dno group by Dname  ;

--5.	List the last name of all managers who have no dependents.


select fname ,lname from Employee e inner join Departments d on d.mgrssn = e.SSN and MGRSSN not in(select essn from Dependent );



--6.	For each department-- if its average salary is less than the average salary of all employees-- display its number, name and number of its employees.


select dnum,dname,count(ssn)from Departments inner join Employee on dno=Dnum group by dnum, dname having avg(salary)<(select avg (salary) from Employee)
--7.	Retrieve a list of employees and the projects they are working on ordered by department and within each department, ordered alphabetically by last name, first name.

select fname,lname ,pname , Dname from Employee e inner join Departments d on d.Dnum = e.dno inner join Project p on d.dnum = p.dnum order by Dname , fname,lname;


--8.	Try to get the max 2 salaries using subquery
select max(salary)
from Employee
union
select max(salary) 
from Employee
where Salary<(select max(salary) from employee)

--9.	Get the full name of employees that is similar to any dependent name
select concat(fname,' ',lname) 
from Employee
intersect
select dependent_name 
from Dependent
--10.	Try to update all salaries of employees who work in Project ‘Al Rabwah’ by 30% 
update employee 
set salary = Salary*1.3 
where ssn in(select essn from Works_for inner join project on pno=pnumber and Pname='Al Rabwah')



--11.	Display the employee number and name if at least one of them have dependents (use exists keyword) self-study.
select ssn ,CONCAT(fname,' ',lname) 
from Employee 
where exists (select essn from Dependent);

select * from Departments;
--dml--------------------------------------------------------------------------------------------------------
--1.	In the department table insert new department called "DEPT IT" , with id 100, employee with SSN = 112233 as a manager for this department. The start date for this manager is '1-11-2006'
insert 
into Departments(Dname,Dnum,MGRSSN,[MGRStart Date])
values('DEPT IT',100,112233,1-11-2006);



--2.	Do what is required if you know that : Mrs.Noha Mohamed(SSN=968574)  moved to be the manager of the new department (id = 100), and they give you(your SSN =102672) her position (Dept. 20 manager) 

--a.	First try to update her record in the department table
--b.	Update your record to be department 20 manager.
--c.	Update the data of employee number=102660 to be in your teamwork (he will be supervised by you) (your SSN =102672)


update Departments set MGRSSN =968574 where dnum=100;

update Departments set MGRSSN =102672 where dnum=20;

update Employee set Superssn=102672 where ssn=102660;

--3.	Unfortunately the company ended the contract with Mr. Kamel Mohamed (SSN=223344) so try to delete his data from your database in case you know that you will be temporarily in his position.
--Hint: (Check if Mr. Kamel has dependents, works as a department manager, supervises any employees or works in any projects and handle these cases).
delete Dependent where ESSN=223344
delete Works_for where ESSN=223344

update Departments set MGRSSN=102672 where MGRSSN=223344;

update Employee set Superssn = 102672  where Superssn=223344;

delete Employee where SSN=223344


--Part-1: Use ITI DB
--1.	Retrieve number of students who have a value in their age. 

SELECT COUNT(ST_age) from Student;


select st_fname,st_lname 
from student  where St_Age is not null;

--2.	Get all instructors Names without repetition
select  distinct ins_name from Instructor 

--3.	Display student with the following Format (use isNull function)
select s.st_id ,CONCAT(s.st_fname,' ',s.st_lname) as 'full name', d.dept_name as 'department name'
from Student s inner join Department d
on d.dept_id =s.Dept_Id

--4.	Display instructor Name and Department Name 
select ins_name,dept_name
from Instructor i full outer join Department d
on d.Dept_Id=i.Dept_Id


--5.	Display student full name and the name of the course he is taking
--For only courses which have a grade  
select CONCAT(s.st_fname,' ',s.st_lname),c.crs_name ,sc.grade
from student s inner join Stud_Course sc
on s.st_id=sc.St_Id and Grade is not null
inner join  Course c 
on c.Crs_Id=sc.Crs_Id;

--6.	Display number of courses for each topic name

select t.top_name,count(c.top_id) as 'number of courses '
from Topic t inner join Course c 
on t.Top_Id=c.Top_Id
group by t.Top_Name;

--7.	Display max and min salary for instructors
select MAX(salary)from Instructor 
select min(salary)from Instructor 
--8.	Display instructors who have salaries less than the average salary of all instructors.
select ins_name from Instructor where Salary <( select AVG(Salary) from Instructor)

--9.	Display the Department name that contains the instructor who receives the minimum salary.
select dept_name 
from Department d inner join Instructor i 
on d.dept_id= i.Dept_Id and salary = ( select min(Salary) from Instructor)


--10.	 Select max two salaries in instructor table. 
select top(2)salary  
from Instructor
order by Salary

--11.	 Select instructor name and his salary but if there is no salary display instructor bonus. “use one of coalesce Function”

select ins_name, coalesce(salary,0) from Instructor 

--12.	Select Average Salary for instructors 
select  avg(salary)from Instructor 

--13.	Select Student first name and the data of his supervisor 
select y.st_fname,x.* from Student x inner join Student y on y.St_super=x.St_Id;


--14.	Write a query to select the highest two salaries in Each Department for instructors who have salaries. “using one of Ranking Functions”
SELECT * FROM 
(select*, dense_rank()OVER(Partition by dept_id order by salary desc) as rn from instructor ) as table1
where rn<3
--15.	 Write a query to select a random  student from each department.  “using one of Ranking Functions”
SELECT * 
FROM  (select*, row_number()OVER(Partition by dept_id order by newid()
) as rn from student ) 
as sup 
where rn=1


--Part-2: Use AdventureWorks DB

--1.	Display the SalesOrderID, ShipDate of the SalesOrderHearder table (Sales schema) to designate SalesOrders that occurred within the period ‘7/28/2002’ and ‘7/29/2014’
select SalesOrderID, ShipDate
from sales.SalesOrderHeader
where OrderDate between '7/28/2002'and'7/29/2014'

--2.	Display only Products(Production schema) with a StandardCost below $110.00 (show ProductID, Name only)
select * 
from Production.Product 
where StandardCost>110.00

--3.	Display ProductID, Name if its weight is unknown

select ProductID ,name from Production.Product where weight is null;

--4.	 Display all Products with a Silver, Black, or Red Color
select * from Production.Product where color in('silver','black','red');

--5.	 Display any Product with a Name starting with the letter B
select * from Production.Product where name like 'b%';

--6.	Run the following Query
--UPDATE Production.ProductDescription
--SET Description = 'Chromoly steel_High of defects'
--WHERE ProductDescriptionID = 3
--Then write a query that displays any Product description with underscore value in its description.

UPDATE Production.ProductDescription
SET Description = 'Chromoly steel_High of defects'
WHERE ProductDescriptionID = 3


select * from Production.ProductDescription where Description  like '%[_]%';
--7.	Calculate sum of TotalDue for each OrderDate in Sales.SalesOrderHeader table for the period between  '7/1/2001' and '7/31/2014'
select sum(TotalDue)from Sales.SalesOrderHeader where OrderDate between '7/1/2001'and'7/31/2014'

--8.	 Display the Employees HireDate (note no repeated values are allowed)
select distinct hiredate from HumanResources.Employee

--9.	 Calculate the average of the unique ListPrices in the Product table
select AVG(listprice) from Production.Product;

--10.	Display the Product Name and its ListPrice within the values of 100 and 120 the list should has the following format "The [product name] is only! [List price]" (the list will be sorted according to its ListPrice value)
select name as 'product name',listprice as 'list price' from Production.Product where ListPrice between 100 and 120  order by listprice

--11.	

--a)	 Transfer the rowguid ,Name, SalesPersonID, Demographics from Sales.Store table  in a newly created table named [store_Archive] 
--Note: Check your database to see the new table and how many rows in it?  701
--b)	Try the previous query but without transferring the data? 


select rowguid ,Name, SalesPersonID, Demographics into new_table2 from Sales.Store 
select * from new_table

--12.	Using union statement, retrieve the today’s date in different styles
select FORMAT(GETDATE(),'dd-2-yyyy')
UNION
select FORMAT(GETDATE(),'dddd-MMMM-yyyy')
union
select FORMAT(GETDATE(),'ddd-MMM-yyyy')






select @@SERVERNAME

select @@VERSION



create table Department(
deptno varchar(5) primary key,
DeptName varchar(25),
Location loc,

)

create rule r1 as @x in('NY','ds','kw');
create default def1 as 'NY';
sp_addtype loc,'nchar(2)';
sp_bindrule r1,loc;
sp_bindefault def1,loc;

insert into Department(deptno,deptname,Location)values('d3','markiting','kw') 


create table employee (
emp_no int ,
emp_fname varchar(20) not null,
emp_lname varchar(20) not null,
dept_no  varchar (5),
salary int,
constraint c1 primary key(emp_no),
constraint c2 foreign key(dept_no) references department(deptno),
constraint c3 unique(salary),




)

create rule r2 as @x<6000;
sp_bindrule r2,'employee.salary';

insert into employee(emp_no,emp_fname,emp_lname,dept_no,salary)values(225348,'mathew','smith','d3',2500),(10102,'ann','jones','d3',3000)

create table project(
projectno varchar(50) primary key,
projectname varchar(max) not null,
budget int null,
)


insert into employee(emp_no)values(11111)
update employee set emp_no=1111 where emp_no=10102
delete from employee where emp_no=10102
alter table employee add  telephone int;
alter table employee drop column telephone;

--2.	Create the following schema and transfer the following tables to it 
--a.	Company Schema 
--i.	Department table (Programmatically)
--ii.	Project table (visually)
--b.	Human Resource Schema
--i.	  Employee table (Programmatically)

create schema company

alter schema company transfer dbo.department

create schema hr

alter schema hr transfer company.employee

--Write query to display the constraints for the Employee table.
SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS

WHERE TABLE_NAME='Employee'
--Write query to display the constraints for the Employee table.
--4.	Create Synonym for table Employee as Emp and then run the following queries and describe the results
--a.	Select * from Employee
--b.	Select * from [Human Resource].Employee
--c.	Select * from Emp
--d.	Select * from [Human Resource].Emp

create synonym emp for hr.employee
select* from employee

select* from [hr].employee

select * from emp;
select * from [hr].emp;



--5.	Increase the budget of the project where the manager number is 10102 by 10%.
UPDATE company.project
SET budget=budget*1.10
from company.project p inner join works_on w
on w.projectno=p.projectno and w.empno=10102

--6.	Change the name of the department for which the employee named James works.The new department name is Sales.
update company.Department set DeptName='sales'
from company.Department d inner join hr.employee e
on d.deptno=e.dept_no and e.emp_fname='JAMES'

--7.	Change the enter date for the projects for those employees who work in project p1 and belong to department ‘Sales’. The new date is 12.12.2007.
update works_on set enter_date='12.12.2007'
from works_on w inner join hr.employee e
on w.empno=e.emp_no and projectno='p1'
inner join company.Department d 
on dept_no=deptno and DeptName='sales'
--8.	Delete the information in the works_on table for all employees who work for the department located in KW.


delete w from  works_on w inner join hr.employee e 
on e.emp_no=w.empno inner join company.Department d
on e.dept_no=d.deptno and location='KW'




-----------------------------------------day 7------------------------------------------------
--1.	 Create a scalar function that takes date and returns Month name of that date.
create function getmonth(@dates date)
returns varchar(20)
begin 
declare @x varchar(20)
select @x=FORMAT(@dates,'MMMM')
return @x
end

select dbo.getmonth('10/10/2020')

 --2.	 Create a multi-statements table-valued function that takes 2 integers and returns the values between them. 
 create function getvalue12(@x int , @y int)
returns @t table	
			(
			 Z int
			 
			)
	as
	begin
set	@x=@x+1
		while @x<@y
		begin
		
		 
			insert into @t
			select @x
			set @x=@x+1
		end
		 return
		
	end

	Select * from getvalue12(1,5)

	create function 


	--3.	 Create a tabled valued function that takes Student No and returns Department Name with Student full name.
	create function fullname1(@x int)
	returns table 
	as 
	return
	(
	select concat(st_fname,' ',st_lname) as 'full name' ,d.Dept_Name 
	from student s inner join Department d
	on s.dept_id=d.dept_id and st_id=@x
	)

	select * from fullname1(2)

--	4.	Create a scalar function that takes Student ID and returns a message to user 
--a.	If first name and Last name are null then display 'First name & last name are null'
--b.	If First name is null then display 'first name is null'
--c.	If Last name is null then display 'last name is null'
--d.	Else display 'First name & last name are not null'

create function rmessage(@x int)
returns varchar(20)
begin
declare @message varchar(max)
declare @z varchar(max)
declare @y varchar(max)

select @z=st_fname,@y=st_lname from Student where st_id=@x
if(@z is null and @y is null)
set @message='First & last null'

else if(@z is null )
set @message='First name  are null'

else if(@y is null)
set @message='last name are null'
else
set @message='First&last not null'


return @message
end
drop function manager
select dbo.rmessage(13)

select* from student where st_id=13

--5.	Create a function that takes integer which represents
--manager ID and displays department name, Manager Name
--and hiring date 

create function manager(@x int)
returns table
as
return
(
select dept_name,Manager_hiredate,ins_name from instructor inner join Department
on dept_manager=@x and ins_id=Dept_Manager

)

select * from manager(1)

--6.	Create multi-statements table-valued function that takes a string
--If string='first name' returns student first name
--If string='last name' returns student last name 
--If string='full name' returns Full Name from student table 
--Note: Use “ISNULL” function

create function getstuds(@format varchar(max))
returns @t table
(
stname varchar(max)
)
as 
begin
if (@format='first')
insert into @t
select st_fname from student

else if (@format='last')
insert into @t
select st_lname from student

else if (@format='full')
insert into @t
select concat(st_fname,' ',st_lname) from student
return
end


select * from getstuds('first')


--7.	Write a query that returns the Student No and Student first name without the last char

select st_id ,substring(st_fname,1,LEN(st_fname)-1) from student;


select
hierarchyid::GETROOT() as orgpath
,ins_id,ins_name
from
dbo.instructor










----------------------------------------day 8---------------------------------------

--1.	 Create a view that displays student full name, course name if the student has a grade more than 50. 
create view grade
as
select st_fname,st_lname,crs_name 
from student s inner join stud_course sc
on s.st_id=sc.st_id and sc.grade>50
inner join  course c
on c.crs_id=sc.crs_id 

select * from grade

--2.	 Create an Encrypted view that 
--displays manager names 
--and the topics they teach. 
alter view manger
with encryption
as
select ins_name,top_name
from instructor i inner join Department 
on i.ins_id=dept_manager
inner join ins_course ic
on i.ins_id=ic.ins_id 
inner join  course c
on c.crs_id=ic.crs_id
inner join topic t
on t.top_id=c.top_id

select * from manger


--3 Create a view that will display Instructor Name,
--Department Name for the ‘SD’ or ‘Java’ Department 
--“use Schema binding” and describe what is the meaning 
--of Schema Binding

create view ins_name 
with schemabinding
as
select ins_name,dept_name
from dbo.instructor i inner join dbo.department d
on d.dept_id=i.dept_id and d.Dept_Name in ('sd','java')

select * from ins_name

--4 Create a view “V1” that displays student
--data for student who lives in Alex or Cairo. 
--Note: Prevent the users to run the following query 
--Update V1 set st_address=’tanta’
--Where st_address=’alex’;

create view v1
as 
select * from student
where st_address in ('alex','cairo')
with check option


select * from v1

--5.	Create index on column (Hiredate) that 
--allow u to cluster the data in table
--Department. What will happen?


create nonclustered index newindex
on department(Manager_hiredate) 


--6.	Create index that allow u 
--to enter unique ages in student table. 
--What will happen?


create unique index v2
on student(st_age)

--7.	Create temporary table [Session based] on 
--Company DB to save employee name and his today
--task.

create table #company
(
emp_name varchar(max),
today_task varchar(max)

)
--8.	Create a view that will display the project
--name and the number of employees work on it.
--“Use Company DB”

create view project 
as
select p.pname,count(c.essn) as 'count'
from Company_SD.dbo.Works_for  c
inner join Company_SD.dbo.project p
on c.pno=p.pnumber
group by (p.pname)

select * from project

--9.Using Merge statement between the following
--two tables [User ID, Transaction Amount]

merge into last_transaction as l
using daily_transaction as d
on l.id=d.id
when matched then
update  set l.lvalue=d.dvalue
when not matched then
insert values(d.id,d.dvalue);

-------------------------part 2--------------------------------------


--1)	Create view named   “v_clerk” that will 
--display employee#,project#, the date of hiring
--of all the jobs of the type 'Clerk'.

create view v_clerk
as
select e.emp_no,w.projectno 
from 
hr.Employee e inner join Works_on w
on emp_no=empno and w.job='clerk'

select * from v_clerk





--2) Create view named  “v_without_budget” that
--will display all the projects data 
--without budget


 Create view v_without_budget 
 as 
 select projectno,projectname
 from company.project

 select * from v_without_budget 


 --3)	Create view named  “v_count “ that will 
 --display the project name
 --and the # of jobs in it

 Create view v_count 
 as
 select projectname, count(job) as job
 from works_on w inner join company.project p
 on p.projectno=w.projectno
 group by (projectname)

 select * from v_count 

-- 4) Create view named ” v_project_p2” that 
-- will display the emp# s for the project# ‘p2’
--use the previously created view  “v_clerk”


Create view  v_project_p2
as
select emp_no,projectno from v_clerk 
where projectno='p2'


select * from v_project_p2


--5)	modifey the view named  “v_without_budget”
--to display all DATA in project p1 and p2 
alter view v_without_budget
as
select * from v_without_budget 
where projectname in ('p1','p2') 

select * from v_without_budget

--6)	Delete the views  “v_ clerk” and “v_count”

drop view v_clerk,v_count

--7)	Create view that will display the emp# and emp lastname who works on dept# is ‘d2’
create view empp22 
as 
select emp_no ,emp_lname 
from hr.employee inner join company.Department
on dept_no=deptno inner join works_on w
on empno=emp_no inner join company.project p
on w.projectno=p.projectno and p.projectno='p2'

select * from empp22

----1)	Display the employee  lastname that 
--contains letter “J”
----Use the previous view created in Q#7

create view n_emp22
as
select * from empp22 where emp_lname like '%j%'

select * from n_emp22

--9)Create view named “v_dept” that will 
--display the department# and department name
alter view v_dept(dno,dname)
as
select deptno,deptname from company.Department;

select * from v_dept

--10)	using the previous view try enter new 
--department data where dept# is ’d4’ and dept 
--name is ‘Development’

insert into v_dept values('d4','development')

--11)Create view name “v_2006_check” that will 
--display employee#, the project #where he works 
--and the date of joining the project which must
--be from the first of January and the last of
--December 2006.this view will be used to insert
--data so make sure that the coming new data must
--match the condition

alter view v_2006_check(empno,projectn,edate)
as
select empno,projectno,enter_date
from works_on where enter_date between '1-1-2006'and'12-31-2006'
with check option


select * from v_2006_check

--------------------------------------------------------day 9--------------------------------------------------
--1.	Display all the data from the Employee table (HumanResources Schema) 
--As an XML document “Use XML Raw”. “Use Adventure works DB” 
--A)	Elements
--B)	Attributes

select * from HumanResources.employee
for xml raw('employee'),elements,root('employees')


--2.	Display Each Department Name with its instructors. “Use ITI DB”
--A)	Use XML Auto
--B)	Use XML Path

select dept_name ,ins_name 
from instructor,Department
where instructor.dept_id=Department.dept_id
for xml auto

select dept_name "@department" ,ins_name "instructor" 
from instructor,Department
where instructor.dept_id=Department.dept_id
for xml path('employee')





declare @docs xml ='<customers>
              <customer FirstName="Bob" Zipcode="91126">
                     <order ID="12221">Laptop</order>
              </customer>
              <customer FirstName="Judy" Zipcode="23235">
                     <order ID="12221">Workstation</order>
              </customer>
              <customer FirstName="Howard" Zipcode="20009">
                     <order ID="3331122">Laptop</order>
              </customer>
              <customer FirstName="Mary" Zipcode="12345">
                     <order ID="555555">Server</order>
              </customer>
       </customers>'

	   declare @hdocs int
	   exec sp_xml_preparedocument @hdocs output , @docs
	   select * from 
	   openxml(@hdocs,'//customer')
	   with(c_name varchar(max) '@FirstName',

	   zip_code int '@Zipcode',
	   order_id int 'order/@ID',
	   orders varchar(max) 'order'
	   )

	   exec sp_xml_removedocument @hdocs


	   
--4.	Create a stored procedure to show the number of students per department.[use ITI DB] 
create proc students 
as
select Dept_Name as 'department' ,count(st_id)
from student s INNER JOIN Department d
ON s.Dept_Id=d.Dept_Id
group by (Dept_Name)


students


--5.Create a stored procedure that will check
--for the # of employees in the project p1 if
--they are more than 3 print message to the user
--“'The number of employees in the project p1 is
--3 or more'” if they are less display a message
--to the user “'The following employees work for
--the project p1'” in addition to the first name 
--and last name of each one. [Company DB] 
use [SD32-Company]
create proc num_emp
as
declare @x int
select @x=count(emp_no)
from hr.employee e inner join  works_on w
on e.emp_no= w.empno and  projectno='p1'

if (@x>=3)
select 'The number of employees in the project p1 is 3 or more'
else 
select 'The following employees work for the project p1',' '
union
select emp_fname ,emp_lname
from hr.employee e inner join  works_on w
on e.emp_no= w.empno and  projectno='p1'


num_emp


--6.	Create a stored procedure that will be used in case
--there is an old employee has left the project and a new 
--one become instead of him. The procedure should take 3
--parameters (old Emp. number, new Emp. number and the 
--project number) and it will be used to update works_on
--table. [Company DB]




-----------------------------------
create proc employee @new_id int ,@projectno varchar(max),@old_id int 
as 
update works_on set empno=@new_id,projectno=@projectno
where empno=@old_id

employee 5,p2,1
--7.	Create an Audit table with the following structure 
--ProjectNo 	UserName 	ModifiedDate 	Budget_Old 
--Budget_New 
--p2 	Dbo 	2008-01-31	95000 	200000 

--This table will be used to audit the update trials
--on the Budget column (Project table, Company DB)
--Example:
--If a user updated the budget column then the project 
--number, user name that made that update, the date of 
--the modification and the value of the old and the new
--budget will be inserted into the Audit table
--Note: This process will take place only if the user 
--updated the budget column

create table history
(
projectno varchar(max),
username varchar (max),
ModifiedDate  date,
Budget_Old  int,
Budget_New  int

)
create trigger t1
on company.project
for update 
as
if update(projectno)
begin
declare  @pronum varchar(max),@bold int,@bnew int
select @pronum=projectno  from inserted
select @bnew=budget   from inserted
select @bold=budget   from deleted
insert into history values(@pronum,suser_name(),getdate(),@bold,@bnew)
end


update company.project set projectno='p3',projectname='new' ,budget=5000 where projectno='p3'

--8.Create a trigger to prevent anyone from inserting a new 
--record in the Department table [ITI DB]
--“Print a message for user to tell him that he can’t
--insert a new record in that table”

create trigger t2 
on company.department
instead of insert
as
select 'can’t insert a new record in that table'


insert into COMPANY.Department values('d5','sales','NY')



--Create a trigger that prevents the insertion Process
--for Employee table in March [Company DB].
create trigger t3
on hr.employee 
after  insert
as
if (format(getdate(),'MMMM') = 'November')
begin
SELECT' YOU CANNOT INSERT IN November'
delete from hr.employee where emp_no=(select emp_no from inserted)
end





--10. Create a trigger that prevents users from altering
--any table in Company DB.

CREATE TRIGGER t4 
ON DATABASE 
FOR ALTER_TABLE 
AS 
 PRINT 'you can not alter' 
 ROLLBACK;
 
-- DISABLE TRIGGER ALL
--ON DATABASE ;

 drop trigger t4
 alter table works_on add  newc int;

 --11.Create a trigger on student table after insert to
 --add Row in Student Audit table
 --(Server User Name , Date, Note) where note will be 
 --“[username] Insert New Row with Key=[Key Value] 
 --in table [table name]”

 create table student_audit
 (
 server_username varchar(50),
 datee date,
 note varchar(50)
 )

 create trigger st_audit
 on student
 after insert 
 as
 declare @x int
 select  @x =st_id from inserted
 insert into student_audit

 values(suser_name(),getdate(),@x)
 --12.	 Create a trigger on student table instead of delete to add Row in Student Audit table (Server User Name, Date, Note) where note will be“ try to delete Row with Key=[Key Value]”
 create trigger st_audit2
 on student
 instead of delete  
 as
 declare @x int
 select  @x =st_id from inserted
 insert into student_audit

 values(suser_name(),getdate(),@x)


 
 )

 -------------------bones---------------------------





--1.	 Create a scalar function that takes date and returns Month name of that date.
create proc getmonth_proc @dates date 
as
select FORMAT(@dates,'MMMM')


getmonth_proc'10/10/2020'

 --2.	 Create a multi-statements table-valued function that takes 2 integers and returns the values between them. 
 create proc getvalue12_proc @x int , @y int
 as
set	@x=@x+1
		while @x<@y
		begin
		
			select @x
			set @x=@x+1
		
	end

 getvalue12_proc 1,5

	create function 


	--3.	 Create a tabled valued function that takes Student No and returns Department Name with Student full name.
	create proc fullname1_proc @x int
	as

	select concat(st_fname,' ',st_lname) as 'full name' ,d.Dept_Name 
	from student s inner join Department d
	on s.dept_id=d.dept_id and st_id=@x
	

	fullname1_proc 2

--	4.	Create a scalar function that takes Student ID and returns a message to user 
--a.	If first name and Last name are null then display 'First name & last name are null'
--b.	If First name is null then display 'first name is null'
--c.	If Last name is null then display 'last name is null'
--d.	Else display 'First name & last name are not null'

alter proc rmessage_proc @x int
as
declare @message varchar(max)
declare @z varchar(max)
declare @y varchar(max)

select @z=st_fname,@y=st_lname from Student where st_id=@x
if(@z is null and @y is null)
select'First & last null'

else if(@z is null )
select 'First name  are null'

else if(@y is null)
select 'last name are null'
else
select'First&last not null'




rmessage_proc 13

select* from student where st_id=13

--5.	Create a function that takes integer which represents
--manager ID and displays department name, Manager Name
--and hiring date 

create proc manager_proc @x int
as
select dept_name,ins_name from instructor inner join Department
on dept_manager=@x and ins_id=Dept_Manager



manager_proc 1

--6.	Create multi-statements table-valued function that takes a string
--If string='first name' returns student first name
--If string='last name' returns student last name 
--If string='full name' returns Full Name from student table 
--Note: Use “ISNULL” function

create proc getstuds_proc @format varchar(max)
as
if (@format='first')
select st_fname from student

else if (@format='last')

select st_lname from student

else if (@format='full')

select concat(st_fname,' ',st_lname) from student




getstuds_proc'first'




-----------------------------------------day 10 ----------------------------------
 ----1.	Create a cursor for Employee table that
 --increases Employee salary by 10% 
 --if Salary <3000 and increases it by 20%
 --if Salary >=3000. Use company DB

 declare c1 cursor 
 for select Salary
 from instructor
 for update
 declare @x int
 open c1
 fetch c1 into @x
 while @@FETCH_STATUS=0
 begin
 if @x<3000
 
 update Instructor set salary=salary*1.2
 where current of c1
 else
  update Instructor set salary=salary*1.1
 where current of c1

 fetch c1 into @x
 end
 close c1




--2.Display Department name with its manager name using cursor. Use ITI DB
declare c2 cursor
for select ins_name,dept_name
from Instructor i inner join Department d
on i.Ins_Id=d.Dept_Id
for read only
declare @x varchar(50),@y varchar(50)
open c2
fetch c2 into @x,@y
while @@FETCH_STATUS=0
begin
select @x,@y
fetch c2 into @x,@y
end
close c2
deallocate c2



--3.Try to display all students first name in one cell separated by comma. Using Cursor 

declare c3 cursor
for select st_fname 
from Student
for read only
declare @x varchar(50),@y varchar(50)
open c3
fetch c3 into @x
while @@FETCH_STATUS=0
begin
set @y=concat(@y,',',@x)

fetch c3 into @x
end
select @y
close c3
deallocate c3

--4.Create full, differential Backup for SD30_Company DB.
backup database iti
to disk='d/iti'

backup database iti
to disk='d/iti'
with differential


--5.	Use import export wizard to display students data (ITI DB) in excel sheet





--6.	Try to generate script from DB ITI that describes all tables and views in this DB


--7.	Create Snapshot for CompanyDB.
create database itisnap
on
(
name='ITI',
filename='d:\companysnap.ss'

)

as snapshot of ITI

--8.	Create job for backup ITI DB every day at 12:00PM

--9


