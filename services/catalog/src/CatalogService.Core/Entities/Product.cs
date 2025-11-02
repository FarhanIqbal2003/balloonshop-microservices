namespace CatalogService.Core.Entities
{
    public class Product
    {
        public int ProductId { get; set; }            // matches [ProductID]
        public string Name { get; set; } = string.Empty;
        public string Description { get; set; } = string.Empty;
        public decimal Price { get; set; }            // maps from [money] to decimal
        public string? Thumbnail { get; set; }        // maps [Thumbnail]
        public string? Image { get; set; }            // maps [Image]
        public bool PromoFront { get; set; }          // maps [PromoFront]
        public bool PromoDept { get; set; }           // maps [PromoDept]

        // 🧩 Navigation (added for EF relationships)
        public int? CategoryId { get; set; }          // optional; might not exist in DB yet
        public Category? Category { get; set; }
    }
}
