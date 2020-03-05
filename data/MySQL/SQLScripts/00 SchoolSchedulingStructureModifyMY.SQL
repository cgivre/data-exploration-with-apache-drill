CREATE DATABASE SchoolSchedulingModify;

use SchoolSchedulingModify;

CREATE TABLE Buildings (
	BuildingCode nvarchar (3) NOT NULL ,
	BuildingName nvarchar (25) NULL ,
	NumberOfFloors smallint NULL ,
	ElevatorAccess bit NOT NULL DEFAULT 0 ,
	SiteParkingAvailable bit NOT NULL DEFAULT 0 
);

CREATE TABLE Categories (
	CategoryID nvarchar (10) NOT NULL ,
	CategoryDescription nvarchar (75) NULL ,
	DepartmentID int NULL DEFAULT 0 
);

CREATE TABLE Class_Rooms (
	ClassRoomID int NOT NULL AUTO_INCREMENT PRIMARY KEY ,
	BuildingCode nvarchar (3) NULL ,
	PhoneAvailable bit NOT NULL DEFAULT 0 
);

CREATE TABLE Classes (
	ClassID int NOT NULL AUTO_INCREMENT PRIMARY KEY ,
	SubjectID int NULL DEFAULT 0 ,
	ClassRoomID int NULL DEFAULT 0 ,
	Credits smallint NULL DEFAULT 0 ,
        StartDate date NULL ,
	StartTime time NULL ,
	Duration smallint NULL DEFAULT 0 ,
	MondaySchedule bit NOT NULL DEFAULT 0 ,
	TuesdaySchedule bit NOT NULL DEFAULT 0 ,
	WednesdaySchedule bit NOT NULL DEFAULT 0 ,
	ThursdaySchedule bit NOT NULL DEFAULT 0 ,
	FridaySchedule bit NOT NULL DEFAULT 0 ,
	SaturdaySchedule bit NOT NULL DEFAULT 0
);

CREATE TABLE Departments (
	DepartmentID int NOT NULL AUTO_INCREMENT PRIMARY KEY ,
	DeptName nvarchar (50) NULL ,
	DeptChair int NULL DEFAULT 0 
);

CREATE TABLE Faculty (
	StaffID int NOT NULL DEFAULT 0 ,
	Title nvarchar (50) NULL ,
	Status nvarchar (12) NULL ,
	Tenured bit NOT NULL DEFAULT 0 
);

CREATE TABLE Faculty_Categories (
	StaffID int NOT NULL ,
	CategoryID nvarchar (10) NOT NULL DEFAULT 'ACC' 
);

CREATE TABLE Faculty_Classes (
	ClassID int NOT NULL ,
	StaffID int NOT NULL 
);

CREATE TABLE Faculty_Subjects (
	StaffID int NOT NULL DEFAULT 0 ,
	SubjectID int NOT NULL DEFAULT 0 ,
	ProficiencyRating real NULL DEFAULT 0 
);

CREATE TABLE Majors (
        MajorID int NOT NULL ,
        Major nvarchar (20) NULL 
        );

CREATE TABLE Staff (
	StaffID int NOT NULL AUTO_INCREMENT PRIMARY KEY ,
	StfFirstName nvarchar (25) NULL ,
	StfLastname nvarchar (25) NULL ,
	StfStreetAddress nvarchar (50) NULL ,
	StfCity nvarchar (30) NULL ,
	StfState nvarchar (2) NULL ,
	StfZipCode nvarchar (5) NULL ,
	StfAreaCode nvarchar (5) NULL ,
	StfPhoneNumber nvarchar (8) NULL ,
	Salary decimal (15,2) NULL ,
	DateHired date NULL ,
	Position nvarchar (50) NULL 
);

CREATE TABLE Student_Class_Status (
	ClassStatus int NOT NULL AUTO_INCREMENT PRIMARY KEY ,
	ClassStatusDescription nvarchar (50) NULL 
);

CREATE TABLE Student_Schedules (
	StudentID int NOT NULL ,
	ClassID int NOT NULL ,
	ClassStatus int NULL DEFAULT 0 ,
	Grade float NULL DEFAULT 0 
);

