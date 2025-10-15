-- BalloonShop sample seed data (copied to App_Data)
-- Run this after App_Data/balloonshop-schema.sql
-- Date: 2025-10-14

USE BalloonShop;

PRINT 'Seeding Departments...';
DECLARE @Dept1 INT; DECLARE @Dept2 INT;
IF NOT EXISTS (SELECT 1 FROM dbo.Departments WHERE Name = 'Party Balloons')
BEGIN
	INSERT INTO dbo.Departments(Name, Description) VALUES ('Party Balloons','Colorful latex and foil balloons for parties');
END
SET @Dept1 = (SELECT DepartmentID FROM dbo.Departments WHERE Name = 'Party Balloons');
IF NOT EXISTS (SELECT 1 FROM dbo.Departments WHERE Name = 'Occasion Supplies')
BEGIN
	INSERT INTO dbo.Departments(Name, Description) VALUES ('Occasion Supplies','Party accessories, ribbons, and decorations');
END
SET @Dept2 = (SELECT DepartmentID FROM dbo.Departments WHERE Name = 'Occasion Supplies');

PRINT 'Seeding Categories...';
DECLARE @Cat1 INT; DECLARE @Cat2 INT; DECLARE @Cat3 INT;
IF NOT EXISTS (SELECT 1 FROM dbo.Categories WHERE Name = 'Latex Balloons' AND DepartmentID = @Dept1)
BEGIN
	INSERT INTO dbo.Categories(DepartmentID, Name, Description) VALUES(@Dept1, 'Latex Balloons','Standard latex balloons in many colors');
END
SET @Cat1 = (SELECT CategoryID FROM dbo.Categories WHERE Name = 'Latex Balloons' AND DepartmentID = @Dept1);
IF NOT EXISTS (SELECT 1 FROM dbo.Categories WHERE Name = 'Foil Balloons' AND DepartmentID = @Dept1)
BEGIN
	INSERT INTO dbo.Categories(DepartmentID, Name, Description) VALUES(@Dept1, 'Foil Balloons','Shaped and printed foil balloons');
END
SET @Cat2 = (SELECT CategoryID FROM dbo.Categories WHERE Name = 'Foil Balloons' AND DepartmentID = @Dept1);
IF NOT EXISTS (SELECT 1 FROM dbo.Categories WHERE Name = 'Ribbons & Bows' AND DepartmentID = @Dept2)
BEGIN
	INSERT INTO dbo.Categories(DepartmentID, Name, Description) VALUES(@Dept2, 'Ribbons & Bows','Assorted ribbons and bows');
END
SET @Cat3 = (SELECT CategoryID FROM dbo.Categories WHERE Name = 'Ribbons & Bows' AND DepartmentID = @Dept2);

PRINT 'Seeding Products...';
DECLARE @Prod1 INT; DECLARE @Prod2 INT; DECLARE @Prod3 INT;
IF NOT EXISTS (SELECT 1 FROM dbo.Products WHERE Name = '100-pack Latex Balloons')
BEGIN
	INSERT INTO dbo.Products(Name, Description, Price, Thumbnail, Image, PromoFront, PromoDept)
	VALUES('100-pack Latex Balloons','Assorted colors, 9-inch latex balloons, pack of 100', 9.99, '0276001.jpg', '0276001.jpg', 1, 1);
END
SET @Prod1 = (SELECT ProductID FROM dbo.Products WHERE Name = '100-pack Latex Balloons');
IF NOT EXISTS (SELECT 1 FROM dbo.Products WHERE Name = 'Happy Birthday Foil Balloon')
BEGIN
	INSERT INTO dbo.Products(Name, Description, Price, Thumbnail, Image, PromoFront, PromoDept)
	VALUES('Happy Birthday Foil Balloon','Round foil balloon printed "Happy Birthday"', 4.99, '114103P.jpg', '114103P.jpg', 0, 1);
END
SET @Prod2 = (SELECT ProductID FROM dbo.Products WHERE Name = 'Happy Birthday Foil Balloon');
IF NOT EXISTS (SELECT 1 FROM dbo.Products WHERE Name = 'Satin Ribbon - 10m')
BEGIN
	INSERT INTO dbo.Products(Name, Description, Price, Thumbnail, Image, PromoFront, PromoDept)
	VALUES('Satin Ribbon - 10m','Red satin ribbon roll, 10 meters', 2.49, 'ribbon.jpg', 'ribbon.jpg', 0, 0);
END
SET @Prod3 = (SELECT ProductID FROM dbo.Products WHERE Name = 'Satin Ribbon - 10m');

PRINT 'Linking products to categories...';
IF NOT EXISTS (SELECT 1 FROM dbo.ProductCategories WHERE ProductID = @Prod1 AND CategoryID = @Cat1)
	INSERT INTO dbo.ProductCategories(ProductID, CategoryID) VALUES(@Prod1, @Cat1);
IF NOT EXISTS (SELECT 1 FROM dbo.ProductCategories WHERE ProductID = @Prod2 AND CategoryID = @Cat2)
	INSERT INTO dbo.ProductCategories(ProductID, CategoryID) VALUES(@Prod2, @Cat2);
IF NOT EXISTS (SELECT 1 FROM dbo.ProductCategories WHERE ProductID = @Prod3 AND CategoryID = @Cat3)
	INSERT INTO dbo.ProductCategories(ProductID, CategoryID) VALUES(@Prod3, @Cat3);

PRINT 'Adding product attributes and a sample review...';
IF NOT EXISTS (SELECT 1 FROM dbo.ProductAttributes WHERE ProductID = @Prod1 AND AttributeName = 'ColorOptions')
	INSERT INTO dbo.ProductAttributes(ProductID, AttributeName, AttributeValue) VALUES(@Prod1, 'ColorOptions', 'Red,Blue,Green,Yellow');
