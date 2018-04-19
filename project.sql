SPOOL project.out
SET ECHO ON
/*
CIS 353 - Database Design Project
Edric Lin
Emilio Braun
Aaron Bager
*/
--
DROP TABLE Member CASCADE CONSTRAINTS;
DROP TABLE Employee CASCADE CONSTRAINTS;
DROP TABLE Job CASCADE CONSTRAINTS;
DROP TABLE Department CASCADE CONSTRAINTS;
DROP TABLE Product CASCADE CONSTRAINTS;
DROP TABLE Supplier CASCADE CONSTRAINTS;
DROP TABLE Transaction CASCADE CONSTRAINTS;
DROP TABLE MPhone CASCADE CONSTRAINTS;
DROP TABLE EPhone CASCADE CONSTRAINTS;
DROP TABLE Prod_Trans CASCADE CONSTRAINTS;
--
CREATE TABLE Member
(
mID 		INTEGER,
mFirst 		VARCHAR2(15) 	NOT NULL,
mLast 		VARCHAR2(15) 	NOT NULL,
mAddress 	VARCHAR2(30) 	NOT NULL,
mFee 		INTEGER 	NOT NULL,
mType 		CHAR(1) 	NOT NULL,
a_mID 		INTEGER,
--
CONSTRAINT mIC01 PRIMARY KEY (mid),
CONSTRAINT mIC02 FOREIGN KEY (a_mID) 
	REFERENCES Member(mID)
	ON DELETE SET NULL
	DEFERRABLE INITIALLY DEFERRED,
CONSTRAINT mIC03 CHECK (mFee = 100 OR mFee = 80),
CONSTRAINT mIC04 CHECK (mType = 'P' OR mType = 'A'),
CONSTRAINT mIC05 CHECK (NOT (mType = 'P' AND NOT (mFee = 100))),
CONSTRAINT mIC06 CHECK (NOT (mType = 'A' AND NOT (mFee = 80)))
);
--
CREATE TABLE Department
(
dID 		INTEGER,
dName 		VARCHAR2(30) 	NOT NULL,
--
CONSTRAINT dIC01 PRIMARY KEY (dID)
);
--
CREATE TABLE Job
(
jID 		INTEGER,
jName 		VARCHAR2(30) 	NOT NULL,
j_dID 		INTEGER,
--
CONSTRAINT jIC01 PRIMARY KEY (jID),
CONSTRAINT jIC02 FOREIGN KEY (j_dID) 
	REFERENCES Department(dID)
	ON DELETE SET NULL
	DEFERRABLE INITIALLY DEFERRED
);
--
CREATE TABLE Employee
(
eID 		INTEGER,
eFirst 		VARCHAR2(15) 	NOT NULL,
eLast 		VARCHAR2(15) 	NOT NULL,
eAddress 	VARCHAR2(30) 	NOT NULL,
eSalary 	INTEGER 	NOT NULL,
s_eID 		INTEGER,
e_jID 		INTEGER 	NOT NULL,
--
CONSTRAINT eIC01 PRIMARY KEY (eID),
CONSTRAINT eIC02 FOREIGN KEY (s_eID) 
	REFERENCES Employee(eID)
	ON DELETE SET NULL
	DEFERRABLE INITIALLY DEFERRED,
CONSTRAINT eIC03 FOREIGN KEY (e_jID) 
	REFERENCES Job(jID)
	ON DELETE CASCADE
	DEFERRABLE INITIALLY DEFERRED
);
--
CREATE TABLE Supplier
(
sID 		INTEGER,
sName 		VARCHAR2(30) 	NOT NULL,
--
CONSTRAINT sIC01 PRIMARY KEY (sid)
);
--
CREATE TABLE Product
(
pID 		INTEGER,
pName 		VARCHAR2(30)	NOT NULL,
pInventory 	INTEGER 	NOT NULL,
pPrice 		NUMBER(6,2) 	NOT NULL,
p_dID 		INTEGER 	NOT NULL,
p_sID 		INTEGER 	NOT NULL,
sDate 		DATE 		NOT NULL,
--
CONSTRAINT pIC01 PRIMARY KEY (pID),
CONSTRAINT pIC02 FOREIGN KEY (p_dID) 
	REFERENCES Department(dID)
	ON DELETE CASCADE
	DEFERRABLE INITIALLY DEFERRED,
CONSTRAINT pIC03 FOREIGN KEY (p_sID) 
	REFERENCES Supplier(sID)
	ON DELETE CASCADE
	DEFERRABLE INITIALLY DEFERRED
);
--
CREATE TABLE Transaction
(
t_mID 		INTEGER,
tTimestamp 	CHAR(17) 	NOT NULL,
tTotal 		NUMBER(7,2) 	NOT NULL,
--
CONSTRAINT tIC01 PRIMARY KEY (t_mID, tTimestamp),
CONSTRAINT tIC02 FOREIGN KEY (t_mID) 
	REFERENCES Member(mID)
	ON DELETE CASCADE
	DEFERRABLE INITIALLY DEFERRED,
CONSTRAINT tIC03 CHECK (tTimestamp LIKE '__/__/__ __:__:__')
);
--
CREATE TABLE MPhone
(
m_mID 		INTEGER,
mPhone 		CHAR(14),
--
CONSTRAINT mpIC01 PRIMARY KEY (m_mID, mPhone),
CONSTRAINT mpIC02 FOREIGN KEY (m_mID) 
	REFERENCES Member(mID)
	ON DELETE CASCADE
	DEFERRABLE INITIALLY DEFERRED,
CONSTRAINT mpIC03 CHECK (mPhone LIKE '(___)-___-____')
);
--
CREATE TABLE EPhone
(
e_mID 		INTEGER,
ePhone 		CHAR(14),
--
CONSTRAINT epIC01 PRIMARY KEY (e_mID, ePhone),
CONSTRAINT epIC02 FOREIGN KEY (e_mID) 
	REFERENCES Member(mID)
	ON DELETE CASCADE
	DEFERRABLE INITIALLY DEFERRED,
CONSTRAINT epIC03 CHECK (ePhone LIKE '(___)-___-____')
);
--
CREATE TABLE Prod_Trans
(
pt_mID 		INTEGER,
pt_tTimestamp 	CHAR(17),
pt_pID 		INTEGER,
--
CONSTRAINT ptIC01 PRIMARY KEY (pt_mID, pt_tTimestamp, pt_pID),
CONSTRAINT ptIC02 FOREIGN KEY (pt_mID, pt_tTimestamp) 
	REFERENCES Transaction(t_mID, tTimestamp)
	ON DELETE CASCADE
	DEFERRABLE INITIALLY DEFERRED,
CONSTRAINT ptIC03 FOREIGN KEY (pt_pID) 
	REFERENCES Product(pID)
	ON DELETE CASCADE
	DEFERRABLE INITIALLY DEFERRED
);
--
SET FEEDBACK OFF
--
INSERT INTO Member VALUES ('10', 'John', 'Smith', '100 address', 100, 'P', 14);
INSERT INTO Member VALUES ('11', 'Logan', 'Gardner', '110 address', 100, 'P', 12);
INSERT INTO Member VALUES ('12', 'Carl', 'Wheeler', '120 address', 80, 'A', NULL);
INSERT INTO Member VALUES ('13', 'Jones', 'Vikema', '130 address', 100, 'P', NULL);
INSERT INTO Member VALUES ('14', 'Gordon', 'Freddrick', '140 address', 80, 'A', NULL);
--
INSERT INTO Department VALUES ('10', 'Salesfloor');
INSERT INTO Department VALUES ('11', 'Checkout');
INSERT INTO Department VALUES ('12', 'Photo');
INSERT INTO Department VALUES ('13', 'Food');
INSERT INTO Department VALUES ('14', 'Pharmacy');
--
INSERT INTO Job VALUES ('10', 'Cashier', '11');
INSERT INTO Job VALUES ('11', 'Chef', '13');
INSERT INTO Job VALUES ('12', 'Sales Associate', '10');
INSERT INTO Job VALUES ('13', 'Photographer', '12');
INSERT INTO Job VALUES ('14', 'Pharmacist', '14');
--
INSERT INTO Employee VALUES ('10', 'Jane', 'Smith', '100 address', '25000', '11', '10');
INSERT INTO Employee VALUES ('11', 'Jill', 'Howard', '110 address', '30000', NULL, '13');
INSERT INTO Employee VALUES ('12', 'Dave', 'Tillman', '120 address', '40000', NULL, '11');
INSERT INTO Employee VALUES ('13', 'Mary', 'Freeman', '130 address', '55000', NULL, '14');
INSERT INTO Employee VALUES ('14', 'Holly', 'North', '100 address', '30000', '10', '12');
--
INSERT INTO Supplier VALUES ('10', 'Gordons Food Service');
INSERT INTO Supplier VALUES ('11', 'Meijers');
INSERT INTO Supplier VALUES ('12', 'Best Buy');
INSERT INTO Supplier VALUES ('13', 'Sparrow Health');
INSERT INTO Supplier VALUES ('14', 'BnH Photo Video');
--
INSERT INTO Product VALUES ('10', 'Charmins Toilet Paper', 100, 5.00, '10', '11', TO_DATE('10/10/18', 'MM/DD/YY')); 
INSERT INTO Product VALUES ('11', 'Ramon Noodle Soup', 50, 2.00, '10', '10', TO_DATE('10/10/18', 'MM/DD/YY')); 
INSERT INTO Product VALUES ('12', 'Light Bulbs (4 pck.)', 40, 10.00, '10', '11', TO_DATE('10/10/18', 'MM/DD/YY')); 
INSERT INTO Product VALUES ('13', 'Asus Laptop', 20, 500.00, '10', '12', TO_DATE('10/10/18', 'MM/DD/YY')); 
INSERT INTO Product VALUES ('14', 'Fresh Chicken Roast', 30, 5.00, '13', '10', TO_DATE('10/10/18', 'MM/DD/YY')); 
--
INSERT INTO Transaction VALUES ('10', '10/12/18 08:12:50', 10);
INSERT INTO Transaction VALUES ('11', '10/12/18 09:00:21', 40);
INSERT INTO Transaction VALUES ('12', '10/12/18 10:14:03', 20);
INSERT INTO Transaction VALUES ('13', '10/12/18 10:53:42', 15);
INSERT INTO Transaction VALUES ('14', '10/12/18 12:38:12', 5);
--
INSERT INTO MPhone VALUES ('10', '(616)-100-1212');
INSERT INTO MPhone VALUES ('11', '(616)-110-1212');
INSERT INTO MPhone VALUES ('12', '(616)-120-1212');
INSERT INTO MPhone VALUES ('13', '(616)-130-1212');
INSERT INTO MPhone VALUES ('14', '(616)-140-1212');
--
INSERT INTO EPhone VALUES ('10', '(616)-000-0000');
INSERT INTO EPhone VALUES ('11', '(616)-001-0101');
INSERT INTO EPhone VALUES ('12', '(616)-002-0202');
INSERT INTO EPhone VALUES ('13', '(616)-003-0303');
INSERT INTO EPhone VALUES ('14', '(616)-004-0404');
--
INSERT INTO Prod_Trans VALUES ('10', '10/12/18 08:12:50', '10');
INSERT INTO Prod_Trans VALUES ('11', '10/12/18 09:00:21', '11');
INSERT INTO Prod_Trans VALUES ('12', '10/12/18 10:14:03', '12');
INSERT INTO Prod_Trans VALUES ('13', '10/12/18 10:53:42', '13');
INSERT INTO Prod_Trans VALUES ('14', '10/12/18 12:38:12', '14');
--
SET FEEDBACK ON
COMMIT;
--
SELECT * FROM Member;
SELECT * FROM Department;
SELECT * FROM Job;
SELECT * FROM Employee;
SELECT * FROM Supplier;
SELECT * FROM Product;
SELECT * FROM Transaction;
SELECT * FROM MPhone;
SELECT * FROM EPhone;
SELECT * FROM Prod_Trans;
--
/*(Q01) Query joining 4 relations.
For every employee who works a job that is a part of a department that sells 'Ramon Noodle Soup': 
Find the employees eID and eLast.
*/
SELECT E.eID, E.eLast
FROM Employee E, Job J, Department D, Product P
WHERE E.e_jID = J.jID AND
      J.j_dID = D.dID AND 
      D.dID = P.p_dID AND 
      P.pName = 'Ramon Noodle Soup'
