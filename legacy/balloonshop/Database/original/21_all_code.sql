USE BalloonShop

GO

-- Create review table
CREATE TABLE Review (
  ReviewID INT NOT NULL PRIMARY KEY IDENTITY(1,1),
  CustomerID UNIQUEIDENTIFIER NOT NULL,
  ProductID INT NOT NULL,
  Review NVARCHAR(MAX) NOT NULL,
  Rating SMALLINT NOT NULL,
  DateCreated DATETIME NOT NULL)

GO

-- Create CatalogGetProductReviews stored procedure
CREATE PROCEDURE CatalogGetProductReviews(@ProductID INT)
AS
SELECT u.UserName as Name, r.Review, r.Rating, r.DateCreated
FROM Review r
INNER JOIN aspnet_Users u ON u.UserID = r.CustomerID
WHERE r.ProductID = @ProductID
ORDER BY r.DateCreated DESC

GO

-- Create CatalogCreateProductReview stored procedure
CREATE PROCEDURE CatalogCreateProductReview
(@CustomerId UNIQUEIDENTIFIER, @ProductId INT, @Review TEXT, @Rating SMALLINT)
AS
INSERT INTO Review (CustomerID, ProductID, Review, Rating, DateCreated)
   VALUES (@CustomerId, @ProductId, @Review, @Rating, GETDATE())

GO

