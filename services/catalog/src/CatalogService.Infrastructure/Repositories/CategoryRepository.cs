using CatalogService.Core.Entities;
using CatalogService.Core.Interfaces;
using CatalogService.Infrastructure.Data;
using Microsoft.EntityFrameworkCore;

namespace CatalogService.Infrastructure.Repositories
{
    public class CategoryRepository : ICategoryRepository
    {
        private readonly CatalogDbContext _db;

        public CategoryRepository(CatalogDbContext db)
        {
            _db = db;
        }

        public async Task<IEnumerable<Category>> GetAllAsync() =>
            await _db.Categories.AsNoTracking().ToListAsync();

        public async Task<Category?> GetByIdAsync(int id) =>
            await _db.Categories.AsNoTracking().FirstOrDefaultAsync(c => c.CategoryId == id);

        public async Task<IEnumerable<Category>> GetByDepartmentAsync(int departmentId)
        {
            return await _db.Categories
                .Where(c => c.DepartmentId == departmentId)
                .ToListAsync();
        }

        public async Task AddAsync(Category category)
        {
            _db.Categories.Add(category);
            await _db.SaveChangesAsync();
        }

        public async Task UpdateAsync(Category category)
        {
            _db.Categories.Update(category);
            await _db.SaveChangesAsync();
        }

        public async Task DeleteAsync(int id)
        {
            var existing = await _db.Categories.FindAsync(id);
            if (existing != null)
            {
                _db.Categories.Remove(existing);
                await _db.SaveChangesAsync();
            }
        }
    }
}
