-- create Lease table
CREATE TABLE Lease (
  LeaseID INT IDENTITY PRIMARY KEY,
  UnitID INT,
  TenantID INT,
  StartDate DATE,
  EndDate DATE,
  MonthlyRent DECIMAL(10,2),
  SecurityDeposit DECIMAL(10,2),
  FOREIGN KEY (UnitID) REFERENCES Unit(UnitID),
  FOREIGN KEY (TenantID) REFERENCES Tenant(TenantID)
);

-- create Lease Payment table
CREATE TABLE LeasePayment (
  LeasePaymentID INT IDENTITY PRIMARY KEY,
  LeaseID INT,
  PaymentAmount DECIMAL(10,2),
  PaymentDate DATE,
  FOREIGN KEY (LeaseID) REFERENCES Lease(LeaseID)
);

-- create Tenant table
CREATE TABLE Tenant (
  TenantID INT IDENTITY PRIMARY KEY,
  FirstName VARCHAR(50),
  LastName VARCHAR(50),
  PhoneNumber VARCHAR(20),
  Email VARCHAR(100)
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
  AddressID VARCHAR(45) NOT NULL
  FOREIGN KEY (AddressID) REFERENCES Address(AddressID)
);

-- create Employee table
CREATE TABLE Employee (
  EmployeeID INT IDENTITY PRIMARY KEY,
  AddressID VARCHAR(50),
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





-- insert data into ManagementCompany table
INSERT INTO ManagementCompany 
	(CompanyID, CompanyName, PhoneNumber, Email, AddressID)
VALUES 
	(1, ‘Steven Property Management Company',2063787879, ‘stevenproplimit@gmail.com’, 4),
	(2, ‘Lora Property Company',2063947870, ‘loraproperty@gmail.com’, 5),
	(3, ‘Redmond Management Company’,2063730740, ‘redmond.co@gmail.com’, 6),
	(4, ‘Richmond Building Company',2063771075, ‘richmondbuilding@gmail.com’, 7),
	(5, ‘Issaquah Management Company',2063787994, ‘redmond.co@gmail.com’, 8),
	(6, ‘Space Limitless Company',2063380074, ‘redmond.co@gmail.com’, 9),
	(7, ‘Redmond Management Company',2063221009, ‘redmond.co@gmail.com’, 10),
	(8, ‘SLU Management Company',2069072093, ‘slumanagement@gmail.com’, 1),
	(9, ‘Washington Property Company',2063012243, ‘washington.co@gmail.com’, 2),
	(10, ‘Magnolia Property Company',2060812263, ‘magnolia.co@gmail.com’, 3);

	 
-- insert data into Employee table	 
INSERT INTO Employee 
	 (AddressID, CompanyID, FirstName, LastName, Type, PhoneNumber, Email)
VALUES 
       ('11', 1, 'John', 'Doe', 'Manager', 5551234, 'john.doe@example.com'),
       ('12', 1, 'Jane', 'Smith', 'Assistant Manager', 5555678, 'jane.smith@example.com'),
       ('13', 2, 'Bob', 'Jones', 'Maintenance Staff', 5559012, 'bob.jones@example.com'),
       ('14', 2, 'Sara', 'Lee', 'Staff', 5553456, 'sara.lee@example.com'),
       ('15', 3, 'Tom', 'Green', 'Maintenance Staff', 5557890, 'tom.green@example.com'),
       ('16', 3, 'Lisa', 'Black', 'Assistant Manager', 5552345, 'lisa.black@example.com'),
       ('17', 4, 'Mike', 'White', 'Staff', 5556789, 'mike.white@example.com'),
       ('18', 4, 'Katie', 'Brown', 'Maintenance Staff', 5550123, 'katie.brown@example.com'),
       ('19', 5, 'Joe', 'Gray', 'Manager', 5554567, 'joe.gray@example.com'),
       ('20', 5, 'Amy', 'Taylor', 'Maintenance Staff', 5558901, 'amy.taylor@example.com');



