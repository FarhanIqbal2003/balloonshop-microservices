namespace CatalogService.Core.DTOs
{
    public class ProductDto
    {
        public int Id { get; set; }
        public string Name { get; set; } = string.Empty;
        public string? Description { get; set; }
        public decimal Price { get; set; }
        public string? ImageUrl { get; set; }
        public string? Thumbnail { get; set; }
        public bool PromoFront { get; set; }
        public bool PromoDept { get; set; }

        // Many-to-many category relationship
        public List<CategoryDto> Categories { get; set; } = new();

        // Only used for POST
        public int? CategoryId { get; set; }

        // Optional — if you want to include department info for read endpoints
        public string? DepartmentName { get; set; }
    }
}
