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
        
        // New method for promo front listing
        Task<PagedResponse<ProductDto>> GetPromoFrontAsync(PromoProductsRequest request);
    }
}
