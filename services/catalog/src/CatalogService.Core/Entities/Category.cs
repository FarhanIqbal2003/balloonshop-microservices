namespace CatalogService.Core.Entities
{
    public class Category
    {
        public int CategoryId { get; set; }
        public int DepartmentId { get; set; }
        public string Name { get; set; } = string.Empty;
        public string? Description { get; set; }

        public Department? Department { get; set; }
        public ICollection<Product> Products { get; set; } = new List<Product>();
    }
}
