--TABLES CREATION

-- create Lease table
CREATE TABLE Lease (
  LeaseID INT IDENTITY PRIMARY KEY,
  UnitID INT NOT NULL,
  TenantID INT NOT NULL,
  StartDate DATE NOT NULL,
  EndDate DATE NOT NULL,
  MonthlyRent DECIMAL(10,2) NOT NULL,
  SecurityDeposit DECIMAL(10,2) NOT NULL,
  FOREIGN KEY (UnitID) REFERENCES Unit(UnitID),
  FOREIGN KEY (TenantID) REFERENCES Tenant(TenantID)
);

-- create Lease Payment table
CREATE TABLE LeasePayment (
  LeasePaymentID INT IDENTITY PRIMARY KEY,
  LeaseID INT NOT NULL,
  PaymentAmount DECIMAL(10,2) NOT NULL,
  PaymentDate DATE NOT NULL,
  FOREIGN KEY (LeaseID) REFERENCES Lease(LeaseID)
);

-- create Tenant table
CREATE TABLE Tenant (
  TenantID INT IDENTITY PRIMARY KEY,
  FirstName VARCHAR(50) NOT NULL,
  LastName VARCHAR(50) NOT NULL,
  PhoneNumber VARCHAR(20) NOT NULL,
  Email VARCHAR(100) NOT NULL
);

-- create LeaseTenant table with a clustered primary key constraint
CREATE TABLE LeaseTenant (
  LeaseID INT NOT NULL
	REFERENCES Lease(LeaseID),
  TenantID INT NOT NULL
	REFERENCES Tenant(TenantID),
  CONSTRAINT PK_LeaseTenant PRIMARY KEY CLUSTERED (LeaseID, TenantID),
);

-- create ManagementCompany table 
CREATE TABLE ManagementCompany (
  CompanyID INT IDENTITY PRIMARY KEY,
  CompanyName VARCHAR(45) NOT NULL,
  PhoneNumber INT NOT NULL,
  Email VARCHAR(45) NOT NULL,
  AddressID INT NOT NULL
  FOREIGN KEY (AddressID) REFERENCES Address(AddressID)
);

-- create Employee table
CREATE TABLE Employee (
  EmployeeID INT IDENTITY PRIMARY KEY,
  AddressID INT NOT NULL,
  CompanyID INT NOT NULL,
  FirstName VARCHAR(25) NOT NULL,
  LastName VARCHAR(25) NOT NULL,
  Type VARCHAR(30) NOT NULL,
  PhoneNumber INT NOT NULL,
  Email VARCHAR(45) NOT NULL,
  FOREIGN KEY (AddressID) REFERENCES Address(AddressID),
  FOREIGN KEY (CompanyID) REFERENCES ManagementCompany(CompanyID)
);

-- create EmployeeBuilding table with a clustered primary key constraint
CREATE TABLE EmployeeBuilding(
  EmployeeID INT NOT NULL
	REFERENCES Employee(EmployeeID),
  BuildingID INT NOT NULL
	REFERENCES Building(buildingID),
  CONSTRAINT PK_EmployeeBuilding PRIMARY KEY CLUSTERED (EmployeeID, BuildingID)
);

-- create table adddress
CREATE TABLE Address(
  AddressID INT IDENTITY PRIMARY KEY,
  DetailedAddress VARCHAR(80) NOT NULL,
  City VARCHAR(20) NOT NULL,
  State VARCHAR(20) NOT NULL,
  Zipcode INT NOT NULL
);

CREATE TABLE Building (
  buildingID INT IDENTITY(1,1) PRIMARY KEY,
  AddressID INT FOREIGN KEY REFERENCES Address(AddressID),
  CompanyID INT FOREIGN KEY REFERENCES ManagementCompany(CompanyID),
  Building_Name VARCHAR(255),
  Building_Type VARCHAR(255),
  Unit_Number INT,
  NoOf_Floors INT,
  PhoneNumber VARCHAR(20),
  Email VARCHAR(255)
);

CREATE TABLE Parking(
   Parking_ID INT IDENTITY(1,1) PRIMARY KEY,
   UnitID INT FOREIGN KEY REFERENCES Unit(UnitID),
   Fee FLOAT,
   PaymentDate DATE
);

CREATE TABLE Amenity (
  Amenity_ID INT IDENTITY(1,1) PRIMARY KEY,
  buildingID INT FOREIGN KEY REFERENCES Building(buildingID),
  Amenity_Name VARCHAR(255),
  Amenity_Type VARCHAR(255),
  Cost FLOAT
);

