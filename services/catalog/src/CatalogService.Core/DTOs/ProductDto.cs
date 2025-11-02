namespace CatalogService.Core.DTOs
{
    public class ProductDto
    {
        public int Id { get; set; }
        public string Name { get; set; } = string.Empty;
        public string? Description { get; set; }
        public decimal Price { get; set; }
        public string? ImageUrl { get; set; }

        // 🔹 Relationship fields
        public int CategoryId { get; set; }

        // Optional — to include category info in responses
        public string? CategoryName { get; set; }

        // Optional — if you want to include department info for read endpoints
        public string? DepartmentName { get; set; }
    }
}
