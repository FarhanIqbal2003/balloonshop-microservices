-- BalloonShop schema and stored procedure stubs
-- Generated from code analysis (inferred columns & procedures)
-- Date: 2025-10-14
-- NOTE: This is a best-effort scaffold. Review and adjust datatypes, lengths
-- and the stored-procedure logic to match original business rules.

-- Create database if it doesn't exist
IF DB_ID(N'BalloonShop') IS NULL
BEGIN
    CREATE DATABASE BalloonShop;
END
GO

USE BalloonShop;
GO

-- =========================
-- Tables
-- =========================

IF OBJECT_ID('dbo.Departments', 'U') IS NULL
CREATE TABLE dbo.Departments (
    DepartmentID INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    Description NVARCHAR(2000) NULL
);
GO

IF OBJECT_ID('dbo.Categories', 'U') IS NULL
CREATE TABLE dbo.Categories (
    CategoryID INT IDENTITY(1,1) PRIMARY KEY,
    DepartmentID INT NOT NULL,
    Name NVARCHAR(100) NOT NULL,
    Description NVARCHAR(2000) NULL,
    CONSTRAINT FK_Categories_Departments FOREIGN KEY(DepartmentID) REFERENCES dbo.Departments(DepartmentID)
);
GO

IF OBJECT_ID('dbo.Products', 'U') IS NULL
CREATE TABLE dbo.Products (
    ProductID INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(200) NOT NULL,
    Description NVARCHAR(MAX) NULL,
    Price DECIMAL(18,2) NOT NULL DEFAULT(0),
    Thumbnail NVARCHAR(256) NULL DEFAULT('GenericThumb.png'),
    Image NVARCHAR(256) NULL DEFAULT('GenericImage.png'),
    PromoFront BIT NOT NULL DEFAULT(0),
    PromoDept BIT NOT NULL DEFAULT(0)
);
GO

IF OBJECT_ID('dbo.ProductCategories', 'U') IS NULL
CREATE TABLE dbo.ProductCategories (
    ProductID INT NOT NULL,
    CategoryID INT NOT NULL,
    CONSTRAINT PK_ProductCategories PRIMARY KEY(ProductID, CategoryID),
    CONSTRAINT FK_ProductCategories_Products FOREIGN KEY(ProductID) REFERENCES dbo.Products(ProductID),
    CONSTRAINT FK_ProductCategories_Categories FOREIGN KEY(CategoryID) REFERENCES dbo.Categories(CategoryID)
);
GO

IF OBJECT_ID('dbo.ProductAttributes', 'U') IS NULL
CREATE TABLE dbo.ProductAttributes (
    AttributeID INT IDENTITY(1,1) PRIMARY KEY,
    ProductID INT NOT NULL,
    AttributeName NVARCHAR(200) NOT NULL,
    CONSTRAINT FK_ProductAttributes_Products FOREIGN KEY(ProductID) REFERENCES dbo.Products(ProductID)
);
GO

-- Add new table for attribute values (normalized)
IF OBJECT_ID('dbo.ProductAttributeValues', 'U') IS NULL
CREATE TABLE dbo.ProductAttributeValues (
    AttributeValueID INT IDENTITY(1,1) PRIMARY KEY,
    AttributeID INT NOT NULL,
    AttributeValue NVARCHAR(1000) NOT NULL,
    CONSTRAINT FK_ProductAttributeValues_ProductAttributes FOREIGN KEY(AttributeID) REFERENCES dbo.ProductAttributes(AttributeID)
);
GO

-- Shipping regions used by CustomerDetailsEdit.ascx
IF OBJECT_ID('dbo.ShippingRegion', 'U') IS NULL
CREATE TABLE dbo.ShippingRegion (
    ShippingRegionID INT IDENTITY(1,1) PRIMARY KEY,
    ShippingRegion NVARCHAR(200) NOT NULL
);
GO

IF OBJECT_ID('dbo.Shipping', 'U') IS NULL
CREATE TABLE dbo.Shipping (
    ShippingID INT IDENTITY(1,1) PRIMARY KEY,
    ShippingType NVARCHAR(200) NOT NULL,
    ShippingCost DECIMAL(18,2) NOT NULL DEFAULT(0),
    ShippingRegionId INT NULL,
    CONSTRAINT FK_Shipping_ShippingRegion FOREIGN KEY(ShippingRegionId) REFERENCES dbo.ShippingRegion(ShippingRegionID)
);
GO

IF OBJECT_ID('dbo.Tax', 'U') IS NULL
CREATE TABLE dbo.Tax (
    TaxID INT IDENTITY(1,1) PRIMARY KEY,
    TaxType NVARCHAR(200) NOT NULL,
    TaxPercentage DECIMAL(5,2) NOT NULL DEFAULT(0)
);
GO

IF OBJECT_ID('dbo.ShoppingCartItems', 'U') IS NULL
CREATE TABLE dbo.ShoppingCartItems (
    CartID NVARCHAR(36) NOT NULL,
    ProductID INT NOT NULL,
    Attributes NVARCHAR(1000) NULL,
    Quantity INT NOT NULL DEFAULT(1),
    DateCreated DATETIME NOT NULL DEFAULT(GETDATE()),
    CONSTRAINT PK_ShoppingCartItems PRIMARY KEY(CartID, ProductID)
);
GO

IF OBJECT_ID('dbo.Orders', 'U') IS NULL
CREATE TABLE dbo.Orders (
    OrderID INT IDENTITY(1,1) PRIMARY KEY,
    TotalAmount DECIMAL(18,2) NOT NULL DEFAULT(0),
    DateCreated DATETIME NOT NULL DEFAULT(GETDATE()),
    DateShipped DATETIME NULL,
    Verified BIT NOT NULL DEFAULT(0),
    Completed BIT NOT NULL DEFAULT(0),
    Canceled BIT NOT NULL DEFAULT(0),
    Comments NVARCHAR(2000) NULL,
    CustomerName NVARCHAR(200) NULL,
    ShippingAddress NVARCHAR(2000) NULL,
    CustomerEmail NVARCHAR(200) NULL,
    CustomerID UNIQUEIDENTIFIER NULL,
    ShippingID INT NULL,
    TaxID INT NULL,
    Status INT NULL,
    AuthCode NVARCHAR(50) NULL,
    Reference NVARCHAR(50) NULL,
    CONSTRAINT FK_Orders_Shipping FOREIGN KEY(ShippingID) REFERENCES dbo.Shipping(ShippingID),
    CONSTRAINT FK_Orders_Tax FOREIGN KEY(TaxID) REFERENCES dbo.Tax(TaxID)
);
GO

