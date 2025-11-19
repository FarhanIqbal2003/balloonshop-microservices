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
    public static DataTable GetProductsOnFrontPromo(string pageNumber, int pageSize, int descriptionLength, out int howManyPages)
    {
        using (var client = new WebClient())
        {
            client.BaseAddress = _baseUrl;
            client.Headers[HttpRequestHeader.ContentType] = "application/json";

            string url = "api/v1/Products/promo-front?pageNumber=" + pageNumber + "&pageSize=" + pageSize + "&descriptionLength=" + descriptionLength;

            string response = client.DownloadString(url);

            // Deserialize strongly typed DTO
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            var result = serializer.Deserialize<PromoProductsResponse>(response);

            // Calculate pages
            howManyPages = (int)Math.Ceiling((double)result.TotalCount / (double)BalloonShopConfiguration.ProductsPerPage);

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

            foreach (var item in result.Items)
            {
                table.Rows.Add(item.ProductID, item.Name, item.Description, item.Price, item.Image, item.Thumbnail, item.PromoFront, item.PromoDept);
            }
            return table;
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
    public string Image { get; set; }
    public bool PromoFront { get; set; }
    public bool PromoDept { get; set; }
}