--create table unit
CREATE TABLE Unit(
UnitID INT IDENTITY PRIMARY KEY,
BuildingID INT NOT NULL,
UnitNo INT NOT NULL,
Bedroom INT NOT NULL,
Bathroom FLOAT NOT NULL,
Availability VARCHAR(45) NOT NULL,
SquareFootage float NOT NULL,
FOREIGN KEY (BuildingID) REFERENCES Building(BuildingID)
);

-- It should be put before "create table utilities"
-- The function used to create a computed column in Utilities Table
GO

CREATE FUNCTION CalculateTotalFee(@gas_bill FLOAT, @electricity_bill FLOAT, @water_bill FLOAT)
RETURNS FLOAT
AS
BEGIN
    DECLARE @TotalFee FLOAT;
    SET @TotalFee =  @gas_bill + @electricity_bill + @water_bill
    RETURN @TotalFee;
END

GO

--create table utilities
CREATE TABLE Utilities(
UtilitiesID INT IDENTITY PRIMARY KEY,
UnitID INT NOT NULL,
Gasbill FLOAT NOT NULL,
ElectricityBill FLOAT NOT NULL,
WaterBill FLOAT NOT NULL,
--computed column, (dbo.) is required before the function
TotalFee AS dbo.CalculateTotalFee(Gasbill, ElectricityBill, WaterBill),
PaymentDate DATE NOT NULL,
FOREIGN KEY (UnitID) REFERENCES Unit(UnitID)
);

--Prospective Tenant
CREATE TABLE ProspectiveTenant (
  P_tenantID INT IDENTITY PRIMARY KEY,
  FirstName VARCHAR(45) NOT NULL,
  LastName VARCHAR(45) NOT NULL,
  PhoneNumber INT NOT NULL,
  Email VARCHAR(45)
);

ALTER TABLE ProspectiveTenant
ALTER COLUMN PhoneNumber BIGINT;

--Unit Maintenance Request
CREATE TABLE UnitMaintenanceRequest (
  RequestID INT IDENTITY PRIMARY KEY,
  TenantID INT NOT NULL,
  UnitID INT NOT NULL,
  EmployeeID INT NOT NULL,
  Description VARCHAR(45) NOT NULL,
  Status VARCHAR(45) NOT NULL,
  RequestDate DATE NOT NULL,
  CompletedDate DATE NOT NULL,
  FOREIGN KEY (TenantID) REFERENCES Tenant(TenantID),
  FOREIGN KEY (UnitID) REFERENCES Unit(UnitID)
);

--Prospective Tenant_InterestedUnit
CREATE TABLE ProspectiveTenantInterestedUnit(
   P_TenantID INT NOT NULL
	REFERENCES ProspectiveTenant(P_tenantID),
   UnitID INT NOT NULL
	REFERENCES Unit(UnitID),
  CONSTRAINT PK_ProspectiveTenantInterestedUnit PRIMARY KEY CLUSTERED (P_TenantID, UnitID)
);

-- create TenantUnit table with a clustered primary key constraint
CREATE TABLE TenantUnit(
TenantID INT NOT NULL
         REFERENCES Tenant(TenantID),
UnitID INT NOT NULL
         REFERENCES Unit(UnitID),
CONSTRAINT PK_TenantUnit PRIMARY KEY CLUSTERED (TenantID,UnitID)
);

-- DATA INSERTION

INSERT INTO Unit
	(BuildingID, UnitNo, Bedroom, Bathroom, Availability, SquareFootage)
VALUES
	(11, 101, 1, 1, 'available', 500),
	(10, 102, 2, 2, 'occupied', 1000),
	(9, 103, 3, 2.5, 'available', 1500),
	(8, 201, 2, 1.5, 'occupied', 1000),
	(7, 202, 1, 1, 'available', 500),
	(6, 203, 2, 2, 'available', 1000),
	(5, 301, 2, 1.5, 'available', 1000),
	(5, 302, 3, 2, 'occupied', 1500),
	(3, 303, 1, 1, 'available', 500),
	(4, 401, 2, 2, 'occupied', 1000),
	(4, 402, 3, 2.5, 'available', 1500),
	(4, 403, 1, 1, 'available', 500),
	(2, 501, 1, 1, 'occupied', 500),
	(3, 502, 2, 1.5, 'available', 1000),
	(3, 503, 3, 2, 'available', 1500);