IF OBJECT_ID('dbo.OrderDetails', 'U') IS NULL
CREATE TABLE dbo.OrderDetails (
    OrderDetailID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT NOT NULL,
    ProductID INT NULL,
    ProductName NVARCHAR(200) NULL,
    Quantity INT NOT NULL DEFAULT(1),
    UnitCost DECIMAL(18,2) NOT NULL DEFAULT(0),
    CONSTRAINT FK_OrderDetails_Orders FOREIGN KEY(OrderID) REFERENCES dbo.Orders(OrderID)
);
GO

IF OBJECT_ID('dbo.Audit', 'U') IS NULL
CREATE TABLE dbo.Audit (
    AuditID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT NOT NULL,
    DateStamp DATETIME NOT NULL DEFAULT(GETDATE()),
    Message NVARCHAR(512) NULL,
    MessageNumber INT NULL,
    CONSTRAINT FK_Audit_Orders FOREIGN KEY(OrderID) REFERENCES dbo.Orders(OrderID)
);
GO

-- =========================
-- Stored procedure stubs (basic implementations)
-- Procedures return columns expected by the application. Enhance logic as needed.
-- =========================

-- Catalog: departments
IF OBJECT_ID('dbo.CatalogGetDepartments', 'P') IS NOT NULL
    DROP PROCEDURE dbo.CatalogGetDepartments;
GO
CREATE PROCEDURE dbo.CatalogGetDepartments
AS
BEGIN
    SET NOCOUNT ON;
    SELECT DepartmentID, Name, Description FROM dbo.Departments ORDER BY Name;
END
GO

IF OBJECT_ID('dbo.CatalogGetDepartmentDetails', 'P') IS NOT NULL
    DROP PROCEDURE dbo.CatalogGetDepartmentDetails;
GO
CREATE PROCEDURE dbo.CatalogGetDepartmentDetails
    @DepartmentID INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT Name, Description FROM dbo.Departments WHERE DepartmentID = @DepartmentID;
END
GO

IF OBJECT_ID('dbo.CatalogGetCategoryDetails', 'P') IS NOT NULL
    DROP PROCEDURE dbo.CatalogGetCategoryDetails;
GO
CREATE PROCEDURE dbo.CatalogGetCategoryDetails
    @CategoryID INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT DepartmentID AS DepartmentID, Name, Description FROM dbo.Categories WHERE CategoryID = @CategoryID;
END
GO

IF OBJECT_ID('dbo.CatalogGetProductDetails', 'P') IS NOT NULL
    DROP PROCEDURE dbo.CatalogGetProductDetails;
GO
CREATE PROCEDURE dbo.CatalogGetProductDetails
    @ProductID INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT ProductID, Name, Description, Price, Thumbnail, Image, PromoFront, PromoDept FROM dbo.Products WHERE ProductID = @ProductID;
END
GO

IF OBJECT_ID('dbo.CatalogGetCategoriesInDepartment', 'P') IS NOT NULL
    DROP PROCEDURE dbo.CatalogGetCategoriesInDepartment;
GO
CREATE PROCEDURE dbo.CatalogGetCategoriesInDepartment
    @DepartmentID INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT CategoryID, Name, Description FROM dbo.Categories WHERE DepartmentID = @DepartmentID ORDER BY Name;
END
GO

-- Basic paged product lists for promotions and category listing
IF OBJECT_ID('dbo.CatalogGetProductsOnFrontPromo', 'P') IS NOT NULL
    DROP PROCEDURE dbo.CatalogGetProductsOnFrontPromo;
GO
CREATE PROCEDURE dbo.CatalogGetProductsOnFrontPromo
    @DescriptionLength INT,
    @PageNumber INT,
    @ProductsPerPage INT,
    @HowManyProducts INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT @HowManyProducts = COUNT(*) FROM dbo.Products WHERE PromoFront = 1;

    ;WITH Paged AS (
      SELECT ProductID, Name, Description, Price, Thumbnail, Image, PromoFront, PromoDept,
        ROW_NUMBER() OVER (ORDER BY ProductID) AS rn
      FROM dbo.Products WHERE PromoFront = 1
    )
    SELECT ProductID, Name, LEFT(Description, @DescriptionLength) AS Description, Price, Thumbnail, Image, PromoFront, PromoDept
    FROM Paged
    WHERE rn BETWEEN ((@PageNumber - 1) * @ProductsPerPage) + 1 AND @PageNumber * @ProductsPerPage
    ORDER BY rn;
END
GO

IF OBJECT_ID('dbo.CatalogGetProductsOnDeptPromo', 'P') IS NOT NULL
    DROP PROCEDURE dbo.CatalogGetProductsOnDeptPromo;
GO
CREATE PROCEDURE dbo.CatalogGetProductsOnDeptPromo
    @DepartmentID INT,
    @DescriptionLength INT,
    @PageNumber INT,
    @ProductsPerPage INT,
    @HowManyProducts INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT @HowManyProducts = COUNT(*)
    FROM dbo.Products p
    JOIN dbo.ProductCategories pc ON p.ProductID = pc.ProductID
    JOIN dbo.Categories c ON pc.CategoryID = c.CategoryID
    WHERE c.DepartmentID = @DepartmentID AND p.PromoDept = 1;

    ;WITH DeptProducts AS (
      SELECT DISTINCT p.ProductID, p.Name, p.Description, p.Price, p.Thumbnail, p.Image, p.PromoFront, p.PromoDept,
        ROW_NUMBER() OVER (ORDER BY p.ProductID) AS rn
      FROM dbo.Products p
      JOIN dbo.ProductCategories pc ON p.ProductID = pc.ProductID
      JOIN dbo.Categories c ON pc.CategoryID = c.CategoryID
      WHERE c.DepartmentID = @DepartmentID AND p.PromoDept = 1
    )
    SELECT ProductID, Name, LEFT(Description, @DescriptionLength) AS Description, Price, Thumbnail, Image, PromoFront, PromoDept
    FROM DeptProducts
    WHERE rn BETWEEN ((@PageNumber - 1) * @ProductsPerPage) + 1 AND @PageNumber * @ProductsPerPage
    ORDER BY rn;
