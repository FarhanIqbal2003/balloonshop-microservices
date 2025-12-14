using CatalogService.Core.DTOs;

namespace CatalogService.Core.Interfaces
{
    public interface IProductService
    {
        Task<IEnumerable<ProductDto>> GetAllAsync();
        Task<ProductDto?> GetByIdAsync(int id);
        Task<ProductDto> CreateAsync(ProductDto dto);
        Task UpdateAsync(int id, ProductDto dto);
        Task DeleteAsync(int id);
        Task RemoveProductFromCategoryAsync(int productId, int categoryId);
        
        // New method for promo front listing
        Task<PagedResponse<ProductDto>> GetProductsAsync(ProductsRequest request);
        Task<IEnumerable<AttributeValueResponse>> GetProductAttributes(int productId);
        Task<IEnumerable<CategoryDto>> GetCategoriesForProduct(int productId);
        Task AssignProductToCategoryAsync(int productId, int categoryId);
    }
}