ORDER BY E.eLast;
--
--
/*(Q02) SELF-JOIN query.
For every employee who has a salary that is different than their supervisor's salary: 
Find the employee's eID, eLast, and the eID of their supervisor.
*/
SELECT E1.eID, E1.eLast, E1.s_eID
FROM Employee E1, Employee E2
WHERE E1.s_eID IS NOT NULL AND
      E1.s_eID = E2.eID AND 
      E1.eSalary <> E2.eSalary
ORDER BY E1.eLast;
--
--
/*(Q03) INTERSECT query.
For every employee who has a supervisor and works for the Salesfloor department: 
Find the employee's eID, eLast.
*/
SELECT eID, eLast
FROM Employee 
WHERE s_eID IS NOT NULL
INTERSECT
SELECT eID, eLast
FROM Employee E, Job J, Department D
WHERE E.e_jID = J.jID AND
      J.j_dID = D.dID AND
      D.dName LIKE 'Salesfloor';
--
--
/*(Q04) MAX query.
Find the max salary of all employees.
*/
SELECT MAX(eSalary)
FROM Employee;
--
--
/*(Q05) GROUP BY, HAVING, ORDER BY in the same query.
Find the mID and mFirst of members who have purchased more than two products.
*/
SELECT M.mID, M.mFirst
FROM   Member M, Prod_Trans PT
WHERE  M.mID = PT.pt_mID
GROUP BY M.mID, M.mFirst
HAVING COUNT(*) > 2;
--
--
/*(Q06) Correlated subquery
Find the mID and mFirst of primary members who have not purchased any products.
*/
SELECT M.mID, M.mFirst
FROM   Member M
WHERE  M.mType = 'P' AND
       NOT EXISTS (SELECT *
                   FROM Prod_Trans PT
                   WHERE PT.pt_mID = M.mID);
