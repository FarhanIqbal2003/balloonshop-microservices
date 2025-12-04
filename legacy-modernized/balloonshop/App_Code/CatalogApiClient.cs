using System;
using System.Collections.Generic;
using System.Net;
using System.Web.Script.Serialization;
using System.Configuration;
using System.Data;
using AmazonEcs;

public static class CatalogApiClient
{
    private static readonly string _baseUrl = ConfigurationManager.AppSettings["CatalogServiceBaseUrl"];

    public static List<DepartmentDto> GetDepartments()
    {
        using (var client = new WebClient())
        {
            try
            {
                string url = _baseUrl + "api/v1/departments";
                string json = client.DownloadString(url);

                JavaScriptSerializer serializer = new JavaScriptSerializer();
                return serializer.Deserialize<List<DepartmentDto>>(json);
            }
            catch
            {
                return new List<DepartmentDto>(); // fail safe
            }
        }
    }
    public static DepartmentDto GetDepartmentById(int id)
    {
        using (var client = new WebClient())
        {
            client.BaseAddress = _baseUrl;
            client.Headers[HttpRequestHeader.ContentType] = "application/json";

            string response = client.DownloadString("api/v1/Departments/" + id);

            JavaScriptSerializer serializer = new JavaScriptSerializer();
            return serializer.Deserialize<DepartmentDto>(response);
        }
    }
    public static CategoryDto GetCategoryById(int id)
    {
        using (var client = new WebClient())
        {
            client.BaseAddress = _baseUrl;
            client.Headers[HttpRequestHeader.ContentType] = "application/json";

            string response = client.DownloadString("api/v1/Categories/" + id);

            JavaScriptSerializer serializer = new JavaScriptSerializer();
            return serializer.Deserialize<CategoryDto>(response);
        }
    }
    public static List<CategoryDto> GetCategoriesInDepartment(string departmentId)
    {
        using (var client = new WebClient())
        {
            client.BaseAddress = _baseUrl;

            string url = "api/v1/categories/department/"+ departmentId;
            string response = client.DownloadString(url);

            JavaScriptSerializer serializer = new JavaScriptSerializer();
            return serializer.Deserialize<List<CategoryDto>>(response);
        }
    }

    public static ProductDto GetProductById(int id)
    {
        using (var client = new WebClient())
        {
            client.BaseAddress = _baseUrl;
            client.Headers[HttpRequestHeader.ContentType] = "application/json";

            string response = client.DownloadString("api/v1/Products/" + id);

            JavaScriptSerializer serializer = new JavaScriptSerializer();
            return serializer.Deserialize<ProductDto>(response);
        }
    }
    public static List<ProductDto> GetProducts(string pageNumber, int pageSize, int descriptionLength, int? departmentId,
        int? categoryId, string search, bool allWords, out int howManyPages)
    {
        using (var client = new WebClient())
        {
            client.BaseAddress = _baseUrl;
            client.Headers[HttpRequestHeader.ContentType] = "application/json";

            string url = "api/v1/Products/filter?pageNumber=" + pageNumber + 
                "&pageSize=" + pageSize + 
                "&descriptionLength=" + descriptionLength;

            if (departmentId.HasValue)
            {
                url += "&departmentId=" + departmentId.Value;
            }
            if (categoryId.HasValue)
            {
                url += "&categoryId=" + categoryId.Value;
            }

            // Search terms
            if (!string.IsNullOrEmpty(search))
                url += "&search=" + Uri.EscapeDataString(search);

            // All-words matching
            url += "&allWords=" + allWords.ToString().ToLower();

            string response = client.DownloadString(url);

            // Deserialize strongly typed DTO
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            var result = serializer.Deserialize<PromoProductsResponse>(response);

            // Calculate pages
            howManyPages = (int)Math.Ceiling((double)result.TotalCount / (double)BalloonShopConfiguration.ProductsPerPage);

            return result.Items;
        }
    }
    public static List<AttributeValueDto> GetProductsAttributes(string productId)
    {
        using (var client = new WebClient())
        {
            client.BaseAddress = _baseUrl;
            client.Headers[HttpRequestHeader.ContentType] = "application/json";

            string url = "api/v1/Products/" + productId + "/attributes";

            string response = client.DownloadString(url);

            JavaScriptSerializer serializer = new JavaScriptSerializer();
            return serializer.Deserialize<List<AttributeValueDto>>(response);
        }
    }
}

public class PromoProductsResponse
{
    public List<ProductDto> Items { get; set; }
    public int TotalCount { get; set; }
    public int PageNumber { get; set; }
    public int PageSize { get; set; }

    public PromoProductsResponse()
    {
        Items = new List<ProductDto>();
    }
}

public class DepartmentDto
{
    public int DepartmentID { get; set; }
    public string Name { get; set; }
    public string Description { get; set; }
}

public class CategoryDto
{
    public int CategoryID { get; set; }
    public int DepartmentID { get; set; }
    public string Name { get; set; }
    public string Description { get; set; }
}

public class ProductDto
{
    public int Id { get; set; } //introduce to handle new database structure
    public int ProductID
    {
        get { return Id; }
        set { Id = value; }
    }
    public string Name { get; set; }
    public string Description { get; set; }
    public decimal Price { get; set; }
    public string Thumbnail { get; set; }
    public string ImageUrl { get; set; }
    public bool PromoFront { get; set; }
    public bool PromoDept { get; set; }
}

public class AttributeValueDto
{
    public string AttributeName { get; set; }
    public int AttributeValueID { get; set; }
    public string AttributeValue { get; set; }
}
