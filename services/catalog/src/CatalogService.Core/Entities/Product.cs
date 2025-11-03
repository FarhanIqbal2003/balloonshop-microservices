namespace CatalogService.Core.Entities
{
    public class Product
    {
        // Matches existing column "Id" in SQL
        public int Id { get; set; }

        public string Name { get; set; } = string.Empty;
        public string Description { get; set; } = string.Empty;
        public decimal Price { get; set; }
        public string? ImageUrl { get; set; }

        // New nullable FK for Category
        public int? CategoryId { get; set; }

        public Category? Category { get; set; }
    }
}
