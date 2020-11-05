/* *****************************************************************************
	FILE:	Delivery Driver IQ Database
	DATE:	2019-11-26 
	AUTHOR:	Haley Hepker
	VERSION:	
	DESCRIPTION:
			Final Project SQL Script
			
	MODIFICATION HISTORY
		<YYYY-MM-DD> <Modifier Name>
		<Modification Description>
			
***************************************************************************** */
DROP DATABASE IF EXISTS ddIQ;
CREATE DATABASE IF NOT EXISTS ddIQ;
USE ddIQ;

/* creating the Employee Table */

DROP TABLE IF EXISTS Employee;
CREATE TABLE Employee(
	Employee_Id INT NOT NULL PRIMARY KEY COMMENT 'An id to identify the employee'
    , Employee_firstName VARCHAR(50) NOT NULL COMMENT 'A first name for the employee'
    , Employee_lastName VARCHAR(50) NOT NULL COMMENT 'A family name for the employee'
    , Employee_hourType CHAR(10) NULL COMMENT 'An option weather the employee is full or part time'
    , Hourly_rate DECIMAL(5,2) NOT NULL COMMENT 'The pay rate of the employee'
) COMMENT 'A table listing information on the employee'
;

/* creating the Zip_Code Table */

DROP TABLE IF EXISTS Zip_Code;
CREATE TABLE Zip_Code(
	Zip_code CHAR(10) NOT NULL PRIMARY KEY COMMENT 'The zip code for the address'
    , City VARCHAR(50) NOT NULL COMMENT 'The city the address is in'
    , State CHAR(2) NOT NULL COMMENT 'The state the address is in'
) COMMENT 'A table listing zip codes and related data'
;        
        
 /* creating the Location Table */
 
 DROP TABLE IF EXISTS Location;
 CREATE TABLE Location(
	Customer_address VARCHAR(50) NOT NULL PRIMARY KEY COMMENT 'The address for the delivery'
    , Zip_code CHAR(10) NOT NULL COMMENT 'The zip code for the address'
    , City VARCHAR(50) NOT NULL COMMENT 'The city the address is in'
	, CONSTRAINT fk_Location_Zip_code_Zip_Code_Zip_code
		FOREIGN KEY (Zip_code)
        REFERENCES Zip_Code(Zip_code)
) COMMENT 'A table describing the location delivered to'
;

/* creating the Shift Table */

DROP TABLE IF EXISTS Shift;
CREATE TABLE  Shift(
	Date_1 DATE NOT NULL PRIMARY KEY COMMENT 'The date the order was completed'
    , Day_ofWeek VARCHAR(15) NOT NULL COMMENT 'The day of the week worked'
    , Day_nightShift VARCHAR(5) NOT NULL COMMENT 'What kind of shift worked'
    , Weather VARCHAR(20) NULL COMMENT 'Weather conditions of the shift'
    , Hours_worked DECIMAL(5,2) NOT NULL COMMENT 'Total hours worked in the shift'
    , Total_payout DECIMAL(7,2) NOT NULL COMMENT 'Total amount of cash paid at end of shift'
    , Total_milage DECIMAL(5,2) NOT NULL COMMENT 'The amount of milage driven in a shift'
    , Number_ofRuns CHAR(10) NOT NULL COMMENT 'The total number of runs in a shift'
) COMMENT 'A table describing the details of the shift worked'
;

/* creating the Order Table */

DROP TABLE IF EXISTS Order_1;
CREATE TABLE Order_1(
	Order_Id INT NOT NULL PRIMARY KEY COMMENT 'An id to identify the order'
    , Date_1 DATE NOT NULL COMMENT 'The date the order was completed'
    , Customer_address VARCHAR(50) NOT NULL COMMENT 'The address for the delivery'
    , Age_group VARCHAR(20) NULL COMMENT 'The age group the customer is in'
    , Gender VARCHAR(10) NULL COMMENT 'The gender that the customer is'
    , Race VARCHAR(20) NULL COMMENT 'The race of the customer'
    , Order_cost DECIMAL(5,2) NOT NULL COMMENT 'The cost the order before tip'
    , Tip DECIMAL(4,2) NOT NULL COMMENT 'The tip that was given'
	, CONSTRAINT fk_Order_1_Date_1_Shift_Date_1
		FOREIGN KEY (Date_1)
        REFERENCES 	Shift(Date_1)
	, CONSTRAINT fk_Order_1_Customer_addrerss_Location_Customer_address
		FOREIGN KEY (Customer_address)
		REFERENCES Location(Customer_address)
) COMMENT 'A table containing all the info collected on the customer and their order'
;

