USE [WideWorldImporters]; -- Your database here.

/*********************
 * Drop Tables
 *********************/

IF SCHEMA_ID(N'Clubs') IS NULL
   EXEC(N'CREATE SCHEMA [Clubs];');
GO

DROP TABLE IF EXISTS Clubs.MeetingAttendee;
DROP TABLE IF EXISTS Clubs.Attendee;
DROP TABLE IF EXISTS Clubs.Meeting;
DROP TABLE IF EXISTS Clubs.Club;
GO

/******************
 * Create Tables
 ******************/

CREATE TABLE Clubs.Club
(
   ClubId INT NOT NULL IDENTITY(1, 1) PRIMARY KEY,
   [Name] NVARCHAR(64) NOT NULL UNIQUE,
   Purpose NVARCHAR(1024) NOT NULL,
   CreatedOn DATETIMEOFFSET NOT NULL DEFAULT(SYSDATETIMEOFFSET()),
   UpdatedOn DATETIMEOFFSET NOT NULL DEFAULT(SYSDATETIMEOFFSET())
);

CREATE TABLE Clubs.Meeting
(
   MeetingId INT NOT NULL IDENTITY(1, 1) PRIMARY KEY,
   ClubId INT NOT NULL FOREIGN KEY
      REFERENCES Clubs.Club(ClubId),
   MeetingTime DATETIME2(0) NOT NULL,
   [Location] NVARCHAR(64) NOT NULL,
   CreatedOn DATETIMEOFFSET NOT NULL DEFAULT(SYSDATETIMEOFFSET()),
   UpdatedOn DATETIMEOFFSET NOT NULL DEFAULT(SYSDATETIMEOFFSET()),

   UNIQUE(ClubId, MeetingTime)
);

CREATE TABLE Clubs.Attendee
(
   AttendeeId INT NOT NULL IDENTITY(1, 1) PRIMARY KEY,
   Email NVARCHAR(128) NOT NULL UNIQUE,
   FirstName NVARCHAR(32) NOT NULL,
   LastName NVARCHAR(32) NOT NULL,
   CreatedOn DATETIMEOFFSET NOT NULL DEFAULT(SYSDATETIMEOFFSET()),
   UpdatedOn DATETIMEOFFSET NOT NULL DEFAULT(SYSDATETIMEOFFSET())
);

CREATE TABLE Clubs.MeetingAttendee
(
   MeetingId INT NOT NULL FOREIGN KEY
      REFERENCES Clubs.Meeting(MeetingId),
   AttendeeId INT NOT NULL FOREIGN KEY
      REFERENCES Clubs.Attendee(AttendeeId),
   CreatedOn DATETIMEOFFSET NOT NULL DEFAULT(SYSDATETIMEOFFSET()),

   PRIMARY KEY(MeetingId, AttendeeId)
);



-- Question 1
INSERT INTO Clubs.Club
VALUES ('ACM','The Association for Computing Machinery is the professional organization for computer scientists.',DEFAULT, DEFAULT),
	('MIS Club', 'The Kansas State MIS Club is a student driven organization focused on the management of information systems.',DEFAULT, DEFAULT)

INSERT Clubs.Meeting(ClubId, [Location], MeetingTime)
SELECT C.ClubId, M.[Location], M.MeetingTime
FROM (VALUES ('ACM','Engineering Building 1114', '2018-10-09 18:30:00'), ('ACM','Engineering Building 1114', '2018-11-13 18:30:00'), 
        ('MIS Club','Business Building 2116', '2018-11-06 18:00:00'), ('MIS Club','Business Building 2116', '2018-12-04 18:00:00')) 
		M([Name], [Location],MeetingTime)
		INNER JOIN Clubs.Club C ON C.Name = M.Name
GO

SELECT * FROM Clubs.Club
--Question 2

INSERT INTO Clubs.Attendee
VALUES ('yuto808263@ksu.edu','Yuto', 'Wada',DEFAULT, DEFAULT)

INSERT INTO Clubs.MeetingAttendee
VALUES (
(SELECT M.MeetingId FROM Clubs.Meeting M WHERE M.MeetingTime = '2018-10-09 18:30'), 
(SELECT A.AttendeeId FROM Clubs.Attendee A WHERE A.FirstName = 'Yuto'), DEFAULT)

SELECT *
FROM Clubs.Club

SELECT *
FROM Clubs.Meeting
SELECT *
FROM Clubs.Attendee
SELECT *
FROM Clubs.Meeting Attendee
-- Question 3

UPDATE Clubs.Meeting
SET Location = 'Business Building 4001' , UpdatedOn = SYSDATETIMEOFFSET()
WHERE ClubId = (SELECT C.ClubId FROM Clubs.Club C WHERE C.Name = 'MIS Club') AND MeetingTime = '2018-12-04 18:00:00' AND Location <> 'Business Building 4001' 

-- Question 4

