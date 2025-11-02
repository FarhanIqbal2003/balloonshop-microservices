namespace CatalogService.Core.Entities
{
    public class Department
    {
        public int DepartmentId { get; set; }
        public string Name { get; set; } = string.Empty;
        public string? Description { get; set; }

        public ICollection<Category> Categories { get; set; } = new List<Category>();
    }
}
