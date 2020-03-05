CREATE DATABASE EntertainmentAgencyExample;

use EntertainmentAgencyExample;

CREATE TABLE Agents (
        AgentID int NOT NULL ,
        AgtFirstName nvarchar (25) NULL ,
        AgtLastName nvarchar (25) NULL ,
        AgtStreetAddress nvarchar (50) NULL ,
        AgtCity nvarchar (30) NULL ,
        AgtState nvarchar (2) NULL ,
        AgtZipCode nvarchar (10) NULL ,
        AgtPhoneNumber nvarchar (15) NULL ,
        DateHired date NULL ,
        Salary decimal(15, 2) NULL DEFAULT 0 ,
        CommissionRate float(24) NULL DEFAULT 0 
);

CREATE TABLE Customers (
        CustomerID int NOT NULL ,
        CustFirstName nvarchar (25) NULL ,
        CustLastName nvarchar (25) NULL ,
        CustStreetAddress nvarchar (50) NULL ,
        CustCity nvarchar (30) NULL ,
        CustState nvarchar (2) NULL ,
        CustZipCode nvarchar (10) NULL ,
        CustPhoneNumber nvarchar (15) NULL 
);

CREATE TABLE Engagements (
        EngagementNumber int NOT NULL DEFAULT 0 ,
        StartDate date NULL ,
        EndDate date NULL ,
        StartTime time NULL ,
        StopTime time NULL ,
        ContractPrice decimal(15,2) NULL DEFAULT 0 ,
        CustomerID int NULL DEFAULT 0 ,
        AgentID int NULL DEFAULT 0 ,
        EntertainerID int NULL DEFAULT 0 
);

CREATE TABLE Entertainer_Members (
        EntertainerID int NOT NULL ,
        MemberID int NOT NULL DEFAULT 0 ,
        Status smallint NULL DEFAULT 0 
);

CREATE TABLE Entertainer_Styles (
        EntertainerID int NOT NULL ,
        StyleID smallint NOT NULL DEFAULT 0 ,
        StyleStrength smallint NOT NULL 
);

CREATE TABLE Entertainers (
        EntertainerID int NOT NULL ,
        EntStageName nvarchar (50) NULL ,
        EntSSN nvarchar (12) NULL ,
        EntStreetAddress nvarchar (50) NULL ,
        EntCity nvarchar (30) NULL ,
        EntState nvarchar (2) NULL ,
        EntZipCode nvarchar (10) NULL ,
        EntPhoneNumber nvarchar (15) NULL ,
        EntWebPage nvarchar (50) NULL ,
        EntEMailAddress nvarchar (50) NULL ,
        DateEntered date NULL 
);

CREATE TABLE Members (
        MemberID int NOT NULL DEFAULT 0 ,
        MbrFirstName nvarchar (25) NULL ,
        MbrLastName nvarchar (25) NULL ,
        MbrPhoneNumber nvarchar (15) NULL ,
        Gender nvarchar (2) NULL 
);

CREATE TABLE Musical_Preferences (
        CustomerID int NOT NULL DEFAULT 0 ,
        StyleID smallint NOT NULL DEFAULT 0 ,
        PreferenceSeq smallint NOT NULL 
);

CREATE TABLE Musical_Styles (
        StyleID smallint NOT NULL DEFAULT 0 ,
        StyleName nvarchar (75) NULL 
);

CREATE TABLE ztblDays (
        DateField date NOT NULL 
);


CREATE TABLE ztblMonths ( 
        MonthYear nvarchar (15) NULL ,
        YearNumber smallint NOT NULL ,
        MonthNumber smallint NOT NULL ,
        MonthStart date NULL ,
        MonthEnd date NULL ,
        January smallint NULL DEFAULT 0 ,
        February smallint NULL DEFAULT 0 ,
        March smallint NULL DEFAULT 0 ,
        April smallint NULL DEFAULT 0 ,
        May smallint NULL DEFAULT 0 ,
        June smallint NULL DEFAULT 0 ,
        July smallint NULL DEFAULT 0 ,
        August smallint NULL DEFAULT 0 ,
        September smallint NULL DEFAULT 0 ,
        October smallint NULL DEFAULT 0 ,
        November smallint NULL DEFAULT 0 ,
        December smallint NULL DEFAULT 0 
);


CREATE TABLE ztblSkipLabels (
        LabelCount int NOT NULL  
);


CREATE TABLE ztblWeeks ( 
        WeekStart date NOT NULL ,
        WeekEnd date NULL 
);


ALTER TABLE Agents 
        ADD CONSTRAINT Agents_PK PRIMARY KEY 
        (
                AgentID
        );

CREATE  INDEX AgtZipCode ON Agents(AgtZipCode);

ALTER TABLE Customers 
        ADD CONSTRAINT Customers_PK PRIMARY KEY
        (
                CustomerID
        );

CREATE  INDEX CustZipCode ON Customers(CustZipCode);

ALTER TABLE Engagements 
        ADD CONSTRAINT Engagements_PK PRIMARY KEY         (
                EngagementNumber
        );