INSERT INTO Utilities (UnitID, Gasbill, ElectricityBill, WaterBill, PaymentDate)
VALUES 
	(16, 50.0, 25.0, 20.0, '2023-02-01'),
	(17, 60.0, 30.0, 25.0, '2023-02-01'),
	(18, 70.0, 35.0, 30.0, '2023-02-01'),
	(19, 80.0, 40.0, 35.0, '2023-02-01'),
	(20, 90.0, 45.0, 40.0, '2023-02-01'),
	(6, 100.0, 50.0, 45.0, '2023-02-01'),
	(7, 110.0, 55.0, 50.0, '2023-02-01'),
	(8, 120.0, 60.0, 55.0, '2023-02-01'),
	(9, 130.0, 65.0, 60.0, '2023-02-01'),
	(10, 140.0, 70.0, 65.0, '2023-02-01'),
	(11, 50.0, 25.0, 20.0, '2023-03-01'),
	(12, 60.0, 30.0, 25.0, '2023-03-01'),
	(13, 70.0, 35.0, 30.0, '2023-03-01'),
	(14, 80.0, 40.0, 35.0, '2023-03-01'),
	(15, 90.0, 45.0, 40.0, '2023-03-01');


INSERT INTO Amenity(buildingID, Amenity_Name, Amenity_Type, Cost)
VALUES (9, 'Swimming Pool', 'Recreational', 150.00),
       (10, 'Gym', 'Fitness', 100.00),
       (11, 'Tennis Court', 'Recreational', 50.00),
       (2, 'BBQ Area', 'Recreational', 25.00),
       (3, 'Meeting Room', 'Business', 75.00),
       (4, 'Movie Theater', 'Entertainment', 200.00),
       (5, 'Playground', 'Recreational', 35.00),
       (6, 'Dog Park', 'Recreational', 50.00),
       (7, 'Yoga Studio', 'Fitness', 80.00),
       (8, 'Game Room', 'Entertainment', 125.00);
       
INSERT INTO Parking(UnitID, Fee, PaymentDate)
VALUES (11, 50.0, '2022-03-01'),
       (12, 25.0, '2022-03-02'),
       (13, 35.0, '2022-03-03'),
       (14, 20.0, '2022-03-04'),
       (15, 30.0, '2022-03-05'),
       (6, 40.0, '2022-03-06'),
       (7, 45.0, '2022-03-07'),
       (8, 15.0, '2022-03-08'),
       (9, 55.0, '2022-03-09'),
       (10, 10.0, '2022-03-10');
       
INSERT INTO Building (AddressID, CompanyID, Building_Name, Building_Type, Unit_Number, NoOf_Floors, PhoneNumber, Email)
VALUES (1, 1, 'ABC Building', 'Office', 50, 10, '123-456-7890', 'abc@building.com'),
       (2, 1, 'XYZ Building', 'Residential', 100, 20, '111-222-3333', 'xyz@building.com'),
       (3, 2, 'PQR Building', 'Retail', 25, 5, '444-555-6666', 'pqr@building.com'),
       (1, 3, 'MNO Building', 'Office', 75, 15, '777-888-9999', 'mno@building.com'),
       (2, 2, 'EFG Building', 'Residential', 200, 30, '555-666-7777', 'efg@building.com'),
       (3, 1, 'LMN Building', 'Retail', 10, 2, '111-444-7777', 'lmn@building.com'),
       (4, 3, 'STU Building', 'Office', 100, 20, '333-777-1111', 'stu@building.com'),
       (4, 2, 'GHI Building', 'Residential', 50, 10, '444-999-2222', 'ghi@building.com'),
       (1, 2, 'DEF Building', 'Retail', 15, 3, '222-555-8888', 'def@building.com'),
       (3, 3, 'VWX Building', 'Office', 125, 25, '777-111-4444', 'vwx@building.com');

-- insert data into the Lease table
INSERT INTO Lease (UnitID, TenantID, StartDate, EndDate, MonthlyRent, SecurityDeposit)
VALUES (11, 1, '2022-01-01', '2023-01-01', 1000.00, 1000.00),
       (12, 2, '2022-02-01', '2023-02-01', 1200.00, 1200.00),
       (13, 3, '2022-03-01', '2023-03-01', 1500.00, 1500.00),
       (14, 4, '2022-04-01', '2023-04-01', 900.00, 900.00),
       (15, 5, '2022-05-01', '2023-05-01', 800.00, 800.00),
       (6, 6, '2022-06-01', '2023-06-01', 1100.00, 1100.00),
       (7, 7, '2022-07-01', '2023-07-01', 950.00, 950.00),
       (8, 8, '2022-08-01', '2023-08-01', 1300.00, 1300.00),
       (9, 9, '2022-09-01', '2023-09-01', 1400.00, 1400.00),
       (10, 10, '2022-10-01', '2023-10-01', 1000.00, 1000.00);

