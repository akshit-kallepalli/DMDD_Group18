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

-- create ManagementCompany table with a 
CREATE TABLE ManagementCompany (
  CompanyID INT IDENTITY PRIMARY KEY,
  CompanyName VARCHAR(45) NOT NULL,
  PhoneNumber INT NOT NULL,
  Email VARCHAR(45) NOT NULL,
  AddressID VARCHAR(45) NOT NULL
  FOREIGN KEY (AddressID) REFERENCES Address(AddressID)
);


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

CREATE TABLE EmployeeBuilding(
  EmployeeID INT NOT NULL
	REFERENCES Employee(EmployeeID),
  BuildingID INT NOT NULL
	REFERENCES Building(BuildingID),
  CONSTRAINT PK_EmployeeBuilding PRIMARY KEY CLUSTERED (EmployeeID, BuildingID)
);