/*  creating the Order_details Table */

DROP TABLE IF EXISTS Order_details;
CREATE TABLE  Order_details(
	Order_Id INT NOT NULL PRIMARY KEY COMMENT 'An id to identify the order'
    , Item_Id INT NOT NULL COMMENT 'An id to identify the item'
    , Order_qty INT NOT NULL COMMENT 'The number of items in the order'
    , Individual_business VARCHAR(15) NOT NULL COMMENT 'Type of location the order was delivered to'
    , Cash_credit VARCHAR(10) NOT NULL COMMENT 'Paid in cash or credit'
    , CONSTRAINT fk_Order_details_Order_Id_Order_1_Order_Id
		FOREIGN KEY (Order_Id)
        REFERENCES Order_1(Order_Id)
)COMMENT 'Table listing items and quantity'
;

/* creating the Wages Table */
        
DROP TABLE IF EXISTS Wages;
CREATE TABLE Wages(
	Check_number INT NOT NULL PRIMARY KEY COMMENT 'The number identifying the check'
    , Hourly_rate DECIMAL(5,2) NOT NULL COMMENT 'The pay rate of the employee'
    , Pay_amount DECIMAL(7,2) NOT NULL COMMENT 'The amount of the paycheck'
    , Total_hoursWorked DECIMAL(5,2) NOT NULL COMMENT 'Hours on the paycheck'
)COMMENT 'Table listing employee wage information'
;
        
/* creating the Paystub Table */

DROP TABLE IF EXISTS Paystub;
CREATE TABLE Paystub(
	Employee_Id INT NOT NULL PRIMARY KEY COMMENT 'An id to identify the employee'
    , Pay_periodBegins DATE NOT NULL COMMENT 'The start date of the pay period'
    , Pay_periodEnds DATE NOT NULL COMMENT 'The end date of the pay period'
    , Net_checkAmount DECIMAL(7,2) NOT NULL COMMENT 'Amount of check after deductions'
    , CONSTRAINT fk_Paystub_Employee_Id_Employee_Employee_Id
		FOREIGN KEY (Employee_Id)
		REFERENCES Employee(Employee_Id)
)COMMENT 'Table listing paystub information'
;

/* creating the  Drive Table */

DROP TABLE IF EXISTS Drive;
CREATE TABLE Drive(
	Date_1 DATE NOT NULL PRIMARY KEY COMMENT 'The date the order was completed'
    , Milage CHAR(10) NOT NULL COMMENT 'Milage used on the tank'
    , Gas_price DECIMAL(5,2) NOT NULL COMMENT 'Price of gasoline'
    , Fill_upPrice DECIMAL(5,2) NOT NULL COMMENT 'Price paid to fill up tank'
    , MPG_onTank CHAR(10) NOT NULL COMMENT 'Average miles per gallon on the tank'
    , CONSTRAINT fk_Drive_Date_1_Order_1_Date_1
		FOREIGN KEY (Date_1)
        REFERENCES Order_1(Date_1)
	, CONSTRAINT fk_Drive_Date_1_Shift_Date_1
		FOREIGN KEY (Date_1)
        REFERENCES Shift(Date_1)
)COMMENT 'Table that tracks gas prices,usage, and MPG'
;

/* creating the Month Table */

DROP TABLE IF EXISTS Month;
CREATE TABLE Month(
	Employee_Id INT NOT NULL PRIMARY KEY COMMENT 'An id to identify the employee'
    , Days_workedInMonth CHAR(10) NOT NULL COMMENT 'Number of days worked within a month'
    , Days_takenOff CHAR(10) NULL COMMENT 'Number of days asked for off of regular schedule'
    , Total_monthHours CHAR(10) NOT NULL COMMENT 'Total amount of hours worked in a month'
    , CONSTRAINT fk_Month_Employee_Id_Employee_Employee_Id
		FOREIGN KEY (Employee_Id)
        REFERENCES Employee(Employee_Id)
	, CONSTRAINT fk_Month_Employee_Id_Paystub_Employee_Id
		FOREIGN KEY (Employee_Id)
        REFERENCES Paystub(Employee_Id)
)COMMENT 'Table that tracks the days worked in a month'
;

