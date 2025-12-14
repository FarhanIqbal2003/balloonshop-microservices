using System;
using System.Data;
using System.Data.Common;
using System.Text.RegularExpressions;
using System.Web.UI.MobileControls;
using System.Xml.Linq;

/// <summary>
/// Wraps department details data
/// </summary>
public struct DepartmentDetails
{
    public string Name;
    public string Description;
}

/// <summary>
/// Wraps category details data
/// </summary>
public struct CategoryDetails
{
    public int DepartmentId;
    public string Name;
    public string Description;
}

/// <summary>
/// Wraps product details data
/// </summary>
public struct ProductDetails
{
    public int ProductID;
    public string Name;
    public string Description;
    public decimal Price;
    public string Thumbnail;
    public string Image;
    public bool PromoFront;
    public bool PromoDept;
}

/// <summary>
/// Product catalog business tier component
/// </summary>
public static class CatalogAccess
{
    static CatalogAccess()
    {
        //
        // TODO: Add constructor logic here
        //
    }

    // Retrieve the list of departments 
    public static DataTable GetDepartments()
    {
        var items = CatalogApiClient.GetDepartments(); // returns List<DepartmentDto>

        // convert list to DataTable (so UI pages remain unchanged)
        var dt = new DataTable();
        dt.Columns.Add("DepartmentID", typeof(int));
        dt.Columns.Add("Name", typeof(string));
        dt.Columns.Add("Description", typeof(string));

        foreach (var item in items)
        {
            dt.Rows.Add(item.DepartmentID, item.Name, item.Description);
        }

        return dt;
    }

    // get department details
    public static DepartmentDetails GetDepartmentDetails(string departmentId)
    {
        var items = CatalogApiClient.GetDepartmentById(int.Parse(departmentId));

        // wrap retrieved data into a DepartmentDetails object
        DepartmentDetails details = new DepartmentDetails();
        if (items != null)
        {
            details.Name = items.Name;
            details.Description = items.Description;
        }
        // return department details
        return details;
    }

    // Get category details
    public static CategoryDetails GetCategoryDetails(string categoryId)
    {
        var items = CatalogApiClient.GetCategoryById(int.Parse(categoryId));
        // wrap retrieved data into a CategoryDetails object
        CategoryDetails details = new CategoryDetails();
        if (items != null)
        {
            details.DepartmentId = items.DepartmentID;
            details.Name = items.Name;
            details.Description = items.Description;
        }
        // return department details
        return details;
    }

    // Get product details
    public static ProductDetails GetProductDetails(string productId)
    {
        var items = CatalogApiClient.GetProductById(int.Parse(productId));

        // wrap retrieved data into a ProductDetails object
        ProductDetails details = new ProductDetails();
        if (items != null)
        {
            // get product details
            details.ProductID = items.ProductID;
            details.Name = items.Name;
            details.Description = items.Description;
            details.Price = items.Price;
            details.Thumbnail = items.Thumbnail;
            details.Image = items.ImageUrl;
            details.PromoFront = items.PromoFront;
            details.PromoDept = items.PromoDept;
        }
        // return department details
        return details;
    }

    // retrieve the list of categories in a department
    public static DataTable GetCategoriesInDepartment(string departmentId)
    {
        var items = CatalogApiClient.GetCategoriesInDepartment(departmentId); // returns List<DepartmentDto>

        // convert list to DataTable (so UI pages remain unchanged)
        var dt = new DataTable();
        dt.Columns.Add("CategoryID", typeof(int));
        dt.Columns.Add("Name", typeof(string));
        dt.Columns.Add("Description", typeof(string));

        foreach (var item in items)
        {
            dt.Rows.Add(item.CategoryID, item.Name, item.Description);
        }

        return dt;
    }

    // Retrieve the list of products on catalog promotion
    public static DataTable GetProductsOnFrontPromo(string pageNumber, out int howManyPages)
    {
        var items = CatalogApiClient.GetProducts(pageNumber, BalloonShopConfiguration.ProductsPerPage, BalloonShopConfiguration.ProductDescriptionLength, null, null, null, false, out howManyPages);

        // Convert result.Items (List<ProductDto>) to DataTable
        DataTable table = new DataTable();
        table.Columns.Add("ProductId", typeof(int));
        table.Columns.Add("Name", typeof(string));
        table.Columns.Add("Description", typeof(string));
        table.Columns.Add("Price", typeof(decimal));
        table.Columns.Add("ImageUrl", typeof(string));
        table.Columns.Add("Thumbnail", typeof(string));
        table.Columns.Add("PromoFront", typeof(bool));
        table.Columns.Add("PromoDept", typeof(bool));

        foreach (var item in items)
        {
            table.Rows.Add(item.ProductID, item.Name, item.Description, item.Price, item.ImageUrl, item.Thumbnail, item.PromoFront, item.PromoDept);
        }

        return table;
    }

