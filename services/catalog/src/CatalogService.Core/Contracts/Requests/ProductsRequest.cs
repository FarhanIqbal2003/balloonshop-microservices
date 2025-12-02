public class ProductsRequest
{
    public int PageNumber { get; set; } = 1;
    public int PageSize { get; set; } = 12;
    public int DescriptionLength { get; set; } = 120;

    public int? DepartmentId { get; set; }
    public int? CategoryId { get; set; }
    public string? Search { get; set; }
    public bool AllWords { get; set; } = false;
}
