using CatalogService.Core.Entities;
using CatalogService.Core.Interfaces;
using CatalogService.Infrastructure.Data;
using Microsoft.EntityFrameworkCore;

namespace CatalogService.Infrastructure.Repositories
{
    public class DepartmentRepository : IDepartmentRepository
    {
        private readonly CatalogDbContext _db;

        public DepartmentRepository(CatalogDbContext db)
        {
            _db = db;
        }

        public async Task<IEnumerable<Department>> GetAllAsync() =>
            await _db.Departments.AsNoTracking().ToListAsync();

        public async Task<Department?> GetByIdAsync(int id) =>
            await _db.Departments.AsNoTracking().FirstOrDefaultAsync(d => d.DepartmentId == id);

        public async Task AddAsync(Department department)
        {
            _db.Departments.Add(department);
            await _db.SaveChangesAsync();
        }

        public async Task UpdateAsync(Department department)
        {
            _db.Departments.Update(department);
            await _db.SaveChangesAsync();
        }

        public async Task DeleteAsync(int id)
        {
            var existing = await _db.Departments.FindAsync(id);
            if (existing != null)
            {
                _db.Departments.Remove(existing);
                await _db.SaveChangesAsync();
            }
        }

    }
}