    // retrieve the list of products featured for a department
    public static DataTable GetProductsOnDeptPromo
    (string departmentId, string pageNumber, out int howManyPages)
    {
        var items = CatalogApiClient.GetProducts(pageNumber, BalloonShopConfiguration.ProductsPerPage, BalloonShopConfiguration.ProductDescriptionLength, int.Parse(departmentId), null, null, false, out howManyPages);

        // Convert result.Items (List<ProductDto>) to DataTable
        DataTable table = new DataTable();
        table.Columns.Add("ProductId", typeof(int));
        table.Columns.Add("Name", typeof(string));
        table.Columns.Add("Description", typeof(string));
        table.Columns.Add("Price", typeof(decimal));
        table.Columns.Add("ImageUrl", typeof(string));
        table.Columns.Add("Thumbnail", typeof(string));
        table.Columns.Add("PromoFront", typeof(bool));
        table.Columns.Add("PromoDept", typeof(bool));

        foreach (var item in items)
        {
            table.Rows.Add(item.ProductID, item.Name, item.Description, item.Price, item.ImageUrl, item.Thumbnail, item.PromoFront, item.PromoDept);
        }

        return table;
    }

    // retrieve the list of products in a category
    public static DataTable GetProductsInCategory
    (string categoryId, string pageNumber, out int howManyPages)
    {
        var items = CatalogApiClient.GetProducts(pageNumber, BalloonShopConfiguration.ProductsPerPage, BalloonShopConfiguration.ProductDescriptionLength, null, int.Parse(categoryId), null, false, out howManyPages);

        // Convert result.Items (List<ProductDto>) to DataTable
        DataTable table = new DataTable();
        table.Columns.Add("ProductId", typeof(int));
        table.Columns.Add("Name", typeof(string));
        table.Columns.Add("Description", typeof(string));
        table.Columns.Add("Price", typeof(decimal));
        table.Columns.Add("ImageUrl", typeof(string));
        table.Columns.Add("Thumbnail", typeof(string));
        table.Columns.Add("PromoFront", typeof(bool));
        table.Columns.Add("PromoDept", typeof(bool));

        foreach (var item in items)
        {
            table.Rows.Add(item.ProductID, item.Name, item.Description, item.Price, item.ImageUrl, item.Thumbnail, item.PromoFront, item.PromoDept);
        }

        return table;
    }

    // Retrieve the list of product attributes 
    public static DataTable GetProductAttributes(string productId)
    {
        var items = CatalogApiClient.GetProductsAttributes(productId);

        // Convert result.Items (List<AttributeValueDto>) to DataTable
        DataTable table = new DataTable();
        table.Columns.Add("AttributeName", typeof(string));
        table.Columns.Add("AttributeValueId", typeof(int));
        table.Columns.Add("AttributeValue", typeof(string));

        foreach (var item in items)
        {
            table.Rows.Add(item.AttributeName, item.AttributeValueID, item.AttributeValue);
        }

        return table;
    }

    // Search the product catalog
    public static DataTable Search(string searchString, string allWords,
    string pageNumber, out int howManyPages)
    {
        var items = CatalogApiClient.GetProducts(
            pageNumber,
            BalloonShopConfiguration.ProductsPerPage,
            BalloonShopConfiguration.ProductDescriptionLength,
            null,
            null,
            searchString,
            bool.Parse(allWords),
            out howManyPages
            );

        // Convert result.Items (List<ProductDto>) to DataTable
        DataTable table = new DataTable();
        table.Columns.Add("ProductId", typeof(int));
        table.Columns.Add("Name", typeof(string));
        table.Columns.Add("Description", typeof(string));
        table.Columns.Add("Price", typeof(decimal));
        table.Columns.Add("ImageUrl", typeof(string));
        table.Columns.Add("Thumbnail", typeof(string));
        table.Columns.Add("PromoFront", typeof(bool));
        table.Columns.Add("PromoDept", typeof(bool));

        foreach (var item in items)
        {
            table.Rows.Add(item.ProductID, item.Name, item.Description, item.Price, item.ImageUrl, item.Thumbnail, item.PromoFront, item.PromoDept);
        }

        return table;
    }

