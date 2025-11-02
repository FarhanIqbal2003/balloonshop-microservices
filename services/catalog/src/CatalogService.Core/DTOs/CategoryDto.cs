public class CategoryDto
{
    public int CategoryId { get; set; }
    public int DepartmentId { get; set; }
    public string Name { get; set; } = string.Empty;
    public string? Description { get; set; }

    // Optional: if you want to include department info inline
    public DepartmentDto? Department { get; set; }
}