END
GO

IF OBJECT_ID('dbo.CatalogGetProductsInCategory', 'P') IS NOT NULL
    DROP PROCEDURE dbo.CatalogGetProductsInCategory;
GO
CREATE PROCEDURE dbo.CatalogGetProductsInCategory
    @CategoryID INT,
    @DescriptionLength INT,
    @PageNumber INT,
    @ProductsPerPage INT,
    @HowManyProducts INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT @HowManyProducts = COUNT(*)
    FROM dbo.ProductCategories pc
    JOIN dbo.Products p ON pc.ProductID = p.ProductID
    WHERE pc.CategoryID = @CategoryID;

    ;WITH CatProducts AS (
      SELECT p.ProductID, p.Name, p.Description, p.Price, p.Thumbnail, p.Image, p.PromoFront, p.PromoDept,
        ROW_NUMBER() OVER (ORDER BY p.ProductID) AS rn
      FROM dbo.ProductCategories pc
      JOIN dbo.Products p ON pc.ProductID = p.ProductID
      WHERE pc.CategoryID = @CategoryID
    )
    SELECT ProductID, Name, LEFT(Description, @DescriptionLength) AS Description, Price, Thumbnail, Image, PromoFront, PromoDept
    FROM CatProducts
    WHERE rn BETWEEN ((@PageNumber - 1) * @ProductsPerPage) + 1 AND @PageNumber * @ProductsPerPage
    ORDER BY rn;
END
GO

IF OBJECT_ID('dbo.CatalogGetProductAttributeValues', 'P') IS NOT NULL
    DROP PROCEDURE dbo.CatalogGetProductAttributeValues;
GO
CREATE PROCEDURE dbo.CatalogGetProductAttributeValues
    @ProductID INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT 
        pa.AttributeID,
        pav.AttributeValueID,
        pa.ProductID,
        pa.AttributeName,
        pav.AttributeValue
    FROM dbo.ProductAttributes pa
    JOIN dbo.ProductAttributeValues pav ON pa.AttributeID = pav.AttributeID
    WHERE pa.ProductID = @ProductID;
END
GO

-- SearchCatalog: basic keyword matching on Name and Description
IF OBJECT_ID('dbo.SearchCatalog', 'P') IS NOT NULL
    DROP PROCEDURE dbo.SearchCatalog;
GO
CREATE PROCEDURE dbo.SearchCatalog
    @DescriptionLength INT,
    @AllWords TINYINT,
    @PageNumber INT,
    @ProductsPerPage INT,
    @HowManyResults INT OUTPUT,
    @Word1 NVARCHAR(100) = NULL,
    @Word2 NVARCHAR(100) = NULL,
    @Word3 NVARCHAR(100) = NULL,
    @Word4 NVARCHAR(100) = NULL,
    @Word5 NVARCHAR(100) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- Build a simple search on Name/Description using LIKE. For production use full-text.
    ;WITH SearchTerms AS (
      SELECT COALESCE(@Word1,'') AS w UNION ALL
      SELECT COALESCE(@Word2,'') UNION ALL
      SELECT COALESCE(@Word3,'') UNION ALL
      SELECT COALESCE(@Word4,'') UNION ALL
      SELECT COALESCE(@Word5,'')
    )

    , FilteredProducts AS (
      SELECT p.ProductID, p.Name, p.Description, p.Price, p.Thumbnail, p.Image,
        ROW_NUMBER() OVER (ORDER BY p.ProductID) AS rn
      FROM dbo.Products p
      WHERE (
        (@Word1 IS NULL OR @Word1 = '')
        OR (p.Name LIKE '%' + @Word1 + '%' OR p.Description LIKE '%' + @Word1 + '%')
        OR ( @Word2 IS NOT NULL AND (p.Name LIKE '%' + @Word2 + '%' OR p.Description LIKE '%' + @Word2 + '%'))
        OR ( @Word3 IS NOT NULL AND (p.Name LIKE '%' + @Word3 + '%' OR p.Description LIKE '%' + @Word3 + '%'))
        OR ( @Word4 IS NOT NULL AND (p.Name LIKE '%' + @Word4 + '%' OR p.Description LIKE '%' + @Word4 + '%'))
        OR ( @Word5 IS NOT NULL AND (p.Name LIKE '%' + @Word5 + '%' OR p.Description LIKE '%' + @Word5 + '%'))
      )
    )
    SELECT @HowManyResults = (SELECT COUNT(*) FROM FilteredProducts);

    SELECT ProductID, Name, LEFT(Description, @DescriptionLength) AS Description, Price, Thumbnail, Image
    FROM FilteredProducts
    WHERE rn BETWEEN ((@PageNumber - 1) * @ProductsPerPage) + 1 AND @PageNumber * @ProductsPerPage
    ORDER BY rn;
END
GO

-- Catalog CRUD stubs (Add/Update/Delete)
IF OBJECT_ID('dbo.CatalogUpdateDepartment', 'P') IS NOT NULL
    DROP PROCEDURE dbo.CatalogUpdateDepartment;
GO
CREATE PROCEDURE dbo.CatalogUpdateDepartment
    @DepartmentId INT,
    @DepartmentName NVARCHAR(100),
    @DepartmentDescription NVARCHAR(2000)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.Departments SET Name = @DepartmentName, Description = @DepartmentDescription WHERE DepartmentID = @DepartmentId;
    SELECT @@ROWCOUNT;
END
GO

