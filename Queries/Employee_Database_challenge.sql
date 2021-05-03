--Drop table if it exist 
DROP TABLE employees;

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

--Slecet title table to check import data

SELECT emp_no, title,from_date, to_date
FROM titles AS t
ORDER BY emp_no


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



-- Use Dictinct with Orderby to remove duplicate rows
SELECT DISTINCT ON (emp_no) emp_no, first_name, last_name, title
INTO unique_titles
FROM retirement_titles
ORDER BY emp_no, to_date DESC;

SELECT *
FROM unique_titles


-- retrieve the number of employees by their most recent job title who are about to retire
SELECT COUNT(title), title
INTO retiring_titles
FROM unique_titles as ut
GROUP BY ut.title
ORDER BY count (title) DESC;


SELECT *
FROM employees AS e;

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