IF NOT EXISTS (SELECT 1 FROM dbo.ProductAttributes WHERE ProductID = @Prod2 AND AttributeName = 'Size')
	INSERT INTO dbo.ProductAttributes(ProductID, AttributeName, AttributeValue) VALUES(@Prod2, 'Size', '18-inch');
IF NOT EXISTS (SELECT 1 FROM dbo.ProductAttributes WHERE ProductID = @Prod1 AND AttributeName = 'Review')
	INSERT INTO dbo.ProductAttributes(ProductID, AttributeName, AttributeValue) VALUES(@Prod1, 'Review', 'Great value for decorations.');

PRINT 'Seeding Shipping regions/options and tax...';
DECLARE @RegionUS INT; DECLARE @RegionEU INT;
IF NOT EXISTS (SELECT 1 FROM dbo.ShippingRegion WHERE ShippingRegion = 'United States')
	INSERT INTO dbo.ShippingRegion(ShippingRegion) VALUES('United States');
SET @RegionUS = (SELECT ShippingRegionId FROM dbo.ShippingRegion WHERE ShippingRegion = 'United States');
IF NOT EXISTS (SELECT 1 FROM dbo.ShippingRegion WHERE ShippingRegion = 'Europe')
	INSERT INTO dbo.ShippingRegion(ShippingRegion) VALUES('Europe');
SET @RegionEU = (SELECT ShippingRegionId FROM dbo.ShippingRegion WHERE ShippingRegion = 'Europe');
IF NOT EXISTS (SELECT 1 FROM dbo.Shipping WHERE ShippingType = 'Standard (US)' AND ShippingRegionId = @RegionUS)
	INSERT INTO dbo.Shipping(ShippingType, ShippingCost, ShippingRegionId) VALUES('Standard (US)', 5.00, @RegionUS);
IF NOT EXISTS (SELECT 1 FROM dbo.Shipping WHERE ShippingType = 'Express (US)' AND ShippingRegionId = @RegionUS)
	INSERT INTO dbo.Shipping(ShippingType, ShippingCost, ShippingRegionId) VALUES('Express (US)', 12.00, @RegionUS);
IF NOT EXISTS (SELECT 1 FROM dbo.Shipping WHERE ShippingType = 'Standard (EU)' AND ShippingRegionId = @RegionEU)
	INSERT INTO dbo.Shipping(ShippingType, ShippingCost, ShippingRegionId) VALUES('Standard (EU)', 15.00, @RegionEU);
IF NOT EXISTS (SELECT 1 FROM dbo.Tax WHERE TaxType = 'US Sales Tax')
	INSERT INTO dbo.Tax(TaxType, TaxPercentage) VALUES('US Sales Tax', 7.25);
IF NOT EXISTS (SELECT 1 FROM dbo.Tax WHERE TaxType = 'VAT EU')
	INSERT INTO dbo.Tax(TaxType, TaxPercentage) VALUES('VAT EU', 20.00);

PRINT 'Seeding a sample shopping cart and an order...';
DECLARE @SampleCartID NVARCHAR(36) = 'test-cart-0001';
IF NOT EXISTS (SELECT 1 FROM dbo.ShoppingCartItems WHERE CartID = @SampleCartID AND ProductID = @Prod1)
	INSERT INTO dbo.ShoppingCartItems(CartID, ProductID, Attributes, Quantity) VALUES(@SampleCartID, @Prod1, 'Color=Red', 2);
IF NOT EXISTS (SELECT 1 FROM dbo.ShoppingCartItems WHERE CartID = @SampleCartID AND ProductID = @Prod3)
	INSERT INTO dbo.ShoppingCartItems(CartID, ProductID, Attributes, Quantity) VALUES(@SampleCartID, @Prod3, 'Length=10m', 1);
DECLARE @OrderTotal DECIMAL(18,2);
SELECT @OrderTotal = SUM(ISNULL(p.Price,0) * sci.Quantity) FROM dbo.ShoppingCartItems sci LEFT JOIN dbo.Products p ON sci.ProductID = p.ProductID WHERE sci.CartID = @SampleCartID;
IF NOT EXISTS (SELECT 1 FROM dbo.Orders WHERE Comments = 'Seed order' AND CustomerEmail = 'john@example.com')
BEGIN
	INSERT INTO dbo.Orders(TotalAmount, DateCreated, Verified, Completed, Canceled, Comments, CustomerName, ShippingAddress, CustomerEmail, ShippingID, TaxID)
	VALUES(ISNULL(@OrderTotal,0), GETDATE(), 0, 0, 0, 'Seed order', 'John Doe', '123 Main St, Anytown, USA', 'john@example.com', (SELECT TOP 1 ShippingID FROM dbo.Shipping WHERE ShippingRegionId = @RegionUS), (SELECT TOP 1 TaxID FROM dbo.Tax WHERE TaxType LIKE 'US%'));
	DECLARE @NewOrderID INT = SCOPE_IDENTITY();
	INSERT INTO dbo.OrderDetails(OrderID, ProductID, ProductName, Quantity, UnitCost)
	SELECT @NewOrderID, sci.ProductID, p.Name, sci.Quantity, ISNULL(p.Price,0)
	FROM dbo.ShoppingCartItems sci LEFT JOIN dbo.Products p ON sci.ProductID = p.ProductID
	WHERE sci.CartID = @SampleCartID;
END
-- optionally clear the sample cart (commented out so you can inspect it)
-- DELETE FROM dbo.ShoppingCartItems WHERE CartID = @SampleCartID;

PRINT 'Seed data insertion complete.';
