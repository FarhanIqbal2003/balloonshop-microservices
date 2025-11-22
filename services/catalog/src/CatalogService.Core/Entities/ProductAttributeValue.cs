namespace CatalogService.Core.Entities
{
    public class ProductAttributeValue
    {
        // composite key: ProductID + AttributeValueID
        public int ProductID { get; set; }
        public int AttributeValueID { get; set; }

        public AttributeValue? AttributeValue { get; set; }
        // Optionally, navigation to Product entity if present:
        // public Product? Product { get; set; }
    }
}