IF OBJECT_ID('dbo.CatalogDeleteDepartment', 'P') IS NOT NULL
    DROP PROCEDURE dbo.CatalogDeleteDepartment;
GO
CREATE PROCEDURE dbo.CatalogDeleteDepartment
    @DepartmentId INT
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM dbo.Departments WHERE DepartmentID = @DepartmentId;
    SELECT @@ROWCOUNT;
END
GO

IF OBJECT_ID('dbo.CatalogAddDepartment', 'P') IS NOT NULL
    DROP PROCEDURE dbo.CatalogAddDepartment;
GO
CREATE PROCEDURE dbo.CatalogAddDepartment
    @DepartmentName NVARCHAR(100),
    @DepartmentDescription NVARCHAR(2000)
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO dbo.Departments(Name, Description) VALUES(@DepartmentName, @DepartmentDescription);
    SELECT SCOPE_IDENTITY() AS DepartmentID;
END
GO

-- Category CRUD
IF OBJECT_ID('dbo.CatalogCreateCategory', 'P') IS NOT NULL
    DROP PROCEDURE dbo.CatalogCreateCategory;
GO
CREATE PROCEDURE dbo.CatalogCreateCategory
    @DepartmentID INT,
    @CategoryName NVARCHAR(100),
    @CategoryDescription NVARCHAR(2000)
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO dbo.Categories(DepartmentID, Name, Description) VALUES(@DepartmentID, @CategoryName, @CategoryDescription);
    SELECT SCOPE_IDENTITY() AS CategoryID;
END
GO

IF OBJECT_ID('dbo.CatalogUpdateCategory', 'P') IS NOT NULL
    DROP PROCEDURE dbo.CatalogUpdateCategory;
GO
CREATE PROCEDURE dbo.CatalogUpdateCategory
    @CategoryId INT,
    @CategoryName NVARCHAR(100),
    @CategoryDescription NVARCHAR(2000)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.Categories SET Name = @CategoryName, Description = @CategoryDescription WHERE CategoryID = @CategoryId;
    SELECT @@ROWCOUNT;
END
GO

IF OBJECT_ID('dbo.CatalogDeleteCategory', 'P') IS NOT NULL
    DROP PROCEDURE dbo.CatalogDeleteCategory;
GO
CREATE PROCEDURE dbo.CatalogDeleteCategory
    @CategoryId INT
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM dbo.Categories WHERE CategoryID = @CategoryId;
    SELECT @@ROWCOUNT;
END
GO

-- Product CRUD (basic)
IF OBJECT_ID('dbo.CatalogCreateProduct', 'P') IS NOT NULL
    DROP PROCEDURE dbo.CatalogCreateProduct;
GO
CREATE PROCEDURE dbo.CatalogCreateProduct
    @CategoryID INT,
    @ProductName NVARCHAR(200),
    @ProductDescription NVARCHAR(MAX),
    @Price DECIMAL(18,2),
    @Thumbnail NVARCHAR(256),
    @Image NVARCHAR(256),
    @PromoDept BIT,
    @PromoFront BIT
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO dbo.Products(Name, Description, Price, Thumbnail, Image, PromoDept, PromoFront)
    VALUES(@ProductName, @ProductDescription, @Price, @Thumbnail, @Image, @PromoDept, @PromoFront);
    DECLARE @pid INT = SCOPE_IDENTITY();
    -- assign to category
    IF @CategoryID IS NOT NULL AND @CategoryID > 0
    BEGIN
        INSERT INTO dbo.ProductCategories(ProductID, CategoryID) VALUES(@pid, @CategoryID);
    END
    SELECT @pid AS ProductID;
END
GO

IF OBJECT_ID('dbo.CatalogUpdateProduct', 'P') IS NOT NULL
    DROP PROCEDURE dbo.CatalogUpdateProduct;
GO
CREATE PROCEDURE dbo.CatalogUpdateProduct
    @ProductID INT,
    @ProductName NVARCHAR(200),
    @ProductDescription NVARCHAR(MAX),
    @Price DECIMAL(18,2),
    @Thumbnail NVARCHAR(256),
    @Image NVARCHAR(256),
    @PromoDept BIT,
    @PromoFront BIT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.Products SET Name=@ProductName, Description=@ProductDescription, Price=@Price,
        Thumbnail=@Thumbnail, Image=@Image, PromoDept=@PromoDept, PromoFront=@PromoFront
    WHERE ProductID = @ProductID;
    SELECT @@ROWCOUNT;
END
GO

IF OBJECT_ID('dbo.CatalogDeleteProduct', 'P') IS NOT NULL
    DROP PROCEDURE dbo.CatalogDeleteProduct;
GO
CREATE PROCEDURE dbo.CatalogDeleteProduct
    @ProductID INT
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM dbo.ProductCategories WHERE ProductID = @ProductID;
    DELETE FROM dbo.ProductAttributes WHERE ProductID = @ProductID;
    DELETE FROM dbo.Products WHERE ProductID = @ProductID;
    SELECT @@ROWCOUNT;
END
GO

-- Product <-> category helpers
IF OBJECT_ID('dbo.CatalogGetCategoriesWithProduct','P') IS NOT NULL
    DROP PROCEDURE dbo.CatalogGetCategoriesWithProduct;
GO
CREATE PROCEDURE dbo.CatalogGetCategoriesWithProduct
    @ProductID INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT c.CategoryID, c.Name FROM dbo.Categories c
    JOIN dbo.ProductCategories pc ON c.CategoryID = pc.CategoryID
    WHERE pc.ProductID = @ProductID;
END
GO

IF OBJECT_ID('dbo.CatalogGetCategoriesWithoutProduct','P') IS NOT NULL
    DROP PROCEDURE dbo.CatalogGetCategoriesWithoutProduct;
GO
CREATE PROCEDURE dbo.CatalogGetCategoriesWithoutProduct
    @ProductID INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT CategoryID, Name FROM dbo.Categories WHERE CategoryID NOT IN (
        SELECT CategoryID FROM dbo.ProductCategories WHERE ProductID = @ProductID
    );
END
GO

