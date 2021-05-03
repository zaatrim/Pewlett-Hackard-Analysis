# ** Pewlett-Hackard-Analysis

## *Project Overview*
Pewlett Hackared is considering offering retirement packages for employees who meet certain criteria. Additionally, the company started to think about which positions need to fill shortly. The number of upcoming retirements will leave thousands of open positions. I need to help Bobby to determine the number of retiring employees per title, and identify employees who are eligible to participate in a mentorship program. Then, I will write a report that summarizes the analysis and helps prepare Bobby’s manager for the “silver tsunami” as many current employees reach retirement age. To help Bobby with this analysis, I will use SQL to import and analyze the Data.    
                  
## *Analysis & Results*
### Analysis
1st step of the analysis, I need to understand the current Data available for us in the CSV files (departments, dept_emp,  For this analysis, dept_manager, employees, salaries, titles) in order to Build the ERD (see below ERD. ERD  helps us in analyzing the relationship between the different Tables).  

  ![EmployeeDB](https://user-images.githubusercontent.com/80013773/116833528-87eadb00-ab6e-11eb-841f-ffa6987eb2d9.png)



 Once I complete the mapping, I will start with the 1st Phase of the analysis: Identifying the Number of Retiring Employees by Title (I will create two tables, Retirement Titles table that holds all the titles of current employees who were born between January 1, 1952 and December 31, 1955 and a count of Retiring employees per Title ). I will create a new SQL Query Names " Employee_Database_Challenge.sql")
  1) to conduct this part of the analysis in need to import the following Tables from the CSV files, Employees table, Titles table. 
  1.1 in the SQL query I will create Employees table, Titles table 
            --Create a new employee Table 
            CREATE TABLE employees (
                emp_no INT NOT NULL,
                birth_date DATE NOT NULL,
                first_name VARCHAR NOT NULL,
                last_name VARCHAR NOT NULL,
                gender VARCHAR NOT NULL,
                hire_date DATE NOT NULL,
                PRIMARY KEY (emp_no)
            );

            --Slecet employee table to check import data

            SELECT *
            FROM employees AS e;

            ----Create a new title Table 

            CREATE TABLE titles (
            emp_no INT NOT NULL,
            title varchar NOT NULL,
            from_date DATE NOT NULL,
            to_date DATE NOT NULL,
            FOREIGN KEY (emp_no) REFERENCES employees (emp_no)
            );
  1.2 Then I will Import the Data from the CSV files to the Created Tables. 
  1.3 In order to get the titles employee Number, First Name, Last Name, Title and from Date and to Date. I need to join the employees' tables with the titles table and save the merged table into a new table Named "Retirement Table"   


            -- Joining employees table and titles tables into retirement_titles
            SELECT
            e.emp_no,
            e.first_name,
            e.last_name, 
            t.title,
            t.from_date,
            t.to_date
            INTO retirement_titles
            FROM employees as e 
            INNER JOIN titles AS t
            ON e.emp_no = t.emp_no
            WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
            ORDER BY emp_no;

            --Slecet rt table to check data
            SELECT *
            FROM retirement_titles AS rt

  1.4 The Retirement table includes duplicate rows, since employees have changed roles, I am interested in using the latest role each employee hold. I will use the Distinct On to clean the table and get the list of employees with the latest title they hold sorted by employee number. the outcome will be a unique list of retiring employees and their titles. see below "Unique_Titles"  

            -- Use Dictinct with Orderby to remove duplicate rows
            SELECT DISTINCT ON (emp_no) emp_no, first_name, last_name, title
            INTO unique_titles
            FROM retirement_titles
            ORDER BY emp_no, to_date DESC;

            SELECT *
            FROM unique_titles
         
  ![UniqueTitles](https://user-images.githubusercontent.com/80013773/116833594-02b3f600-ab6f-11eb-85f4-1203c3abe5c5.png)


  1.5 The last step in this part of the analysis to create a count table that retrieves the number of employees by their most recent job title who are about to retire, I will use the "Unique_titles" table to group the count of # emoplyess per Title. and then I will save it as new Table "retiring_titles" and export it to CSV File  

            -- retrieve the number of employees by their most recent job title who are about to retire
            SELECT COUNT(title), title
            INTO retiring_titles
            FROM unique_titles as ut
            GROUP BY ut.title
            ORDER BY count (title) DESC;

      ![retiringTitles](https://user-images.githubusercontent.com/80013773/116833654-4f97cc80-ab6f-11eb-845d-c6e360583f00.png)

  2) In the 2nd part of the analysis, I need to determine The Employees Eligible for the Mentorship Program ( Final outcome: I will create a mentorship-eligibility table that holds the current employees who were born between January 1, 1965, and December 31, 1965.). for this Part I will import employees, Titles and demp_emp tables.  Then I will merge them into one table Named " mentorship_eligibilty", The table will include only eligible employees (Birth_date Between '1965-01-01' AND '1965-12-31' and filter on the latest title using the distinct function).  
  
            --Create a new Department Employee Table 

            CREATE TABLE dept_emp (
            emp_no INT NOT NULL,
            dept_no varchar NOT NULL,
            from_date DATE NOT NULL,
            to_date DATE NOT NULL,
            FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
            PRIMARY KEY (emp_no)
            );

            SELECT * 
            FROM dept_emp AS de

            SELECT *
            FROM employees AS e;

            SELECT *
            FROM titles AS t;

            -- Joining employees table and titles tables into retirement_titles
            SELECT DISTINCT ON (emp_no)
            e.emp_no,
            e.first_name,
            e.last_name, 
            e.birth_date,
            de.from_date,
            de.to_date,
            t.title
            INTO mentorship_eligibilty
            FROM employees as e 
            INNER JOIN dept_emp AS de
            ON e.emp_no = de.emp_no 
            INNER JOIN titles AS t
            ON e.emp_no = t.emp_no 
            WHERE (de.to_date = '9999-01-01') AND (t.to_date = '9999-01-01') AND (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31') 
            ORDER BY e.emp_no,de.to_date DESC;

 
     ![mentorship](https://user-images.githubusercontent.com/80013773/116833776-ecf30080-ab6f-11eb-8e0b-3bfa1fa22cf3.png)
 
         
### Results
1) Based on Titel Analysis we have 90398 Candidates for Retiring. 38% of total company employees. this a significant retirement hit.
2) 63% of the retirement candidate employees are from Senior Eng. & Senior staff. 
3) Assistant Engineer, Engineer, and staff titles have the highest retirement Perectnage per Title ~ 48-49% out of the total title.   

