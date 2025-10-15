/*------------------------------------------------------------
 CreateAdminUser.sql
 Creates a default 'admin' user with password 'password'
 and assigns it to the 'Administrators' role if it does not exist.

 Safe to run multiple times (idempotent).
-------------------------------------------------------------*/

USE [BalloonShop];
GO

/*------------------------------------------------------------
  Ensure Application exists
-------------------------------------------------------------*/
DECLARE @AppId UNIQUEIDENTIFIER;

SELECT @AppId = ApplicationId
FROM dbo.aspnet_Applications
WHERE LoweredApplicationName = 'balloonshop';

IF @AppId IS NULL
BEGIN
    INSERT INTO dbo.aspnet_Applications (ApplicationName, LoweredApplicationName, Description)
    VALUES ('BalloonShop', 'balloonshop', 'BalloonShop Web Application');
    SELECT @AppId = ApplicationId
    FROM dbo.aspnet_Applications
    WHERE LoweredApplicationName = 'balloonshop';
END

/*------------------------------------------------------------
  Ensure Administrators role exists
-------------------------------------------------------------*/
DECLARE @RoleId UNIQUEIDENTIFIER;

SELECT @RoleId = RoleId
FROM dbo.aspnet_Roles
WHERE ApplicationId = @AppId AND LoweredRoleName = 'administrators';

IF @RoleId IS NULL
BEGIN
    SET @RoleId = NEWID();
    INSERT INTO dbo.aspnet_Roles (ApplicationId, RoleId, RoleName, LoweredRoleName, Description)
    VALUES (@AppId, @RoleId, 'Administrators', 'administrators', 'Site administrators');
END

/*------------------------------------------------------------
  Ensure Admin user exists
-------------------------------------------------------------*/
DECLARE @UserId UNIQUEIDENTIFIER;

SELECT @UserId = UserId
FROM dbo.aspnet_Users
WHERE ApplicationId = @AppId AND LoweredUserName = 'admin';

IF @UserId IS NULL
BEGIN
    SET @UserId = NEWID();

    INSERT INTO dbo.aspnet_Users (ApplicationId, UserId, UserName, LoweredUserName, IsAnonymous, LastActivityDate)
    VALUES (@AppId, @UserId, 'admin', 'admin', 0, GETDATE());

    /*------------------------------------------------------------
      Create admin membership account (clear password = 'password')
      PasswordFormat = 0 means plaintext for legacy ASP.NET Membership.
    -------------------------------------------------------------*/
    INSERT INTO dbo.aspnet_Membership
    (ApplicationId, UserId, Password, PasswordFormat, PasswordSalt, Email, LoweredEmail, IsApproved, IsLockedOut, CreateDate, LastLoginDate, LastPasswordChangedDate, LastLockoutDate)
    VALUES
    (@AppId, @UserId, 'password', 0, '', 'admin@balloonshop.com', 'admin@balloonshop.com', 1, 0, GETDATE(), GETDATE(), GETDATE(), GETDATE());

    PRINT 'Admin user created: admin / password';
END
ELSE
BEGIN
    PRINT 'Admin user already exists. Skipping creation.';
END

/*------------------------------------------------------------
  Ensure Admin user is assigned to Administrators role
-------------------------------------------------------------*/
IF NOT EXISTS (
    SELECT 1 FROM dbo.aspnet_UsersInRoles
    WHERE UserId = @UserId AND RoleId = @RoleId
)
BEGIN
    INSERT INTO dbo.aspnet_UsersInRoles (UserId, RoleId)
    VALUES (@UserId, @RoleId);
    PRINT 'Admin user assigned to Administrators role.';
END
ELSE
BEGIN
    PRINT 'Admin user already in Administrators role.';
END

PRINT 'Setup completed successfully.';
GO