-- insert data into the LeasePayment table
INSERT INTO LeasePayment (LeaseID, PaymentAmount, PaymentDate)
VALUES (10, 1000.00, '2022-01-01'),
       (11, 200.00, '2022-02-01'),
       (12, 1200.00, '2022-02-01'),
       (13, 1500.00, '2022-03-01'),
       (14, 900.00, '2022-04-01'),
       (9, 100.00, '2022-05-01'),
       (5, 800.00, '2022-06-01'),
       (6, 1100.00, '2022-07-01'),
       (7, 950.00, '2022-08-01'),
       (8, 1300.00, '2022-09-01');


-- insert data into the Tenant table
INSERT INTO Tenant (FirstName, LastName, PhoneNumber, Email)
VALUES ('John', 'Doe', '555-1234', 'john.doe@email.com'),
       ('Jane', 'Doe', '555-5678', 'jane.doe@email.com'),
       ('Bob', 'Smith', '555-9876', 'bob.smith@email.com'),
       ('Sally', 'Johnson', '555-6543', 'sally.johnson@email.com'),
       ('Mike', 'Williams', '555-2345', 'mike.williams@email.com'),
       ('Karen', 'Davis', '555-4321', 'karen.davis@email.com'),
       ('Tom', 'Brown', '555-8765', 'tom.brown');


-- insert data into Address table
INSERT INTO Address (DetailedAddress, City, State, Zipcode)
VALUES 
	( '100 Main St.', 'Seattle', 'CA', 12345),
      	( '200 Elm St.', 'Boston', 'NY', 54321),
	( '300 Maple Ave.', 'Portland', 'TX', 67890),
	( '400 Oak Rd.', 'NewYork', 'CA', 23456),
	( '500 Pine St.', 'Seattle', 'NY', 65432),
	( '600 Cedar Ln.', 'SF', 'TX', 78901),
	( '700 Walnut Dr.', 'San Hose', 'CA', 34567),
	( '800 Cherry St.', 'Olive', 'NY', 76543),
	( '900 Birch Ave.', 'Angels', 'TX', 89012),
	( '1000 Rose Blvd.', 'Dawn', 'CA', 45678),
	('567 Cherry Lane', 'Miami', 'FL', 33130),
	('890 Peachtree Street', 'Atlanta', 'GA', 30309),
	('234 Cedar Avenue', 'Portland', 'OR', 97205),
	('876 Oakwood Drive', 'San Francisco', 'CA', 94103),
	('543 Birch Street', 'Philadelphia', 'PA', 19107),
	('901 Magnolia Boulevard', 'New Orleans', 'LA', 70112),
	('432 Walnut Avenue', 'Dallas', 'TX', 75202),
	('765 Spruce Street', 'San Diego', 'CA', 92103),
	('2100 Broad Street', 'Nashville', 'TN', 37212),
	('987 Market Street', 'San Francisco', 'CA', 94103);


-- insert data into ManagementCompany table
INSERT INTO ManagementCompany 
	(CompanyName, PhoneNumber, Email, AddressID)
VALUES 
	( 'Steven Property Management Company',2063787879, 'stevenproplimit@gmail.com', 4),
	( 'Lora Property Company',2063947870, 'loraproperty@gmail.com', 5),
	( 'Redmond Management Company',2063730740, 'redmond.co@gmail.com', 6),
	( 'Richmond Building Company',2063771075, 'richmondbuilding@gmail.com', 7),
	( 'Issaquah Management Company',2063787994, 'redmond.co@gmail.com', 8),
	( 'Space Limitless Company',2063380074, 'redmond.co@gmail.com', 9),
	( 'Redmond Management Company',2063221009, 'redmond.co@gmail.com', 10),
	( 'SLU Management Company',2069072093, 'slumanagement@gmail.com', 1),
	( 'Washington Property Company',2063012243, 'washington.co@gmail.com', 2),
	( 'Magnolia Property Company',2060812263, 'magnolia.co@gmail.com', 3);

	 