--
--
/*(Q07) Non-correlated subquery
Find the mID and mFirst of primary members who have not purchased any products.
*/
SELECT M.mID, M.mFirst
FROM   Member M
WHERE  M.mType = 'P' AND
       M.mID NOT IN (SELECT PT.pt_mID
                     FROM Prod_Trans PT);
--
--
/*(Q08) Relational DIVISION Query
Find the mID and mFirst of every member who has purchased every product named 'Light Bulbs (4 pck.)'.
*/
SELECT M.mID, M.mFirst
FROM   Member M
WHERE NOT EXISTS ((SELECT P.pID
                   FROM  Product P
                   WHERE P.pName= 'Light Bulbs (4 pck.)')
                   MINUS
                  (SELECT P.pID
                   FROM   Prod_Trans PT, Product P
                   WHERE  PT.pt_mID = m.mID AND
                          PT.pt_pID = P.pID AND
                          P.pName = 'Light Bulbs (4 pck.)')); 
--
--
/*(Q09) Outer Join Query
Find the mID, mFirst of every member. Also show transactions for those who have them.
*/
SELECT M.mID, M.mFirst, T.tTimestamp, T.tTotal
FROM Member M LEFT OUTER JOIN Transaction T ON M.mID = T.t_mID;
--
--
/*(Q10) RANK Query
Find the rank of the salary 30000 among all salaries.
*/
SELECT RANK(40000) WITHIN GROUP
      (ORDER BY E.eSalary) "Rank of 30000"
