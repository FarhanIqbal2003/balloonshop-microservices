namespace CatalogService.Core.Entities
{
    //class name changed from Attribute to AttributeEntity to avoid conflict with System.Attribute
    public class AttributeEntity
    {
        public int AttributeID { get; set; }
        public string Name { get; set; } = string.Empty;

        public ICollection<AttributeValue> AttributeValues { get; set; } = new List<AttributeValue>();
    }
}