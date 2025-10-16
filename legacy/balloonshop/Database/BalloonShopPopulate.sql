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
DECLARE @Prod1 INT; DECLARE @Prod2 INT; DECLARE @Prod3 INT; DECLARE @Prod4 INT; DECLARE @Prod5 INT; 
DECLARE @Prod6 INT; DECLARE @Prod7 INT; DECLARE @Prod8 INT; DECLARE @Prod9 INT; DECLARE @Prod10 INT;

-- Latex Balloons
IF NOT EXISTS (SELECT 1 FROM dbo.Products WHERE Name = '100-pack Classic Latex Balloons')
BEGIN
	INSERT INTO dbo.Products(Name, Description, Price, Thumbnail, Image, PromoFront, PromoDept)
	VALUES('100-pack Classic Latex Balloons','Assorted colors, 9-inch latex balloons, pack of 100. Perfect for birthday parties and celebrations.', 9.99, 't0276001.jpg', '0276001.jpg', 1, 1);
END
SET @Prod1 = (SELECT ProductID FROM dbo.Products WHERE Name = '100-pack Classic Latex Balloons');

IF NOT EXISTS (SELECT 1 FROM dbo.Products WHERE Name = 'Premium Pearl Latex Balloons')
BEGIN
	INSERT INTO dbo.Products(Name, Description, Price, Thumbnail, Image, PromoFront, PromoDept)
	VALUES('Premium Pearl Latex Balloons','Pearlescent finish latex balloons, 12-inch size, pack of 50. Adds an elegant touch to any event.', 12.99, 't0326801.jpg', '0326801.jpg', 1, 1);
END
SET @Prod2 = (SELECT ProductID FROM dbo.Products WHERE Name = 'Premium Pearl Latex Balloons');

IF NOT EXISTS (SELECT 1 FROM dbo.Products WHERE Name = 'Giant Party Balloon Set')
BEGIN
	INSERT INTO dbo.Products(Name, Description, Price, Thumbnail, Image, PromoFront, PromoDept)
	VALUES('Giant Party Balloon Set','24-inch oversized latex balloons, pack of 10. Makes a big statement at parties.', 14.99, 't0366101.jpg', '0366101.jpg', 0, 1);
END
SET @Prod3 = (SELECT ProductID FROM dbo.Products WHERE Name = 'Giant Party Balloon Set');

-- Foil Balloons
IF NOT EXISTS (SELECT 1 FROM dbo.Products WHERE Name = 'Happy Birthday Star Balloon')
BEGIN
	INSERT INTO dbo.Products(Name, Description, Price, Thumbnail, Image, PromoFront, PromoDept)
	VALUES('Happy Birthday Star Balloon','18-inch star-shaped foil balloon with Happy Birthday design', 4.99, 't114103p.jpg', '114103P.jpg', 1, 1);
END
SET @Prod4 = (SELECT ProductID FROM dbo.Products WHERE Name = 'Happy Birthday Star Balloon');

IF NOT EXISTS (SELECT 1 FROM dbo.Products WHERE Name = 'Congratulations Foil Set')
BEGIN
	INSERT INTO dbo.Products(Name, Description, Price, Thumbnail, Image, PromoFront, PromoDept)
	VALUES('Congratulations Foil Set','Set of 3 coordinating foil balloons with congratulations theme', 12.99, 't114118p.jpg', '114118p.jpg', 0, 1);
END
SET @Prod5 = (SELECT ProductID FROM dbo.Products WHERE Name = 'Congratulations Foil Set');

IF NOT EXISTS (SELECT 1 FROM dbo.Products WHERE Name = 'Number Foil Balloon')
BEGIN
	INSERT INTO dbo.Products(Name, Description, Price, Thumbnail, Image, PromoFront, PromoDept)
	VALUES('Number Foil Balloon','34-inch large number foil balloon, available in gold finish', 7.99, 't16110p.jpg', '16110p.jpg', 0, 1);
END
SET @Prod6 = (SELECT ProductID FROM dbo.Products WHERE Name = 'Number Foil Balloon');

-- Party Supplies
IF NOT EXISTS (SELECT 1 FROM dbo.Products WHERE Name = 'Deluxe Balloon Bouquet Kit')
BEGIN
	INSERT INTO dbo.Products(Name, Description, Price, Thumbnail, Image, PromoFront, PromoDept)
	VALUES('Deluxe Balloon Bouquet Kit','Complete kit for creating professional-looking balloon bouquets', 24.99, 't16151p.jpg', '16151p.jpg', 1, 0);
END
SET @Prod7 = (SELECT ProductID FROM dbo.Products WHERE Name = 'Deluxe Balloon Bouquet Kit');

IF NOT EXISTS (SELECT 1 FROM dbo.Products WHERE Name = 'Premium Satin Ribbon Roll')
BEGIN
	INSERT INTO dbo.Products(Name, Description, Price, Thumbnail, Image, PromoFront, PromoDept)
	VALUES('Premium Satin Ribbon Roll','25-meter roll of high-quality satin ribbon, perfect for balloon decorating', 6.99, 't214154p.jpg', '214154p.jpg', 0, 0);
