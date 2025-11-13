using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
//using System.Net.Http;
//using System.Net.Http.Json;
//using System.Threading.Tasks;


/// <summary>
/// Summary description for CatalogApiClient
/// </summary>
public class CatalogApiClient
{
    //private readonly HttpClient _client;
    private readonly string _baseUrl;

    public CatalogApiClient()
    {
        //_client = new HttpClient();
        _baseUrl = ConfigurationManager.AppSettings["CatalogService.BaseUrl"];
    }
}