IF OBJECT_ID('dbo.CatalogAssignProductToCategory','P') IS NOT NULL
    DROP PROCEDURE dbo.CatalogAssignProductToCategory;
GO
CREATE PROCEDURE dbo.CatalogAssignProductToCategory
    @ProductID INT,
    @CategoryID INT
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS(SELECT 1 FROM dbo.ProductCategories WHERE ProductID=@ProductID AND CategoryID=@CategoryID)
        INSERT INTO dbo.ProductCategories(ProductID, CategoryID) VALUES(@ProductID, @CategoryID);
    SELECT @@ROWCOUNT;
END
GO

IF OBJECT_ID('dbo.CatalogMoveProductToCategory','P') IS NOT NULL
    DROP PROCEDURE dbo.CatalogMoveProductToCategory;
GO
CREATE PROCEDURE dbo.CatalogMoveProductToCategory
    @ProductID INT,
    @OldCategoryID INT,
    @NewCategoryID INT
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM dbo.ProductCategories WHERE ProductID=@ProductID AND CategoryID=@OldCategoryID;
    IF NOT EXISTS(SELECT 1 FROM dbo.ProductCategories WHERE ProductID=@ProductID AND CategoryID=@NewCategoryID)
        INSERT INTO dbo.ProductCategories(ProductID, CategoryID) VALUES(@ProductID, @NewCategoryID);
    SELECT @@ROWCOUNT;
END
GO

IF OBJECT_ID('dbo.CatalogRemoveProductFromCategory','P') IS NOT NULL
    DROP PROCEDURE dbo.CatalogRemoveProductFromCategory;
GO
CREATE PROCEDURE dbo.CatalogRemoveProductFromCategory
    @ProductID INT,
    @CategoryID INT
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM dbo.ProductCategories WHERE ProductID=@ProductID AND CategoryID=@CategoryID;
    SELECT @@ROWCOUNT;
END
GO

-- Product reviews (simple append)
IF OBJECT_ID('dbo.CatalogGetProductReviews','P') IS NOT NULL
    DROP PROCEDURE dbo.CatalogGetProductReviews;
GO
CREATE PROCEDURE dbo.CatalogGetProductReviews
    @ProductID INT
AS
BEGIN
    SET NOCOUNT ON;
    -- Get reviews from normalized attributes structure
    SELECT 
        pa.AttributeID,
        pa.ProductID,
        pa.AttributeName,
        pav.AttributeValue
    FROM dbo.ProductAttributes pa
    JOIN dbo.ProductAttributeValues pav ON pa.AttributeID = pav.AttributeID
    WHERE pa.ProductID = @ProductID AND pa.AttributeName LIKE '%Review%';
END
GO

IF OBJECT_ID('dbo.CatalogAddProductReview','P') IS NOT NULL
    DROP PROCEDURE dbo.CatalogAddProductReview;
GO
CREATE PROCEDURE dbo.CatalogAddProductReview
    @CustomerID NVARCHAR(100),
    @ProductID INT,
    @Review NVARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO dbo.ProductAttributes(ProductID, AttributeName, AttributeValue) VALUES(@ProductID, 'Review', @Review);
    SELECT SCOPE_IDENTITY() AS AttributeID;
END
GO

-- =========================
-- Shopping cart & order procedures
-- =========================
IF OBJECT_ID('dbo.ShoppingCartAddItem','P') IS NOT NULL
    DROP PROCEDURE dbo.ShoppingCartAddItem;
GO
CREATE PROCEDURE dbo.ShoppingCartAddItem
    @CartID NVARCHAR(36),
    @ProductID INT,
    @Attributes NVARCHAR(1000)
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS(SELECT 1 FROM dbo.ShoppingCartItems WHERE CartID=@CartID AND ProductID=@ProductID)
        UPDATE dbo.ShoppingCartItems SET Attributes=@Attributes, Quantity = Quantity + 1 WHERE CartID=@CartID AND ProductID=@ProductID;
    ELSE
        INSERT INTO dbo.ShoppingCartItems(CartID, ProductID, Attributes, Quantity) VALUES(@CartID, @ProductID, @Attributes, 1);
    SELECT @@ROWCOUNT;
END
GO

IF OBJECT_ID('dbo.ShoppingCartUpdateItem','P') IS NOT NULL
    DROP PROCEDURE dbo.ShoppingCartUpdateItem;
GO
CREATE PROCEDURE dbo.ShoppingCartUpdateItem
    @CartID NVARCHAR(36),
    @ProductID INT,
    @Quantity INT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.ShoppingCartItems SET Quantity = @Quantity WHERE CartID=@CartID AND ProductID=@ProductID;
    SELECT @@ROWCOUNT;
END
GO

IF OBJECT_ID('dbo.ShoppingCartRemoveItem','P') IS NOT NULL
    DROP PROCEDURE dbo.ShoppingCartRemoveItem;
GO
CREATE PROCEDURE dbo.ShoppingCartRemoveItem
    @CartID NVARCHAR(36),
    @ProductID INT
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM dbo.ShoppingCartItems WHERE CartID=@CartID AND ProductID=@ProductID;
    SELECT @@ROWCOUNT;
END
GO

IF OBJECT_ID('dbo.ShoppingCartGetItems','P') IS NOT NULL
    DROP PROCEDURE dbo.ShoppingCartGetItems;
GO
CREATE PROCEDURE dbo.ShoppingCartGetItems
    @CartID NVARCHAR(36)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT sci.CartID, sci.ProductID, p.Name AS ProductName, sci.Attributes, sci.Quantity
    FROM dbo.ShoppingCartItems sci
    LEFT JOIN dbo.Products p ON sci.ProductID = p.ProductID
    WHERE sci.CartID = @CartID;
END
GO

IF OBJECT_ID('dbo.ShoppingCartGetTotalAmount','P') IS NOT NULL
    DROP PROCEDURE dbo.ShoppingCartGetTotalAmount;
GO
CREATE PROCEDURE dbo.ShoppingCartGetTotalAmount
    @CartID NVARCHAR(36)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT SUM(ISNULL(p.Price,0) * sci.Quantity) AS TotalAmount
    FROM dbo.ShoppingCartItems sci
    LEFT JOIN dbo.Products p ON sci.ProductID = p.ProductID
    WHERE sci.CartID = @CartID;