END
SET @Prod8 = (SELECT ProductID FROM dbo.Products WHERE Name = 'Premium Satin Ribbon Roll');

IF NOT EXISTS (SELECT 1 FROM dbo.Products WHERE Name = 'Party Decoration Bundle')
BEGIN
	INSERT INTO dbo.Products(Name, Description, Price, Thumbnail, Image, PromoFront, PromoDept)
	VALUES('Party Decoration Bundle','Complete party decoration set including balloons, ribbons, and accessories', 29.99, 't215302p.jpg', '215302p.jpg', 1, 0);
END
SET @Prod9 = (SELECT ProductID FROM dbo.Products WHERE Name = 'Party Decoration Bundle');

IF NOT EXISTS (SELECT 1 FROM dbo.Products WHERE Name = 'Balloon Weight & Clip Set')
BEGIN
	INSERT INTO dbo.Products(Name, Description, Price, Thumbnail, Image, PromoFront, PromoDept)
	VALUES('Balloon Weight & Clip Set','Set of 10 balloon weights with quick-release clips', 8.99, 't38196.jpg', '38196.jpg', 0, 0);
END
SET @Prod10 = (SELECT ProductID FROM dbo.Products WHERE Name = 'Balloon Weight & Clip Set');

PRINT 'Linking products to categories...';
-- Latex Balloons
IF NOT EXISTS (SELECT 1 FROM dbo.ProductCategories WHERE ProductID = @Prod1 AND CategoryID = @Cat1)
	INSERT INTO dbo.ProductCategories(ProductID, CategoryID) VALUES(@Prod1, @Cat1);
IF NOT EXISTS (SELECT 1 FROM dbo.ProductCategories WHERE ProductID = @Prod2 AND CategoryID = @Cat1)
	INSERT INTO dbo.ProductCategories(ProductID, CategoryID) VALUES(@Prod2, @Cat1);
IF NOT EXISTS (SELECT 1 FROM dbo.ProductCategories WHERE ProductID = @Prod3 AND CategoryID = @Cat1)
	INSERT INTO dbo.ProductCategories(ProductID, CategoryID) VALUES(@Prod3, @Cat1);

-- Foil Balloons
IF NOT EXISTS (SELECT 1 FROM dbo.ProductCategories WHERE ProductID = @Prod4 AND CategoryID = @Cat2)
	INSERT INTO dbo.ProductCategories(ProductID, CategoryID) VALUES(@Prod4, @Cat2);
IF NOT EXISTS (SELECT 1 FROM dbo.ProductCategories WHERE ProductID = @Prod5 AND CategoryID = @Cat2)
	INSERT INTO dbo.ProductCategories(ProductID, CategoryID) VALUES(@Prod5, @Cat2);
IF NOT EXISTS (SELECT 1 FROM dbo.ProductCategories WHERE ProductID = @Prod6 AND CategoryID = @Cat2)
	INSERT INTO dbo.ProductCategories(ProductID, CategoryID) VALUES(@Prod6, @Cat2);

-- Party Supplies & Ribbons
IF NOT EXISTS (SELECT 1 FROM dbo.ProductCategories WHERE ProductID = @Prod7 AND CategoryID = @Cat3)
	INSERT INTO dbo.ProductCategories(ProductID, CategoryID) VALUES(@Prod7, @Cat3);
IF NOT EXISTS (SELECT 1 FROM dbo.ProductCategories WHERE ProductID = @Prod8 AND CategoryID = @Cat3)
	INSERT INTO dbo.ProductCategories(ProductID, CategoryID) VALUES(@Prod8, @Cat3);
IF NOT EXISTS (SELECT 1 FROM dbo.ProductCategories WHERE ProductID = @Prod9 AND CategoryID = @Cat3)
	INSERT INTO dbo.ProductCategories(ProductID, CategoryID) VALUES(@Prod9, @Cat3);
IF NOT EXISTS (SELECT 1 FROM dbo.ProductCategories WHERE ProductID = @Prod10 AND CategoryID = @Cat3)
	INSERT INTO dbo.ProductCategories(ProductID, CategoryID) VALUES(@Prod10, @Cat3);

PRINT 'Adding product attributes and values...';
DECLARE @ColorAttr INT;
DECLARE @SizeAttr INT;
DECLARE @ReviewAttr INT;
DECLARE @MaterialAttr INT;

-- Classic Latex Balloons Colors
IF NOT EXISTS (SELECT 1 FROM dbo.ProductAttributes WHERE ProductID = @Prod1 AND AttributeName = 'ColorOptions')
BEGIN
    INSERT INTO dbo.ProductAttributes(ProductID, AttributeName) 
    VALUES(@Prod1, 'ColorOptions');
    SET @ColorAttr = SCOPE_IDENTITY();
    
    INSERT INTO dbo.ProductAttributeValues(AttributeID, AttributeValue) 
    VALUES
        (@ColorAttr, 'Red'),
        (@ColorAttr, 'Blue'),
        (@ColorAttr, 'Green'),
        (@ColorAttr, 'Yellow'),
        (@ColorAttr, 'Pink'),
        (@ColorAttr, 'Purple');
