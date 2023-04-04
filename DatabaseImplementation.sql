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

-- create Lease_Tenant table with a clustered primary key constraint
CREATE TABLE Lease_Tenant (
  LeaseID INT NOT NULL
	REFERENCES Lease(LeaseID),
  TenantID INT NOT NULL
	REFERENCES Tenant(TenantID),
  CONSTRAINT PK_Lease_Tenant PRIMARY KEY CLUSTERED (LeaseID, TenantID),
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
  Type VARCHAR(15) NOT NULL,
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
	REFERENCES Building(BuildingID),
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
  Building_ID INT IDENTITY(1,1) PRIMARY KEY,
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
   Unit_ID INT FOREIGN KEY REFERENCES Unit(Unit_ID),
   Fee FLOAT,
   PaymentDate DATE
);

CREATE TABLE Amenity (
  Amenity_ID INT IDENTITY(1,1) PRIMARY KEY,
  Building_ID INT FOREIGN KEY REFERENCES Building(Building_ID),
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


--create table utilities
CREATE TABLE Utilities(
UtilitiesID INT IDENTITY PRIMARY KEY,
UnitID INT NOT NULL,
Gasbill FLOAT NOT NULL,
ElectricityBill FLOAT NOT NULL,
WaterBill FLOAT NOT NULL,
--computed column	
TotalFee AS CalculateTotalFee(Gasbill, ElectricityBill, WaterBill),
PaymentDate DATE NOT NULL,
FOREIGN KEY (UnitID) REFERENCES Unit(UnitID)
);


-- The function used to create a computed column in Utilities Table
GO

CREATE FUNCTION CalculateTotalFee(@gas_bill FLOAT, @electricity_bill FLOAT, @water_bill FLOAT)
RETURNS FLOAT
AS
BEGIN
    DECLARE @TotalFee FLOAT;
    SET @TotalPayment =  @gas_bill + @electricity_bill + @water_bill
    RETURN @TotalPayment;
END

GO

-- create TenantUnit table with a clustered primary key constraint
CREATE TABLE TenantUnit(
TenantID INT NOT NULL
         REFERENCES Tenant(TenantID),
UnitID INT NOT NULL
         REFERENCES Unit(UnitID),
CONSTRAINT PK_TenantUnit PRIMARY KEY CLUSTERED (TenantID,UnitID)
);



INSERT INTO Unit
	(BuildingID, UnitNo, Bedroom, Bathroom, Availability, SquareFootage)
VALUES
	(1, 101, 1, 1, 'available', 500),
	(1, 102, 2, 2, 'occupied', 1000),
	(1, 103, 3, 2.5, 'available', 1500),
	(2, 201, 2, 1.5, 'occupied', 1000),
	(2, 202, 1, 1, 'available', 500),
	(2, 203, 2, 2, 'available', 1000),
	(3, 301, 2, 1.5, 'available', 1000),
	(3, 302, 3, 2, 'occupied', 1500),
	(3, 303, 1, 1, 'available', 500),
	(4, 401, 2, 2, 'occupied', 1000),
	(4, 402, 3, 2.5, 'available', 1500),
	(4, 403, 1, 1, 'available', 500),
	(5, 501, 1, 1, 'occupied', 500),
	(5, 502, 2, 1.5, 'available', 1000),
	(5, 503, 3, 2, 'available', 1500);



	INSERT INTO Utilities (UnitID, Gasbill, ElectricityBill, WaterBill, TotalFee, PaymentDate)
VALUES 
	(1, 50.0, 25.0, 20.0, 95.0, '2023-02-01'),
	(2, 60.0, 30.0, 25.0, 115.0, '2023-02-01'),
	(3, 70.0, 35.0, 30.0, 135.0, '2023-02-01'),
	(4, 80.0, 40.0, 35.0, 155.0, '2023-02-01'),
	(5, 90.0, 45.0, 40.0, 175.0, '2023-02-01'),
	(6, 100.0, 50.0, 45.0, 195.0, '2023-02-01'),
	(7, 110.0, 55.0, 50.0, 215.0, '2023-02-01'),
	(8, 120.0, 60.0, 55.0, 235.0, '2023-02-01'),
	(9, 130.0, 65.0, 60.0, 255.0, '2023-02-01'),
	(10, 140.0, 70.0, 65.0, 275.0, '2023-02-01'),
	(11, 50.0, 25.0, 20.0, 95.0, '2023-03-01'),
	(12, 60.0, 30.0, 25.0, 115.0, '2023-03-01'),
	(13, 70.0, 35.0, 30.0, 135.0, '2023-03-01'),
	(14, 80.0, 40.0, 35.0, 155.0, '2023-03-01'),
	(15, 90.0, 45.0, 40.0, 175.0, '2023-03-01');


INSERT INTO Amenity(Building_ID, Amenity_Name, Amenity_Type, Cost)
VALUES (1, 'Swimming Pool', 'Recreational', 150.00),
       (1, 'Gym', 'Fitness', 100.00),
       (2, 'Tennis Court', 'Recreational', 50.00),
       (2, 'BBQ Area', 'Recreational', 25.00),
       (3, 'Meeting Room', 'Business', 75.00),
       (4, 'Movie Theater', 'Entertainment', 200.00),
       (5, 'Playground', 'Recreational', 35.00),
       (6, 'Dog Park', 'Recreational', 50.00),
       (7, 'Yoga Studio', 'Fitness', 80.00),
       (8, 'Game Room', 'Entertainment', 125.00);
       
INSERT INTO Parking(Unit_ID, Fee, PaymentDate)
VALUES (1, 50.0, '2022-03-01'),
       (2, 25.0, '2022-03-02'),
       (3, 35.0, '2022-03-03'),
       (4, 20.0, '2022-03-04'),
       (5, 30.0, '2022-03-05'),
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
VALUES (1, 1, '2022-01-01', '2023-01-01', 1000.00, 1000.00),
       (1, 2, '2022-02-01', '2023-02-01', 1200.00, 1200.00),
       (2, 3, '2022-03-01', '2023-03-01', 1500.00, 1500.00),
       (2, 4, '2022-04-01', '2023-04-01', 900.00, 900.00),
       (3, 5, '2022-05-01', '2023-05-01', 800.00, 800.00),
       (3, 6, '2022-06-01', '2023-06-01', 1100.00, 1100.00),
       (4, 7, '2022-07-01', '2023-07-01', 950.00, 950.00),
       (4, 8, '2022-08-01', '2023-08-01', 1300.00, 1300.00),
       (5, 9, '2022-09-01', '2023-09-01', 1400.00, 1400.00),
       (5, 10, '2022-10-01', '2023-10-01', 1000.00, 1000.00);

-- insert data into the LeasePayment table
INSERT INTO LeasePayment (LeaseID, PaymentAmount, PaymentDate)
VALUES (1, 1000.00, '2022-01-01'),
       (1, 200.00, '2022-02-01'),
       (2, 1200.00, '2022-02-01'),
       (3, 1500.00, '2022-03-01'),
       (4, 900.00, '2022-04-01'),
       (4, 100.00, '2022-05-01'),
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
       ('Tom', 'Brown', '555-8765', 'tom.brown);




-- insert data into Address table
INSERT INTO Address (DetailedAddress, City, State, Zipcode)
VALUES ( '100 Main St.', 'Seattle', 'CA', 12345),
       ( '200 Elm St.', 'Boston', 'NY', 54321),
       ( '300 Maple Ave.', 'Portland', 'TX', 67890),
       ( '400 Oak Rd.', 'NewYork', 'CA', 23456),
       ( '500 Pine St.', 'Seattle', 'NY', 65432),
       ( '600 Cedar Ln.', 'SF', 'TX', 78901),
       ( '700 Walnut Dr.', 'San Hose', 'CA', 34567),
       ( '800 Cherry St.', 'Olive', 'NY', 76543),
       ( '900 Birch Ave.', 'Angels', 'TX', 89012),
       ( '1000 Rose Blvd.', 'Dawn', 'CA', 45678);


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
       
INSERT INTO Address (Detailed_Address, City, State, ZipCode)
VALUES 
('123 Main Street', 'New York', 'NY', 10001),
('456 Elm Street', 'Los Angeles', 'CA', 90012),
('789 Oak Street', 'Chicago', 'IL', 60611),
('987 Pine Street', 'Houston', 'TX', 77002),
('654 Maple Street', 'Seattle', 'WA', 98101),
('246 Broadway', 'Boston', 'MA', 02115),
('1350 15th Street', 'Denver', 'CO', 80202),
('3780 Wilshire Blvd', 'Los Angeles', 'CA', 90010),
('1600 Pennsylvania Ave NW', 'Washington', 'DC', 20500),
('3300 Las Vegas Blvd S', 'Las Vegas', 'NV', 89109);
       
       
       
-- create a funtion used to create a computed column
GO

CREATE FUNCTION GetTotalParkingFee_Unit(@UnitID INT)
RETURNS FLOAT(10,2)
AS
BEGIN
    DECLARE @TotalPayment FLOAT(10,2)
    SELECT  @TotalPayment = SUM(Fee) 
    FROM Parking
    WHERE UnitID = @UnitID
    RETURN @TotalPayment;
END

GO

-- create a view to show the total parking payment for each unit

CREATE VIEW unit_parkingfee AS
SELECT DISTINCT UnitID, GetTotalParkingFee_Unit(UnitID) AS TotalParkingPayment, COUNT(UnitID) AS PaymentTimes
FROM Parking p;

SELECT * FROM unit_parkingfee;