    // Update department details
    public static bool UpdateDepartment(string id, string name, string description)
    {
        return CatalogApiClient.UpdateDepartment(new DepartmentDto() { DepartmentID = int.Parse(id), Description = description, Name = name });
    }

    // Delete department
    public static bool DeleteDepartment(string id)
    {
        return CatalogApiClient.DeleteDepartment(int.Parse(id));
    }

    // Add a new department
    public static bool AddDepartment(string name, string description)
    {
        return CatalogApiClient.CreateDepartment(new DepartmentDto() { Description = description, Name = name });
    }

    // Create a new Category
    public static bool CreateCategory(string departmentId,
     string name, string description)
    {
        return CatalogApiClient.CreateCategory(new CategoryDto() { DepartmentID = int.Parse(departmentId), Name = name, Description = description });
    }

    // Update category details
    public static bool UpdateCategory(string id, string name, string description)
    {
        return CatalogApiClient.UpdateCategory(new CategoryDto()
        {
            CategoryID = int.Parse(id),
            Name = name,
            Description = description
        });
    }

    // Delete Category
    public static bool DeleteCategory(string id)
    {
        return CatalogApiClient.DeleteCategory(int.Parse(id));
    }

    // retrieve the list of products in a category
    public static DataTable GetAllProductsInCategory(string categoryId)
    {
        int howManyPages;
        var items = CatalogApiClient.GetProducts("1", 200, 100, null, int.Parse(categoryId), null, false, out howManyPages);

        // Convert result.Items (List<ProductDto>) to DataTable
        DataTable table = new DataTable();
        table.Columns.Add("ProductId", typeof(int));
        table.Columns.Add("Name", typeof(string));
        table.Columns.Add("Description", typeof(string));
        table.Columns.Add("Price", typeof(decimal));
        table.Columns.Add("Image", typeof(string));
        table.Columns.Add("Thumbnail", typeof(string));
        table.Columns.Add("PromoFront", typeof(bool));
        table.Columns.Add("PromoDept", typeof(bool));

        foreach (var item in items)
        {
            table.Rows.Add(item.ProductID, item.Name, item.Description, item.Price, item.ImageUrl, item.Thumbnail, item.PromoFront, item.PromoDept);
        }

        return table;
    }

    // Create a new product
    public static bool CreateProduct(string categoryId, string name, string description, string price, string Thumbnail, string Image,
        string PromoDept, string PromoFront)
    {
        return CatalogApiClient.CreateProduct(new ProductDto()
        {
            CategoryId = int.Parse(categoryId),
            Name = name,
            Description = description,
            Price = decimal.Parse(price),
            Thumbnail = Thumbnail,
            ImageUrl = Image,
            PromoDept = bool.Parse(PromoDept),
            PromoFront = bool.Parse(PromoFront)
        });
    }

    // Update an existing product
    public static bool UpdateProduct(string productId, string name, string description, string price, string Thumbnail, string Image, 
        string PromoDept, string PromoFront)
    {
        return CatalogApiClient.UpdateProduct(new ProductDto()
        {
            ProductID = int.Parse(productId),
            Name = name,
            Description = description,
            Price = decimal.Parse(price),
            Thumbnail = Thumbnail,
            ImageUrl = Image,
            PromoDept = bool.Parse(PromoDept),
            PromoFront = bool.Parse(PromoFront)
        });
    }

    // get categories that contain a specified product
    public static DataTable GetCategoriesWithProduct(string productId)
    {
        var items = CatalogApiClient.GetProductCategories(productId);

        // convert list to DataTable (so UI pages remain unchanged)
        var dt = new DataTable();
        dt.Columns.Add("CategoryID", typeof(int));
        dt.Columns.Add("Name", typeof(string));

        foreach (var item in items)
        {
            dt.Rows.Add(item.CategoryID, item.Name);
        }

        return dt;
    }

    // get categories that do not contain a specified product
    public static DataTable GetCategoriesWithoutProduct(string productId)
    {
        // get a configured DbCommand object
        DbCommand comm = GenericDataAccess.CreateCommand();
        // set the stored procedure name
        comm.CommandText = "CatalogGetCategoriesWithoutProduct";
        // create a new parameter
        DbParameter param = comm.CreateParameter();
        param.ParameterName = "@ProductID";
        param.Value = productId;
        param.DbType = DbType.Int32;
        comm.Parameters.Add(param);
        // execute the stored procedure
        return GenericDataAccess.ExecuteSelectCommand(comm);
    }

