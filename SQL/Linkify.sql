CREATE DATABASE Linkify

	CREATE TABLE Location(
		LID VARCHAR(150) PRIMARY KEY,
		Country VARCHAR(30),
		City VARCHAR(30),
		State VARCHAR(30),
		PostalCode VARCHAR(30)
	)

	CREATE TABLE Person(
		PID INT PRIMARY KEY IDENTITY(1,1),
		Username VARCHAR(60) NOT NULL,
		PassHash VARCHAR(150) NOT NULL,
		RegDate DATETIME,
		LID VARCHAR(150) FOREIGN KEY REFERENCES Location(LID) ON DELETE SET NULL
	)

	CREATE TABLE FriendList(
		PID INT FOREIGN KEY REFERENCES Person(PID),
		FID INT FOREIGN KEY REFERENCES Person(PID) ON DELETE CASCADE,
		Status VARCHAR(20) NOT NULL DEFAULT 'pending',
		PRIMARY KEY (PID, FID),
		CONSTRAINT CHK_NotSelfFriend CHECK (PID <> FID),
		CONSTRAINT FriendList_Status CHECK (Status IN ('pending', 'accepted', 'rejected'))
	)

	CREATE TABLE Post (
		PostID INT PRIMARY KEY IDENTITY(1,1),
		PersonID INT FOREIGN KEY REFERENCES Person(PID) ON DELETE CASCADE,
		CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
		PrivacyLevel VARCHAR(10) NOT NULL DEFAULT 'public',
		CommentCount INT NOT NULL DEFAULT 0,
		ShareCount INT NOT NULL DEFAULT 0,
		URL VARCHAR(255) NOT NULL,
		CONSTRAINT CHK_PrivacyLevel CHECK(PrivacyLevel IN ('public','connections','private'))
	)

	CREATE TABLE PostText (
		PostID INT PRIMARY KEY FOREIGN KEY REFERENCES Post(PostID) ON DELETE CASCADE,
		ContentText NVARCHAR(MAX) NOT NULL
	)

	CREATE TABLE PostImage (
		ImageID INT IDENTITY(1,1),
		PostID INT FOREIGN KEY REFERENCES Post(PostID) ON DELETE CASCADE,
		ImageURL VARCHAR(255) NOT NULL,
		Format VARCHAR(5) NOT NULL,
		PRIMARY KEY(ImageID, PostID)
	)

	CREATE TABLE Comment (
		CommentID INT PRIMARY KEY IDENTITY(1,1),
		PostID INT NOT NULL FOREIGN KEY REFERENCES Post(PostID) ON DELETE CASCADE,
		PersonID INT NOT NULL FOREIGN KEY REFERENCES Person(PID),
		CommentText NVARCHAR(MAX) NOT NULL,
		CONSTRAINT FK_Comment_Post FOREIGN KEY (PostID) REFERENCES Post(PostID),
		CONSTRAINT FK_Comment_Person FOREIGN KEY (PersonID) REFERENCES Person(PID)
    )

	CREATE TABLE CommentReply (
		ReplyID INT PRIMARY KEY IDENTITY(1,1),
		CommentID INT NOT NULL FOREIGN KEY REFERENCES Comment(CommentID) ON DELETE CASCADE,
		PersonID INT NOT NULL FOREIGN KEY REFERENCES Person(PID),
		ReplyText NVARCHAR(MAX) NOT NULL,
		CONSTRAINT FK_Reply_Comment FOREIGN KEY (CommentID) REFERENCES Comment(CommentID),
		CONSTRAINT FK_Reply_Person FOREIGN KEY (PersonID) REFERENCES Person(PID)
    )

	CREATE TABLE PostReaction (
		ReactionID INT IDENTITY(1,1),
		PostID INT NOT NULL FOREIGN KEY REFERENCES Post(PostID) ON DELETE CASCADE,
		PersonID INT NOT NULL FOREIGN KEY REFERENCES Person(PID),
		ReactionType VARCHAR(10) NOT NULL,
		PRIMARY KEY (ReactionID),
		CONSTRAINT UQ_PostReaction UNIQUE (PostID, PersonID),
		CONSTRAINT CHK_PostReactionType CHECK (ReactionType IN ('Like','Love','Haha','Sad','Angry'))
	)

	CREATE TABLE CommentReaction (
		ReactionID INT IDENTITY(1,1),
		CommentID INT NOT NULL FOREIGN KEY REFERENCES Comment(CommentID) ON DELETE CASCADE,
		PersonID INT NOT NULL FOREIGN KEY REFERENCES Person(PID),
		ReactionType VARCHAR(10) NOT NULL,
		PRIMARY KEY (ReactionID),
		CONSTRAINT UQ_CommentReaction UNIQUE (CommentID, PersonID),
		CONSTRAINT CHK_CommentReactionType CHECK (ReactionType IN ('Like','Love','Haha','Sad','Angry'))
	)

	CREATE TABLE ReplyReaction (
		ReactionID INT IDENTITY(1,1),
		ReplyID INT NOT NULL FOREIGN KEY REFERENCES CommentReply(ReplyID) ON DELETE CASCADE,
		PersonID INT NOT NULL FOREIGN KEY REFERENCES Person(PID),
		ReactionType VARCHAR(10) NOT NULL,
		PRIMARY KEY (ReactionID),
		CONSTRAINT UQ_ReplyReaction UNIQUE (ReplyID, PersonID),
		CONSTRAINT CHK_ReplyReactionType CHECK (ReactionType IN ('Like','Love','Haha','Sad','Angry'))
	)

	CREATE TABLE Employer(
		PID INT FOREIGN KEY REFERENCES Person(PID) ON DELETE CASCADE,
		ReleasedDate DATETIME
	)

	CREATE TABLE Candidate(
		PID INT FOREIGN KEY REFERENCES Person(PID) ON DELETE CASCADE,
		Status VARCHAR(30),
		BirthDate DATETIME,
		CONSTRAINT Candidate_Status CHECK(Status IN ('fulltime','parttime','selfemployed', 'freelancer',
														'opentowork', 'student', 'intern', 'onleave', 'retired'))
	)

	CREATE TABLE Contact(
		PID INT FOREIGN KEY REFERENCES Person(PID) ON DELETE CASCADE,
		Value VARCHAR(150),
		Type VARCHAR(30) NOT NULL,
		PRIMARY KEY(PID, Value)
	)

	CREATE TABLE Skill(
		SID INT PRIMARY KEY IDENTITY(1,1),
		Sname VARCHAR(30) UNIQUE NOT NULL,
		Category VARCHAR(30)
	)

	CREATE TABLE Tag(
		PID INT FOREIGN KEY REFERENCES Person(PID) ON DELETE CASCADE,
		SID INT FOREIGN KEY REFERENCES Skill(SID) ON DELETE CASCADE,
		InterestLevel INT,
		CONSTRAINT Interest_Level CHECK (InterestLevel BETWEEN 1 AND 5)
	)

	CREATE TABLE Job(
		JID INT PRIMARY KEY IDENTITY(1,1),
		EID INT FOREIGN KEY REFERENCES Person(PID) ON DELETE CASCADE, --Employer ID
		Title VARCHAR(30) NOT NULL,
		Category VARCHAR(30) NOT NULL,
		Description NVARCHAR(MAX),
		Type VARCHAR(30),
		ExperienceLevel INT,
		LID VARCHAR(150) FOREIGN KEY REFERENCES Location(LID),
		SalaryRange VARCHAR(30),
		PostedDate DATETIME NOT NULL DEFAULT GETDATE(),
		CONSTRAINT Job_Type CHECK (Type IN ('remote', 'hybrid', 'onsite')),
		CONSTRAINT Experience_Level CHECK (ExperienceLevel BETWEEN 1 and 5)
	)

	CREATE TABLE Application(
		AID INT PRIMARY KEY IDENTITY(1,1),
		JID INT FOREIGN KEY REFERENCES Job(JID),
		CID INT FOREIGN KEY REFERENCES Person(PID) ON DELETE CASCADE,
		SubmissionDate DATETIME NOT NULL DEFAULT GETDATE(),
		Status VARCHAR(30),
		CONSTRAINT Application_Status CHECK (Status IN ('submitted', 'underreview', 'interviewing', 'offered', 'rejected', 'accepted'))
	)

	--CREATE TABLE Interview(
	--	IID INT PRIMARY KEY IDENTITY(1,1),
	--	AID INT FOREIGN KEY REFERENCES Application(AID),
	--	Type VARCHAR(30),
	--	Schedule DATETIMEOFFSET(0),
	--	Result VARCHAR(30),
	--	CONSTRAINT Interview_Type CHECK(Type IN('onsite', 'online', 'video')),
	--	CONSTRAINT Interview_Result CHECK(Result IN('rejected','onhold','accepted','waitinglist'))
	--)

	--CREATE TABLE Feedback(
	--	IID INT PRIMARY KEY FOREIGN KEY REFERENCES Interview(IID) ON DELETE CASCADE,
	--	Rating INT, --add constraint
	--	Notes VARCHAR(MAX),
	--	ReleasedDate DATETIME,
	--	CONSTRAINT Feedback_Rating CHECK(Rating BETWEEN 1 AND 5)
	--)