![Results1](https://user-images.githubusercontent.com/80013773/116833859-5e32b380-ab70-11eb-9a0c-91423efdec18.PNG)

4) Only 1549 Employees qualify for the mentorship program. 

![mentorship candidates](https://user-images.githubusercontent.com/80013773/116833808-1ca20880-ab70-11eb-8ed4-8db70acea961.PNG)

5) Based on the selected criteria for the mentorship program, we won't have enough employees in the pipeline to fill the gaps for the retriments candidates. we can fill only 2% of positions for the retiring employees through the mentorship program. 
 
![mentorship vs  retiring](https://user-images.githubusercontent.com/80013773/116833828-33485f80-ab70-11eb-945f-952677f245be.PNG)


6) Senior Engineers and Senior staff are the top candidates for the mentorship program. representing 70% of total mentorship candidates 

    
## *Summary*
### Advantages
 Without this analysis, Pewlett-Hackard could be surprised by the # of retriment candidates and the number. This analysis help Bobby and the HR management to well prepare for the retriment candidates. The retirement candidates are almost 38% of the total company employees. Bobby could use this analysis to select different criteria or give incentives to stretch the retriment program over a while to allow the company to prepare the HC pipeline for the open positions. if all retirement candidates were to retire today we could only fill 2% through the mentorship program. this will leave a huge gap and a large number of vacant positions within the company.  