    // assign a product to a new category
    public static bool AssignProductToCategory(string productId, string categoryId)
    {
        return CatalogApiClient.AssignProductToCategory(productId, categoryId);
    }

    // move product to a new category
    public static bool MoveProductToCategory(string productId, string oldCategoryId,
     string newCategoryId)
    {
        // get a configured DbCommand object
        DbCommand comm = GenericDataAccess.CreateCommand();
        // set the stored procedure name
        comm.CommandText = "CatalogMoveProductToCategory";
        // create a new parameter
        DbParameter param = comm.CreateParameter();
        param.ParameterName = "@ProductID";

        param.Value = productId;
        param.DbType = DbType.Int32;
        comm.Parameters.Add(param);
        // create a new parameter
        param = comm.CreateParameter();
        param.ParameterName = "@OldCategoryID";
        param.Value = oldCategoryId;
        param.DbType = DbType.Int32;
        comm.Parameters.Add(param);
        // create a new parameter
        param = comm.CreateParameter();
        param.ParameterName = "@NewCategoryID";
        param.Value = newCategoryId;
        param.DbType = DbType.Int32;
        comm.Parameters.Add(param);
        // result will represent the number of changed rows
        int result = -1;
        try
        {
            // execute the stored procedure
            result = GenericDataAccess.ExecuteNonQuery(comm);
        }
        catch
        {
            // any errors are logged in GenericDataAccess, we ignore them here
        }
        // result will be 1 in case of success 
        return (result != -1);
    }

    // removes a product from a category 
    public static bool RemoveProductFromCategory(string productId, string categoryId)
    {
        return CatalogApiClient.RemoveProductFromCategory(productId, categoryId);
    }

    // deletes a product from the product catalog
    public static bool DeleteProduct(string productId)
    {
        return CatalogApiClient.DeleteProduct(int.Parse(productId));
    }

    // gets product recommendations
    public static DataTable GetRecommendations(string productId)
    {
        // get a configured DbCommand object
        DbCommand comm = GenericDataAccess.CreateCommand();
        // set the stored procedure name
        comm.CommandText = "CatalogGetProductRecommendations";
        // create a new parameter
        DbParameter param = comm.CreateParameter();
        param.ParameterName = "@ProductID";
        param.Value = productId;
        param.DbType = DbType.Int32;
        comm.Parameters.Add(param);
        // create a new parameter
        param = comm.CreateParameter();
        param.ParameterName = "@DescriptionLength";
        param.Value = BalloonShopConfiguration.ProductDescriptionLength;
        param.DbType = DbType.Int32;
        comm.Parameters.Add(param);
        // execute the stored procedure
        return GenericDataAccess.ExecuteSelectCommand(comm);
    }

    // Gets the reviews for a specific product
    public static DataTable GetProductReviews(string productId)
    {
        // get a configured DbCommand object
        DbCommand comm = GenericDataAccess.CreateCommand();
        // set the stored procedure name
        comm.CommandText = "CatalogGetProductReviews";
        // create a new parameter
        DbParameter param = comm.CreateParameter();
        param.ParameterName = "@ProductID";
        param.Value = productId;
        param.DbType = DbType.Int32;
        comm.Parameters.Add(param);
        // execute the stored procedure
        return GenericDataAccess.ExecuteSelectCommand(comm);
    }

    // Add a new shopping cart item
    public static bool AddReview(string customerId, string productId, string review)
    {
        // get a configured DbCommand object
        DbCommand comm = GenericDataAccess.CreateCommand();
        // set the stored procedure name
        comm.CommandText = "CatalogAddProductReview ";
        // create a new parameter
        DbParameter param = comm.CreateParameter();
        param.ParameterName = "@CustomerID";
        param.Value = customerId;
        param.DbType = DbType.String;
        comm.Parameters.Add(param);
        // create a new parameter
        param = comm.CreateParameter();
        param.ParameterName = "@ProductID";
        param.Value = productId;
        param.DbType = DbType.Int32;
        comm.Parameters.Add(param);
        // create a new parameter
        param = comm.CreateParameter();
        param.ParameterName = "@Review";
        param.Value = review;
        param.DbType = DbType.String;
        comm.Parameters.Add(param);
        // returns true in case of success or false in case of an error
        try
        {
            // execute the stored procedure and return true if it executes
            // successfully, or false otherwise
            return (GenericDataAccess.ExecuteNonQuery(comm) != -1);
        }
        catch
        {
            // prevent the exception from propagating, but return false to
            // signal the error
            return false;
        }
    }
}