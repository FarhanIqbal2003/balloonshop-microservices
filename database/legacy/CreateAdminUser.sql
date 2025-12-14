DECLARE @AppId UNIQUEIDENTIFIER;

-- Get or create the ApplicationId for '/'
SELECT @AppId = ApplicationId
FROM dbo.aspnet_Applications
WHERE LoweredApplicationName = '/';

IF @AppId IS NULL
BEGIN
    EXEC dbo.aspnet_Applications_CreateApplication
        @ApplicationName = N'/',
        @ApplicationId = @AppId OUTPUT;
END

-- Create the 'Customers' role if not exists
EXEC dbo.aspnet_Roles_CreateRole
    @ApplicationName = N'/',
    @RoleName = N'Customers';
GO

DECLARE @UserId UNIQUEIDENTIFIER = NEWID();
DECLARE @Now DATETIME = GETDATE();
DECLARE @Utc DATETIME = GETUTCDATE();

EXEC dbo.aspnet_Membership_CreateUser
    @ApplicationName = N'/',
    @UserName = N'admin',
    @Password = N'password',
    @PasswordSalt = N'',
    @Email = N'admin@balloonshop.com',
    @PasswordQuestion = NULL,
    @PasswordAnswer = NULL,
    @IsApproved = 1,
    @CurrentTimeUtc = @Utc,
    @CreateDate = @Now,
    @UniqueEmail = 0,
    @PasswordFormat = 0,
    @UserId = @UserId OUTPUT;
GO

IF NOT EXISTS (
    SELECT 1 FROM dbo.aspnet_Roles r
    JOIN dbo.aspnet_Applications a ON r.ApplicationId = a.ApplicationId
    WHERE r.RoleName = 'Administrators'
      AND a.LoweredApplicationName = '/'
)
BEGIN
    EXEC dbo.aspnet_Roles_CreateRole
        @ApplicationName = N'/',
        @RoleName = N'Administrators';
END

DECLARE @Utc DATETIME = GETUTCDATE();
IF NOT EXISTS (
    SELECT 1
    FROM dbo.aspnet_UsersInRoles ur
    JOIN dbo.aspnet_Users u ON ur.UserId = u.UserId
    JOIN dbo.aspnet_Roles r ON ur.RoleId = r.RoleId
    JOIN dbo.aspnet_Applications a ON u.ApplicationId = a.ApplicationId
    WHERE u.UserName = 'admin'
      AND r.RoleName = 'Administrators'
      AND a.LoweredApplicationName = '/'
)
BEGIN
    EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles
        @ApplicationName = N'/',
        @UserNames = N'admin',
        @RoleNames = N'Administrators',
        @CurrentTimeUtc = @Utc
END