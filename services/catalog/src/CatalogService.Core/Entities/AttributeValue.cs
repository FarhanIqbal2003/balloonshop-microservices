namespace CatalogService.Core.Entities
{
    public class AttributeValue
    {
        public int AttributeValueID { get; set; }
        public int AttributeID { get; set; }
        public string Value { get; set; } = string.Empty;

        public AttributeEntity? Attribute { get; set; }

        // navigation to mapping table
        public ICollection<ProductAttributeValue> ProductAttributeValues { get; set; } = new List<ProductAttributeValue>();
    }
}