CREATE  INDEX AgentsEngagements ON Engagements(AgentID);

CREATE  INDEX CustomersEngagements ON Engagements(CustomerID);

CREATE INDEX Engagements_EmployeeID ON Engagements(AgentID);

CREATE  INDEX EntertainersEngagements ON Engagements(EntertainerID);

ALTER TABLE Entertainer_Members 
        ADD CONSTRAINT Entertainer_Members_PK PRIMARY KEY
        (
                EntertainerID,
                MemberID
        );

CREATE  INDEX EntertainersEntertainerMembers ON Entertainer_Members(EntertainerID);

CREATE  INDEX MembersEntertainerMembers ON Entertainer_Members(MemberID);

ALTER TABLE Entertainer_Styles 
        ADD CONSTRAINT Entertainer_Styles_PK PRIMARY KEY 
        (
                EntertainerID, 
                StyleID
        );

CREATE  INDEX EntertainersEntertainerStyles ON Entertainer_Styles(EntertainerID);

CREATE  INDEX MusicalStylesEntStyles ON Entertainer_Styles(StyleID);

ALTER TABLE Entertainers 
        ADD CONSTRAINT Entertainers_PK PRIMARY KEY 
        (
                EntertainerID
        );

CREATE  UNIQUE  INDEX EntertainerID ON Entertainers(EntertainerID);

CREATE  INDEX EntZipCode ON Entertainers(EntZipCode);

ALTER TABLE Members 
        ADD CONSTRAINT Members_PK PRIMARY KEY 
        (
                MemberID
        );

CREATE  INDEX MemberID ON Members(MemberID);

ALTER TABLE Musical_Preferences 
        ADD CONSTRAINT Musical_Preferences_PK PRIMARY KEY 
        (
                CustomerID, 
                StyleID
        );

CREATE  INDEX CustomersMusicalPreferences ON Musical_Preferences(CustomerID);

CREATE  INDEX StyleID ON Musical_Preferences(StyleID);

ALTER TABLE Musical_Styles 
        ADD CONSTRAINT Musical_Styles_PK PRIMARY KEY 
        (
                StyleID
        );

ALTER TABLE ztblDays ADD 
        CONSTRAINT ztblDays_PK PRIMARY KEY 
        ( 
                DateField 
        );


ALTER TABLE ztblMonths ADD 
        CONSTRAINT ztblMonths_PK PRIMARY KEY 
        ( 
                YearNumber, 
                MonthNumber
        );


 CREATE UNIQUE INDEX ztblMontths_MonthEnd ON ztblMonths(MonthEnd) ;


 CREATE UNIQUE INDEX ztblMonths_MonthStart ON ztblMonths(MonthStart) ;


 CREATE UNIQUE INDEX ztblMonths_MonthYear ON ztblMonths(MonthYear) ;


ALTER TABLE ztblSkipLabels ADD 
        CONSTRAINT ztblSkipLabels_PK PRIMARY KEY 
        (
                LabelCount 
        ) ;


ALTER TABLE ztblWeeks ADD 
        CONSTRAINT ztblWeeks_PK PRIMARY KEY 
        ( 
                WeekStart 
        ) ;


ALTER TABLE Engagements 
        ADD CONSTRAINT Engagements_FK00 FOREIGN KEY 
        (
                AgentID
        ) REFERENCES Agents (
                AgentID
        ),
        ADD CONSTRAINT Engagements_FK01 FOREIGN KEY 
        (
                CustomerID
        ) REFERENCES Customers (
                CustomerID
        ),
        ADD CONSTRAINT Engagements_FK02 FOREIGN KEY 
        (
                EntertainerID
        ) REFERENCES Entertainers (
                EntertainerID
        );

ALTER TABLE Entertainer_Members 
        ADD CONSTRAINT Entertainer_Members_FK00 FOREIGN KEY 
        (
                EntertainerID
        ) REFERENCES Entertainers (
                EntertainerID
        ),
        ADD CONSTRAINT Entertainer_Members_FK01 FOREIGN KEY 
        (
                MemberID
        ) REFERENCES Members (
                MemberID
        );

ALTER TABLE Entertainer_Styles 
        ADD CONSTRAINT Entertainer_Styles_FK00 FOREIGN KEY 
        (
                EntertainerID
        ) REFERENCES Entertainers (
                EntertainerID
        ),
        ADD CONSTRAINT Entertainer_Styles_FK01 FOREIGN KEY 
        (
                StyleID
        ) REFERENCES Musical_Styles (
                StyleID
        );

ALTER TABLE Musical_Preferences 
        ADD CONSTRAINT Musical_Preferences_FK00 FOREIGN KEY 
        (
                CustomerID
        ) REFERENCES Customers (
                CustomerID
        ),
        ADD CONSTRAINT Musical_Preferences_FK01 FOREIGN KEY 
        (
                StyleID
        ) REFERENCES Musical_Styles (
                StyleID
        );
