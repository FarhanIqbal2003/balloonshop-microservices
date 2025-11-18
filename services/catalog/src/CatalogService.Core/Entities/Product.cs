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
        public string? Thumbnail { get; set; }
        public bool? PromoFront { get; set; }
        public bool? PromoDept { get; set; }
        
        public ICollection<Category> Categories { get; set; } = new List<Category>();
    }
}