-- For job searches
CREATE INDEX IX_Job_EmpID ON Job(EID);
CREATE INDEX IX_Job_Location ON Job(LID);
CREATE INDEX IX_Job_Type ON Job(Type);

-- For application tracking
CREATE INDEX IX_Application_Candidate ON Application(CID);
CREATE INDEX IX_Application_Job ON Application(JID);
CREATE INDEX IX_Application_Status ON Application(Status);

---- For interview management
--CREATE INDEX IX_Interview_Application ON Interview(AID);
--CREATE INDEX IX_Interview_Schedule ON Interview(Schedule);

-- For fast tag searching
CREATE INDEX IX_Tag_Skill ON Tag(SID);

-- For fast post searching
CREATE INDEX IX_Post_Person ON Post(PersonID);

-- For fast friendlist search
CREATE INDEX IX_FriendList_PID_Status ON FriendList(PID, Status);


GO
--Stored Procedures


CREATE PROCEDURE sp_RegisterUser     --to regester a new user
    @Email VARCHAR(100),
    @PasswordHash VARCHAR(150),
    @FirstName NVARCHAR(30),
    @LastName NVARCHAR(30),
    @UserType VARCHAR(10), -- 'candidate' or 'employer'
    @CompanyName NVARCHAR(100) = NULL -- Optional for candidates, required for employers
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Validate parameters
        IF @UserType NOT IN ('candidate', 'employer')
            THROW 50001, 'Invalid UserType. Must be "candidate" or "employer"', 1;
            
        -- Validation for employers
        IF @UserType = 'employer' AND (@CompanyName IS NULL OR LTRIM(RTRIM(@CompanyName)) = '')
            THROW 50002, 'Company name is required for employer registration', 1;
        
        BEGIN TRANSACTION;
        
        -- Insert base person record
        INSERT INTO Person (PassHash, RegDate)
        VALUES (@PasswordHash, GETDATE());

        DECLARE @NewPID INT = SCOPE_IDENTITY();

		INSERT INTO Contact (PID, Value, Type)
		VALUES (@NewPID, @Email, 'Email');
        
        -- Handle candidate registration
        IF @UserType = 'candidate'
            INSERT INTO Candidate (PID, FirstName, LastName)
            VALUES (@NewPID, @FirstName, @LastName);
        
        -- Handle employer registration
        ELSE
            INSERT INTO Employer (PID, Company)
            VALUES (@NewPID, @CompanyName);
            
        -- Return the new user ID
        SELECT @NewPID AS NewUserID;
        
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO



