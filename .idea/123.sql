CREATE TABLE dbo.Patient
(
PatientID int IDENTITY NOT NULL PRIMARY KEY ,
LastName varchar(40) NOT NULL,
FirstName varchar(40) NOT NULL,
DateOfBirth DATETIME
);