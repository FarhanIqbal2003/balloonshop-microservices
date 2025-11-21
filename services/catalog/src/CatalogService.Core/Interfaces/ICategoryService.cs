using CatalogService.Core.DTOs;

namespace CatalogService.Core.Interfaces
{
    public interface ICategoryService
    {
        Task<IEnumerable<CategoryDto>> GetAllAsync();
        Task<CategoryDto?> GetByIdAsync(int id);
        Task<IEnumerable<CategoryDto>> GetByDepartmentAsync(int departmentId);
        Task<CategoryDto> CreateAsync(CategoryDto dto);
        Task UpdateAsync(int id, CategoryDto dto);
        Task DeleteAsync(int id);
    }
}
