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
            await _db.Products.AsNoTracking().FirstOrDefaultAsync(p => p.ProductId == id);

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
    }
}