END
GO

IF OBJECT_ID('dbo.ShoppingCartCountOldCarts','P') IS NOT NULL
    DROP PROCEDURE dbo.ShoppingCartCountOldCarts;
GO
CREATE PROCEDURE dbo.ShoppingCartCountOldCarts
    @Days TINYINT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT COUNT(DISTINCT CartID) FROM dbo.ShoppingCartItems WHERE DateCreated < DATEADD(DAY, -@Days, GETDATE());
END
GO

IF OBJECT_ID('dbo.ShoppingCartDeleteOldCarts','P') IS NOT NULL
    DROP PROCEDURE dbo.ShoppingCartDeleteOldCarts;
GO
CREATE PROCEDURE dbo.ShoppingCartDeleteOldCarts
    @Days TINYINT
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM dbo.ShoppingCartItems WHERE DateCreated < DATEADD(DAY, -@Days, GETDATE());
    SELECT @@ROWCOUNT;
END
GO

-- CreateOrder: create Orders from ShoppingCart (basic)
IF OBJECT_ID('dbo.CreateOrder','P') IS NOT NULL
    DROP PROCEDURE dbo.CreateOrder;
GO
CREATE PROCEDURE dbo.CreateOrder
    @CartID NVARCHAR(36)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Total DECIMAL(18,2);
    SELECT @Total = SUM(ISNULL(p.Price,0) * sci.Quantity) FROM dbo.ShoppingCartItems sci LEFT JOIN dbo.Products p ON sci.ProductID = p.ProductID WHERE sci.CartID = @CartID;
    INSERT INTO dbo.Orders(TotalAmount, DateCreated) VALUES(ISNULL(@Total,0), GETDATE());
    DECLARE @NewOrderID INT = SCOPE_IDENTITY();
    INSERT INTO dbo.OrderDetails(OrderID, ProductID, ProductName, Quantity, UnitCost)
    SELECT @NewOrderID, sci.ProductID, p.Name, sci.Quantity, ISNULL(p.Price,0)
    FROM dbo.ShoppingCartItems sci LEFT JOIN dbo.Products p ON sci.ProductID = p.ProductID
    WHERE sci.CartID = @CartID;
    -- optional: clear cart
    DELETE FROM dbo.ShoppingCartItems WHERE CartID = @CartID;
    SELECT @NewOrderID AS OrderID;
END
GO

IF OBJECT_ID('dbo.CreateCustomerOrder','P') IS NOT NULL
    DROP PROCEDURE dbo.CreateCustomerOrder;
GO
CREATE PROCEDURE dbo.CreateCustomerOrder
    @CartID NVARCHAR(36),
    @CustomerId UNIQUEIDENTIFIER,
    @ShippingId INT,
    @TaxId INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Total DECIMAL(18,2);
    SELECT @Total = SUM(ISNULL(p.Price,0) * sci.Quantity) FROM dbo.ShoppingCartItems sci LEFT JOIN dbo.Products p ON sci.ProductID = p.ProductID WHERE sci.CartID = @CartID;
    INSERT INTO dbo.Orders(TotalAmount, DateCreated, CustomerID, ShippingID, TaxID) VALUES(ISNULL(@Total,0), GETDATE(), @CustomerId, @ShippingId, @TaxId);
    DECLARE @NewOrderID INT = SCOPE_IDENTITY();
    INSERT INTO dbo.OrderDetails(OrderID, ProductID, ProductName, Quantity, UnitCost)
    SELECT @NewOrderID, sci.ProductID, p.Name, sci.Quantity, ISNULL(p.Price,0)
    FROM dbo.ShoppingCartItems sci LEFT JOIN dbo.Products p ON sci.ProductID = p.ProductID
    WHERE sci.CartID = @CartID;
    DELETE FROM dbo.ShoppingCartItems WHERE CartID = @CartID;
    SELECT @NewOrderID AS OrderID;
END
GO

-- Catalog recommendations for cart (simple placeholder)
IF OBJECT_ID('dbo.CatalogGetCartRecommendations','P') IS NOT NULL
    DROP PROCEDURE dbo.CatalogGetCartRecommendations;
GO
CREATE PROCEDURE dbo.CatalogGetCartRecommendations
    @CartID NVARCHAR(36),
    @DescriptionLength INT
AS
BEGIN
    SET NOCOUNT ON;
    -- Return products from same categories as items in cart (simple example)
    SELECT DISTINCT p.ProductID, p.Name, LEFT(p.Description, @DescriptionLength) AS Description, p.Price, p.Thumbnail, p.Image
    FROM dbo.ShoppingCartItems sci
    JOIN dbo.ProductCategories pc ON sci.ProductID = pc.ProductID
    JOIN dbo.ProductCategories pc2 ON pc.CategoryID = pc2.CategoryID
    JOIN dbo.Products p ON pc2.ProductID = p.ProductID
    WHERE sci.CartID = @CartID AND p.ProductID NOT IN (SELECT ProductID FROM dbo.ShoppingCartItems WHERE CartID = @CartID);
END
GO

-- =========================
-- Orders access procedures
-- =========================
IF OBJECT_ID('dbo.OrdersGetByRecent','P') IS NOT NULL
    DROP PROCEDURE dbo.OrdersGetByRecent;
GO
CREATE PROCEDURE dbo.OrdersGetByRecent
    @Count INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT TOP(@Count) OrderID, TotalAmount, DateCreated, DateShipped, Status, CustomerName FROM dbo.Orders ORDER BY DateCreated DESC;
END
GO

IF OBJECT_ID('dbo.OrdersGetByDate','P') IS NOT NULL
    DROP PROCEDURE dbo.OrdersGetByDate;
GO
CREATE PROCEDURE dbo.OrdersGetByDate
    @StartDate DATE,
    @EndDate DATE
AS
BEGIN
    SET NOCOUNT ON;
    SELECT OrderID, TotalAmount, DateCreated, DateShipped, Status, CustomerName FROM dbo.Orders
    WHERE CAST(DateCreated AS DATE) BETWEEN @StartDate AND @EndDate ORDER BY DateCreated DESC;
