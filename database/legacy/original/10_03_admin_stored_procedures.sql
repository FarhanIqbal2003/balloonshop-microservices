USE BalloonShop

GO
IF OBJECT_ID('OrdersGetByRecent', 'P') IS NOT NULL
    DROP PROCEDURE OrdersGetByRecent;
GO
CREATE PROCEDURE OrdersGetByRecent 
(@Count smallint)
AS
-- Set the number of rows to be returned
SET ROWCOUNT @Count
-- Get list of orders
SELECT OrderID, DateCreated, DateShipped, 
       Verified, Completed, Canceled, CustomerName
FROM Orders
ORDER BY DateCreated DESC
-- Reset rowcount value
SET ROWCOUNT 0

GO

IF OBJECT_ID('OrdersGetByDate', 'P') IS NOT NULL
    DROP PROCEDURE OrdersGetByDate;
GO
CREATE PROCEDURE OrdersGetByDate 
(@StartDate smalldatetime,
 @EndDate smalldatetime)
AS
SELECT OrderID, DateCreated, DateShipped, 
       Verified, Completed, Canceled, CustomerName
FROM Orders
WHERE DateCreated BETWEEN @StartDate AND @EndDate
ORDER BY DateCreated DESC

GO

IF OBJECT_ID('OrdersGetUnverifiedUncanceled', 'P') IS NOT NULL
    DROP PROCEDURE OrdersGetUnverifiedUncanceled;
GO
CREATE PROCEDURE OrdersGetUnverifiedUncanceled
AS
SELECT OrderID, DateCreated, DateShipped, 
       Verified, Completed, Canceled, CustomerName
FROM Orders
WHERE Verified=0 AND Canceled=0
ORDER BY DateCreated DESC

GO

IF OBJECT_ID('OrdersGetVerifiedUncompleted', 'P') IS NOT NULL
    DROP PROCEDURE OrdersGetVerifiedUncompleted;
GO
CREATE PROCEDURE OrdersGetVerifiedUncompleted
AS
SELECT OrderID, DateCreated, DateShipped, 
       Verified, Completed, Canceled, CustomerName
FROM Orders
WHERE Verified=1 AND Completed=0
ORDER BY DateCreated DESC