/* CRUD stored procedure 1 */

SELECT *
FROM Employee
WHERE Employee_Id IN (120, 153)
;

DELIMITER $$
DROP PROCEDURE IF EXISTS EmployeeCreate$$
CREATE PROCEDURE EmployeeCreate()

BEGIN
	/*
		Copyright statement
		Author:
		File:
		DESCRIPTION:
		Modification History
		Date modified - Who did it - what was modified
	*/
	-- Declare variables and constants here
    DECLARE Keep_Id INT DEFAULT 120;
    DECLARE Delete_Id INT DEFAULT 153;
    DECLARE Sql_error TINYINT DEFAULT FALSE;
    -- Define error conditions
        DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
		SET Sql_error = TRUE;
	-- Primary logic goes here
    START TRANSACTION;
    
    UPDATE Employee
    SET Employee_firstName = 'Haley'
    WHERE Employee_Id = Keep_Id
    ; 
    
    UPDATE Employee
    SET Employee_Id = Keep_Id
    WHERE Employee_Id = Delete_Id
    ;
    
    DELETE FROM Employee
    WHERE Employee_Id = Delete_Id
    ;
	-- Final logic goes here
    IF Sql_error = FALSE THEN
		SELECT 'ID Deleted!' AS 'Message';
	ELSE
		SELECT 'Something went wrong' AS 'Message';
	END IF;
	
END$$
DELIMITER ;


/* stored procedure 2 */

SELECT *
FROM Location
WHERE Zip_code IN (52403, 52317)
;

DELIMITER $$
DROP PROCEDURE IF EXISTS ZipCreate$$
CREATE PROCEDURE ZipCreate()

BEGIN
	/*
		Copyright statement
		Author:
		File:
		DESCRIPTION:
		Modification History
		Date modified - Who did it - what was modified
	*/
	-- Declare variables and constants here
    DECLARE Keep_Id INT DEFAULT 52403;
    DECLARE Delete_Id INT DEFAULT 52317;
    DECLARE Sql_error TINYINT DEFAULT FALSE;
    -- Define error conditions
        DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
		SET Sql_error = TRUE;
	-- Primary logic goes here
    START TRANSACTION;
    
    UPDATE Location
    SET City = 'North Liberty'
    WHERE Zip_code = Keep_Id
    ; 
    
    UPDATE Location
    SET Zip_code = Keep_Id
    WHERE Zip_code = Delete_Id
    ;
    
    DELETE FROM Location
    WHERE Zip_code = Delete_Id
    ;
	-- Final logic goes here
    IF Sql_error = FALSE THEN
		SELECT 'Zip Deleted!' AS 'Message';
	ELSE
		SELECT 'Something went wrong' AS 'Message';
	END IF;
	
END$$
DELIMITER ;


/* stored procedure 3 */

SELECT *
FROM Order_details
WHERE item_Id IN (5, 10)
;

DELIMITER $$
DROP PROCEDURE IF EXISTS ItemCreate$$
CREATE PROCEDURE ItemCreate()

BEGIN
	/*
		Copyright statement
		Author:
		File:
		DESCRIPTION:
		Modification History
		Date modified - Who did it - what was modified
	*/
	-- Declare variables and constants here
    DECLARE Keep_Id INT DEFAULT 5;
    DECLARE Delete_Id INT DEFAULT 10;
    DECLARE Sql_error TINYINT DEFAULT FALSE;
    -- Define error conditions
        DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
		SET Sql_error = TRUE;
	-- Primary logic goes here
    START TRANSACTION;
    
    UPDATE Order_details
    SET Order_qty = '7'
    WHERE Item_Id = Keep_Id
    ; 
    
    UPDATE Order_details
    SET Item_Id = Keep_Id
    WHERE Item_Id = Delete_Id
    ;
    
    DELETE FROM Order_details
    WHERE Item_Id = Delete_Id
    ;
	-- Final logic goes here
    IF Sql_error = FALSE THEN
		SELECT 'ID Deleted!' AS 'Message';
	ELSE
		SELECT 'Something went wrong' AS 'Message';
	END IF;
	
