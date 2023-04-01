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
       ('Tom', 'Brown', '555-8765', 'tom.brown

-- insert data into Address table
INSERT INTO Address 
	(DetailedAddress, City, State, Zipcode)
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