FROM Employee E;
--
-- 
/*(Q11) Top-N Query
For every employee whose salary is equal to one of the two lowest salaries, Find the eID, eLast, and eSalary.
*/
SELECT E.eID, E.eLast, E.eSalary
FROM   EMPLOYEE E
WHERE  E.eSalary IN (SELECT *
                    FROM (SELECT DISTINCT E.eSalary
                          FROM Employee E
                          ORDER BY E.eSalary)
                          WHERE ROWNUM < 3);
-- 
-- Testing: mIC01 (accept 1111 named Aaa)
INSERT INTO Member VALUES (null, 'Aaa', 'Aaa', '123 4th Street', 100, 'P', null);
INSERT INTO Member VALUES (1111, 'Aaa', 'Aaa', '123 4th Street', 100, 'P', null);
INSERT INTO Member VALUES (1111, 'Bbb', 'Bbb', '123 4th Street', 100, 'P', null);
--
-- Testing: eIC02 (accept 2222 with null supervisor)
INSERT INTO Department VALUES (9999, 'Department');
INSERT INTO Job VALUES (9999, 'Job', 9999);
INSERT INTO Employee VALUES (2221, 'Ccc', 'Ccc', '123 4th Street', 10000, 2222, 9999);
INSERT INTO Employee VALUES (2222, 'Ddd', 'Ddd', '123 4th Street', 10000, null, 9999);
DELETE FROM Employee WHERE eID = 2222;
--
-- Testing: mIC03 (accept 3331, 3332)
INSERT INTO Member VALUES (3330, 'Ccc', 'Ccc', '123 4th Street', 50, 'P', 321);
INSERT INTO Member VALUES (3331, 'Ccc', 'Ccc', '123 4th Street', 100, 'P', null);
INSERT INTO Member VALUES (3332, 'Ccc', 'Ccc', '123 4th Street', 80, 'A', null);
--
-- Testing: mIC04 (accept 4441, 4442)
INSERT INTO Member VALUES (4440, 'Fff', 'Fff', '123 4th Street', 100, 'Z', null);
INSERT INTO Member VALUES (4441, 'Fff', 'Fff', '123 4th Street', 80, 'A', null);
INSERT INTO Member VALUES (4442, 'Fff', 'Fff', '123 4th Street', 100, 'P', null);
--
-- Testing: mIC05, mIC06 (accept 5552, 5553)
INSERT INTO Member VALUES (5550, 'Ggg', 'Ggg', '123 4th Street', 100, 'A', null);
INSERT INTO Member VALUES (5551, 'Ggg', 'Ggg', '123 4th Street', 80, 'P', null);
INSERT INTO Member VALUES (5552, 'Ggg', 'Ggg', '123 4th Street', 80, 'A', null);
INSERT INTO Member VALUES (5553, 'Ggg', 'Ggg', '123 4th Street', 100, 'P', null);
--
COMMIT;
--
SELECT * FROM Member;
SELECT * FROM Employee;
SELECT * FROM Product;
SELECT * FROM Transaction;
SELECT * FROM MPhone;
--
SPOOL OFF