END$$
DELIMITER ;


/* stored procedure 4 */

SELECT *
FROM Order_1
WHERE Order_Id IN (747, 228)
;

DELIMITER $$
DROP PROCEDURE IF EXISTS OrderCreate$$
CREATE PROCEDURE OrderCreate()

BEGIN
	/*
		Copyright statement
		Author:
		File:
		DESCRIPTION:
		Modification History
		Date modified - Who did it - what was modified
	*/
	-- Declare variables and constants here
    DECLARE Keep_Id INT DEFAULT 747;
    DECLARE Delete_Id INT DEFAULT 228;
    DECLARE Sql_error TINYINT DEFAULT FALSE;
    -- Define error conditions
        DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
		SET Sql_error = TRUE;
	-- Primary logic goes here
    START TRANSACTION;
    
    UPDATE Order_1
    SET Customer_address = '123 Apple Ln'
    WHERE Order_Id = Keep_Id
    ; 
    
    UPDATE Order_1
    SET Order_Id = Keep_Id
    WHERE Order_Id = Delete_Id
    ;
    
    DELETE FROM Order_1
    WHERE Order_Id = Delete_Id
    ;
	-- Final logic goes here
    IF Sql_error = FALSE THEN
		SELECT 'ID Deleted!' AS 'Message';
	ELSE
		SELECT 'Something went wrong' AS 'Message';
	END IF;
	
END$$
DELIMITER ;


/* Trigger 1 */

DROP TABLE IF EXISTS Employee_audit;
CREATE TABLE Employee_audit (
	Employee_Id INT NOT NULL PRIMARY KEY COMMENT 'An id to identify the employee'
	, Employee_lastName VARCHAR(50) NOT NULL COMMENT 'A family name for the employee'
    , changedat DATETIME DEFAULT NULL
    , action VARCHAR(50) DEFAULT NULL
);

DELIMITER $$
DROP TRIGGER IF EXISTS Before_Employee_Update$$
CREATE TRIGGER Before_Employee_Update
	BEFORE UPDATE ON Employee
    FOR EACH ROW
BEGIN
	/*
		Copyright statement
		Author:
		File:
		DESCRIPTION:
		Modification History
		Date modified - Who did it - what was modified
	*/
	-- Declare variables and constants here
	-- Define error conditions
	-- Primary logic goes here
    INSERT INTO Employee_audit
    SET action = 'update',
    Employee_Id = OLD.Employee_Id,
    Employee_lastName = OLD.Employee_lastName,
    changedat = NOW();
	-- Final logic goes here
END$$
DELIMITER ;

/* trigger 2 */

DROP TABLE IF EXISTS Order_audit;
CREATE TABLE Order_audit (
	Order_Id INT NOT NULL PRIMARY KEY COMMENT 'An id to identify the order'
	, Customer_address VARCHAR(50) NOT NULL COMMENT 'The address for the delivery'
    , changedat DATETIME DEFAULT NULL
    , action VARCHAR(50) DEFAULT NULL
);

DELIMITER $$
DROP TRIGGER IF EXISTS Before_Order_Update$$
CREATE TRIGGER Before_Order_Update
	BEFORE UPDATE ON Order_1
    FOR EACH ROW
BEGIN
	/*
		Copyright statement
		Author:
		File:
		DESCRIPTION:
		Modification History
		Date modified - Who did it - what was modified
	*/
	-- Declare variables and constants here
	-- Define error conditions
	-- Primary logic goes here
    INSERT INTO Order_audit
    SET action = 'update',
    Order_Id = OLD.Order_Id,
    Customer_address = OLD.Customer_address,
    changedat = NOW();
	-- Final logic goes here
END$$
DELIMITER ;

/* creating view 1 */

CREATE OR REPLACE VIEW Gas_items AS
SELECT 	
	Date_1
    , Gas_price
    , MPG_onTank
    , Milage / Fill_upPrice AS 'Tank_amount'
FROM Drive
WHERE Milage / Fill_upPrice > 0
;

/* creating view 2 */

CREATE OR REPLACE VIEW Order_view AS
SELECT
	Order_qty
    , Order_Id
FROM Order_details
WHERE Order_Id >25
;

/* *****************************************************************************
                               END OF SCRIPT
***************************************************************************** */