END

-- Pearl Latex Balloons Colors
IF NOT EXISTS (SELECT 1 FROM dbo.ProductAttributes WHERE ProductID = @Prod2 AND AttributeName = 'ColorOptions')
BEGIN
    INSERT INTO dbo.ProductAttributes(ProductID, AttributeName) 
    VALUES(@Prod2, 'ColorOptions');
    SET @ColorAttr = SCOPE_IDENTITY();
    
    INSERT INTO dbo.ProductAttributeValues(AttributeID, AttributeValue) 
    VALUES
        (@ColorAttr, 'Pearl White'),
        (@ColorAttr, 'Pearl Pink'),
        (@ColorAttr, 'Pearl Blue'),
        (@ColorAttr, 'Pearl Gold');
END

-- Giant Balloon Sizes
IF NOT EXISTS (SELECT 1 FROM dbo.ProductAttributes WHERE ProductID = @Prod3 AND AttributeName = 'Size')
BEGIN
    INSERT INTO dbo.ProductAttributes(ProductID, AttributeName)
    VALUES(@Prod3, 'Size');
    SET @SizeAttr = SCOPE_IDENTITY();
    
    INSERT INTO dbo.ProductAttributeValues(AttributeID, AttributeValue)
    VALUES
        (@SizeAttr, '24-inch'),
        (@SizeAttr, '36-inch');
END

-- Foil Balloon Attributes
IF NOT EXISTS (SELECT 1 FROM dbo.ProductAttributes WHERE ProductID = @Prod4 AND AttributeName = 'Material')
BEGIN
    INSERT INTO dbo.ProductAttributes(ProductID, AttributeName)
    VALUES(@Prod4, 'Material');
    SET @MaterialAttr = SCOPE_IDENTITY();
    
    INSERT INTO dbo.ProductAttributeValues(AttributeID, AttributeValue)
    VALUES(@MaterialAttr, 'Mylar Foil');
END

-- Number Balloon Options
IF NOT EXISTS (SELECT 1 FROM dbo.ProductAttributes WHERE ProductID = @Prod6 AND AttributeName = 'Number')
BEGIN
    INSERT INTO dbo.ProductAttributes(ProductID, AttributeName)
    VALUES(@Prod6, 'Number');
    SET @ColorAttr = SCOPE_IDENTITY();
    
    INSERT INTO dbo.ProductAttributeValues(AttributeID, AttributeValue)
    VALUES
        (@ColorAttr, '0'),
        (@ColorAttr, '1'),
        (@ColorAttr, '2'),
        (@ColorAttr, '3'),
        (@ColorAttr, '4'),
        (@ColorAttr, '5'),
        (@ColorAttr, '6'),
        (@ColorAttr, '7'),
        (@ColorAttr, '8'),
        (@ColorAttr, '9');
END

-- Ribbon Colors
IF NOT EXISTS (SELECT 1 FROM dbo.ProductAttributes WHERE ProductID = @Prod8 AND AttributeName = 'ColorOptions')
BEGIN
    INSERT INTO dbo.ProductAttributes(ProductID, AttributeName)
    VALUES(@Prod8, 'ColorOptions');
    SET @ColorAttr = SCOPE_IDENTITY();
    
    INSERT INTO dbo.ProductAttributeValues(AttributeID, AttributeValue)
    VALUES
        (@ColorAttr, 'Red'),
        (@ColorAttr, 'White'),
        (@ColorAttr, 'Blue'),
        (@ColorAttr, 'Gold'),
        (@ColorAttr, 'Silver');
END

-- Sample Reviews
IF NOT EXISTS (SELECT 1 FROM dbo.ProductAttributes WHERE ProductID = @Prod1 AND AttributeName = 'Review')
BEGIN
    INSERT INTO dbo.ProductAttributes(ProductID, AttributeName)
    VALUES(@Prod1, 'Review');
    SET @ReviewAttr = SCOPE_IDENTITY();
    
    INSERT INTO dbo.ProductAttributeValues(AttributeID, AttributeValue)
    VALUES
        (@ReviewAttr, 'Great value for party decorations! The colors are vibrant and the quality is excellent.'),
        (@ReviewAttr, 'Perfect for our school event. All balloons inflated well with no duds.');
END

IF NOT EXISTS (SELECT 1 FROM dbo.ProductAttributes WHERE ProductID = @Prod4 AND AttributeName = 'Review')
BEGIN
    INSERT INTO dbo.ProductAttributes(ProductID, AttributeName)
    VALUES(@Prod4, 'Review');
    SET @ReviewAttr = SCOPE_IDENTITY();
    
    INSERT INTO dbo.ProductAttributeValues(AttributeID, AttributeValue)
    VALUES
        (@ReviewAttr, 'The foil balloon looked amazing at our party! Stayed inflated for days.'),
        (@ReviewAttr, 'High quality material and the design is beautiful. Would buy again!');
END

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
