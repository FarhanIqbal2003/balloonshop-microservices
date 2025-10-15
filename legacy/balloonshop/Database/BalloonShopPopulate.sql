-- BalloonShop sample seed data (copied to App_Data)
-- Run this after App_Data/balloonshop-schema.sql
-- Date: 2025-10-14

USE BalloonShop;
GO

PRINT 'Seeding Departments...';

DECLARE @Dept1 INT; DECLARE @Dept2 INT;
INSERT INTO dbo.Departments(Name, Description) VALUES ('Party Balloons','Colorful latex and foil balloons for parties');
SET @Dept1 = SCOPE_IDENTITY();
INSERT INTO dbo.Departments(Name, Description) VALUES ('Occasion Supplies','Party accessories, ribbons, and decorations');
SET @Dept2 = SCOPE_IDENTITY();
GO

PRINT 'Seeding Categories...';

DECLARE @Cat1 INT; DECLARE @Cat2 INT; DECLARE @Cat3 INT;
INSERT INTO dbo.Categories(DepartmentID, Name, Description) VALUES(@Dept1, 'Latex Balloons','Standard latex balloons in many colors');
SET @Cat1 = SCOPE_IDENTITY();
INSERT INTO dbo.Categories(DepartmentID, Name, Description) VALUES(@Dept1, 'Foil Balloons','Shaped and printed foil balloons');
SET @Cat2 = SCOPE_IDENTITY();
INSERT INTO dbo.Categories(DepartmentID, Name, Description) VALUES(@Dept2, 'Ribbons & Bows','Assorted ribbons and bows');
SET @Cat3 = SCOPE_IDENTITY();
GO

PRINT 'Seeding Products...';

DECLARE @Prod1 INT; DECLARE @Prod2 INT; DECLARE @Prod3 INT;
INSERT INTO dbo.Products(Name, Description, Price, Thumbnail, Image, PromoFront, PromoDept)
VALUES('100-pack Latex Balloons','Assorted colors, 9-inch latex balloons, pack of 100', 9.99, '0276001.jpg', '0276001.jpg', 1, 1);
SET @Prod1 = SCOPE_IDENTITY();
INSERT INTO dbo.Products(Name, Description, Price, Thumbnail, Image, PromoFront, PromoDept)
VALUES('Happy Birthday Foil Balloon','Round foil balloon printed "Happy Birthday"', 4.99, '114103P.jpg', '114103P.jpg', 0, 1);
SET @Prod2 = SCOPE_IDENTITY();
INSERT INTO dbo.Products(Name, Description, Price, Thumbnail, Image, PromoFront, PromoDept)
VALUES('Satin Ribbon - 10m','Red satin ribbon roll, 10 meters', 2.49, 'ribbon.jpg', 'ribbon.jpg', 0, 0);
SET @Prod3 = SCOPE_IDENTITY();
GO

PRINT 'Linking products to categories...';

INSERT INTO dbo.ProductCategories(ProductID, CategoryID) VALUES(@Prod1, @Cat1);
INSERT INTO dbo.ProductCategories(ProductID, CategoryID) VALUES(@Prod2, @Cat2);
INSERT INTO dbo.ProductCategories(ProductID, CategoryID) VALUES(@Prod3, @Cat3);
GO

PRINT 'Adding product attributes and a sample review...';

INSERT INTO dbo.ProductAttributes(ProductID, AttributeName, AttributeValue) VALUES(@Prod1, 'ColorOptions', 'Red,Blue,Green,Yellow');
INSERT INTO dbo.ProductAttributes(ProductID, AttributeName, AttributeValue) VALUES(@Prod2, 'Size', '18-inch');
INSERT INTO dbo.ProductAttributes(ProductID, AttributeName, AttributeValue) VALUES(@Prod1, 'Review', 'Great value for decorations.');
GO

PRINT 'Seeding Shipping regions/options and tax...';

DECLARE @RegionUS INT; DECLARE @RegionEU INT;
INSERT INTO dbo.ShippingRegion(ShippingRegion) VALUES('United States'); SET @RegionUS = SCOPE_IDENTITY();
INSERT INTO dbo.ShippingRegion(ShippingRegion) VALUES('Europe'); SET @RegionEU = SCOPE_IDENTITY();

INSERT INTO dbo.Shipping(ShippingType, ShippingCost, ShippingRegionId) VALUES('Standard (US)', 5.00, @RegionUS);
INSERT INTO dbo.Shipping(ShippingType, ShippingCost, ShippingRegionId) VALUES('Express (US)', 12.00, @RegionUS);
INSERT INTO dbo.Shipping(ShippingType, ShippingCost, ShippingRegionId) VALUES('Standard (EU)', 15.00, @RegionEU);

INSERT INTO dbo.Tax(TaxType, TaxPercentage) VALUES('US Sales Tax', 7.25);
INSERT INTO dbo.Tax(TaxType, TaxPercentage) VALUES('VAT EU', 20.00);
GO

PRINT 'Seeding a sample shopping cart and an order...';

-- sample shopping cart
DECLARE @SampleCartID NVARCHAR(36) = 'test-cart-0001';
INSERT INTO dbo.ShoppingCartItems(CartID, ProductID, Attributes, Quantity) VALUES(@SampleCartID, @Prod1, 'Color=Red', 2);
INSERT INTO dbo.ShoppingCartItems(CartID, ProductID, Attributes, Quantity) VALUES(@SampleCartID, @Prod3, 'Length=10m', 1);

-- create a sample order from the cart (mimic CreateOrder procedure)
DECLARE @OrderTotal DECIMAL(18,2);
SELECT @OrderTotal = SUM(ISNULL(p.Price,0) * sci.Quantity) FROM dbo.ShoppingCartItems sci LEFT JOIN dbo.Products p ON sci.ProductID = p.ProductID WHERE sci.CartID = @SampleCartID;

INSERT INTO dbo.Orders(TotalAmount, DateCreated, Verified, Completed, Canceled, Comments, CustomerName, ShippingAddress, CustomerEmail, ShippingID, TaxID)
VALUES(ISNULL(@OrderTotal,0), GETDATE(), 0, 0, 0, 'Seed order', 'John Doe', '123 Main St, Anytown, USA', 'john@example.com', (SELECT TOP 1 ShippingID FROM dbo.Shipping WHERE ShippingRegionId = @RegionUS), (SELECT TOP 1 TaxID FROM dbo.Tax WHERE TaxType LIKE 'US%'));

DECLARE @NewOrderID INT = SCOPE_IDENTITY();

INSERT INTO dbo.OrderDetails(OrderID, ProductID, ProductName, Quantity, UnitCost)
SELECT @NewOrderID, sci.ProductID, p.Name, sci.Quantity, ISNULL(p.Price,0)
FROM dbo.ShoppingCartItems sci LEFT JOIN dbo.Products p ON sci.ProductID = p.ProductID
WHERE sci.CartID = @SampleCartID;

-- optionally clear the sample cart (commented out so you can inspect it)
-- DELETE FROM dbo.ShoppingCartItems WHERE CartID = @SampleCartID;
GO

PRINT 'Seed data insertion complete.';
