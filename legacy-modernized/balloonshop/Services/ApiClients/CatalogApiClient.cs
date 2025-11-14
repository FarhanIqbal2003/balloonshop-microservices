using System;
using System.Collections.Generic;
using System.Configuration;
using System.Net;
using System.IO;
using System.Web.Script.Serialization;


/// <summary>
/// Summary description for CatalogApiClient
/// </summary>

/// <summary>
/// Summary description for CatalogApiClient
/// </summary>
public class CatalogApiClient
{
    private readonly string _baseUrl;

    public CatalogApiClient()
    {
        _baseUrl = ConfigurationManager.AppSettings["CatalogService.BaseUrl"];
    }

    public List<ProductDto> GetProducts()
    {
        var url = _baseUrl + "/api/catalog";
        using (var client = new WebClient())
        {
            client.Headers[HttpRequestHeader.ContentType] = "application/json";

            try
            {
                var json = client.DownloadString(url);
                var serializer = new JavaScriptSerializer();
                return serializer.Deserialize<List<ProductDto>>(json);
            }
            catch //(Exception ex)
            {
                // Log exception
                return new List<ProductDto>();
            }
        }
    }
}
public class ProductDto
{
    public int Id { get; set; }
    public string Name { get; set; }
    public decimal Price { get; set; }
}