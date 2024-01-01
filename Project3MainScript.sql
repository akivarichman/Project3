--------------------------------------- CREATE THE DATABASE ------------------------------------------
-- Step 1 Instructions: run only lines 9 and 10 using the master database 

USE master
DROP DATABASE [QC_ClassSchedule_Group1]
GO

USE master
CREATE DATABASE [QC_ClassSchedule_Group1];
GO

--------------------------------------- CREATE SCHEMAS ------------------------------------------
-- Step 2 Instructions: Run all remaining code under the [QC_ClassSchedule_Group1] database

USE [QC_ClassSchedule_Group1];
GO

DROP SCHEMA IF EXISTS [Uploadfile]
GO
CREATE SCHEMA [Uploadfile]
GO

DROP SCHEMA IF EXISTS [DbSecurity]; 
GO
CREATE SCHEMA [DbSecurity];
GO

DROP SCHEMA IF EXISTS [Process]; 
GO
CREATE SCHEMA [Process];
GO

DROP SCHEMA IF EXISTS [Academic]; 
GO
CREATE SCHEMA [Academic];
GO

DROP SCHEMA IF EXISTS [Personnel]; 
GO
CREATE SCHEMA [Personnel];
GO

DROP SCHEMA IF EXISTS [ClassManagement]; 
GO
CREATE SCHEMA [ClassManagement];
GO

DROP SCHEMA IF EXISTS [Facilities];
GO
CREATE SCHEMA [Facilities];
GO

DROP SCHEMA IF EXISTS [Enrollment]; 
GO
CREATE SCHEMA [Enrollment];
GO

DROP SCHEMA IF EXISTS [Project3];
GO
CREATE SCHEMA [Project3];
GO

------------------------------------------ Import the UploadFile Data ---------------------------------------

-- Create the table 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Uploadfile].[CurrentSemesterCourseOfferings]
(
    [Semester] [varchar](50) NULL,
    [Sec] [varchar](50) NULL,
    [Code] [varchar](50) NULL,
    [Course (hr, crd)] [varchar](50) NULL,
    [Description] [varchar](50) NULL,
    [Day] [varchar](50) NULL,
    [Time] [varchar](50) NULL,
    [Instructor] [varchar](50) NULL,
    [Location] [varchar](50) NULL,
    [Enrolled] [varchar](50) NULL,
    [Limit] [varchar](50) NULL,
    [Mode of Instruction] [varchar](50) NULL
) ON [PRIMARY]
GO
ALTER TABLE [Uploadfile].[CurrentSemesterCourseOfferings] ADD CONSTRAINT [DF_CurrentSemesterCourseOfferings_Semester]  DEFAULT ('Current Semester') FOR [Semester]
GO

-- Upload data
INSERT INTO [QC_ClassSchedule_Group1].[Uploadfile].[CurrentSemesterCourseOfferings]
    (
    [Semester],
    [Sec],
    [Code],
    [Course (hr, crd)],
    [Description],
    [Day],
    [Time],
    [Instructor],
    [Location],
    [Enrolled],
    [Limit],
    [Mode of Instruction]
    )
SELECT *
FROM [QueensClassSchedule].[UploadFile].[CurrentSemesterCourseOfferings]
GO

------------------------------------------- CREATE TABLES ----------------------------------------------