END
GO

IF OBJECT_ID('dbo.OrdersGetUnverifiedUncanceled','P') IS NOT NULL
    DROP PROCEDURE dbo.OrdersGetUnverifiedUncanceled;
GO
CREATE PROCEDURE dbo.OrdersGetUnverifiedUncanceled
AS
BEGIN
    SET NOCOUNT ON;
    SELECT OrderID, TotalAmount, DateCreated, DateShipped, Status, CustomerName FROM dbo.Orders WHERE Verified = 0 AND Canceled = 0 ORDER BY DateCreated DESC;
END
GO

IF OBJECT_ID('dbo.OrdersGetVerifiedUncompleted','P') IS NOT NULL
    DROP PROCEDURE dbo.OrdersGetVerifiedUncompleted;
GO
CREATE PROCEDURE dbo.OrdersGetVerifiedUncompleted
AS
BEGIN
    SET NOCOUNT ON;
    SELECT OrderID, TotalAmount, DateCreated, DateShipped, Status, CustomerName FROM dbo.Orders WHERE Verified = 1 AND Completed = 0 AND Canceled = 0 ORDER BY DateCreated DESC;
END
GO

IF OBJECT_ID('dbo.OrderGetInfo','P') IS NOT NULL
    DROP PROCEDURE dbo.OrderGetInfo;
GO
CREATE PROCEDURE dbo.OrderGetInfo
    @OrderID INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT o.OrderID, o.TotalAmount, o.DateCreated, o.DateShipped, o.Verified, o.Completed, o.Canceled, o.Comments, o.CustomerName, o.ShippingAddress, o.CustomerEmail, o.ShippingID, o.TaxID, o.Status, o.AuthCode, o.Reference, o.CustomerID
    FROM dbo.Orders o
    WHERE o.OrderID = @OrderID;
END
GO

IF OBJECT_ID('dbo.OrderGetDetails','P') IS NOT NULL
    DROP PROCEDURE dbo.OrderGetDetails;
GO
CREATE PROCEDURE dbo.OrderGetDetails
    @OrderID INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT OrderDetailID, OrderID, ProductID, ProductName, Quantity, UnitCost FROM dbo.OrderDetails WHERE OrderID = @OrderID;
END
GO

IF OBJECT_ID('dbo.OrderUpdate','P') IS NOT NULL
    DROP PROCEDURE dbo.OrderUpdate;
GO
CREATE PROCEDURE dbo.OrderUpdate
    @OrderID INT,
    @DateCreated DATETIME,
    @DateShipped DATETIME = NULL,
    @Verified TINYINT = 0,
    @Completed TINYINT = 0,
    @Canceled TINYINT = 0,
    @Comments NVARCHAR(2000) = NULL,
    @CustomerName NVARCHAR(200) = NULL,
    @ShippingAddress NVARCHAR(2000) = NULL,
    @CustomerEmail NVARCHAR(200) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.Orders
    SET DateCreated = @DateCreated,
        DateShipped = @DateShipped,
        Verified = @Verified,
        Completed = @Completed,
        Canceled = @Canceled,
        Comments = @Comments,
        CustomerName = @CustomerName,
        ShippingAddress = @ShippingAddress,
        CustomerEmail = @CustomerEmail
    WHERE OrderID = @OrderID;
    SELECT @@ROWCOUNT;
END
GO

IF OBJECT_ID('dbo.OrderMarkVerified','P') IS NOT NULL
    DROP PROCEDURE dbo.OrderMarkVerified;
GO
CREATE PROCEDURE dbo.OrderMarkVerified
    @OrderID INT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.Orders SET Verified = 1 WHERE OrderID = @OrderID;
END
GO

IF OBJECT_ID('dbo.OrderMarkCompleted','P') IS NOT NULL
    DROP PROCEDURE dbo.OrderMarkCompleted;
GO
CREATE PROCEDURE dbo.OrderMarkCompleted
    @OrderID INT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.Orders SET Completed = 1 WHERE OrderID = @OrderID;
END
GO

IF OBJECT_ID('dbo.OrderMarkCanceled','P') IS NOT NULL
    DROP PROCEDURE dbo.OrderMarkCanceled;
GO
CREATE PROCEDURE dbo.OrderMarkCanceled
    @OrderID INT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.Orders SET Canceled = 1 WHERE OrderID = @OrderID;
END
GO

-- =========================
-- CommerceLib procedures (shipping, audit, order status)
-- =========================
IF OBJECT_ID('dbo.CommerceLibShippingGetInfo','P') IS NOT NULL
    DROP PROCEDURE dbo.CommerceLibShippingGetInfo;
GO
CREATE PROCEDURE dbo.CommerceLibShippingGetInfo
    @ShippingRegionId INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT ShippingID, ShippingType, ShippingCost FROM dbo.Shipping WHERE ShippingRegionId = @ShippingRegionId;
END
GO

IF OBJECT_ID('dbo.CommerceLibOrderGetInfo','P') IS NOT NULL
    DROP PROCEDURE dbo.CommerceLibOrderGetInfo;
GO
CREATE PROCEDURE dbo.CommerceLibOrderGetInfo
    @OrderID INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT o.*, s.ShippingType, s.ShippingCost, t.TaxType, t.TaxPercentage
    FROM dbo.Orders o
    LEFT JOIN dbo.Shipping s ON o.ShippingID = s.ShippingID
    LEFT JOIN dbo.Tax t ON o.TaxID = t.TaxID
    WHERE o.OrderID = @OrderID;
END
GO

IF OBJECT_ID('dbo.CreateAudit','P') IS NOT NULL
    DROP PROCEDURE dbo.CreateAudit;
GO
CREATE PROCEDURE dbo.CreateAudit
    @OrderID INT,
    @Message NVARCHAR(512),
    @MessageNumber INT
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO dbo.Audit(OrderID, Message, MessageNumber) VALUES(@OrderID, @Message, @MessageNumber);
    SELECT SCOPE_IDENTITY() AS AuditID;
