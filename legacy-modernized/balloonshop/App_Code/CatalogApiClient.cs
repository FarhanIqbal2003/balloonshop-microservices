using System;
using System.Collections.Generic;
using System.Net;
using System.Web.Script.Serialization;
using System.Configuration;

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
}

public class DepartmentDto
{
    public int DepartmentID { get; set; }
    public string Name { get; set; }
    public string Description { get; set; }
}

public class CategoryDto { 
    public int CategoryID { get; set; }
    public int DepartmentID { get; set; }
    public string Name { get; set; }
    public string Description { get; set; }
}

public class ProductDto { 
    public int ProductID { get; set; }
    public string Name { get; set; }
    public string Description { get; set; } 
    public decimal Price { get; set; }
    public string Thumbnail { get; set; }
    public string Image { get; set; }
    public bool PromoFront { get; set; }
    public bool PromoDept { get; set; }
}