CREATE TABLE Students (
	StudentID int NOT NULL AUTO_INCREMENT PRIMARY KEY ,
	StudFirstName nvarchar (25) NULL ,
	StudLastName nvarchar (25) NULL ,
	StudStreetAddress nvarchar (50) NULL ,
	StudCity nvarchar (30) NULL ,
	StudState nvarchar (2) NULL ,
	StudZipCode nvarchar (5) NULL ,
	StudAreaCode nvarchar (5) NULL ,
	StudPhoneNumber nvarchar (8) NULL ,
	StudGPA float NULL DEFAULT 0 ,
        StudMajor int NULL 
);

CREATE TABLE Subjects (
	SubjectID int NOT NULL AUTO_INCREMENT PRIMARY KEY ,
	CategoryID nvarchar (10) NULL ,
	SubjectCode nvarchar (8) NULL ,
	SubjectName nvarchar (50) NULL ,
        SubjectPreReq nvarchar (8) NULL DEFAULT NULL ,
	SubjectDescription text NULL
);

ALTER TABLE Buildings 
	ADD CONSTRAINT Buildings_PK PRIMARY KEY 
	(
		BuildingCode
	);

CREATE  INDEX NumberOfFloors ON Buildings(NumberOfFloors);

ALTER TABLE Categories 
	ADD CONSTRAINT Categories_PK PRIMARY KEY 
	(
		CategoryID
	);

CREATE  INDEX DepartmentID ON Categories(DepartmentID);

CREATE  INDEX BuildingNumber ON Class_Rooms(BuildingCode);

CREATE  INDEX ClassesCategoryID ON Classes(SubjectID);

CREATE  INDEX ClassRoomID ON Classes(ClassRoomID);

CREATE  INDEX StaffDepartments ON Departments(DeptChair);

ALTER TABLE Faculty 
	ADD CONSTRAINT Faculty_PK PRIMARY KEY 
	(
		StaffID
	);

ALTER TABLE Faculty_Categories 
	ADD CONSTRAINT Faculty_Categories_PK PRIMARY KEY 
	(
		StaffID, 
		CategoryID
	);

CREATE  INDEX CategoryIDFaculty_Categories ON Faculty_Categories(CategoryID);

CREATE  INDEX StaffIDFaculty_Categories ON Faculty_Categories(StaffID);

ALTER TABLE Faculty_Classes 
	ADD CONSTRAINT Faculty_Classes_PK PRIMARY KEY 
	(
		ClassID, 
		StaffID
	);

CREATE  INDEX ClassesFaculty_Classes ON Faculty_Classes(ClassID);

CREATE  INDEX StaffFaculty_Classes ON Faculty_Classes(StaffID);

ALTER TABLE Faculty_Subjects 
	ADD CONSTRAINT Faculty_Subjects_PK PRIMARY KEY 
	(
		StaffID, 
		SubjectID
	);

CREATE  INDEX StaffIDFaculty_Subjects ON Faculty_Subjects(StaffID);

CREATE  INDEX SubjectsFaculty_Subjects ON Faculty_Subjects(SubjectID);

CREATE  INDEX StaffZipCode ON Staff(StfZipCode);

CREATE  INDEX StudAreaCode ON Staff(StfAreaCode);

ALTER TABLE Majors 
        ADD CONSTRAINT Majors_PK PRIMARY KEY
        (
               MajorID
        );

ALTER TABLE Student_Schedules 
	ADD CONSTRAINT Student_Schedules_PK PRIMARY KEY 
	(
		StudentID, 
		ClassID
	);

CREATE  INDEX ClassesStudent_Schedules ON Student_Schedules(ClassID);

CREATE  INDEX Student_Class_StatusStudent_Schedules ON Student_Schedules(ClassStatus);

CREATE  INDEX StudentsStudent_Schedules ON Student_Schedules(StudentID);

CREATE  INDEX StudAreaCode ON Students(StudAreaCode);

CREATE  INDEX StudZipCode ON Students(StudZipCode);

