/*------------------------------------------------------------
  BalloonShopMembership.sql  (Idempotent)
  Creates ASP.NET Membership, Roles, and Profile schema
  for the BalloonShop database.

  Safe to execute multiple times (no duplicate objects).
-------------------------------------------------------------*/

USE [BalloonShop];
GO

/*------------------------------------------------------------
  Create aspnet_Applications
-------------------------------------------------------------*/
IF OBJECT_ID('dbo.aspnet_Applications', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.aspnet_Applications (
        ApplicationName NVARCHAR(256) NOT NULL,
        LoweredApplicationName NVARCHAR(256) NOT NULL,
        ApplicationId UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
        Description NVARCHAR(256) NULL
    );
    PRINT 'Created table: aspnet_Applications';
END
ELSE
    PRINT 'Table exists: aspnet_Applications';
GO

/*------------------------------------------------------------
  Create aspnet_Roles
-------------------------------------------------------------*/
IF OBJECT_ID('dbo.aspnet_Roles', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.aspnet_Roles (
        ApplicationId UNIQUEIDENTIFIER NOT NULL,
        RoleId UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
        RoleName NVARCHAR(256) NOT NULL,
        LoweredRoleName NVARCHAR(256) NOT NULL,
        Description NVARCHAR(256) NULL
    );
    PRINT 'Created table: aspnet_Roles';
END
ELSE
    PRINT 'Table exists: aspnet_Roles';
GO

/*------------------------------------------------------------
  Create aspnet_Users
-------------------------------------------------------------*/
IF OBJECT_ID('dbo.aspnet_Users', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.aspnet_Users (
        ApplicationId UNIQUEIDENTIFIER NOT NULL,
        UserId UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
        UserName NVARCHAR(256) NOT NULL,
        LoweredUserName NVARCHAR(256) NOT NULL,
        IsAnonymous BIT NOT NULL,
        LastActivityDate DATETIME NOT NULL
    );
    PRINT 'Created table: aspnet_Users';
END
ELSE
    PRINT 'Table exists: aspnet_Users';
GO

/*------------------------------------------------------------
  Create aspnet_Membership
-------------------------------------------------------------*/
IF OBJECT_ID('dbo.aspnet_Membership', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.aspnet_Membership (
        ApplicationId UNIQUEIDENTIFIER NOT NULL,
        UserId UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
        Password NVARCHAR(128) NOT NULL,
        PasswordFormat INT NOT NULL,
        PasswordSalt NVARCHAR(128) NOT NULL,
        MobilePIN NVARCHAR(16) NULL,
        Email NVARCHAR(256) NULL,
        LoweredEmail NVARCHAR(256) NULL,
        PasswordQuestion NVARCHAR(256) NULL,
        PasswordAnswer NVARCHAR(128) NULL,
        IsApproved BIT NOT NULL DEFAULT 1,
        IsLockedOut BIT NOT NULL DEFAULT 0,
        CreateDate DATETIME NOT NULL DEFAULT GETDATE(),
        LastLoginDate DATETIME NULL,
        LastPasswordChangedDate DATETIME NULL,
        LastLockoutDate DATETIME NULL,
        FailedPasswordAttemptCount INT NOT NULL DEFAULT 0,
        FailedPasswordAttemptWindowStart DATETIME NULL,
        FailedPasswordAnswerAttemptCount INT NOT NULL DEFAULT 0,
        FailedPasswordAnswerAttemptWindowStart DATETIME NULL,
        Comment NTEXT NULL
    );
    PRINT 'Created table: aspnet_Membership';
END
ELSE
    PRINT 'Table exists: aspnet_Membership';
GO

/*------------------------------------------------------------
  Create aspnet_UsersInRoles
-------------------------------------------------------------*/
IF OBJECT_ID('dbo.aspnet_UsersInRoles', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.aspnet_UsersInRoles (
        UserId UNIQUEIDENTIFIER NOT NULL,
        RoleId UNIQUEIDENTIFIER NOT NULL,
        CONSTRAINT PK_aspnet_UsersInRoles PRIMARY KEY (UserId, RoleId)
    );
    PRINT 'Created table: aspnet_UsersInRoles';
END
ELSE
    PRINT 'Table exists: aspnet_UsersInRoles';
GO

/*------------------------------------------------------------
  Create aspnet_Profile
-------------------------------------------------------------*/
IF OBJECT_ID('dbo.aspnet_Profile', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.aspnet_Profile (
        UserId UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
        PropertyNames NTEXT NOT NULL,
        PropertyValuesString NTEXT NOT NULL,
        PropertyValuesBinary IMAGE NULL,
        LastUpdatedDate DATETIME NOT NULL DEFAULT GETDATE()
    );
    PRINT 'Created table: aspnet_Profile';
END
ELSE
    PRINT 'Table exists: aspnet_Profile';
GO

/*------------------------------------------------------------
  Add missing foreign keys safely
-------------------------------------------------------------*/
IF NOT EXISTS (
    SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_Roles_Applications'
)
BEGIN
    ALTER TABLE dbo.aspnet_Roles
        ADD CONSTRAINT FK_Roles_Applications FOREIGN KEY (ApplicationId)
        REFERENCES dbo.aspnet_Applications (ApplicationId);
    PRINT 'Added FK_Roles_Applications';
END

IF NOT EXISTS (
    SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_Users_Applications'
)
BEGIN
    ALTER TABLE dbo.aspnet_Users
        ADD CONSTRAINT FK_Users_Applications FOREIGN KEY (ApplicationId)
        REFERENCES dbo.aspnet_Applications (ApplicationId);
    PRINT 'Added FK_Users_Applications';
END

IF NOT EXISTS (
    SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_Membership_Users'
)
BEGIN
    ALTER TABLE dbo.aspnet_Membership
        ADD CONSTRAINT FK_Membership_Users FOREIGN KEY (UserId)
        REFERENCES dbo.aspnet_Users (UserId);
    PRINT 'Added FK_Membership_Users';
END

IF NOT EXISTS (
    SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_UsersInRoles_Users'
)
BEGIN
    ALTER TABLE dbo.aspnet_UsersInRoles
        ADD CONSTRAINT FK_UsersInRoles_Users FOREIGN KEY (UserId)
        REFERENCES dbo.aspnet_Users (UserId);
    PRINT 'Added FK_UsersInRoles_Users';
END

IF NOT EXISTS (
    SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_UsersInRoles_Roles'
)
BEGIN
    ALTER TABLE dbo.aspnet_UsersInRoles
        ADD CONSTRAINT FK_UsersInRoles_Roles FOREIGN KEY (RoleId)
        REFERENCES dbo.aspnet_Roles (RoleId);
    PRINT 'Added FK_UsersInRoles_Roles';
END

IF NOT EXISTS (
    SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_Profile_Users'
)
BEGIN
    ALTER TABLE dbo.aspnet_Profile
        ADD CONSTRAINT FK_Profile_Users FOREIGN KEY (UserId)
        REFERENCES dbo.aspnet_Users (UserId);
    PRINT 'Added FK_Profile_Users';
END
GO

/*------------------------------------------------------------
  Seed BalloonShop Application
-------------------------------------------------------------*/
IF NOT EXISTS (
    SELECT 1 FROM dbo.aspnet_Applications WHERE LoweredApplicationName = 'balloonshop'
)
BEGIN
    INSERT INTO dbo.aspnet_Applications (ApplicationName, LoweredApplicationName, Description)
    VALUES ('BalloonShop', 'balloonshop', 'BalloonShop Web Application');
    PRINT 'Inserted BalloonShop application record.';
END
ELSE
    PRINT 'BalloonShop application record already exists.';
GO

PRINT 'BalloonShop Membership schema setup completed successfully.';
GO
