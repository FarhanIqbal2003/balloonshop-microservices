using CatalogService.Core.Entities;

namespace CatalogService.Core.Interfaces
{
    public interface IProductRepository
    {
        Task<IEnumerable<Product>> GetAllAsync();
        Task<Product?> GetByIdAsync(int id);
        Task AddAsync(Product product);
        Task UpdateAsync(Product product);
        Task DeleteAsync(int id);
        // New method for promo-front products
        Task<(IEnumerable<Product> Items, int TotalCount)> GetPromoFrontAsync(
            int pageNumber, 
            int pageSize, 
            int descriptionLength,
            int? departmentId
        );
    }
}
