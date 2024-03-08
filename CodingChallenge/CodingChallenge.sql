CREATE DATABASE CarreerHub

CREATE TABLE Companies(
CompanyID int identity(1,1) primary key,
CompanyName varchar(20),
Location varchar(20))

CREATE TABLE JOBS(
JobID int identity(1,1) primary key,
CompanyID int,
FOREIGN KEY (CompanyID) References Companies(CompanyID) on delete cascade,
Jobtitle VARCHAR(20),
JobDescription varchar(20),
JobLocatiob varchar(20),
Salary decimal(10,2),
JobType varchar(20),
PostedDate datetime)

exec sp_rename 'Jobs.JobLocatiob','JobLocation','Column'

CREATE TABLE Applicants(
ApplicantID int identity(1,1) primary key,
FirstName varchar(20),
LastName varchar(20),
Email varchar(50),
Phone varchar(20),
Resume text)


CREATE TABLE Applications(
ApplicationID int identity(1,1) primary key,
JobID int,
FOREIGN KEY (JobID) REFERENCES Jobs(JobID) on delete cascade,
ApplicantId int,
FOREIGN KEY (ApplicantId) REFERENCES Applicants(ApplicantId) on delete cascade,
ApplicationDate datetime,
Coverletter text)


INSERT INTO Companies (CompanyName, Location) VALUES ('ABC Corporation', 'New York')
INSERT INTO Companies (CompanyName, Location) VALUES ('XYZ Industries', 'Los Angeles')
INSERT INTO Companies (CompanyName, Location) VALUES ('DEF Enterprises', 'Chicago')
INSERT INTO Companies (CompanyName, Location) VALUES ('GHI Limited', 'San Francisco')
INSERT INTO Companies (CompanyName, Location) VALUES ('JKL Co.', 'Seattle')


INSERT INTO Jobs (CompanyID, JobTitle, JobDescription, JobLocation, Salary, JobType, PostedDate) 
VALUES 
    (1, 'Data Analyst', 'Software Engineer', 'New York', 80000.00, 'Full-time', '2024-03-08 09:00:00'),
    (2, 'Software Developer', 'Marketing Specialist', 'Los Angeles', 60000.00, 'Full-time', '2024-03-08 10:00:00'),
    (2, 'Marketing Manager', 'Accountant', 'Chicago', 70000.00, 'Full-time', '2024-03-08 11:00:00'),
    (4, 'Sales Representative', 'Data Analyst', 'San Francisco', 75000.00, 'Full-time', '2024-03-08 12:00:00'),
    (5, 'HR Coordinator', 'Graphic Designer', 'Seattle', 55000.00, 'Part-time', '2024-03-08 13:00:00')



SELECT * FROM JOBS


INSERT INTO Applicants (FirstName, LastName, Email, Phone, Resume) 
VALUES 
('John', 'Doe', 'john.doe@example.com', '123-456-7890', 'abc.txt'),
('Jane', 'Smith', 'jane.smith@example.com', '987-654-3210', 'def.txt'),
('Michael', 'Johnson', 'michael.johnson@example.com', '555-123-4567', 'ghi.txt'),
('Emily', 'Brown', 'emily.brown@example.com', '111-222-3333', 'jkl.txt'),
('Christopher', 'Lee', 'christopher.lee@example.com', '444-555-6666', 'mno.txt');

select * from applicants


INSERT INTO Applications (JobID, ApplicantID, ApplicationDate, Coverletter)
VALUES 
    (1, 1, '2024-03-08 09:00:00', 'I am very interested in the Software Engineer position.'),
    (2, 2, '2024-03-08 10:30:00', 'I am excited about the opportunity to work as a Marketing Specialist.'),
    (1, 2, '2024-03-08 11:45:00', 'I have a strong background in software development'),
    (2, 3, '2024-03-08 13:20:00', 'I am eager to leverage my marketing skills .'),
    (1, 4, '2024-03-08 14:55:00', 'As a software engineer with several years of experience '),
	(4, 5, '2024-03-08 14:55:00', 'As a software engineer with several years of experience ')


---Tasks:

---1. Provide a SQL script that initializes the database for the Job Board scenario “CareerHub”. 
---2. Create tables for Companies, Jobs, Applicants and Applications. 
---3. Define appropriate primary keys, foreign keys, and constraints. 
---4. Ensure the script handles potential errors, such as if the database or tables already exist.

---5. Write an SQL query to count the number of applications received for each job listing in the 
---"Jobs" table. Display the job title and the corresponding application count. Ensure that it lists all 
---jobs, even if they have no applications.
SELECT j.JobID, j.JobTitle, COUNT(a.ApplicationID) AS ApplicationCount
FROM Jobs j
LEFT JOIN Applications a ON j.JobID = a.JobID
GROUP BY j.JobID, j.JobTitle

---6. Develop an SQL query that retrieves job listings from the "Jobs" table within a specified salary 
---range. Allow parameters for the minimum and maximum salary values. Display the job title, 
---company name, location, and salary for each matching job.
DECLARE @MinSalary DECIMAL(10, 2) = 60000
DECLARE @MaxSalary DECIMAL(10, 2) = 80000

SELECT j.JobTitle, c.CompanyName, j.JobLocation, j.Salary
FROM Jobs j
JOIN Companies c ON j.CompanyID = c.CompanyID
WHERE j.Salary BETWEEN @MinSalary AND @MaxSalary