-- UserAuthorization Table -- 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
DROP TABLE IF EXISTS [DbSecurity].[UserAuthorization]
GO
CREATE TABLE [DbSecurity].[UserAuthorization]
(
    -- all tables must have the following 3 columns:
    [UserAuthorizationKey] [int] NOT NULL IDENTITY(1,1), -- primary key
    [DateAdded] [datetime2] NOT NULL,
    [DateOfLastUpdate] [datetime2] NOT NULL,
    --
    [ClassTime] CHAR(4) NULL,
    [IndividualProject] CHAR(9) NULL,
    [GroupName] CHAR(7) NOT NULL,
    [GroupMemberLastName] VARCHAR(15) NOT NULL,
    [GroupMemberFirstName] VARCHAR(15) NOT NULL,
    PRIMARY KEY CLUSTERED ( [UserAuthorizationKey] ASC ) 
    WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/*
Table: Process.[WorkflowSteps]
Description:
This table is used for auditing and tracking the execution of various workflow steps within the system. 
It records key information about each workflow step, including a description, the number of rows affected, 
the start and end times of the step, and the user who executed the step.
*/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
DROP TABLE IF EXISTS [Process].[WorkflowSteps]
GO
CREATE TABLE [Process].[WorkflowSteps]
(
    [WorkFlowStepKey] [int] NOT NULL IDENTITY(1,1), -- primary key
    [WorkFlowStepDescription] VARCHAR(100) NOT NULL,
    [WorkFlowStepTableRowCount] [int] NULL,
    [StartingDateTime] [datetime2] NULL,
    [EndingDateTime] [datetime2] NULL,
    [QueryTime (ms)] [bigint] NULL,
    [Class Time] CHAR(4) NULL,
    -- all tables must have the following 3 columns:
    [UserAuthorizationKey] [int] NOT NULL, 
    [DateAdded] [datetime2] NOT NULL,
    [DateOfLastUpdate] [datetime2] NOT NULL,
    PRIMARY KEY CLUSTERED ( [WorkFlowStepKey] ASC )
    WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/*
Table: [Enrollment].[Semester]
-- =============================================
-- Author:		Sigalita Yakubova
-- Create date: 12/4/23
-- Description:	Showcase what semester belongs to each ID 
-- =============================================
*/
DROP TABLE IF EXISTS [Enrollment].[Semester]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Enrollment].[Semester]
(
    SemesterID [int] NOT NULL IDENTITY(1, 1), -- primary key
    SemesterName CHAR(16) NOT NULL,
    -- 1 of the 4 options
    -- add Year 
    -- all tables must have the following 3 columns:
    [UserAuthorizationKey] [int] NOT NULL, 
    [DateAdded] [datetime2] NOT NULL,
    [DateOfLastUpdate] [datetime2] NOT NULL,
    PRIMARY KEY CLUSTERED ( [SemesterID] ASC )
    WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/*
Table: [ClassManagement].[Days]
-- =============================================
-- Author:		Ahnaf Ahmed
-- Create date: 12/4/23
-- Description:	Table to store all days of the week to be later used for classdays bridge table
-- =============================================
*/
DROP TABLE IF EXISTS [ClassManagement].[Days]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ClassManagement].[Days]
(
    [DayID] [int] NOT NULL IDENTITY(1, 1), -- primary key
    [DayAbbreviation] CHAR(2) NOT NULL,
    -- all tables must have the following 3 columns:
    [UserAuthorizationKey] [int] NOT NULL, 
    [DateAdded] [datetime2] NOT NULL,
    [DateOfLastUpdate] [datetime2] NOT NULL,
    PRIMARY KEY CLUSTERED ( [DayID] ASC )
    WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/*
Table: [Personnel].[Instructor]
-- =============================================
-- Author:		Aleksandra Georgievska
-- Create date: 12/4/23
-- Description:	Load the names & IDs into the user Instructor table
-- =============================================
*/
DROP TABLE IF EXISTS [Personnel].[Instructor]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Personnel].[Instructor]
(
    InstructorID [int] NOT NULL IDENTITY(1, 1), -- primary key
    FirstName VARCHAR(25) NULL, 
    LastName VARCHAR(25) NULL,
    -- all tables must have the following 3 columns:
    [UserAuthorizationKey] [int] NOT NULL, 
    [DateAdded] [datetime2] NOT NULL,
    [DateOfLastUpdate] [datetime2] NOT NULL,
    PRIMARY KEY CLUSTERED ( [InstructorID] ASC )
    WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/*
Table: [Academic].[Department]
-- =============================================
-- Author:		Aryeh Richman
-- Create date: 12/5/23
-- Description:	Create a Department table with id and name
-- =============================================
*/
DROP TABLE IF EXISTS [Academic].[Department]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Academic].[Department]
(
    DepartmentID [int] NOT NULL IDENTITY(1, 1), -- primary key
    DepartmentName CHAR(5) NOT NULL,
    -- all tables must have the following 3 columns:
    [UserAuthorizationKey] [int] NOT NULL, 
    [DateAdded] [datetime2] NOT NULL,
    [DateOfLastUpdate] [datetime2] NOT NULL,
    PRIMARY KEY CLUSTERED ( [DepartmentID] ASC ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/*
Table: [Personnel].[DepartmentInstructor]
-- =============================================
-- Author:		Aryeh Richman
-- Create date: 12/6/23
-- Description:	Create a bridge table between departments and instructors
-- =============================================
*/
DROP TABLE IF EXISTS [Personnel].[DepartmentInstructor]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Personnel].[DepartmentInstructor]
(
    DepartmentInstructorID [int] NOT NULL IDENTITY(1, 1), -- primary key
    DepartmentID [int] NOT NULL,
    InstructorID [int] NOT NULL,
    -- all tables must have the following 3 columns:
    [UserAuthorizationKey] [int] NOT NULL, 
    [DateAdded] [datetime2] NOT NULL,
    [DateOfLastUpdate] [datetime2] NOT NULL,
    PRIMARY KEY CLUSTERED ( [DepartmentInstructorID] ASC )
    WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/*
Table: [Facilities].[BuildingLocations]
-- =============================================
-- Author:		Edwin Wray
-- Create date: 12/5/23
-- Description:	Create BuildingLocations table with building id and names
-- =============================================
*/
DROP TABLE IF EXISTS [Facilities].[BuildingLocations]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Facilities].[BuildingLocations]
(
    BuildingID [int] NOT NULL IDENTITY(1, 1), -- primary key
    BuildingAbbrv CHAR(2) NOT NULL,
    BuildingName VARCHAR(20) NOT NULL,
    -- all tables must have the following 3 columns:
    [UserAuthorizationKey] [int] NOT NULL, 
    [DateAdded] [datetime2] NOT NULL,
    [DateOfLastUpdate] [datetime2] NOT NULL,
    PRIMARY KEY CLUSTERED ( [BuildingID] ASC )
    WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/*
Table: [ClassManagement].[ModeOfInstruction]
-- =============================================
-- Author:		Nicholas Kong
-- Create date: 12/4/23
-- Description:	Load the names & IDs into the user ModeOfInstruction table
-- =============================================
*/
DROP TABLE IF EXISTS [ClassManagement].[ModeOfInstruction]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE  [ClassManagement].[ModeOfInstruction] (
    ModeID [int] NOT NULL IDENTITY (1,1), -- primary key
	ModeName VARCHAR(12) NOT NULL,
	-- all tables must have the following 3 columns:
    [UserAuthorizationKey] [int] NOT NULL, 
    [DateAdded] [datetime2] NOT NULL,
    [DateOfLastUpdate] [datetime2] NOT NULL,
    PRIMARY KEY CLUSTERED ( [ModeID] ASC )
    WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/*
Table: [Academic].[Course]
-- =============================================
-- Author:		Aleksandra Georgievska
-- Create date: 12/5/23
-- Description:	Load the Course Codes, Names, Credit/Course nums into the Course table
-- =============================================
*/
DROP TABLE IF EXISTS [Academic].[Course]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Academic].[Course] 
(
    CourseID [int] NOT NULL IDENTITY(1, 1), -- primary key
    CourseNumber CHAR(5) NOT NULL,
    CourseName CHAR(35) NOT NULL,
    CourseCredit FLOAT NOT NULL, -- (Needs Check Constraint to be positive)
    CreditHours FLOAT NOT NULL, -- CreditHours (Needs Check Constraint) -> should be positive, possibly a UDT
    DepartmentID [int] NOT NULL, -- FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID)
    -- all tables must have the following 3 columns:
    [UserAuthorizationKey] [int] NOT NULL, 
    [DateAdded] [datetime2] NOT NULL,
    [DateOfLastUpdate] [datetime2] NOT NULL,
    PRIMARY KEY CLUSTERED ( [CourseId] ASC ) 
    WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/*
Table: [Facilities].[RoomLocation]
-- =============================================
-- Author:		Nicholas Kong
-- Create date: 
-- Description:	
-- =============================================
*/
DROP TABLE IF EXISTS [Facilities].[RoomLocation]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Facilities].[RoomLocation] (
    RoomID [int] NOT NULL IDENTITY(1,1), -- primary key
	RoomNumber CHAR(5) NOT NULL,
    BuildingID INT NOT NULL,
    -- all tables must have the following 3 columns:
    [UserAuthorizationKey] [int] NOT NULL, 
    [DateAdded] [datetime2] NOT NULL,
    [DateOfLastUpdate] [datetime2] NOT NULL,
    PRIMARY KEY CLUSTERED ( [RoomID] ASC )
    WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/*
Table: [Academic].[Section]
-- =============================================
-- Author:		Sigalita Yakubova
-- Create date: 12/7/2023
-- Description:	Load the Section Codes into the Section table
-- =============================================
*/
DROP TABLE IF EXISTS [Academic].[Section]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Academic].[Section] 
(
    SectionID [int] NOT NULL IDENTITY(1, 1), -- primary key
    SectionNumber CHAR(4) NOT NULL, 
    SectionCode CHAR(5) NOT NULL,
    CourseID [int] NOT NULL, -- FOREIGN KEY (CourseID) 
    -- all tables must have the following 3 columns:
    [UserAuthorizationKey] [int] NOT NULL, 
    [DateAdded] [datetime2] NOT NULL,
    [DateOfLastUpdate] [datetime2] NOT NULL,
    PRIMARY KEY CLUSTERED ( [SectionID] ASC )
    WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/*
Table: [Enrollment].[EnrollmentDetails]
-- =============================================
-- Author:		Ahnaf Ahmed
-- Create date: 12/8/23
-- Description:	Create table to store enrollment details for each section
-- =============================================
*/
DROP TABLE IF EXISTS [Enrollment].[EnrollmentDetails]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Enrollment].[EnrollmentDetails]
(
    [EnrollmentID] [int] NOT NULL IDENTITY(1, 1), -- primary key
	[SectionID] [int] NOT NULL, -- Foreign Key (SectionID)
    [CurrentEnrollment] [int] NOT NULL,
    [MaxEnrollmentLimit] [int] NOT NULL,
	[OverEnrolled] CHAR(3),
    -- all tables must have the following 3 columns:
    [UserAuthorizationKey] [int] NOT NULL, 
    [DateAdded] [datetime2] NOT NULL,
    [DateOfLastUpdate] [datetime2] NOT NULL,
    PRIMARY KEY CLUSTERED ( [EnrollmentID] ASC )
    WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/*
Table: [ClassManagement].[ClassSchedule]
-- =============================================
-- Author:		Nicholas Kong & Edwin Wray
-- Create date: 12/7/23
-- Description:	Create ClassSchedule table
-- =============================================
*/
DROP TABLE IF EXISTS [ClassManagement].[ClassSchedule]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ClassManagement].[ClassSchedule]
(
    ClassID [int] NOT NULL IDENTITY(1, 1), -- primary key
    SemesterID [int] NOT NULL,
    SectionID [int] NOT NULL,
    InstructorID [int],
    RoomID [int],
    ModeID [int] NOT NULL,
    StartTime CHAR(5) NOT NULL, -- CHECK (StartTime >= '00:00:00.0000000' AND StartTime <= '24:00:00.0000000')
	EndTime CHAR(5) NOT NULL, -- CHECK (EndTime >= '00:00:00.0000000' AND EndTime <= '24:00:00.0000000')
    -- all tables must have the following 3 columns:
    [UserAuthorizationKey] [int] NOT NULL, 
    [DateAdded] [datetime2] NOT NULL,
    [DateOfLastUpdate] [datetime2] NOT NULL,
    PRIMARY KEY CLUSTERED ( [ClassID] ASC )
    WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/*
Table: [ClassManagement].[ClassDays]
-- =============================================
-- Author:		Aryeh Richman
-- Create date: 12/6/23
-- Description:	Create a bridge table between class and days
-- =============================================
*/
DROP TABLE IF EXISTS [ClassManagement].[ClassDays]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ClassManagement].[ClassDays]
(
    ClassDaysID [int] NOT NULL IDENTITY(1, 1), -- primary key
    ClassID [int] NOT NULL,
    DayID [int] NOT NULL,
    -- all tables must have the following 3 columns:
    [UserAuthorizationKey] [int] NOT NULL, 
    [DateAdded] [datetime2] NOT NULL,
    [DateOfLastUpdate] [datetime2] NOT NULL,
    PRIMARY KEY CLUSTERED(
	[ClassDaysID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

--------------------- Alter Tables To Update Defaults -------------------

-- Aleks
ALTER TABLE [DbSecurity].[UserAuthorization] ADD  DEFAULT ('9:15') FOR [ClassTime]
GO
ALTER TABLE [DbSecurity].[UserAuthorization] ADD  DEFAULT ('PROJECT 3') FOR [IndividualProject]
GO
ALTER TABLE [DbSecurity].[UserAuthorization] ADD  DEFAULT ('GROUP 1') FOR [GroupName]
GO
ALTER TABLE [DbSecurity].[UserAuthorization] ADD  DEFAULT (sysdatetime()) FOR [DateAdded]
GO
ALTER TABLE [DbSecurity].[UserAuthorization] ADD  DEFAULT (sysdatetime()) FOR [DateOfLastUpdate]
GO
ALTER TABLE [Process].[WorkflowSteps] ADD  DEFAULT ((0)) FOR [WorkFlowStepTableRowCount]
GO
ALTER TABLE [Process].[WorkflowSteps] ADD  DEFAULT ('9:15') FOR [Class Time]
GO
ALTER TABLE [Process].[WorkflowSteps] ADD  DEFAULT (sysdatetime()) FOR [StartingDateTime]
GO
ALTER TABLE [Process].[WorkflowSteps] ADD  DEFAULT (sysdatetime()) FOR [EndingDateTime]
GO
ALTER TABLE [Process].[WorkflowSteps] ADD  DEFAULT (sysdatetime()) FOR [DateAdded]
GO
ALTER TABLE [Process].[WorkflowSteps] ADD  DEFAULT (sysdatetime()) FOR [DateOfLastUpdate]
GO
ALTER TABLE [Personnel].[Instructor] ADD  DEFAULT (sysdatetime()) FOR [DateAdded]
GO
ALTER TABLE [Personnel].[Instructor] ADD  DEFAULT (sysdatetime()) FOR [DateOfLastUpdate]
GO
ALTER TABLE [Personnel].[Instructor] ADD DEFAULT ('none') FOR [LastName]
GO
ALTER TABLE [Personnel].[Instructor] ADD DEFAULT ('none') FOR [FirstName]
GO
ALTER TABLE [Academic].[Course] ADD  DEFAULT (sysdatetime()) FOR [DateAdded]
GO
ALTER TABLE [Academic].[Course] ADD  DEFAULT (sysdatetime()) FOR [DateOfLastUpdate]
GO

-- Ahnaf
ALTER TABLE [ClassManagement].[Days] ADD  DEFAULT (sysdatetime()) FOR [DateAdded]
GO
ALTER TABLE [ClassManagement].[Days] ADD  DEFAULT (sysdatetime()) FOR [DateOfLastUpdate]
GO
ALTER TABLE [Enrollment].[EnrollmentDetails] ADD  DEFAULT (sysdatetime()) FOR [DateAdded]
GO
ALTER TABLE [Enrollment].[EnrollmentDetails] ADD  DEFAULT (sysdatetime()) FOR [DateOfLastUpdate]
GO

-- Nicholas
ALTER TABLE [ClassManagement].[ModeOfInstruction] ADD  DEFAULT (sysdatetime()) FOR [DateAdded]
GO
ALTER TABLE [ClassManagement].[ModeOfInstruction] ADD  DEFAULT (sysdatetime()) FOR [DateOfLastUpdate]
GO
ALTER TABLE [Facilities].[RoomLocation] ADD  DEFAULT (sysdatetime()) FOR [DateAdded]
GO
ALTER TABLE [Facilities].[RoomLocation]  ADD  DEFAULT (sysdatetime()) FOR [DateOfLastUpdate]
GO

-- Sigi
ALTER TABLE [Enrollment].[Semester] ADD  DEFAULT (sysdatetime()) FOR [DateAdded]
GO
ALTER TABLE [Enrollment].[Semester] ADD  DEFAULT (sysdatetime()) FOR [DateOfLastUpdate]
GO
ALTER TABLE [Academic].[Section] ADD  DEFAULT (sysdatetime()) FOR [DateAdded]
GO
ALTER TABLE [Academic].[Section] ADD  DEFAULT (sysdatetime()) FOR [DateOfLastUpdate]
GO

-- Aryeh
ALTER TABLE [Academic].[Department] ADD  DEFAULT (sysdatetime()) FOR [DateAdded]
GO
ALTER TABLE [Academic].[Department] ADD  DEFAULT (sysdatetime()) FOR [DateOfLastUpdate]
GO
ALTER TABLE [Personnel].[DepartmentInstructor] ADD  DEFAULT (sysdatetime()) FOR [DateAdded]
GO
ALTER TABLE [Personnel].[DepartmentInstructor] ADD  DEFAULT (sysdatetime()) FOR [DateOfLastUpdate]
GO
ALTER TABLE [ClassManagement].[ClassDays] ADD  DEFAULT (sysdatetime()) FOR [DateAdded]
GO
ALTER TABLE [ClassManagement].[ClassDays] ADD  DEFAULT (sysdatetime()) FOR [DateOfLastUpdate]
GO

-- Edwin
ALTER TABLE [Facilities].[BuildingLocations] ADD  DEFAULT (sysdatetime()) FOR [DateAdded]
GO
ALTER TABLE [Facilities].[BuildingLocations] ADD  DEFAULT (sysdatetime()) FOR [DateOfLastUpdate]
GO
ALTER TABLE [ClassManagement].[ClassSchedule] ADD  DEFAULT (sysdatetime()) FOR [DateAdded]
GO
ALTER TABLE [ClassManagement].[ClassSchedule] ADD  DEFAULT (sysdatetime()) FOR [DateOfLastUpdate]
GO

--------------------- Alter Tables To Update Constraints -------------------

-- Aleks
ALTER TABLE [Process].[WorkflowSteps]  WITH CHECK ADD  CONSTRAINT [FK_WorkFlowSteps_UserAuthorization] FOREIGN KEY([UserAuthorizationKey])
REFERENCES [DbSecurity].[UserAuthorization] ([UserAuthorizationKey])
GO
ALTER TABLE [Process].[WorkflowSteps] CHECK CONSTRAINT [FK_WorkFlowSteps_UserAuthorization]
GO
ALTER TABLE [Personnel].[Instructor] WITH CHECK ADD  CONSTRAINT [FK_Instructor_UserAuthorization] FOREIGN KEY([UserAuthorizationKey])
REFERENCES [DbSecurity].[UserAuthorization] ([UserAuthorizationKey])
GO
ALTER TABLE [Personnel].[Instructor] CHECK CONSTRAINT [FK_Instructor_UserAuthorization]
GO
ALTER TABLE [Academic].[Course] WITH CHECK ADD CONSTRAINT [FK_Course_DepartmentID] FOREIGN KEY([DepartmentID])
REFERENCES [Academic].[Department] ([DepartmentID])
GO
ALTER TABLE [Academic].[Course] CHECK CONSTRAINT [FK_Course_DepartmentID]
GO
ALTER TABLE [Academic].[Course] WITH CHECK ADD CONSTRAINT [FK_Course_UserAuthorization] FOREIGN KEY([UserAuthorizationKey])
REFERENCES [DbSecurity].[UserAuthorization] ([UserAuthorizationKey])
GO
ALTER TABLE [Academic].[Course] CHECK CONSTRAINT [FK_Course_UserAuthorization]
GO
ALTER TABLE [Academic].[Course] ADD CONSTRAINT [CHK_CreditHours_Positive] CHECK (CreditHours >= 0)
GO
ALTER TABLE [Academic].[Course] ADD CONSTRAINT [CHK_CourseCredit_Positive] CHECK (CourseCredit >= 0)
GO

-- Sigi
ALTER TABLE [Enrollment].[Semester]  WITH CHECK ADD  CONSTRAINT [FK_Semester_UserAuthorization] FOREIGN KEY([UserAuthorizationKey])
REFERENCES [DbSecurity].[UserAuthorization] ([UserAuthorizationKey])
GO
ALTER TABLE [Enrollment].[Semester] CHECK CONSTRAINT [FK_Semester_UserAuthorization]
GO
ALTER TABLE [Academic].[Section]  WITH CHECK ADD  CONSTRAINT [FK_Section_UserAuthorization] FOREIGN KEY([UserAuthorizationKey])
REFERENCES [DbSecurity].[UserAuthorization] ([UserAuthorizationKey])
GO
ALTER TABLE [Academic].[Section] CHECK CONSTRAINT [FK_Section_UserAuthorization]
GO
ALTER TABLE [Academic].[Section] WITH CHECK ADD CONSTRAINT [FK_Section_Course] FOREIGN KEY([CourseId])
REFERENCES [Academic].[Course] ([CourseId])
GO
ALTER TABLE [Academic].[Section] CHECK CONSTRAINT [FK_Section_Course]
GO

-- Ahnaf
ALTER TABLE [ClassManagement].[Days]  WITH CHECK ADD  CONSTRAINT [FK_Days_UserAuthorization] FOREIGN KEY([UserAuthorizationKey])
REFERENCES [DbSecurity].[UserAuthorization] ([UserAuthorizationKey])
GO
ALTER TABLE [ClassManagement].[Days] CHECK CONSTRAINT [FK_Days_UserAuthorization]
GO
ALTER TABLE [ClassManagement].[Days] ADD CONSTRAINT CHK_DayOfWeek CHECK (DayAbbreviation IN ('M', 'T', 'W', 'TH', 'F', 'S', 'SU'))
GO
ALTER TABLE [Enrollment].[EnrollmentDetails]  WITH CHECK ADD  CONSTRAINT [FK_EnrollmentDetail_UserAuthorization] FOREIGN KEY([UserAuthorizationKey])
REFERENCES [DbSecurity].[UserAuthorization] ([UserAuthorizationKey])
GO
ALTER TABLE [Enrollment].[EnrollmentDetails] CHECK CONSTRAINT [FK_EnrollmentDetail_UserAuthorization]
GO
ALTER TABLE [Enrollment].[EnrollmentDetails] WITH CHECK ADD CONSTRAINT [FK_EnrollmentDetail_Section] FOREIGN KEY([SectionID])
REFERENCES [Academic].[Section] ([SectionID])
GO
ALTER TABLE [Enrollment].[EnrollmentDetails] CHECK CONSTRAINT [FK_EnrollmentDetail_Section]
GO

-- Nicholas
ALTER TABLE [ClassManagement].[ModeOfInstruction]  WITH CHECK ADD  CONSTRAINT [FK_ModeOfInst_UserAuthorization] FOREIGN KEY([UserAuthorizationKey])
REFERENCES [DbSecurity].[UserAuthorization] ([UserAuthorizationKey])
GO
ALTER TABLE [ClassManagement].[ModeOfInstruction] CHECK CONSTRAINT [FK_ModeOfInst_UserAuthorization]
GO
ALTER TABLE [Facilities].[RoomLocation]  WITH CHECK ADD  CONSTRAINT [FK_RoomLocation_UserAuthorization] FOREIGN KEY([UserAuthorizationKey])
REFERENCES [DbSecurity].[UserAuthorization] ([UserAuthorizationKey])
GO
ALTER TABLE [Facilities].[RoomLocation]  CHECK CONSTRAINT [FK_RoomLocation_UserAuthorization]
GO
ALTER TABLE [Facilities].[RoomLocation]  WITH CHECK ADD  CONSTRAINT [FK_RoomLocation_BuildingLocations] FOREIGN KEY([BuildingID])
REFERENCES [Facilities].[BuildingLocations] ([BuildingID])
GO
ALTER TABLE [Facilities].[RoomLocation]  CHECK CONSTRAINT [FK_RoomLocation_BuildingLocations]
GO
ALTER TABLE [ClassManagement].[ClassSchedule]  WITH CHECK ADD  CONSTRAINT [FK_Class_UserAuthorization] FOREIGN KEY([UserAuthorizationKey])
REFERENCES [DbSecurity].[UserAuthorization] ([UserAuthorizationKey])
GO
ALTER TABLE [ClassManagement].[ClassSchedule] CHECK CONSTRAINT [FK_Class_UserAuthorization]
GO
ALTER TABLE [ClassManagement].[ClassSchedule]  WITH CHECK ADD  CONSTRAINT [FK_Class_Semester] FOREIGN KEY([SemesterID])
REFERENCES [Enrollment].[Semester] ([SemesterID])
GO
ALTER TABLE [ClassManagement].[ClassSchedule] CHECK CONSTRAINT [FK_Class_Semester]
GO

-- Aryeh
ALTER TABLE [Academic].[Department]  WITH CHECK ADD  CONSTRAINT [FK_Department_UserAuthorization] FOREIGN KEY([UserAuthorizationKey])
REFERENCES [DbSecurity].[UserAuthorization] ([UserAuthorizationKey])
GO
ALTER TABLE [Academic].[Department] CHECK CONSTRAINT [FK_Department_UserAuthorization]
GO
ALTER TABLE [Personnel].[DepartmentInstructor]  WITH CHECK ADD  CONSTRAINT [FK_DepartmentInstructor_UserAuthorization] FOREIGN KEY([UserAuthorizationKey])
REFERENCES [DbSecurity].[UserAuthorization] ([UserAuthorizationKey])
GO
ALTER TABLE [Personnel].[DepartmentInstructor] CHECK CONSTRAINT [FK_DepartmentInstructor_UserAuthorization]
GO
ALTER TABLE [Personnel].[DepartmentInstructor]  WITH CHECK ADD  CONSTRAINT [FK_DepartmentInstructor_Department] FOREIGN KEY([DepartmentID])
REFERENCES [Academic].[Department] ([DepartmentID])
GO
ALTER TABLE [Personnel].[DepartmentInstructor] CHECK CONSTRAINT [FK_DepartmentInstructor_Department]
GO
ALTER TABLE [Personnel].[DepartmentInstructor]  WITH CHECK ADD  CONSTRAINT [FK_DepartmentInstructor_Instructor] FOREIGN KEY([InstructorID])
REFERENCES [Personnel].[Instructor] ([InstructorID])
GO
ALTER TABLE [Personnel].[DepartmentInstructor] CHECK CONSTRAINT [FK_DepartmentInstructor_Department]
GO
ALTER TABLE [ClassManagement].[ClassDays]  WITH CHECK ADD  CONSTRAINT [FK_ClassDays_UserAuthorization] FOREIGN KEY([UserAuthorizationKey])
REFERENCES [DbSecurity].[UserAuthorization] ([UserAuthorizationKey])
GO
ALTER TABLE [ClassManagement].[ClassDays] CHECK CONSTRAINT [FK_ClassDays_UserAuthorization]
GO
ALTER TABLE [ClassManagement].[ClassDays]  WITH CHECK ADD  CONSTRAINT [FK_ClassDays_Class] FOREIGN KEY([ClassID])
REFERENCES [ClassManagement].[Class] ([ClassID])
GO
ALTER TABLE [ClassManagement].[ClassDays] CHECK CONSTRAINT [FK_ClassDays_Class]
GO
ALTER TABLE [ClassManagement].[ClassDays]  WITH CHECK ADD  CONSTRAINT [FK_ClassDays_Days] FOREIGN KEY([DayID])
REFERENCES [ClassManagement].[Days] ([DayID])
GO
ALTER TABLE [ClassManagement].[ClassDays] CHECK CONSTRAINT [FK_ClassDays_Days]
GO

-- Edwin
ALTER TABLE [Facilities].[BuildingLocations]  WITH CHECK ADD  CONSTRAINT [FK_BuildingLocations_UserAuthorization] FOREIGN KEY([UserAuthorizationKey])
REFERENCES [DbSecurity].[UserAuthorization] ([UserAuthorizationKey])
GO
ALTER TABLE [Facilities].[BuildingLocations] CHECK CONSTRAINT [FK_BuildingLocations_UserAuthorization]
GO
ALTER TABLE [ClassManagement].[ClassSchedule]  WITH CHECK ADD  CONSTRAINT [FK_Class_Section] FOREIGN KEY([SectionID])
REFERENCES [Academic].[Section] ([SectionID])
GO
ALTER TABLE [ClassManagement].[ClassSchedule] CHECK CONSTRAINT [FK_Class_Section]
GO
ALTER TABLE [ClassManagement].[ClassSchedule]  WITH CHECK ADD  CONSTRAINT [FK_Class_Instructor] FOREIGN KEY([InstructorID])
REFERENCES [Personnel].[Instructor] ([InstructorID])
GO
ALTER TABLE [ClassManagement].[ClassSchedule] CHECK CONSTRAINT [FK_Class_Instructor]
GO
ALTER TABLE [ClassManagement].[ClassSchedule]  WITH CHECK ADD  CONSTRAINT [FK_Class_RoomLocation] FOREIGN KEY([RoomID])
REFERENCES [Facilities].[RoomLocation] ([RoomID])
GO
ALTER TABLE [ClassManagement].[ClassSchedule] CHECK CONSTRAINT [FK_Class_RoomLocation]
GO
ALTER TABLE [ClassManagement].[ClassSchedule]  WITH CHECK ADD  CONSTRAINT [FK_Class_ModeOfInstruction] FOREIGN KEY([ModeID])
REFERENCES [ClassManagement].[ModeOfInstruction] ([ModeID])
GO
ALTER TABLE [ClassManagement].[ClassSchedule] CHECK CONSTRAINT [FK_Class_ModeOfInstruction]
GO

--------------------------------- CREATE FUNCTIONS --------------------------------

-- Sigi 
-- Create a function to determine the season
CREATE FUNCTION [Project3].GetSeason(@DateAdded DATETIME2)
RETURNS VARCHAR(6)
AS
BEGIN
    DECLARE @Season VARCHAR(6);

    SET @Season = 
        CASE
            WHEN MONTH(@DateAdded) BETWEEN 1 AND 3 THEN 'Winter'
            WHEN MONTH(@DateAdded) BETWEEN 4 AND 6 THEN 'Spring'
            WHEN MONTH(@DateAdded) BETWEEN 7 AND 9 THEN 'Summer'
            WHEN MONTH(@DateAdded) BETWEEN 10 AND 12 THEN 'Fall'
        END;

    RETURN @Season;
END;
GO

-- Create a function to get the formatted SemesterName
CREATE FUNCTION [Project3].GetSemesterName(@DateAdded DATETIME2)
RETURNS VARCHAR(11)
AS
BEGIN
    DECLARE @Season VARCHAR(6);
    DECLARE @Year VARCHAR(4);
    DECLARE @SemesterName VARCHAR(11);

    SET @Season = [Project3].GetSeason(@DateAdded);
    SET @Year = FORMAT(@DateAdded, 'yyyy');
    SET @SemesterName = @Season + ' ' + @Year;

    RETURN @SemesterName;
END;
GO

-- string splitter function for classdays
CREATE FUNCTION dbo.SplitString (@List NVARCHAR(MAX), @Delimiter NVARCHAR(255))
RETURNS TABLE
AS
RETURN ( 
    SELECT [Value] = y.i.value('(./text())[1]', 'nvarchar(4000)')
    FROM ( 
        SELECT x = CONVERT(XML, '<i>' 
        + REPLACE(@List, @Delimiter, '</i><i>') 
        + '</i>').query('.')
    ) AS a CROSS APPLY x.nodes('i') AS y(i)
);
GO

----------------------------------------------- CREATE VIEWS -------------------------------------------------------


--------------------------------- Create Stored Procedures -------------------------------

--------------------------------------- WORKFLOW STORED PROCEDURES ----------------------------------------------

/*
-- Stored Procedure: [Process].[usp_ShowWorkflowSteps]
Description:
This stored procedure is designed to retrieve and display all records from the Process.[WorkFlowSteps] table. 
It is intended to provide a comprehensive view of all workflow steps that have been logged in the system, 
offering insights into the various processes and their execution details.
-- =============================================
-- Author:		Aleksandra Georgievska
-- Create date: 11/13/23
-- Description:	Show table of all workflow steps
-- =============================================
*/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [Process].[usp_ShowWorkflowSteps]
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
    SET NOCOUNT ON;
    SELECT *
    FROM [Process].[WorkFlowSteps];
END
GO

/*
-- Stored Procedure: Process.[usp_TrackWorkFlow]
Description:
This stored procedure is designed to track and log each step of various workflows within the system. 
It inserts records into the [WorkflowSteps] table, capturing key details about each workflow step, 
such as its description, the number of table rows affected, and the start and end times. 
This procedure is instrumental in maintaining an audit trail and enhancing transparency in automated processes.
-- =============================================
-- Author:		Aleksandra Georgievska
-- Create date: 11/13/23
-- Description:	Keep track of all workflow steps
-- =============================================
*/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [Process].[usp_TrackWorkFlow]
    -- Add the parameters for the stored procedure here
    @WorkflowDescription NVARCHAR(100),
    @WorkFlowStepTableRowCount INT,
    @StartingDateTime DATETIME2,
    @EndingDateTime DATETIME2,
    @QueryTime BIGINT,
    @UserAuthorizationKey INT
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
    SET NOCOUNT ON;
    -- Insert statements for procedure here
    INSERT INTO [Process].[WorkflowSteps]
        (WorkFlowStepDescription,
        WorkFlowStepTableRowCount,
        StartingDateTime,
        EndingDateTime,
        [QueryTime (ms)],
        UserAuthorizationKey)
    VALUES
        (@WorkflowDescription,
        @WorkFlowStepTableRowCount,
        @StartingDateTime,
        @EndingDateTime,
        @QueryTime,
        @UserAuthorizationKey);
END;
GO

/*
-- Stored Procedure: Process.[Load_UserAuthorization]
-- =============================================
-- Author:		Aleksandra Georgievska
-- Create date: 11/126/23
-- Description:	Prepopulating the names & default values into the user authorization table
-- =============================================
*/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [Project3].[Load_UserAuthorization]
    @UserAuthorizationKey INT
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
    DECLARE @StartingDateTime DATETIME2 = SYSDATETIME();
    INSERT INTO [DbSecurity].[UserAuthorization]
        ([GroupMemberLastName],[GroupMemberFirstName])
    VALUES
        ('Georgievska', 'Aleksandra'),
        ('Yakubova', 'Sigalita'),
        ('Kong', 'Nicholas'),
        ('Wray', 'Edwin'),
        ('Ahmed', 'Ahnaf'),
        ('Richman', 'Aryeh');
    DECLARE @WorkFlowStepTableRowCount INT;
    SET @WorkFlowStepTableRowCount = 6;
    DECLARE @EndingDateTime DATETIME2 = SYSDATETIME();
    DECLARE @QueryTime BIGINT = CAST(DATEDIFF(MILLISECOND, @StartingDateTime, @EndingDateTime) AS bigint);
    EXEC [Process].[usp_TrackWorkFlow] 'Add Users',
                                       @WorkFlowStepTableRowCount,
                                       @StartingDateTime,
                                       @EndingDateTime,
                                       @QueryTime,
                                       @UserAuthorizationKey;
END;
GO

/*
-- Stored Procedure: [Project3].[AddForeignKeysToClassSchedule]
Description:
This procedure is responsible for establishing foreign key relationships across various tables in 
the database. It adds constraints to link fact and dimension tables to ensure referential integrity. 
The procedure also associates dimension tables with the UserAuthorization table, thereby establishing 
a traceable link between data records and the users responsible for their creation or updates.
-- =============================================
-- Author:		Aleksandra Georgievska
-- Create date: 11/13/23
-- Description:	Add the foreign keys to the start Schema database
-- =============================================
*/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [Project3].[AddForeignKeysToClassSchedule]
    @UserAuthorizationKey INT
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
    DECLARE @StartingDateTime DATETIME2 = SYSDATETIME();
    -- Aleks
    ALTER TABLE [Process].[WorkflowSteps]
    ADD CONSTRAINT FK_WorkFlowSteps_UserAuthorization
        FOREIGN KEY (UserAuthorizationKey)
        REFERENCES [DbSecurity].[UserAuthorization] (UserAuthorizationKey);
    ALTER TABLE [Personnel].[Instructor]
    ADD CONSTRAINT FK_Instructor_UserAuthorization 
        FOREIGN KEY(UserAuthorizationKey)
        REFERENCES [DbSecurity].[UserAuthorization] (UserAuthorizationKey);
    ALTER TABLE [Academic].[Course]
    ADD CONSTRAINT FK_Course_UserAuthorization
        FOREIGN KEY (UserAuthorizationKey)
        REFERENCES [DbSecurity].[UserAuthorization] (UserAuthorizationKey);
    ALTER TABLE [Academic].[Course]
    ADD CONSTRAINT FK_Course_DepartmentID
        FOREIGN KEY (DepartmentID)
        REFERENCES [Academic].[Department] (DepartmentID)

    -- Aryeh
    ALTER TABLE [Academic].[Department]
    ADD CONSTRAINT FK_Department_UserAuthorization
        FOREIGN KEY (UserAuthorizationKey)
        REFERENCES [DbSecurity].[UserAuthorization] (UserAuthorizationKey);
    ALTER TABLE [Personnel].[DepartmentInstructor]
    ADD CONSTRAINT FK_DepartmentInstructor_UserAuthorization
        FOREIGN KEY (UserAuthorizationKey)
        REFERENCES [DbSecurity].[UserAuthorization] (UserAuthorizationKey);
    ALTER TABLE [Personnel].[DepartmentInstructor]
    ADD CONSTRAINT FK_DepartmentInstructor_Department
        FOREIGN KEY (DepartmentID)
        REFERENCES [Academic].[Department] (DepartmentID);
    ALTER TABLE [Personnel].[DepartmentInstructor]
    ADD CONSTRAINT FK_Department_Instructor
        FOREIGN KEY (InstructorID)
        REFERENCES [Personnel].[Instructor] (InstructorID);
    -- ALTER TABLE [ClassManagement].[ClassDays]
    -- ADD CONSTRAINT FK_ClassDays_UserAuthorization
    --     FOREIGN KEY (UserAuthorizationKey)
    --     REFERENCES [DbSecurity].[UserAuthorization] (UserAuthorizationKey);
    -- ALTER TABLE [ClassManagement].[ClassDays]
    -- ADD CONSTRAINT FK_ClassDays_Class
    --     FOREIGN KEY (ClassID)
    --     REFERENCES [ClassManagement].[Class] (ClassID);
    -- ALTER TABLE [ClassManagement].[ClassDays]
    -- ADD CONSTRAINT FK_ClassDays_Days
    --     FOREIGN KEY (DayID)
    --     REFERENCES [ClassManagement].[Days] (DayID);

    -- Sigi
    ALTER TABLE [Enrollment].[Semester]
    ADD CONSTRAINT FK_Semester_UserAuthorization
        FOREIGN KEY([UserAuthorizationKey])
        REFERENCES [DbSecurity].[UserAuthorization] ([UserAuthorizationKey]);
    ALTER TABLE [Academic].[Section]
        ADD CONSTRAINT FK_Section_UserAuthorization
        FOREIGN KEY (UserAuthorizationKey)
        REFERENCES [DbSecurity].[UserAuthorization] (UserAuthorizationKey);
    ALTER TABLE [Academic].[Section]
    ADD CONSTRAINT FK_Section_Course
        FOREIGN KEY (CourseID)
        REFERENCES [Academic].[Course] (CourseID)

    -- Ahnaf 
    ALTER TABLE [ClassManagement].[Days]
    ADD CONSTRAINT FK_Days_UserAuthorization
        FOREIGN KEY (UserAuthorizationKey)
        REFERENCES [DbSecurity].[UserAuthorization] (UserAuthorizationKey);
    ALTER TABLE [Enrollment].[EnrollmentDetails]
    ADD CONSTRAINT FK_EnrollmentDetail_UserAuthorization
        FOREIGN KEY (UserAuthorizationKey)
        REFERENCES [DbSecurity].[UserAuthorization] (UserAuthorizationKey);
    ALTER TABLE [Enrollment].[EnrollmentDetails]
    ADD CONSTRAINT FK_EnrollmentDetail_Section
        FOREIGN KEY (SectionID)
        REFERENCES [Academic].[Section] ([SectionID]);

    -- Nicholas
    ALTER TABLE [ClassManagement].[ModeOfInstruction]  
    ADD CONSTRAINT FK_ModeOfInst_UserAuthorization
        FOREIGN KEY([UserAuthorizationKey])
        REFERENCES [DbSecurity].[UserAuthorization] ([UserAuthorizationKey]);
	ALTER TABLE [Facilities].[RoomLocation]  
    ADD CONSTRAINT FK_RoomLocation_UserAuthorization 
        FOREIGN KEY([UserAuthorizationKey])
        REFERENCES [DbSecurity].[UserAuthorization] ([UserAuthorizationKey]);
    ALTER TABLE [Facilities].[RoomLocation]  
    ADD CONSTRAINT FK_RoomLocation_BuildingLocations
        FOREIGN KEY([BuildingID])
        REFERENCES [Facilities].[BuildingLocations] ([BuildingID]);
	ALTER TABLE [ClassManagement].[ClassSchedule]
    ADD CONSTRAINT FK_Class_UserAuthorization
        FOREIGN KEY (UserAuthorizationKey)
        REFERENCES [DbSecurity].[UserAuthorization] (UserAuthorizationKey);
	ALTER TABLE [ClassManagement].[ClassSchedule]
    ADD CONSTRAINT FK_Class_Semester
		FOREIGN KEY (SemesterID)
		REFERENCES [Enrollment].[Semester] (SemesterID);

    -- Edwin
    ALTER TABLE [Facilities].[BuildingLocations]
    ADD CONSTRAINT FK_BuildingLocations_UserAuthorization
        FOREIGN KEY (UserAuthorizationKey)
        REFERENCES [DbSecurity].[UserAuthorization] (UserAuthorizationKey);
    ALTER TABLE [ClassManagement].[ClassSchedule]
    ADD CONSTRAINT FK_Class_Section
        FOREIGN KEY (SectionID)
        REFERENCES [Academic].[Section] (SectionID);
    ALTER TABLE [ClassManagement].[ClassSchedule]
    ADD CONSTRAINT FK_Class_Instructor
        FOREIGN KEY (InstructorID)
        REFERENCES [Personnel].[Instructor] (InstructorID);
    ALTER TABLE [ClassManagement].[ClassSchedule]
    ADD CONSTRAINT FK_Class_RoomLocation
        FOREIGN KEY (RoomID)
        REFERENCES [Facilities].[RoomLocation] (RoomID);
    ALTER TABLE [ClassManagement].[ClassSchedule]
    ADD CONSTRAINT FK_Class_ModeOfInstruction
        FOREIGN KEY (ModeID)
        REFERENCES [ClassManagement].[ModeOfInstruction] (ModeID);

    -- add more here...

    DECLARE @WorkFlowStepTableRowCount INT;
    SET @WorkFlowStepTableRowCount = 0;
    DECLARE @EndingDateTime DATETIME2 = SYSDATETIME();
    DECLARE @QueryTime BIGINT = CAST(DATEDIFF(MILLISECOND, @StartingDateTime, @EndingDateTime) AS bigint);
    EXEC [Process].[usp_TrackWorkFlow] 'Add Foreign Keys',
                                       @WorkFlowStepTableRowCount,
                                       @StartingDateTime,
                                       @EndingDateTime,
                                       @QueryTime,
                                       @UserAuthorizationKey;
END;
GO

/*
-- Stored Procedure: [Project3].[DropForeignKeysFromClassSchedule]
Description:
This procedure is designed to remove foreign key constraints from various tables in the database. 
It primarily focuses on dropping constraints that link fact and dimension tables as well as the 
constraints linking dimension tables to the UserAuthorization table. This is typically performed 
in preparation for data loading operations that require constraint-free bulk data manipulations.
-- =============================================
-- Author:		Aleksandra Georgievska
-- Create date: 11/13/23
-- Description:	Drop the foreign keys from the start Schema database
-- =============================================
*/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [Project3].[DropForeignKeysFromClassSchedule]
    @UserAuthorizationKey INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @StartingDateTime DATETIME2 = SYSDATETIME();

    -- Aleks
    ALTER TABLE [Process].[WorkflowSteps] DROP CONSTRAINT [FK_WorkFlowSteps_UserAuthorization];
    ALTER TABLE [Personnel].[Instructor] DROP CONSTRAINT [FK_Instructor_UserAuthorization];
    ALTER TABLE [Academic].[Course] DROP CONSTRAINT [FK_Course_UserAuthorization];
    ALTER TABLE [Academic].[Course] DROP CONSTRAINT [FK_Course_DepartmentID];

    -- Ahnaf
    ALTER TABLE [ClassManagement].[Days] DROP CONSTRAINT [FK_Days_UserAuthorization];
    ALTER TABLE [Enrollment].[EnrollmentDetails] DROP CONSTRAINT [FK_EnrollmentDetail_UserAuthorization];
    ALTER TABLE [Enrollment].[EnrollmentDetails] DROP CONSTRAINT [FK_EnrollmentDetail_Section];

    -- Nicholas
    ALTER TABLE [ClassManagement].[ModeOfInstruction] DROP CONSTRAINT [FK_ModeOfInst_UserAuthorization];
    ALTER TABLE [Facilities].[RoomLocation] DROP CONSTRAINT [FK_RoomLocation_UserAuthorization];
    ALTER TABLE [Facilities].[RoomLocation] DROP CONSTRAINT [FK_RoomLocation_BuildingLocations];
    ALTER TABLE [ClassManagement].[ClassSchedule] DROP CONSTRAINT [FK_Class_UserAuthorization];
    ALTER TABLE [ClassManagement].[ClassSchedule]  DROP CONSTRAINT [FK_Class_Semester];

    -- Sigi
    ALTER TABLE [Enrollment].[Semester] DROP CONSTRAINT FK_Semester_UserAuthorization;
    ALTER TABLE [Academic].[Section] DROP CONSTRAINT [FK_Section_UserAuthorization];
    ALTER TABLE [Academic].[Section] DROP CONSTRAINT [FK_Section_Course];

    -- Aryeh
    ALTER TABLE [Academic].[Department] DROP CONSTRAINT FK_Department_UserAuthorization;
    ALTER TABLE [Personnel].[DepartmentInstructor] DROP CONSTRAINT FK_DepartmentInstructor_UserAuthorization;
    ALTER TABLE [Personnel].[DepartmentInstructor] DROP CONSTRAINT FK_DepartmentInstructor_Department;
    ALTER TABLE [Personnel].[DepartmentInstructor] DROP CONSTRAINT FK_DepartmentInstructor_Instructor;
    -- ALTER TABLE [ClassManagement].[ClassDays] DROP CONSTRAINT FK_ClassDays_UserAuthorization;
    -- ALTER TABLE [ClassManagement].[ClassDays] DROP CONSTRAINT FK_ClassDays_Class;
    -- ALTER TABLE [ClassManagement].[ClassDays] DROP CONSTRAINT FK_ClassDays_Days;

    -- Edwin
    ALTER TABLE [Facilities].[BuildingLocations] DROP CONSTRAINT FK_BuildingLocations_UserAuthorization;
    ALTER TABLE [ClassManagement].[ClassSchedule] DROP CONSTRAINT FK_Class_Section;
    ALTER TABLE [ClassManagement].[ClassSchedule] DROP CONSTRAINT FK_Class_Instructor;
    ALTER TABLE [ClassManagement].[ClassSchedule] DROP CONSTRAINT FK_Class_RoomLocation;
    ALTER TABLE [ClassManagement].[ClassSchedule] DROP CONSTRAINT FK_Class_ModeOfInstruction;

    -- add more here...

    DECLARE @WorkFlowStepTableRowCount INT;
    SET @WorkFlowStepTableRowCount = 0;
    DECLARE @EndingDateTime DATETIME2 = SYSDATETIME();
    DECLARE @QueryTime BIGINT = CAST(DATEDIFF(MILLISECOND, @StartingDateTime, @EndingDateTime) AS bigint);
    EXEC [Process].[usp_TrackWorkFlow] 'Drop Foreign Keys',
                                       @WorkFlowStepTableRowCount,
                                       @StartingDateTime,
                                       @EndingDateTime,
                                       @QueryTime,
                                       @UserAuthorizationKey;
END;
GO

/*
-- Stored Procedure: Project2.[TruncateClassScheduleData]
Description:
This procedure is designed to truncate tables in the schema of the data warehouse. 
It removes all records from specified dimension and fact tables and restarts the 
associated sequences. This action is essential for data refresh scenarios where 
existing data needs to be cleared before loading new data.
-- =============================================
-- Author:		Nicholas Kong
-- Create date: 11/13/2023
-- Description:	Truncate the star schema 
-- =============================================
*/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [Project3].[TruncateClassScheduleData]
    @UserAuthorizationKey int
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
    SET NOCOUNT ON;
    DECLARE @StartingDateTime DATETIME2 = SYSDATETIME();

    -- Aleks
    TRUNCATE TABLE [DbSecurity].[UserAuthorization]
    TRUNCATE TABLE [Process].[WorkFlowSteps]
    TRUNCATE TABLE [Personnel].[Instructor]
    TRUNCATE TABLE [Academic].[Course]

    -- Aryeh
    TRUNCATE TABLE [Academic].[Department]
    TRUNCATE TABLE [Personnel].[DepartmentInstructor]
    -- TRUNCATE TABLE [ClassManagement].[ClassDays]

	-- Nicholas
	TRUNCATE TABLE [ClassManagement].[ModeOfInstruction]
	TRUNCATE TABLE [Facilities].[RoomLocation]

    -- Ahnaf
    TRUNCATE TABLE [ClassManagement].[Days]
	TRUNCATE TABLE [Enrollment].[EnrollmentDetails]

    -- Sigi
    TRUNCATE TABLE [Enrollment].[Semester]
    TRUNCATE TABLE [Academic].[Section]

    -- Edwin
    TRUNCATE TABLE [Facilities].[BuildingLocations]
    TRUNCATE TABLE [ClassManagement].[ClassSchedule]

    -- add more here...

    DECLARE @WorkFlowStepTableRowCount INT;
    SET @WorkFlowStepTableRowCount = 0;
    DECLARE @EndingDateTime DATETIME2 = SYSDATETIME();
    DECLARE @QueryTime BIGINT = CAST(DATEDIFF(MILLISECOND, @StartingDateTime, @EndingDateTime) AS bigint);
    EXEC [Process].[usp_TrackWorkFlow] 'Truncate Data',
                                       @WorkFlowStepTableRowCount,
                                       @StartingDateTime,
                                       @EndingDateTime,
                                       @QueryTime,
                                       @UserAuthorizationKey;
END;
GO

/*
-- Stored Procedure: Project2.[ShowTableStatusRowCount]
Description:
This procedure is designed to report the row count of various tables in the database, 
providing a snapshot of the current data volume across different tables. 
The procedure also logs this operation, including user authorization keys and timestamps, 
to maintain an audit trail.
-- =============================================
-- Author:		Aryeh Richman
-- Create date: 11/13/23
-- Description:	Populate a table to show the status of the row counts
-- =============================================
*/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [Project3].[ShowTableStatusRowCount]
    @TableStatus VARCHAR(64),
    @UserAuthorizationKey INT
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
    SET NOCOUNT ON;
    DECLARE @DateAdded DATETIME2 = SYSDATETIME();
    DECLARE @DateOfLastUpdate DATETIME2 = SYSDATETIME();
    DECLARE @StartingDateTime DATETIME2 = SYSDATETIME();
    DECLARE @WorkFlowStepTableRowCount INT = 0;

    -- Aleks
        SELECT TableStatus = @TableStatus,
            TableName = '[DbSecurity].[UserAuthorization]',
            [Row Count] = COUNT(*)
        FROM [DbSecurity].[UserAuthorization]
    UNION ALL
        SELECT TableStatus = @TableStatus,
            TableName = '[Process].[WorkflowSteps]',
            [Row Count] = COUNT(*)
        FROM [Process].[WorkflowSteps]
    UNION ALL
        SELECT TableStatus = @TableStatus,
            TableName = '[Personnel].[Instructor]',
            [Row Count] = COUNT(*)
        FROM [Personnel].[Instructor]
    UNION ALL
        SELECT TableStatus = @TableStatus,
            TableName = '[Academic].[Course]',
            [Row Count] = COUNT(*)
        FROM [Academic].[Course]

    -- Ahnaf
    UNION ALL
        SELECT TableStatus = @TableStatus,
            TableName = '[ClassManagement].[Days]',
            [Row Count] = COUNT(*)
        FROM [ClassManagement].[Days]
    UNION ALL
        SELECT TableStatus = @TableStatus,
            TableName = '[Enrollment].[EnrollmentDetails]',
            [Row Count] = COUNT(*)
        FROM [Enrollment].[EnrollmentDetails]

    -- Nicholas 
    UNION ALL
        SELECT TableStatus = @TableStatus,
            TableName = '[ClassManagement].[ModeOfInstruction]',
            [Row Count] = COUNT(*)
        FROM [ClassManagement].[ModeOfInstruction]
	UNION ALL
        SELECT TableStatus = @TableStatus,
            TableName = '[Facilities].[RoomLocation]',
            [Row Count] = COUNT(*)
        FROM [Facilities].[RoomLocation]

    -- Sigi
    UNION ALL
        SELECT TableStatus = @TableStatus,
            TableName = '[Enrollment].[Semester]',
            [Row Count] = COUNT(*)
        FROM [Enrollment].[Semester]
    UNION ALL
        SELECT TableStatus = @TableStatus,
            TableName = '[Academic].[Section]',
            [Row Count] = COUNT(*)
        FROM [Academic].[Section]

    -- Aryeh
    UNION ALL
        SELECT TableStatus = @TableStatus,
            TableName = '[Academic].[Department]',
            [Row Count] = COUNT(*)
        FROM [Academic].[Department]
    UNION ALL
        SELECT TableStatus = @TableStatus,
            TableName = '[Personnel].[DepartmentInstructor]',
            [Row Count] = COUNT(*)
        FROM [Personnel].[DepartmentInstructor]
    -- UNION ALL
    --     SELECT TableStatus = @TableStatus,
    --         TableName = '[ClassManagement].[ClassDays]',
    --         [Row Count] = COUNT(*)
    --     FROM [ClassManagement].[ClassDays]

    -- Edwin
    UNION ALL
        SELECT TableStatus = @TableStatus,
            TableName = '[Facilities].[BuildingLocations]',
            [Row Count] = COUNT(*)
        FROM [Facilities].[BuildingLocations]
    UNION ALL
        SELECT TableStatus = @TableStatus,
            TableName = '[ClassManagement].[ClassSchedule]',
            [Row Count] = COUNT(*)
        FROM [ClassManagement].[ClassSchedule];

    -- add more here...

    DECLARE @EndingDateTime DATETIME2 = SYSDATETIME();
    DECLARE @QueryTime BIGINT = CAST(DATEDIFF(MILLISECOND, @StartingDateTime, @EndingDateTime) AS bigint);
    EXEC [Process].[usp_TrackWorkFlow] 'Procedure: Project3[ShowStatusRowCount] loads data into ShowTableStatusRowCount',
                                       @WorkFlowStepTableRowCount,
                                       @StartingDateTime,
                                       @EndingDateTime,
                                       @QueryTime,
                                       @UserAuthorizationKey;
END;
GO

--------------------------------------- LOAD DATA STORED PROCEDURES ----------------------------------------------

/*
Stored Procedure: [Project3].[LoadInstructors]
-- =============================================
-- Author:		Aleksandra Georgievska
-- Create date: 12/4/23
-- Description:	Adds the Instructors to the Instructor Table
-- =============================================
*/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [Project3].[LoadInstructors] @UserAuthorizationKey INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @StartingDateTime DATETIME2 = SYSDATETIME();

    INSERT INTO [Personnel].[Instructor](
        FirstName, LastName, UserAuthorizationKey
    )
    SELECT DISTINCT
        -- use COALESCE/NULLIF to check when importing the data from the original table to prevent importing nulls 
        LTRIM(RTRIM(SUBSTRING(Instructor, CHARINDEX(',', Instructor) + 2, LEN(Instructor)))) AS FirstName,
        LTRIM(RTRIM(SUBSTRING(Instructor, 1, CHARINDEX(',', Instructor) - 1))) AS LastName,
        @UserAuthorizationKey
    FROM [Uploadfile].[CurrentSemesterCourseOfferings]
    WHERE NULLIF(LTRIM(RTRIM(SUBSTRING(Instructor, CHARINDEX(',', Instructor) + 2, LEN(Instructor)))), '') IS NOT NULL
        AND NULLIF(LTRIM(RTRIM(SUBSTRING(Instructor, 1, CHARINDEX(',', Instructor) - 1))), '') IS NOT NULL
    ORDER BY LastName;

    DECLARE @WorkFlowStepTableRowCount INT;
    SET @WorkFlowStepTableRowCount = (
                                    SELECT COUNT(*) 
                                    FROM [Personnel].[Instructor]
                                    );
    DECLARE @EndingDateTime DATETIME2 = SYSDATETIME();
    DECLARE @QueryTime BIGINT = CAST(DATEDIFF(MILLISECOND, @StartingDateTime, @EndingDateTime) AS bigint);
    EXEC [Process].[usp_TrackWorkFlow] 'Add Instructor Data',
                                       @WorkFlowStepTableRowCount,
                                       @StartingDateTime,
                                       @EndingDateTime,
                                       @QueryTime,
                                       @UserAuthorizationKey;
END;
GO

/*
Stored Procedure: [Project3].[LoadCourse]
-- =============================================
-- Author:		Aleksandra Georgievska
-- Create date: 12/4/23
-- Description:	Adds the Courses to the Course Table
-- =============================================
*/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [Project3].[LoadCourse] @UserAuthorizationKey INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @StartingDateTime DATETIME2 = SYSDATETIME();

    INSERT INTO [Academic].[Course](
        [DepartmentID], -- fk
        [CourseNumber], -- Course (parse number)
        [CourseName], -- Description 
        [CourseCredit], -- Course (parse second number in (,))
        [CreditHours], -- Course (parse first number in (,))
        UserAuthorizationKey
    )
    SELECT DISTINCT
        ( SELECT TOP 1 D.DepartmentID
          FROM [Academic].[Department] AS D
          WHERE D.DepartmentName = LEFT([Course (hr, crd)], PATINDEX('%[ (]%', [Course (hr, crd)]) - 1)) -- DepartmentID
        ,SUBSTRING(
                [Course (hr, crd)], 
                PATINDEX('%[0-9]%', [Course (hr, crd)]), 
                CHARINDEX('(', [Course (hr, crd)]) - PATINDEX('%[0-9]%', [Course (hr, crd)])
            ) -- CourseNumber
        ,C.Description -- CourseName
        ,CAST(SUBSTRING(
                [Course (hr, crd)], 
                CHARINDEX(',', [Course (hr, crd)]) + 2, 
                CHARINDEX(')', [Course (hr, crd)]) - CHARINDEX(',', [Course (hr, crd)]) - 2 
                ) AS FLOAT) --CourseCredit
        ,CAST(SUBSTRING(
                [Course (hr, crd)], 
                CHARINDEX('(', [Course (hr, crd)]) + 1, 
                CHARINDEX(',', [Course (hr, crd)]) - CHARINDEX('(', [Course (hr, crd)]) - 1
                ) AS FLOAT) -- CreditHours 
        ,@UserAuthorizationKey
    FROM
    [Uploadfile].[CurrentSemesterCourseOfferings] AS C;

    DECLARE @WorkFlowStepTableRowCount INT;
    SET @WorkFlowStepTableRowCount = (
                                    SELECT COUNT(*) 
                                    FROM [Academic].[Course]
                                    );
    DECLARE @EndingDateTime DATETIME2 = SYSDATETIME();
    DECLARE @QueryTime BIGINT = CAST(DATEDIFF(MILLISECOND, @StartingDateTime, @EndingDateTime) AS bigint);
    EXEC [Process].[usp_TrackWorkFlow] 'Add Course Data',
                                       @WorkFlowStepTableRowCount,
                                       @StartingDateTime,
                                       @EndingDateTime,
                                       @QueryTime,
                                       @UserAuthorizationKey;
END;
GO

/*
Stored Procedure: [Project3].[LoadSemesters]
-- =============================================
-- Author:		Sigalita Yakubova
-- Create date: 12/4/23
-- Description:	Loads in the Semester Table
-- =============================================
*/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [Project3].[LoadSemesters] @UserAuthorizationKey INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @DateAdded DATETIME2 = SYSDATETIME();
    DECLARE @StartingDateTime DATETIME2 = SYSDATETIME();

    -- Right now this will only fill the table with Fall 2023 but in the future the functions below will be a useful feature
    INSERT INTO [Enrollment].[Semester](
        SemesterName, UserAuthorizationKey
    )
    VALUES 
        ('Fall 2023', @UserAuthorizationKey)

    DECLARE @WorkFlowStepTableRowCount INT;
    SET @WorkFlowStepTableRowCount = (
                                    SELECT COUNT(*) 
                                    FROM [Enrollment].[Semester]
                                    );
    DECLARE @EndingDateTime DATETIME2 = SYSDATETIME();
    DECLARE @QueryTime BIGINT = CAST(DATEDIFF(MILLISECOND, @StartingDateTime, @EndingDateTime) AS bigint);
    EXEC [Process].[usp_TrackWorkFlow] 'Add Semester Data',
                                       @WorkFlowStepTableRowCount,
                                       @StartingDateTime,
                                       @EndingDateTime,
                                       @QueryTime,
                                       @UserAuthorizationKey;
END;
GO

/*
Stored Procedure: [Project3].[LoadSections]
-- =============================================
-- Author:		Sigalita Yakubova
-- Create date: 12/4/23
-- Description:	Loads in the Section Table
-- =============================================
*/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [Project3].[LoadSections] @UserAuthorizationKey INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @StartingDateTime DATETIME2 = SYSDATETIME();

    INSERT INTO [Academic].[Section] (SectionNumber, SectionCode, CourseID, UserAuthorizationKey)
    SELECT DISTINCT
        Upload.Sec,
        Upload.Code,
        (
            SELECT TOP 1 C.CourseId
            FROM [Academic].[Course] AS C
                INNER JOIN [Academic].[Department] AS D
                    ON C.DepartmentID = D.DepartmentID
            WHERE 
                D.DepartmentName = LEFT(Upload.[Course (hr, crd)], PATINDEX('%[ (]%', Upload.[Course (hr, crd)]) - 1) AND 
                C.CourseNumber = SUBSTRING(
                    Upload.[Course (hr, crd)], 
                    PATINDEX('%[0-9]%', Upload.[Course (hr, crd)]), 
                    CHARINDEX('(', Upload.[Course (hr, crd)]) - PATINDEX('%[0-9]%', Upload.[Course (hr, crd)])
                )
        ) AS CourseID,
        @UserAuthorizationKey
    FROM
        [Uploadfile].[CurrentSemesterCourseOfferings] AS Upload;

    DECLARE @WorkFlowStepTableRowCount INT;
    SET @WorkFlowStepTableRowCount = (
                                    SELECT COUNT(*) 
                                    FROM [Academic].[Section]
                                    );
    DECLARE @EndingDateTime DATETIME2 = SYSDATETIME();
    DECLARE @QueryTime BIGINT = CAST(DATEDIFF(MILLISECOND, @StartingDateTime, @EndingDateTime) AS bigint);
    EXEC [Process].[usp_TrackWorkFlow] 'Add Section Data',
                                       @WorkFlowStepTableRowCount,
                                       @StartingDateTime,
                                       @EndingDateTime,
                                       @QueryTime,
                                       @UserAuthorizationKey;
END;
GO

/*
Stored Procedure: [Project3].[LoadDays]
-- =============================================
-- Author:		Ahnaf Ahmed
-- Create date: 12/4/23
-- Description:	Adds the day abbreviation to the Days Table
-- =============================================
*/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [Project3].[LoadDays] @UserAuthorizationKey INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @StartingDateTime DATETIME2 = SYSDATETIME();

    INSERT INTO [ClassManagement].[Days](
        [DayAbbreviation], [UserAuthorizationKey]
    )
    VALUES 
        ('M', @UserAuthorizationKey),
        ('T', @UserAuthorizationKey),
        ('W', @UserAuthorizationKey),
        ('TH', @UserAuthorizationKey),
        ('F', @UserAuthorizationKey),
        ('S', @UserAuthorizationKey),
        ('SU', @UserAuthorizationKey)

    DECLARE @WorkFlowStepTableRowCount INT;
    SET @WorkFlowStepTableRowCount = 7;
    DECLARE @EndingDateTime DATETIME2 = SYSDATETIME();
    DECLARE @QueryTime BIGINT = CAST(DATEDIFF(MILLISECOND, @StartingDateTime, @EndingDateTime) AS bigint);
    EXEC [Process].[usp_TrackWorkFlow] 'Procedure: [Project3].[LoadDays] loads DayAbbreviation into the [Days] table',
                                       @WorkFlowStepTableRowCount,
                                       @StartingDateTime,
                                       @EndingDateTime,
                                       @QueryTime,
                                       @UserAuthorizationKey;
END;
GO

/*
Stored Procedure: [Project3].[LoadEnrollmentDetails]
-- =============================================
-- Author:		Ahnaf Ahmed
-- Create date: 12/8/23
-- Description:	Loads in the EnrollmentDetails Table
-- =============================================
*/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [Project3].[LoadEnrollmentDetails] @UserAuthorizationKey INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @StartingDateTime DATETIME2 = SYSDATETIME();

    INSERT INTO [Enrollment].[EnrollmentDetails]
	(SectionID,
		CurrentEnrollment,
		MaxEnrollmentLimit,
		OverEnrolled,
		UserAuthorizationKey
	)
    SELECT DISTINCT
        S.SectionID,
		CAST(Upload.Enrolled AS INT),
		CAST(Upload.Limit AS INT),
		CASE
			WHEN CAST(Upload.Enrolled AS INT) <= CAST(Upload.Limit AS INT) THEN 'No'
			ELSE 'Yes'
		END,
        @UserAuthorizationKey
    FROM
        [Uploadfile].[CurrentSemesterCourseOfferings] AS Upload
		INNER JOIN [Academic].[Section] AS S
		ON Upload.Code = S.SectionCode

    DECLARE @WorkFlowStepTableRowCount INT;
    SET @WorkFlowStepTableRowCount = (
                                    SELECT COUNT(*) 
                                    FROM [Enrollment].[EnrollmentDetails]
                                    );
    DECLARE @EndingDateTime DATETIME2 = SYSDATETIME();
    DECLARE @QueryTime BIGINT = CAST(DATEDIFF(MILLISECOND, @StartingDateTime, @EndingDateTime) AS bigint);
    EXEC [Process].[usp_TrackWorkFlow] 'Procedure: [Project3].[LoadEnrollmentDetails] loads [EnrollmentDetails] table',
                                       @WorkFlowStepTableRowCount,
                                       @StartingDateTime,
                                       @EndingDateTime,
                                       @QueryTime,
                                       @UserAuthorizationKey;
END;
GO

/*
Stored Procedure: [Project3].[LoadModeOfInstruction]
-- =============================================
-- Author:		Nicholas Kong
-- Create date: 12/4/23
-- Description:	Populate a table to show the mode of instruction
-- =============================================
*/
CREATE OR ALTER PROCEDURE [Project3].[LoadModeOfInstruction]
    @UserAuthorizationKey INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @StartingDateTime DATETIME2 = SYSDATETIME();

    INSERT INTO ClassManagement.ModeOfInstruction(
        ModeName, UserAuthorizationKey
    )
    SELECT DISTINCT Q.[Mode of Instruction], 
            @UserAuthorizationKey
    FROM [QueensClassSchedule].[Uploadfile].[CurrentSemesterCourseOfferings] as Q

    DECLARE @WorkFlowStepTableRowCount INT;
    SET @WorkFlowStepTableRowCount = (
                                    SELECT COUNT(*) 
                                    FROM [ClassManagement].[ModeOfInstruction]
                                    );
	DECLARE @EndingDateTime DATETIME2 = SYSDATETIME();
	DECLARE @QueryTime BIGINT = CAST(DATEDIFF(MILLISECOND, @StartingDateTime, @EndingDateTime) AS bigint);
    EXEC [Process].[usp_TrackWorkFlow] 'Procedure: Project3[LoadModeOfInstruction] loads data into ShowTableStatusRowCount',
                                       @WorkFlowStepTableRowCount,
                                       @StartingDateTime,
                                       @EndingDateTime,
                                       @QueryTime,
                                       @UserAuthorizationKey;
END;
GO

/*
Stored Procedure: [Project3].[LoadRoomLocation]
-- =============================================
-- Author:		Nicholas Kong
-- Create date: 12/6/23
-- Description:	Populate a table to show the room location
-- =============================================
*/
CREATE OR ALTER PROCEDURE [Project3].[LoadRoomLocation]
    @UserAuthorizationKey INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @StartingDateTime DATETIME2 = SYSDATETIME();

	INSERT INTO [Facilities].[RoomLocation](BuildingID, RoomNumber, UserAuthorizationKey)
    SELECT
        ( SELECT TOP 1 B.BuildingID
          FROM [Facilities].[BuildingLocations] AS B
          WHERE B.BuildingAbbrv = LEFT(Q.Location, CHARINDEX(' ', Q.Location) - 1)) AS BuildingID, -- BuildingID
        CASE
		    -- add the edge cases and then manually set it correctly
            WHEN RIGHT(Q.Location, 4) = 'H 17' THEN '17'
            WHEN RIGHT(Q.Location, 4) = '135H' THEN 'A135H'
		    WHEN RIGHT(Q.Location, 4) = '135B' THEN 'A135B'
            WHEN RIGHT(Q.Location, 4) = 'H 08' THEN '08'
		    WHEN RIGHT(Q.Location, 4) = 'H 09' THEN '09'
		    WHEN RIGHT(Q.Location, 4) = 'H 12' THEN '12'
            WHEN RIGHT(Q.Location, 4) = 'H 17' THEN '17'
            WHEN RIGHT(Q.Location, 4) = 'A 11' THEN '11'
		    -- checks for null and empty string, if so set default string named TBD
            WHEN Q.Location IS NULL OR LTRIM(RTRIM(Q.Location)) = '' THEN 'TBD'
            ELSE LTRIM(RTRIM(RIGHT(Q.Location, 4)))
        END AS RoomNumber, @UserAuthorizationKey
    FROM [Uploadfile].[CurrentSemesterCourseOfferings] as Q
    WHERE CHARINDEX(' ', Location) > 0
    GROUP BY Q.[Location]

    DECLARE @WorkFlowStepTableRowCount INT;
    SET @WorkFlowStepTableRowCount = (
                                    SELECT COUNT(*) 
                                    FROM [Facilities].[RoomLocation]
                                    );
	DECLARE @EndingDateTime DATETIME2 = SYSDATETIME();
	DECLARE @QueryTime BIGINT = CAST(DATEDIFF(MILLISECOND, @StartingDateTime, @EndingDateTime) AS bigint);
    EXEC [Process].[usp_TrackWorkFlow] 'Procedure: Project3[LoadRoomLocation] loads data into ShowTableStatusRowCount',
                                       @WorkFlowStepTableRowCount,
                                       @StartingDateTime,
                                       @EndingDateTime,
                                       @QueryTime,
                                       @UserAuthorizationKey;
END;
GO

/*
Stored Procedure: [Project3].[LoadClassSchedule]
-- =============================================
-- Author:		Nicholas Kong & Edwin Wray
-- Create date: 12/5/23
-- Description:	Adds Classes to the ClassSchedule Table
-- =============================================
*/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [Project3].[LoadClassSchedule] @UserAuthorizationKey INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @StartingDateTime DATETIME2 = SYSDATETIME();

    INSERT INTO [ClassManagement].[ClassSchedule] (
        SemesterID, SectionID, InstructorID, RoomID, ModeID, StartTime, EndTime, UserAuthorizationKey
    ) 
    SELECT DISTINCT
        -- SemesterID
        ( SELECT S.SemesterID
            FROM [Enrollment].[Semester] AS S
            WHERE S.SemesterName = 'Fall 2023'
        ),
        -- SectionID
        ( SELECT TOP 1 S.SectionID
            FROM [Academic].[Section] AS S
            WHERE S.SectionCode = U.Code -- Section Code
                AND S.SectionNumber = U.Sec -- Section Number
        ),
        -- InstructorID
        ( SELECT TOP 1 I.InstructorID
            FROM [Personnel].[Instructor] AS I
            WHERE I.FirstName = COALESCE(NULLIF(LTRIM(RTRIM(SUBSTRING(U.Instructor, CHARINDEX(',', U.Instructor) + 2, LEN(U.Instructor)))), ''), 'none') -- FirstName
                AND I.LastName = COALESCE(NULLIF(LTRIM(RTRIM(SUBSTRING(U.Instructor, 1, CHARINDEX(',', U.Instructor) - 1))), ''), 'none') -- LastName
        ),
        -- RoomID
        ( SELECT TOP 1 R.RoomID
            FROM [Facilities].[RoomLocation] AS R
            WHERE R.RoomNumber = CASE
                                    -- add the edge cases and then manually set it correctly
                                    WHEN RIGHT(U.Location, 4) = 'H 17' THEN '17'
                                    WHEN RIGHT(U.Location, 4) = '135H' THEN 'A135H'
                                    WHEN RIGHT(U.Location, 4) = '135B' THEN 'A135B'
                                    WHEN RIGHT(U.Location, 4) = 'H 08' THEN '08'
                                    WHEN RIGHT(U.Location, 4) = 'H 09' THEN '09'
                                    WHEN RIGHT(U.Location, 4) = 'H 12' THEN '12'
                                    WHEN RIGHT(U.Location, 4) = 'H 17' THEN '17'
                                    WHEN RIGHT(U.Location, 4) = 'A 11' THEN '11'
                                    -- checks for null and empty string, if so set default string named TBD
                                    WHEN U.Location IS NULL OR LTRIM(RTRIM(U.Location)) = '' THEN 'TBD'
                                    ELSE LTRIM(RTRIM(RIGHT(U.Location, 4)))
                                END
        ),
        -- ModeID
        ( SELECT TOP 1 M.ModeID
            FROM [ClassManagement].[ModeOfInstruction] AS M
            WHERE M.ModeName = U.[Mode of Instruction]
        ),
        -- StartTime
		CONVERT(TIME, NULLIF(LEFT(U.Time, CHARINDEX('-', U.Time) - 1), 'TBD'), 108), 
		--EndTime
		CONVERT(TIME, NULLIF(RIGHT(U.Time, LEN(U.Time) - CHARINDEX('-', U.Time)), 'TBD'), 108),
        @UserAuthorizationKey
    FROM [Uploadfile].[CurrentSemesterCourseOfferings] AS U

    DECLARE @WorkFlowStepTableRowCount INT;
    SET @WorkFlowStepTableRowCount = (
                                    SELECT COUNT(*) 
                                    FROM [ClassManagement].[ClassSchedule]
                                    );
    DECLARE @EndingDateTime DATETIME2 = SYSDATETIME();
    DECLARE @QueryTime BIGINT = CAST(DATEDIFF(MILLISECOND, @StartingDateTime, @EndingDateTime) AS bigint);
    EXEC [Process].[usp_TrackWorkFlow] 'Add Class Data',
                                       @WorkFlowStepTableRowCount,
                                       @StartingDateTime,
                                       @EndingDateTime,
                                       @QueryTime,
                                       @UserAuthorizationKey;
END;
GO

/*
Stored Procedure: [Project3].[LoadDepartments]
-- =============================================
-- Author:		Aryeh Richman
-- Create date: 12/5/23
-- Description:	Adds the Departments to the Department Table
-- =============================================
*/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [Project3].[LoadDepartments] @UserAuthorizationKey INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @StartingDateTime DATETIME2 = SYSDATETIME();

    INSERT INTO [Academic].[Department] (
        DepartmentName, UserAuthorizationKey
    )
    SELECT DISTINCT
        LEFT([Course (hr, crd)], CHARINDEX(' ', [Course (hr, crd)]) - 1) AS DepartmentName,
        @UserAuthorizationKey
    FROM [Uploadfile].[CurrentSemesterCourseOfferings]
    ORDER BY DepartmentName

    DECLARE @WorkFlowStepTableRowCount INT;
    SET @WorkFlowStepTableRowCount = (
                                    SELECT COUNT(*) 
                                    FROM [Academic].[Department]
                                    );
    DECLARE @EndingDateTime DATETIME2 = SYSDATETIME();
    DECLARE @QueryTime BIGINT = CAST(DATEDIFF(MILLISECOND, @StartingDateTime, @EndingDateTime) AS bigint);
    EXEC [Process].[usp_TrackWorkFlow] 'Add Department Data',
                                       @WorkFlowStepTableRowCount,
                                       @StartingDateTime,
                                       @EndingDateTime,
                                       @QueryTime,
                                       @UserAuthorizationKey;
END;
GO

/*
Stored Procedure: [Project3].[LoadDepartmentInstructor]
-- =============================================
-- Author:		Aryeh Richman
-- Create date: 12/6/23
-- Description:	Adds the values to the Department / Instructor bridge table
-- =============================================
*/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [Project3].[LoadDepartmentInstructor] @UserAuthorizationKey INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @StartingDateTime DATETIME2 = SYSDATETIME();

    INSERT INTO [Personnel].[DepartmentInstructor] (
        DepartmentID, InstructorID, UserAuthorizationKey
    )
    SELECT DISTINCT D.DepartmentID, I.InstructorID, @UserAuthorizationKey
    FROM Academic.Department AS D
        CROSS JOIN Personnel.Instructor AS I
        INNER JOIN Uploadfile.CurrentSemesterCourseOfferings AS U
            ON LEFT(U.[Course (hr, crd)], CHARINDEX(' ', U.[Course (hr, crd)]) - 1) = D.DepartmentName
            AND LTRIM(RTRIM(SUBSTRING(U.Instructor, CHARINDEX(',', U.Instructor) + 2, LEN(U.Instructor)))) = I.FirstName
            AND LTRIM(RTRIM(SUBSTRING(U.Instructor, 1, CHARINDEX(',', U.Instructor) - 1))) = I.LastName

    DECLARE @WorkFlowStepTableRowCount INT;
    SET @WorkFlowStepTableRowCount = (
                                    SELECT COUNT(*) 
                                    FROM [Personnel].[DepartmentInstructor]
                                    );
    DECLARE @EndingDateTime DATETIME2 = SYSDATETIME();
    DECLARE @QueryTime BIGINT = CAST(DATEDIFF(MILLISECOND, @StartingDateTime, @EndingDateTime) AS bigint);
    EXEC [Process].[usp_TrackWorkFlow] 'Add Department Data',
                                       @WorkFlowStepTableRowCount,
                                       @StartingDateTime,
                                       @EndingDateTime,
                                       @QueryTime,
                                       @UserAuthorizationKey;
END;
GO

/*
Stored Procedure: [Project3].[LoadClassDays]
-- =============================================
-- Author:		Aryeh Richman
-- Create date: 12/10/23
-- Description:	Adds the values to the Class / Day bridge table
-- =============================================
*/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [Project3].[LoadClassDays] @UserAuthorizationKey INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @StartingDateTime DATETIME2 = SYSDATETIME();

    INSERT INTO [ClassManagement].[ClassDays] (
        ClassID, DayID, UserAuthorizationKey
    )
    SELECT DISTINCT C.ClassID, D.DayID, @UserAuthorizationKey
    FROM ClassManagement.ClassSchedule AS C
        CROSS JOIN ClassManagement.[Days] AS D
        INNER JOIN Academic.Section AS S 
            ON S.SectionID = C.SectionID
        INNER JOIN Uploadfile.CurrentSemesterCourseOfferings AS U
            ON U.Code = S.SectionCode
        CROSS APPLY dbo.SplitString(U.Day, ',') AS SS
        WHERE D.DayAbbreviation = LTRIM(RTRIM(SS.Value))

    DECLARE @WorkFlowStepTableRowCount INT;
    SET @WorkFlowStepTableRowCount = (
                                    SELECT COUNT(*) 
                                    FROM [ClassManagement].[ClassDays]
                                    );
    DECLARE @EndingDateTime DATETIME2 = SYSDATETIME();
    DECLARE @QueryTime BIGINT = CAST(DATEDIFF(MILLISECOND, @StartingDateTime, @EndingDateTime) AS bigint);
    EXEC [Process].[usp_TrackWorkFlow] 'Add ClassDays Data',
                                       @WorkFlowStepTableRowCount,
                                       @StartingDateTime,
                                       @EndingDateTime,
                                       @QueryTime,
                                       @UserAuthorizationKey;
END;
GO

/*
Stored Procedure: [Project3].[LoadBuildingLocations]
-- =============================================
-- Author:		Edwin Wray
-- Create date: 12/5/23
-- Description:	Adds the BuildingLocations to the BuildingLocations Table
-- =============================================
*/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [Project3].[LoadBuildingLocations] @UserAuthorizationKey INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @StartingDateTime DATETIME2 = SYSDATETIME();

    INSERT INTO [Facilities].[BuildingLocations] (
        BuildingAbbrv, BuildingName, UserAuthorizationKey
    )
    SELECT DISTINCT
        LEFT(Location, CHARINDEX(' ', Location) - 1) AS BuildingAbbrv,
        CASE
            WHEN LEFT(Location, CHARINDEX(' ', Location) - 1) = 'AE' THEN 'Alumni Hall'
            WHEN LEFT(Location, CHARINDEX(' ', Location) - 1) = 'CD' THEN 'Campbell Dome'
            WHEN LEFT(Location, CHARINDEX(' ', Location) - 1) = 'CA' THEN 'Colden Auditorium'
            WHEN LEFT(Location, CHARINDEX(' ', Location) - 1) = 'CH' THEN 'Colwin Hall'
            WHEN LEFT(Location, CHARINDEX(' ', Location) - 1) = 'CI' THEN 'Continuing Ed 1'
            WHEN LEFT(Location, CHARINDEX(' ', Location) - 1) = 'DY' THEN 'Delany Hall'
            WHEN LEFT(Location, CHARINDEX(' ', Location) - 1) = 'DH' THEN 'Dining Hall'
            WHEN LEFT(Location, CHARINDEX(' ', Location) - 1) = 'FG' THEN 'FitzGerald Gym'
            WHEN LEFT(Location, CHARINDEX(' ', Location) - 1) = 'FH' THEN 'Frese Hall'
            WHEN LEFT(Location, CHARINDEX(' ', Location) - 1) = 'GB' THEN 'G Building'
            WHEN LEFT(Location, CHARINDEX(' ', Location) - 1) = 'GC' THEN 'Gertz Center'
            WHEN LEFT(Location, CHARINDEX(' ', Location) - 1) = 'GT' THEN 'Goldstein Theatre'
            WHEN LEFT(Location, CHARINDEX(' ', Location) - 1) = 'HH' THEN 'Honors Hall'
            WHEN LEFT(Location, CHARINDEX(' ', Location) - 1) = 'IB' THEN 'I Building'
            WHEN LEFT(Location, CHARINDEX(' ', Location) - 1) = 'JH' THEN 'Jefferson Hall'
            WHEN LEFT(Location, CHARINDEX(' ', Location) - 1) = 'KY' THEN 'Kiely Hall'
            WHEN LEFT(Location, CHARINDEX(' ', Location) - 1) = 'KG' THEN 'King Hall'
            WHEN LEFT(Location, CHARINDEX(' ', Location) - 1) = 'KS' THEN 'Kissena Hall'
            WHEN LEFT(Location, CHARINDEX(' ', Location) - 1) = 'KP' THEN 'Klapper Hall'
            WHEN LEFT(Location, CHARINDEX(' ', Location) - 1) = 'MU' THEN 'Music Building'
            WHEN LEFT(Location, CHARINDEX(' ', Location) - 1) = 'PH' THEN 'Powdermaker Hall'
            WHEN LEFT(Location, CHARINDEX(' ', Location) - 1) = 'QH' THEN 'Queens Hall'
            WHEN LEFT(Location, CHARINDEX(' ', Location) - 1) = 'RA' THEN 'Rathaus Hall'
            WHEN LEFT(Location, CHARINDEX(' ', Location) - 1) = 'RZ' THEN 'Razran Hall'
            WHEN LEFT(Location, CHARINDEX(' ', Location) - 1) = 'RE' THEN 'Remsen Hall'
            WHEN LEFT(Location, CHARINDEX(' ', Location) - 1) = 'RO' THEN 'Rosenthal Library'
            WHEN LEFT(Location, CHARINDEX(' ', Location) - 1) = 'SB' THEN 'Science Building'
            WHEN LEFT(Location, CHARINDEX(' ', Location) - 1) = 'SU' THEN 'Student Union'
            WHEN LEFT(Location, CHARINDEX(' ', Location) - 1) = 'C2' THEN 'Tech Incubator'
            ELSE 'Athletic Fields' -- Default case for any other or unexpected abbreviation
        END AS BuildingName,
        @UserAuthorizationKey
    FROM [Uploadfile].[CurrentSemesterCourseOfferings]
    WHERE CHARINDEX(' ', Location) > 0
    ORDER BY BuildingName

    DECLARE @WorkFlowStepTableRowCount INT;
    SET @WorkFlowStepTableRowCount = (
                                    SELECT COUNT(*) 
                                    FROM [Facilities].[BuildingLocations]
                                    );
    DECLARE @EndingDateTime DATETIME2 = SYSDATETIME();
    DECLARE @QueryTime BIGINT = CAST(DATEDIFF(MILLISECOND, @StartingDateTime, @EndingDateTime) AS bigint);
    EXEC [Process].[usp_TrackWorkFlow] 'Add BuildingLocations Data',
                                       @WorkFlowStepTableRowCount,
                                       @StartingDateTime,
                                       @EndingDateTime,
                                       @QueryTime,
                                       @UserAuthorizationKey;
END;
GO

-- add more stored procedures here... 

--------------------------------------- DB CONTROLLER STORED PROCEDURES ----------------------------------------------

/*
-- =============================================
-- Author:		Aleksandra Georgievska
-- Create date: 11/14/23
-- Description:	Clears all data from the Class Schedule db
-- =============================================
*/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [Project3].[TruncateClassScheduleDatabase]
    @UserAuthorizationKey INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @StartingDateTime DATETIME2 = SYSDATETIME();
    -- Drop All of the foreign keys prior to truncating tables in the Class Schedule db
    EXEC [Project3].[DropForeignKeysFromClassSchedule] @UserAuthorizationKey = 1;
    --	Check row count before truncation
    EXEC [Project3].[ShowTableStatusRowCount] @UserAuthorizationKey = 6,  
		@TableStatus = N'''Pre-truncate of tables'''
    --	Always truncate the Star Schema Data
    EXEC  [Project3].[TruncateClassScheduleData] @UserAuthorizationKey = 3;
    --	Check row count AFTER truncation
    EXEC [Project3].[ShowTableStatusRowCount] @UserAuthorizationKey = 6,  
		@TableStatus = N'''Post-truncate of tables'''
END;
GO

/*
This T-SQL script is for creating a stored procedure named LoadClassScheduleDatabase within a SQL Server database, likely for the 
purpose of managing and updating a star schema data warehouse structure. Here's a breakdown of what this script does:
-- =============================================
-- Author:		Aleksandra Georgievska
-- Create date: 11/14/23
-- Description:	Procedure runs other stored procedures to populate the data
-- =============================================
*/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [Project3].[LoadClassScheduleDatabase]
    @UserAuthorizationKey INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @StartingDateTime DATETIME2 = SYSDATETIME();
    /*
            Note: User Authorization keys are hardcoded, each representing a different group user 
                    Aleksandra Georgievska → User Key 1
                    Sigalita Yakubova → User Key 2
                    Nicholas Kong → User Key 3
                    Edwin Wray → User Key 4
                    Ahnaf Ahmed → User Key 5
                    Aryeh Richman → User Key 6
    */

    -- ADD EXEC COMMANDS:

    -- TIER ONE TABLES LOAD
    -- Aleks
    EXEC [Project3].[Load_UserAuthorization] @UserAuthorizationKey = 1
    EXEC [Project3].[LoadInstructors] @UserAuthorizationKey = 1
    -- Aryeh
    EXEC [Project3].[LoadDepartments] @UserAuthorizationKey = 6
    -- Nicholas
    EXEC [Project3].[LoadModeOfInstruction] @UserAuthorizationKey = 3
    -- Ahnaf
    EXEC [Project3].[LoadDays] @UserAuthorizationKey = 5
    -- Sigi
    EXEC [Project3].[LoadSemesters] @UserAuthorizationKey = 2
    -- Edwin
    EXEC [Project3].[LoadBuildingLocations] @UserAuthorizationKey = 4	

    -- TIER 2 TABLES LOAD
    -- Aleks
    EXEC [Project3].[LoadCourse] @UserAuthorizationKey = 1
    -- Aryeh
    EXEC [Project3].[LoadDepartmentInstructor] @UserAuthorizationKey = 6
    -- Nicholas
    EXEC [Project3].[LoadRoomLocation]  @UserAuthorizationKey = 3

    -- TIER 3 TABLES LOAD (In Order)
    --Sigi
    EXEC [Project3].[LoadSections] @UserAuthorizationKey = 2
	-- Ahnaf
	EXEC [Project3].[LoadEnrollmentDetails] @UserAuthorizationKey = 5
    -- Edwin
    EXEC [Project3].[LoadClassSchedule] @UserAuthorizationKey = 4 -- still needs work
	-- Aryeh
    EXEC [Project3].[LoadClassDays]  @UserAuthorizationKey = 6 -- still needs work

    --	Check row count before truncation
    EXEC [Project3].[ShowTableStatusRowCount] @UserAuthorizationKey = 6,
		@TableStatus = N'''Row Count after loading the Class Schedule db'''
END;
GO

EXEC [Project3].[TruncateClassScheduleDatabase] @UserAuthorizationKey = 1;
EXEC [Project3].[LoadClassScheduleDatabase] @UserAuthorizationKey = 1;
EXEC [Project3].[AddForeignKeysToClassSchedule] @UserAuthorizationKey = 1;