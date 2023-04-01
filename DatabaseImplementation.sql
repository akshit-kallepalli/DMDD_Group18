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



