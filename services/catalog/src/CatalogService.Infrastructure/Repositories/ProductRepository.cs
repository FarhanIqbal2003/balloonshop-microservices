using CatalogService.Core.Entities;
using CatalogService.Core.Interfaces;
using CatalogService.Infrastructure.Data;
using Microsoft.EntityFrameworkCore;

namespace CatalogService.Infrastructure.Repositories
{
    public class ProductRepository : IProductRepository
    {
        private readonly CatalogDbContext _db;

        public ProductRepository(CatalogDbContext db)
        {
            _db = db;
        }

        public async Task<IEnumerable<Product>> GetAllAsync() =>
            await _db.Products.AsNoTracking().ToListAsync();

        public async Task<Product?> GetByIdAsync(int id) =>
            await _db.Products.AsNoTracking().FirstOrDefaultAsync(p => p.Id == id);

        public async Task AddAsync(Product product)
        {
            _db.Products.Add(product);
            await _db.SaveChangesAsync();
        }

        public async Task UpdateAsync(Product product)
        {
            _db.Products.Update(product);
            await _db.SaveChangesAsync();
        }

        public async Task DeleteAsync(int id)
        {
            var existing = await _db.Products.FindAsync(id);
            if (existing != null)
            {
                _db.Products.Remove(existing);
                await _db.SaveChangesAsync();
            }
        }

        public async Task<(IEnumerable<Product> Items, int TotalCount)> GetPromoFrontAsync(
            int pageNumber, 
            int pageSize, 
            int descriptionLength,
            int? departmentId)
        {
            IQueryable<Product> query;

            if (departmentId.HasValue)
            {
                query = _db.Products.Where(p => p.PromoDept == true 
                && p.Categories.Any(c => c.DepartmentId == departmentId.Value));
            }
            else
            {
                query = _db.Products.Where(p => p.PromoFront == true);
            }
            var totalCount = await query.CountAsync();

            var items = await query
                .OrderBy(p => p.Id)
                .Skip((pageNumber - 1) * pageSize)
                .Take(pageSize)
                .ToListAsync();

            // Truncate descriptions here if needed
            foreach (var product in items)
            {
                if (!string.IsNullOrEmpty(product.Description) && product.Description.Length > descriptionLength)
                {
                    product.Description = product.Description.Substring(0, descriptionLength) + "...";
                }
            }

            return (items, totalCount);
        }


    }
}
