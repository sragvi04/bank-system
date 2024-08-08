\about
SHOW DATABASES;
CREATE DATABASE Bank;
USE bank;
CREATE TABLE Branch(ID INT, Name CHAR(50) UNIQUE, Address CHAR(50), PRIMARY KEY(ID));
CREATE TABLE Customers(ID INT, Branch_ID INT, First_name CHAR(20) NOT NULL, Last_name CHAR(20) NOT NULL, Date_of_birth DATE, Gender CHAR(6), PRIMARY KEY(ID), FOREIGN KEY (Branch_ID) REFERENCES branch(ID) ON UPDATE CASCADE);
CREATE TABLE Accounts(ID INT, Customer_ID INT, Balance CHAR(20), PRIMARY KEY(ID), FOREIGN KEY(Customer_ID) REFERENCES Customers(ID) ON UPDATE CASCADE);
CREATE TABLE Loan(ID INT, Account_ID INT, Base_amount DECIMAL(10,3),Base_interest_rate DECIMAL(10,3),Amount_paid DECIMAL(10,3),Start_date DATE, Due_date DATE, PRIMARY KEY(ID), FOREIGN KEY(Account_ID) REFERENCES Accounts(ID) ON UPDATE CASCADE);
CREATE TABLE Transactions(ID INT,Account_ID INT,Amount DECIMAL(10,3),Descriptions CHAR(100),Transaction_date DATE, PRIMARY KEY(ID), FOREIGN KEY(Account_ID) REFERENCES Accounts(ID) ON UPDATE CASCADE);
SHOW TABLES;
INSERT INTO branch VALUES(1,'State Bank of India','Chennai');
INSERT INTO branch VALUES(2,'Canara Bank','Bangalore');
INSERT INTO branch VALUES(3,'Bank of India','New Delhi');
INSERT INTO branch VALUES(4,'Bank of Maharashtra','Mumbai');
INSERT INTO branch VALUES(5,'HDFC Bank','Hyderabad');
INSERT INTO branch VALUES(6,'ICICI Bank','Bangalore');
INSERT INTO branch VALUES(7,'Axis Bank','Pune');
INSERT INTO customers VALUES(1,1,'Laalu','Prasad','1996-10-07','Male');
INSERT INTO customers VALUES(2,3,'Rangu','Yadav','1998-09-02','Male');
INSERT INTO customers VALUES(3,1,'Samiksha','Naidu','1997-02-17','Female');
INSERT INTO customers VALUES(4,2,'Simon','Joseph','1998-04-26','Male');
INSERT INTO customers VALUES(5,2,'Ananya','Mishra','1996-10-11','Female');
INSERT INTO customers VALUES(6,6,'Sagar','Sharma','1999-05-20','Male');
INSERT INTO customers VALUES(7,5,'Pranavi','Desai','1998-03-03','Female');
INSERT INTO Accounts VALUES(1,1,10000);
INSERT INTO Accounts VALUES(2,2,100);
INSERT INTO Accounts VALUES(3,3,2000);
INSERT INTO Accounts VALUES(4,5,500);
INSERT INTO Accounts VALUES(5,5,20000);
INSERT INTO Accounts VALUES(6,6,3000);
INSERT INTO Accounts VALUES(7,6,200);
INSERT INTO loan VALUES(1,1,1000,5,0,'2020-02-24','2024-10-24');
INSERT INTO loan VALUES(2,4,20000,15,0,'2021-03-04','2026-03-04');
INSERT INTO loan VALUES(3,5,15000,3,1000,'2022-10-11','2024-10-11');
INSERT INTO loan VALUES(4,3,100000,5,20000,'2020-12-12','2024-12-12');
INSERT INTO loan VALUES(5,2,50000,3.5,100,'2022-04-23','2025-04-23');
INSERT INTO loan VALUES(6,5,20000,5,0,'2023-05-14','2025-05-14');
INSERT INTO loan VALUES(7,6,30000,7,2000,'2023-09-08','2026-09-08');
INSERT INTO transactions VALUES(1,1,1000.9,'Success','2024-03-05');
INSERT INTO transactions VALUES(2,2,500,'Success','2024-07-06');
INSERT INTO transactions VALUES(3,5,300.5,'Success','2024-08-02');
INSERT INTO transactions VALUES(4,3,200,'Fail','2024-07-27');
INSERT INTO transactions VALUES(5,4,100.6,'Success','2024-07-23');
INSERT INTO transactions VALUES(6,1,20.35,'Success','2024-06-24');
INSERT INTO transactions VALUES(7,7,1000,'Success','2024-04-19');
INSERT INTO customers VALUES(8,3,'Samiksha','Naidu','1997-02-17','Female');
DELETE FROM customers WHERE ID = 8;

SELECT * FROM accounts;
SELECT * FROM loan;
SELECT * FROM transactions;
SELECT * FROM branch;
SELECT * FROM customers;
SELECT * FROM accounts;
SELECT * FROM loan;
SELECT first_name, last_name 
FROM customers 
WHERE customers.ID IN (
    SELECT ID 
    FROM branch 
    GROUP BY ID 
    HAVING COUNT(*) >= 2
);

SELECT Gender,COUNT(*) AS count 
FROM customers AS c
WHERE c.ID IN( 
    SELECT customer_ID 
    FROM accounts AS a
    WHERE a.ID IN (
        SELECT Account_ID 
        FROM loan AS l))
GROUP BY Gender ORDER BY COUNT DESC;
/*this above query shows that men take more loans*/

SELECT c.first_name, c.last_name 
	FROM customers AS c
	WHERE c.id IN (SELECT a.customer_id
		FROM accounts AS a
		WHERE a.id NOT IN (SELECT l.account_id
				FROM Loan l));
/*this above query shows the customers that have never taken a loan*/
SELECT c.first_name, c.last_name 
	FROM customers AS c
	WHERE c.id IN (SELECT a.customer_id
		FROM accounts AS a
		WHERE a.id IN (SELECT l.account_id
				FROM Loan l
                GROUP BY l.Account_id
                HAVING COUNT(l.ID)>1));
/* this above query shows the customers that have taken more than one loan*/
SELECT c.first_name, c.last_name 
	FROM customers AS c
	WHERE c.id IN (SELECT a.customer_id
		FROM accounts AS a
		WHERE a.id IN (SELECT l.account_id
				FROM Loan l
                WHERE l.Amount_paid=0)
                );
/* this above query shows the people who have not started paying of their loan yet*/
SELECT c.first_name, c.last_name 
	FROM customers AS c
	WHERE c.id NOT IN (SELECT customer_id
		FROM accounts AS cb
        GROUP BY customer_id);  
/* the above query shows the people who have no open accounts*/
SELECT b.Name,b.Address
    FROM branch AS b
    WHERE b.id IN( SELECT c.branch_id
        FROM customers as c
        WHERE c.id IN( SELECT a.customer_id
            FROM accounts as a
            WHERE a.id IN ( SELECT d.account_id
                FROM transactions as d
                WHERE Descriptions='Fail'
            )));
/* the above query shows the banks that have failed transactions*/
