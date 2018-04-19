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
mFirst 		VARCHAR2(10) 	NOT NULL,
mLast 		VARCHAR2(10) 	NOT NULL,
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
dName 		VARCHAR2(10) 	NOT NULL,
--
CONSTRAINT dIC01 PRIMARY KEY (dID)
);
--
CREATE TABLE Job
(
jID 		INTEGER,
jName 		VARCHAR2(10) 	NOT NULL,
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
eFirst 		VARCHAR2(10) 	NOT NULL,
eLast 		VARCHAR2(10) 	NOT NULL,
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
sName 		VARCHAR2(10) 	NOT NULL,
--
CONSTRAINT sIC01 PRIMARY KEY (sid)
);
--
CREATE TABLE Product
(
pID 		INTEGER,
pName 		VARCHAR2(10)	NOT NULL,
pInventory 	INTEGER 	NOT NULL,
pPrice 		NUMBER(5,2) 	NOT NULL,
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
tTotal 		NUMBER(6,2) 	NOT NULL,
--
CONSTRAINT tIC01 PRIMARY KEY (t_mID, tTimestamp),
CONSTRAINT tIC02 FOREIGN KEY (t_mID) 
	REFERENCES Member(mID)
	ON DELETE CASCADE
	DEFERRABLE INITIALLY DEFERRED
);
--
CREATE TABLE MPhone
(
m_mID 		INTEGER,
mPhone 		CHAR(12),
--
CONSTRAINT mpIC01 PRIMARY KEY (m_mID, mPhone),
CONSTRAINT mpIC02 FOREIGN KEY (m_mID) 
	REFERENCES Member(mID)
	ON DELETE CASCADE
	DEFERRABLE INITIALLY DEFERRED
);
--
CREATE TABLE EPhone
(
e_mID 		INTEGER,
ePhone 		CHAR(12),
--
CONSTRAINT epIC01 PRIMARY KEY (e_mID, ePhone),
CONSTRAINT epIC02 FOREIGN KEY (e_mID) 
	REFERENCES Member(mID)
	ON DELETE CASCADE
	DEFERRABLE INITIALLY DEFERRED
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
< The INSERT statements that populate the tables>
Important: Keep the number of rows in each table small enough so that the results of your
queries can be verified by hand. See the Sailors database as an example.
SET FEEDBACK ON
COMMIT;
--
< One query (per table) of the form: SELECT * FROM table; in order to print out your
database >
--
< The SQL queries>. Include the following for each query:
1. A comment line stating the query number and the feature(s) it demonstrates
(e.g. – Q25 – correlated subquery).
2. A comment line stating the query in English.
3. The SQL code for the query.
--
< The insert/delete/update statements to test the enforcement of ICs >
Include the following items for every IC that you test (Important: see the next section titled
“Submit a final report” regarding which ICs to test).
? A comment line stating: Testing: < IC name>
? A SQL INSERT, DELETE, or UPDATE that will test the IC.
COMMIT;
--
SPOOL OFF