END
GO

IF OBJECT_ID('dbo.CommerceLibOrderUpdateStatus','P') IS NOT NULL
    DROP PROCEDURE dbo.CommerceLibOrderUpdateStatus;
GO
CREATE PROCEDURE dbo.CommerceLibOrderUpdateStatus
    @OrderID INT,
    @Status INT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.Orders SET Status = @Status WHERE OrderID = @OrderID;
END
GO

IF OBJECT_ID('dbo.CommerceLibOrderSetAuthCode','P') IS NOT NULL
    DROP PROCEDURE dbo.CommerceLibOrderSetAuthCode;
GO
CREATE PROCEDURE dbo.CommerceLibOrderSetAuthCode
    @OrderID INT,
    @AuthCode NVARCHAR(50),
    @Reference NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.Orders SET AuthCode = @AuthCode, Reference = @Reference WHERE OrderID = @OrderID;
END
GO

IF OBJECT_ID('dbo.CommerceLibOrderSetDateShipped','P') IS NOT NULL
    DROP PROCEDURE dbo.CommerceLibOrderSetDateShipped;
GO
CREATE PROCEDURE dbo.CommerceLibOrderSetDateShipped
    @OrderID INT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.Orders SET DateShipped = GETDATE() WHERE OrderID = @OrderID;
END
GO

IF OBJECT_ID('dbo.CommerceLibOrderGetAuditTrail','P') IS NOT NULL
    DROP PROCEDURE dbo.CommerceLibOrderGetAuditTrail;
GO
CREATE PROCEDURE dbo.CommerceLibOrderGetAuditTrail
    @OrderID INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT AuditID, OrderID, DateStamp, Message, MessageNumber FROM dbo.Audit WHERE OrderID = @OrderID ORDER BY DateStamp DESC;
END
GO

IF OBJECT_ID('dbo.CommerceLibOrdersGetByCustomer','P') IS NOT NULL
    DROP PROCEDURE dbo.CommerceLibOrdersGetByCustomer;
GO
CREATE PROCEDURE dbo.CommerceLibOrdersGetByCustomer
    @CustomerID UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;
    SELECT OrderID, TotalAmount, DateCreated, DateShipped, Status FROM dbo.Orders WHERE CustomerID = @CustomerID ORDER BY DateCreated DESC;
END
GO

IF OBJECT_ID('dbo.CommerceLibOrdersGetByDate','P') IS NOT NULL
    DROP PROCEDURE dbo.CommerceLibOrdersGetByDate;
GO
CREATE PROCEDURE dbo.CommerceLibOrdersGetByDate
    @StartDate DATE,
    @EndDate DATE
AS
BEGIN
    SET NOCOUNT ON;
    SELECT OrderID, TotalAmount, DateCreated, DateShipped, Status FROM dbo.Orders
    WHERE CAST(DateCreated AS DATE) BETWEEN @StartDate AND @EndDate ORDER BY DateCreated DESC;
END
GO

IF OBJECT_ID('dbo.CommerceLibOrdersGetByRecent','P') IS NOT NULL
    DROP PROCEDURE dbo.CommerceLibOrdersGetByRecent;
GO
CREATE PROCEDURE dbo.CommerceLibOrdersGetByRecent
    @Count INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT TOP(@Count) OrderID, TotalAmount, DateCreated, DateShipped, Status FROM dbo.Orders ORDER BY DateCreated DESC;
END
GO

IF OBJECT_ID('dbo.CommerceLibOrdersGetByStatus','P') IS NOT NULL
    DROP PROCEDURE dbo.CommerceLibOrdersGetByStatus;
GO
CREATE PROCEDURE dbo.CommerceLibOrdersGetByStatus
    @Status INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT OrderID, TotalAmount, DateCreated, DateShipped, Status FROM dbo.Orders WHERE Status = @Status ORDER BY DateCreated DESC;
END
GO

IF OBJECT_ID('dbo.CommerceLibOrderUpdate','P') IS NOT NULL
    DROP PROCEDURE dbo.CommerceLibOrderUpdate;
GO
CREATE PROCEDURE dbo.CommerceLibOrderUpdate
    @OrderID INT,
    @DateCreated DATETIME,
    @DateShipped DATETIME = NULL,
    @Status INT,
    @AuthCode NVARCHAR(50) = NULL,
    @Reference NVARCHAR(50) = NULL,
    @Comments NVARCHAR(2000) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.Orders SET DateCreated = @DateCreated, DateShipped = @DateShipped, Status = @Status, AuthCode = @AuthCode, Reference = @Reference, Comments = @Comments WHERE OrderID = @OrderID;
END
GO

-- Get product recommendations based on categories
IF OBJECT_ID('dbo.CatalogGetProductRecommendations','P') IS NOT NULL
    DROP PROCEDURE dbo.CatalogGetProductRecommendations;
GO
CREATE PROCEDURE dbo.CatalogGetProductRecommendations
    @ProductID INT,
    @DescriptionLength INT = 1000
AS
BEGIN
    SET NOCOUNT ON;
    -- Return products from same categories as the current product
    SELECT DISTINCT TOP 5 p.ProductID, p.Name, LEFT(p.Description, @DescriptionLength) AS Description, 
           p.Price, p.Thumbnail, p.Image
    FROM dbo.Products p
    JOIN dbo.ProductCategories pc1 ON p.ProductID = pc1.ProductID
    JOIN dbo.ProductCategories pc2 ON pc1.CategoryID = pc2.CategoryID
    WHERE pc2.ProductID = @ProductID 
    AND p.ProductID != @ProductID
    ORDER BY p.ProductID;
END
GO

-- =========================
-- ASP.NET membership
-- =========================
-- The app uses ASP.NET Membership views/tables (vw_aspnet_Users, aspnet_UsersInRoles, aspnet_Roles).
-- You should install the ASP.NET membership schema into the BalloonShop database using the Microsoft tool:
--     aspnet_regsql.exe -S .\SQLEXPRESS -E -d BalloonShop
-- or run the Microsoft-provided SQL script to create the membership schema.

-- End of file
