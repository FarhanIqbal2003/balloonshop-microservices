using System;
using System.Collections.Generic;
using System.Net;
using System.Web.Script.Serialization;
using System.Configuration;

public static class CatalogApiClient
{
    private static readonly string _baseUrl = ConfigurationManager.AppSettings["CatalogService.BaseUrl"];

    public static List<DepartmentDto> GetDepartments()
    {
        using (var client = new WebClient())
        {
            try
            {
                string url = _baseUrl + "/api/catalog/departments";
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
}

public class DepartmentDto
{
    public string Name { get; set; }
    public string Description { get; set; }
}
