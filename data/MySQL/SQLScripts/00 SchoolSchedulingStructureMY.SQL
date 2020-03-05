CREATE DATABASE SchoolSchedulingExample;



use SchoolSchedulingExample;

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
	ClassRoomID int NOT NULL ,
	BuildingCode nvarchar (3) NULL ,
	PhoneAvailable bit NOT NULL DEFAULT 0 ,
        Capacity smallint NOT NULL DEFAULT 0
);

CREATE TABLE Classes (
	ClassID int NOT NULL ,
	SubjectID int NULL DEFAULT 0 ,
	ClassRoomID int NULL DEFAULT 0 ,
	Credits tinyint NULL DEFAULT 0 , 
        SemesterNumber smallint , 
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
	DepartmentID int NOT NULL ,
	DeptName nvarchar (50) NULL ,
	DeptChair int NULL DEFAULT 0 
);

CREATE TABLE Faculty (
	StaffID int NOT NULL ,
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
	StaffID int NOT NULL ,
	StfFirstName nvarchar (25) NULL ,
	StfLastname nvarchar (25) NULL ,
	StfStreetAddress nvarchar (50) NULL ,
	StfCity nvarchar (30) NULL ,
	StfState nvarchar (2) NULL ,
	StfZipCode nvarchar (5) NULL ,
	StfAreaCode nvarchar (5) NULL ,
	StfPhoneNumber nvarchar (8) NULL ,
	Salary decimal(15,2) NULL ,
	DateHired date NULL ,
	Position nvarchar (50) NULL 
);

CREATE TABLE Student_Class_Status (
	ClassStatus int NOT NULL DEFAULT 0 ,
	ClassStatusDescription nvarchar (50) NULL 
);

CREATE TABLE Student_Schedules (
	StudentID int NOT NULL ,
	ClassID int NOT NULL ,
	ClassStatus int NULL DEFAULT 0 ,
	Grade real NULL DEFAULT 0
);

CREATE TABLE Students (
	StudentID int NOT NULL ,
	StudFirstName nvarchar (25) NULL ,
	StudLastName nvarchar (25) NULL ,
	StudStreetAddress nvarchar (50) NULL ,
	StudCity nvarchar (30) NULL ,
	StudState nvarchar (2) NULL ,
	StudZipCode nvarchar (5) NULL ,
	StudAreaCode nvarchar (5) NULL ,
	StudPhoneNumber nvarchar (8) NULL ,
	StudBirthDate date NULL ,
	StudGender nvarchar (1) NULL,
	StudMaritalStatus nvarchar (1) NULL, 
        StudMajor int NULL 
);

CREATE TABLE Subjects (
	SubjectID int NOT NULL DEFAULT 0 ,
	CategoryID nvarchar (10) NULL ,
	SubjectCode nvarchar (8) NULL ,
	SubjectName nvarchar (50) NULL ,
        SubjectPreReq nvarchar (8) NULL DEFAULT NULL ,
	SubjectDescription text NULL ,
        SubjectEstClassSize smallint NOT NULL DEFAULT 0 
);

CREATE TABLE ztblGenderMatrix (
	Gender nvarchar (1) NOT NULL ,
        Male smallint NULL ,
        Female smallint NULL
) ;


CREATE TABLE ztblLetterGrades ( 
	LetterGrade nvarchar (3) NOT NULL ,
        LowGradePoint real NULL ,
        HighGradePoint real NULL 
) ; 


CREATE TABLE ztblMaritalStatusMatrix (
	MaritalStatus nvarchar (1) NOT NULL , 
	Married smallint NULL ,
        Single smallint NULL ,
        Widowed smallint NULL ,
        Divorced smallint NULL  
) ; 


CREATE TABLE ztblProfRatings ( 
        ProfRatingDesc nvarchar (12) NULL ,
        ProfRatingLow float (53) NOT NULL ,
        ProfRatingHigh float (53) NULL 
) ; 


CREATE TABLE ztblSemesterDays (
        SemesterNo smallint NOT NULL ,
        SemDate date NOT NULL ,
        SemDayName nvarchar (10) NULL
) ; 


CREATE TABLE ztblSeqNumbers ( 
        Sequence int NOT NULL DEFAULT 0 
) ; 


ALTER TABLE Buildings 
        ADD CONSTRAINT Buildings_PK PRIMARY KEY 
        (
                BuildingCode
        );

CREATE  INDEX NumberOfFloors ON Buildings(NumberOfFloors);