-- insert data into Employee table	 
INSERT INTO Employee 
	 (AddressID, CompanyID, FirstName, LastName, Type, PhoneNumber, Email)
VALUES 
       (11, 1, 'John', 'Doe', 'Manager', 5551234, 'john.doe@example.com'),
       (12, 1, 'Jane', 'Smith', 'Assistant Manager', 5555678, 'jane.smith@example.com'),
       (13, 2, 'Bob', 'Jones', 'Maintenance Staff', 5559012, 'bob.jones@example.com'),
       (14, 2, 'Sara', 'Lee', 'Staff', 5553456, 'sara.lee@example.com'),
       (15, 3, 'Tom', 'Green', 'Maintenance Staff', 5557890, 'tom.green@example.com'),
       (16, 3, 'Lisa', 'Black', 'Assistant Manager', 5552345, 'lisa.black@example.com'),
       (17, 4, 'Mike', 'White', 'Staff', 5556789, 'mike.white@example.com'),
       (18, 4, 'Katie', 'Brown', 'Maintenance Staff', 5550123, 'katie.brown@example.com'),
       (19, 5, 'Joe', 'Gray', 'Manager', 5554567, 'joe.gray@example.com'),
       (20, 5, 'Amy', 'Taylor', 'Maintenance Staff', 5558901, 'amy.taylor@example.com');

	
INSERT INTO ProspectiveTenant (FirstName, LastName, PhoneNumber, Email)
VALUES
  ('John', 'Doe', 1234567890, 'john.doe@email.com'),
  ('Jane', 'Doe', 2345678901, 'jane.doe@email.com'),
  ('Bob', 'Smith', 3456789012, 'bob.smith@email.com'),
  ('Alice', 'Johnson', 4567890123, 'alice.johnson@email.com'),
  ('David', 'Lee', 5678901234, 'david.lee@email.com'),
  ('Emily', 'Chen', 6789012345, 'emily.chen@email.com'),
  ('James', 'Wilson', 7890123456, 'james.wilson@email.com'),
  ('Sarah', 'Garcia', 8901234567, 'sarah.garcia@email.com'),
  ('Michael', 'Taylor', 9012345678, 'michael.taylor@email.com'),
  ('Karen', 'Nguyen', 1234509876, 'karen.nguyen@email.com');


-- Assuming TenantID 1 and UnitID 1 exist in their respective tables
INSERT INTO UnitMaintenanceRequest (TenantID, UnitID, EmployeeID, Description, Status, RequestDate, CompletedDate)
VALUES
(1, 11, 123, 'Leaky faucet', 'Open', '2023-03-01', '2023-03-05'),
(2, 12, 234, 'Broken toilet', 'Open', '2023-03-02', '2023-03-06'),
(3, 10, 345, 'Clogged drain', 'Open', '2023-03-03', '2023-03-07'),
(4, 13, 456, 'Faulty light switch', 'Open', '2023-03-04', '2023-03-08'),
(5, 6, 567, 'No hot water', 'Open', '2023-03-05', '2023-03-09'),
(6, 7, 678, 'Leaking ceiling', 'Open', '2023-03-06', '2023-03-10'),
(7, 8, 789, 'Loud HVAC unit', 'Open', '2023-03-07', '2023-03-11'),
(8, 9, 890, 'Bathroom sink not draining', 'Open', '2023-03-08', '2023-03-12'),
(9, 13, 901, 'Damaged window', 'Open', '2023-03-09', '2023-03-13'),
(10, 10, 012, 'Appliance not working', 'Open', '2023-03-10', '2023-03-14');

 
--insert data into EmployeeBuilding table
INSERT INTO EmployeeBuilding (EmployeeID, BuildingID)
VALUES 
    (1, 10),
    (2, 9),
    (3, 8),
    (4, 7),
    (5, 6),
    (6, 5),
    (7, 4),
    (8, 3),
    (9, 2),
    (10, 11);
    
INSERT INTO LeaseTenant (LeaseID, TenantID) VALUES
(13, 1),
(6, 2),
(7, 3),
(8, 4),
(9, 5),
(10, 6),
(11, 7),
(12, 8),
(13, 9),
(10, 10);


INSERT INTO TenantUnit (TenantID, UnitID) VALUES
(1, 11),
(2, 13),
(3, 15),
(4, 9),
(5, 10),
(6, 9),
(7, 6),
(8, 7),
(9, 8),
(10, 9);

