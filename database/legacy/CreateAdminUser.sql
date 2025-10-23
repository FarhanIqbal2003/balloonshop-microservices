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