CREATE PROCEDURE sp_ApplyForJob
    @JobID INT,
    @CandidateID INT
AS
BEGIN
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM Candidate WHERE PID = @CandidateID)
            THROW 50001, 'Invalid candidate ID', 1;
            
        IF NOT EXISTS (SELECT 1 FROM Job WHERE JID = @JobID)
            THROW 50002, 'Invalid job ID', 1;
            
        INSERT INTO Application (JID, CID, Status)
        VALUES (@JobID, @CandidateID, 'submitted');
        
        SELECT SCOPE_IDENTITY() AS ApplicationID;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END;
GO



CREATE PROCEDURE sp_DeleteUserAccount
    @UserID INT
AS
BEGIN
    BEGIN TRY
        -- Cascading deletes will handle related records
        DELETE FROM Person
        WHERE PID = @UserID;
        
        -- Return success even if no rows affected (already deleted)
        SELECT 1 AS Success;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END;
GO


CREATE PROCEDURE sp_SendFriendRequest
    @RequesterPID INT,
    @TargetPID INT
AS
BEGIN
    BEGIN TRY
        IF @RequesterPID = @TargetPID
            THROW 50010, 'Cannot friend yourself', 1;
            
        IF EXISTS (SELECT 1 FROM FriendList 
                  WHERE PID = @TargetPID AND FID = @RequesterPID)
            THROW 50011, 'Friend request already exists', 1;
            
        INSERT INTO FriendList (PID, FID, Status)
        VALUES (@RequesterPID, @TargetPID, 'pending');
        
        SELECT 1 AS Success;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END;