INSERT INTO ProspectiveTenantInterestedUnit (P_TenantID, UnitID) VALUES
(11, 9),
(10, 8),
(12, 6),
(13, 9),
(14, 14),
(15,13),
(6, 7),
(7, 8),
(8, 9),
(9, 10);


-- Table-level CHECK Constraints based on a function

-- Function to check if end date is after start date on the lease
CREATE FUNCTION CheckLeaseDates
(
	@StartDate DATE,
	@EndDate DATE
)
RETURNS BIT
AS
BEGIN
	DECLARE @Result BIT

	IF @EndDate >= @StartDate
		SET @Result = 1
	ELSE
		SET @Result = 0

	RETURN @Result
END

-- Alter the lease table to include the table level check constraint based on the function
ALTER TABLE Lease 
ADD CONSTRAINT CHK_LeaseDates CHECK (dbo.CheckLeaseDates(StartDate, EndDate) = 1);

-- To test the function
INSERT INTO Lease (UnitID, TenantID, StartDate, EndDate, MonthlyRent, SecurityDeposit)
VALUES (1, 2, '2023-04-01', '2022-03-31', 1200.00, 1000.00);


-- Function to validate zipcodes
CREATE FUNCTION dbo.validate_zipcode(@zipcode VARCHAR(10))
RETURNS BIT
AS
BEGIN
    DECLARE @result BIT
    SET @result = 0

    IF @zipcode LIKE '[0-9][0-9][0-9][0-9][0-9]' 
        SET @result = 1

    RETURN @result
END
GO

-- Alter the address table to include the table level check constraint based on the function
ALTER TABLE address
ADD CONSTRAINT chk_zipcode CHECK (dbo.validate_zipcode(zipcode) = 1);

-- To test the function
INSERT INTO Address (DetailedAddress, City, State, Zipcode)
VALUES ('123 Main St', 'Anytown', 'CA', 123456);


-- Function to check square footage
CREATE FUNCTION CheckSquareFootage (@squareFootage FLOAT)
RETURNS BIT
AS
BEGIN
    DECLARE @result BIT
    IF (@squareFootage >= 100)
        SET @result = 1
    ELSE
        SET @result = 0
    RETURN @result
END

-- Alter the unit table to include the table level check constraint based on the function
ALTER TABLE Unit
ADD CONSTRAINT CK_Unit_SquareFootage CHECK (dbo.CheckSquareFootage(SquareFootage) = 1);

-- To test the function
INSERT INTO Unit (BuildingID, UnitNo, Bedroom, Bathroom, Availability, SquareFootage)
VALUES (1, 101, 2, 1.5, 'Available', 12.0);


-- create a funtion used to create a computed column
GO

CREATE FUNCTION GetTotalParkingFee_Unit(@UnitID INT)
RETURNS FLOAT(2)
AS
BEGIN
    DECLARE @TotalPayment FLOAT(2)
    SELECT  @TotalPayment = SUM(Fee) 
    FROM Parking
    WHERE UnitID = @UnitID
    RETURN @TotalPayment;
END

GO

-- create a view to show the total parking payment for each unit

CREATE VIEW unit_parkingfee AS(
    SELECT DISTINCT UnitID, dbo.GetTotalParkingFee_Unit(UnitID) AS TotalParkingPayment, COUNT(UnitID) AS PaymentTimes
    FROM Parking p
    GROUP BY UnitID
)

SELECT * FROM unit_parkingfee;

--  create a view to see the units and their maintenance requests

CREATE VIEW MaintenanceRequests
AS
SELECT r.RequestID, r.TenantID, r.UnitID, u.UnitNo, u.Availability, r.Description, r.Status, r.RequestDate, r.CompletedDate
FROM UnitMaintenanceRequest r
JOIN Unit u ON r.UnitID = u.UnitID;
-- SELECT * FROM MaintenanceRequests;


-- View for prospective tenants to view all the available units

CREATE VIEW AvailableUnits AS
SELECT 
  Building.Building_Name,
  Building.Building_Type,
  Unit.UnitNo,
  Unit.Bedroom,
  Unit.Bathroom,
  Unit.SquareFootage,
  Unit.Availability
FROM 
  Building
  INNER JOIN Unit ON Building.buildingID = Unit.BuildingID
  LEFT JOIN Amenity ON Building.buildingID = Amenity.buildingID
WHERE 
  Unit.Availability = 'Available'