CREATE  INDEX StudMajor ON Students(StudMajor);

CREATE  INDEX CategoriesSubjects ON Subjects(CategoryID);

CREATE  UNIQUE  INDEX SubjectCode ON Subjects(SubjectCode);

CREATE  INDEX SubjPreReq ON Subjects(SubjectPreReq);

ALTER TABLE Categories 
        ADD CONSTRAINT Categories_FK00 FOREIGN KEY 
        (
                DepartmentID
        ) REFERENCES Departments (
                DepartmentID
        );

ALTER TABLE Class_Rooms 
        ADD CONSTRAINT Class_Rooms_FK00 FOREIGN KEY 
        (
                BuildingCode
        ) REFERENCES Buildings (
                BuildingCode
        );

ALTER TABLE Classes 
        ADD CONSTRAINT Classes_FK00 FOREIGN KEY 
        (
                ClassRoomID
        ) REFERENCES Class_Rooms (
                ClassRoomID
        ),
        ADD CONSTRAINT Classes_FK01 FOREIGN KEY 
        (
                SubjectID
        ) REFERENCES Subjects (
                SubjectID
        );

ALTER TABLE Departments 
        ADD CONSTRAINT Departments_FK00 FOREIGN KEY 
        (
                DeptChair
        ) REFERENCES Staff (
                StaffID
        );

ALTER TABLE Faculty 
        ADD CONSTRAINT Faculty_FK00 FOREIGN KEY 
        (
                StaffID
        ) REFERENCES Staff (
                StaffID
        );

ALTER TABLE Faculty_Categories 
        ADD CONSTRAINT Faculty_Categories_FK00 FOREIGN KEY 
        (
                CategoryID
        ) REFERENCES Categories (
                CategoryID
        ),
        ADD CONSTRAINT Faculty_Categories_FK01 FOREIGN KEY 
        (
                StaffID
        ) REFERENCES Faculty (
                StaffID
        );

ALTER TABLE Faculty_Classes 
        ADD CONSTRAINT Faculty_Classes_FK00 FOREIGN KEY 
        (
                ClassID
        ) REFERENCES Classes (
                ClassID
        ),
        ADD CONSTRAINT Faculty_Classes_FK01 FOREIGN KEY 
        (
                StaffID
        ) REFERENCES Staff (
                StaffID
	),
        ADD CONSTRAINT Faculty_CLasses_FK02 FOREIGN KEY
	(
		StaffID
	) REFERENCES Faculty (
		StaffID
        );

ALTER TABLE Faculty_Subjects 
        ADD CONSTRAINT Faculty_Subjects_FK00 FOREIGN KEY 
        (
                StaffID
        ) REFERENCES Faculty (
                StaffID
        ),
        ADD CONSTRAINT Faculty_Subjects_FK01 FOREIGN KEY 
        (
                SubjectID
        ) REFERENCES Subjects (
                SubjectID
        );

ALTER TABLE Students 
        ADD CONSTRAINT Students_FK00 FOREIGN KEY
        (
                StudMajor
        ) REFERENCES Majors (
                MajorID
        );

ALTER TABLE Student_Schedules 
        ADD CONSTRAINT Student_Schedules_FK00 FOREIGN KEY 
        (
                ClassID
        ) REFERENCES Classes (
                ClassID
        ),
        ADD CONSTRAINT Student_Schedules_FK01 FOREIGN KEY 
        (
                ClassStatus
        ) REFERENCES Student_Class_Status (
                ClassStatus
        ),
        ADD CONSTRAINT Student_Schedules_FK02 FOREIGN KEY 
        (
                StudentID
        ) REFERENCES Students (
                StudentID
        );

ALTER TABLE Subjects 
        ADD CONSTRAINT Subjects_FK00 FOREIGN KEY 
        (
                CategoryID
        ) REFERENCES Categories (
                CategoryID
        ),
        ADD CONSTRAINT Subjects_FK01 FOREIGN KEY
	(
		SubjectPreReq
	) REFERENCES Subjects (
		SubjectCode
	);