---7. Write an SQL query that retrieves the job application history for a specific applicant. Allow a 
---parameter for the ApplicantID, and return a result set with the job titles, company names, and 
---application dates for all the jobs the applicant has applied to
DECLARE @ApplicantID INT = 2

SELECT j.JobTitle, c.CompanyName, a.ApplicationDate
FROM Applications a
JOIN Jobs j ON a.JobID = j.JobID
JOIN Companies c ON j.CompanyID = c.CompanyID
WHERE a.ApplicantID = @ApplicantID

---8. Create an SQL query that calculates and displays the average salary offered by all companies for 
---job listings in the "Jobs" table. Ensure that the query filters out jobs with a salary of zero.
SELECT AVG(Salary) AS AverageSalary
FROM Jobs
WHERE Salary > 0

---9. Write an SQL query to identify the company that has posted the most job listings. Display the 
---company name along with the count of job listings they have posted. Handle ties if multiple 
---companies have the same maximum count.
SELECT c.CompanyName, COUNT(*) AS JobCount
FROM Companies c
JOIN Jobs j ON c.CompanyID = j.CompanyID
GROUP BY c.CompanyName
ORDER BY COUNT(*) DESC

---10. Find the applicants who have applied for positions in companies located in 'CityX' and have at 
---least 3 years of experience.
ALTER TABLE Applicants ADD Experience int
ALTER TABLE Applicants ADD City varchar(50)
UPDATE Applicants SET Experience = 2 where ApplicantID = 5
UPDATE Applicants SET City = 'Goa' where ApplicantID = 4
SELECT * FROM APPLICANTS

SELECT DISTINCT a.FirstName, a.LastName,c.CompanyName
FROM Applicants a
JOIN Applications ap ON a.ApplicantID = ap.ApplicantID
JOIN Jobs j ON ap.JobID = j.JobID
JOIN Companies c ON j.CompanyID = c.CompanyID
WHERE j.JobLocation = 'New York'
AND Experience >= 3

---11. Retrieve a list of distinct job titles with salaries between $60,000 and $80,000.
SELECT DISTINCT JobTitle
FROM Jobs
WHERE Salary BETWEEN 60000 AND 80000;

---12. Find the jobs that have not received any applications.
SELECT j.JobID, j.JobTitle,a.ApplicationId
FROM Jobs j
LEFT JOIN Applications a ON j.JobID = a.JobID
WHERE a.JobID IS NULL

---13. Retrieve a list of job applicants along with the companies they have applied to and the positions 
---they have applied for.
SELECT a.FirstName, a.LastName, c.CompanyName, j.JobTitle
FROM Applicants a
LEFT JOIN Applications app ON a.ApplicantID = app.ApplicantID
LEFT JOIN Jobs j ON app.JobID = j.JobID
LEFT JOIN Companies c ON j.CompanyID = c.CompanyID

---14. Retrieve a list of companies along with the count of jobs they have posted, even if they have not 
---received any applications.
SELECT c.CompanyName, COUNT(j.JobID) AS JobCount
FROM Companies c
LEFT JOIN Jobs j ON c.CompanyID = j.CompanyID
GROUP BY c.CompanyName

---15. List all applicants along with the companies and positions they have applied for, including those 
---who have not applied.
SELECT a.FirstName, a.LastName, c.CompanyName, j.JobTitle
FROM Applicants a
CROSS JOIN Companies c
LEFT JOIN Applications app ON a.ApplicantID = app.ApplicantID
LEFT JOIN Jobs j ON app.JobID = j.JobID AND j.CompanyID = c.CompanyID

---16. Find companies that have posted jobs with a salary higher than the average salary of all jobs.
SELECT DISTINCT c.CompanyName
FROM Companies c
JOIN Jobs j ON c.CompanyID = j.CompanyID
WHERE j.Salary > (SELECT AVG(Salary) FROM Jobs)

---17. Display a list of applicants with their names and a concatenated string of their city and state.
ALTER TABLE Applicants ADD State varchar(50)
UPDATE Applicants SET State = 'Vellore' where ApplicantID = 1
UPDATE Applicants SET State = 'Mudaliarpet' where ApplicantID = 2
SELECT * FROM Applicants
SELECT CONCAT(FirstName, ' ', LastName) AS ApplicantName, CONCAT_WS(' ',State, City) AS Location
FROM Applicants

---18. Retrieve a list of jobs with titles containing either 'Developer' or 'Engineer'.
SELECT * FROM Jobs
WHERE JobTitle LIKE '%Developer%' OR JobTitle LIKE '%Engineer%'

---19. Retrieve a list of applicants and the jobs they have applied for, including those who have not 
---applied and jobs without applicants.
SELECT a.FirstName, a.LastName, j.JobTitle, c.CompanyName
FROM Applicants a
CROSS JOIN Jobs j
LEFT JOIN Applications app ON a.ApplicantID = app.ApplicantID AND j.JobID = app.JobID
LEFT JOIN Companies c ON j.CompanyID = c.CompanyID

---20. List all combinations of applicants and companies where the company is in a specific city and the 
---applicant has more than 2 years of experience. For example: city=Chennai

SELECT a.FirstName, a.LastName, c.CompanyName
FROM Applicants a
CROSS JOIN Companies c
JOIN Jobs as j ON c.CompanyID = j.CompanyId
WHERE j.JobLocation = 'New York' AND Experience > 2
