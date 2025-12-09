using CatalogService.Core.Entities;

namespace CatalogService.Core.Interfaces
{
    public interface IProductRepository
    {
        Task<IEnumerable<Product>> GetAllAsync();
        Task<Product?> GetByIdAsync(int id);
        Task AddAsync(Product product, int categoryId);
        Task UpdateAsync(Product product);
        Task DeleteAsync(int id);
        // New method for promo-front products
        Task<(IEnumerable<Product> Items, int TotalCount)> GetProductsAsync(
            int pageNumber, 
            int pageSize, 
            int descriptionLength,
            int? departmentId,
            int? categoryId,
            string? search,
            bool allWords
        );
        Task<IEnumerable<AttributeValue>> GetProductAttributes(int productId);
    }
}