ALTER TABLE Categories 
        ADD CONSTRAINT Categories2_PK PRIMARY KEY 
        (
                CategoryID
        );

CREATE  INDEX DepartmentID ON Categories(DepartmentID);

ALTER TABLE Class_Rooms 
        ADD CONSTRAINT Class_Rooms_PK PRIMARY KEY 
        (
                ClassRoomID
        );

CREATE  INDEX BuildingNumber ON Class_Rooms(BuildingCode);

ALTER TABLE Classes 
        ADD CONSTRAINT Classes_PK PRIMARY KEY 
        (
                ClassID
        );

CREATE  INDEX SubjectID ON Classes(SubjectID);

CREATE  INDEX ClassRoomID ON Classes(ClassRoomID);

ALTER TABLE Departments 
	ADD CONSTRAINT Departments_PK PRIMARY KEY  
	(
		DepartmentID
	);  

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

CREATE  INDEX CategoriesFaculty_Categories ON Faculty_Categories(CategoryID);

CREATE  INDEX FacultyFaculty_Categories ON Faculty_Categories(StaffID);

ALTER TABLE Faculty_Classes 
        ADD CONSTRAINT Faculty_Classes_PK PRIMARY KEY 
        (
                ClassID, 
                StaffID
        );

CREATE  INDEX ClassesFacultyClasses ON Faculty_Classes(ClassID);

CREATE  INDEX StaffFacultyClasses ON Faculty_Classes(StaffID);

ALTER TABLE Faculty_Subjects 
        ADD CONSTRAINT Faculty_Subjects_PK PRIMARY KEY 
        (
                StaffID, 
                SubjectID
        );

CREATE  INDEX FacultyFacultySubjects ON Faculty_Subjects(StaffID);

CREATE  INDEX SubjectsFacultySubjects ON Faculty_Subjects(SubjectID);

ALTER TABLE Majors 
        ADD CONSTRAINT Majors_PK PRIMARY KEY
        (
               MajorID
        );

ALTER TABLE Staff 
        ADD CONSTRAINT Staff_PK PRIMARY KEY 
        (
                StaffID
        );

CREATE  INDEX StaffZipCode ON Staff(StfZipCode);

CREATE  INDEX StudAreaCode ON Staff(StfAreaCode);

ALTER TABLE Student_Class_Status 
        ADD CONSTRAINT Student_Class_Status_PK PRIMARY KEY 
        (
                ClassStatus
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

ALTER TABLE Students 
        ADD CONSTRAINT Students_PK PRIMARY KEY 
        (
                StudentID
        );

CREATE  INDEX StudAreaCode ON Students(StudAreaCode);

CREATE  INDEX StudZipCode ON Students(StudZipCode);

CREATE  INDEX StudMajor ON Students(StudMajor);

ALTER TABLE Subjects 
        ADD CONSTRAINT Subjects_PK PRIMARY KEY 
        (
                SubjectID
        );

CREATE  INDEX CategoryID ON Subjects(CategoryID);

CREATE  UNIQUE  INDEX SubjectCode ON Subjects(SubjectCode);

CREATE  INDEX SubjectPreReq ON Subjects(SubjectPreReq);

ALTER TABLE ztblGenderMatrix ADD 
        CONSTRAINT ztblGenderMatrix_PK PRIMARY KEY 
        (
               Gender
        ); 


ALTER TABLE ztblLetterGrades ADD 
        CONSTRAINT ztblLetterGrades_PK PRIMARY KEY
        (
                LetterGrade 
        ); 


ALTER TABLE ztblMaritalStatusMatrix ADD 
        CONSTRAINT ztblMaritalStatusMatrix_PK PRIMARY KEY
        (
                MaritalStatus 
        ); 


ALTER TABLE ztblProfRatings ADD 
	CONSTRAINT ztblProfRatings_PK PRIMARY KEY 
	(
		ProfRatingLow 
	); 


ALTER TABLE ztblSemesterDays ADD 
	CONSTRAINT ztblSemesterDays_PK PRIMARY KEY 
	( 
		SemesterNo ,
                SemDate 
	); 


ALTER TABLE ztblSeqNumbers ADD 
	CONSTRAINT ztblSeqNumbers_PK PRIMARY KEY 
	(
		Sequence 
	); 


ALTER TABLE Categories ADD 
	CONSTRAINT Categories_FK00 FOREIGN KEY 
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

ALTER TABLE Departments ADD 
	CONSTRAINT Departments_FK00 FOREIGN KEY 
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