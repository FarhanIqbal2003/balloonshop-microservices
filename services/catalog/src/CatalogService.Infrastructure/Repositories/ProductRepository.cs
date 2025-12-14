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

        public async Task AddAsync(Product product, int categoryId)
        {            
            var category = await _db.Categories.FindAsync(categoryId);
            if (category == null)
                throw new Exception("Category not found");
            
            product.Categories.Add(category);
            
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

        public async Task<(IEnumerable<Product> Items, int TotalCount)> GetProductsAsync(
            int pageNumber, 
            int pageSize, 
            int descriptionLength,
            int? departmentId,
            int? categoryId,
            string? search,
            bool allWords)
        {
            IQueryable<Product> query = _db.Products.AsQueryable();

            if (departmentId.HasValue)
            {
                query = _db.Products.Where(p => p.PromoDept == true 
                && p.Categories.Any(c => c.DepartmentId == departmentId.Value));
            }
            else if (categoryId.HasValue)
            {
                query = _db.Products.Where(p => p.Categories.Any(c => c.CategoryId == categoryId.Value));
            }
             else if (!string.IsNullOrEmpty(search))
             {
                 var searchTerms = search.Split(' ', StringSplitOptions.RemoveEmptyEntries);
                
                if (allWords)
                {
                    foreach (var term in searchTerms)
                    {
                        query = query.Where(p => 
                            p.Name.Contains(term) || 
                            (p.Description != null && p.Description.Contains(term))
                        );
                    }
                }
                else
                {
                    query = query.Where(p => 
                        p.Name.Contains(search) || 
                        (p.Description != null && p.Description.Contains(search))
                    );
               }
                

                // Ranking / relevance ordering
                query = query.OrderByDescending(p =>
                    searchTerms.Count(term =>
                    p.Name.Contains(term) ||
                    p.Description.Contains(term)));
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
        public async Task<IEnumerable<AttributeValue>> GetProductAttributes(int productId)
        {
            var result = await _db.AttributeValues
                .Include(av => av.Attribute) // join Attribute table
                .Where(av => av.ProductAttributeValues.Any(pav => pav.ProductID == productId)
                    )
                .OrderBy(av => av.Attribute!.Name)
                .ToListAsync();

            return result;
        }
        public async Task<IEnumerable<Category>> GetCategoriesForProduct(int productId)
        {
            var categories = await _db.Categories
                .Where(c => c.Products.Any(p => p.Id == productId))
                .ToListAsync();

            return categories;
        }

        public async Task<bool> RemoveProductFromCategoryAsync(int productId, int categoryId)
        {
            // Load product + its categories
            var product = await _db.Products
                .Include(p => p.Categories)
                .FirstOrDefaultAsync(p => p.Id == productId);

            if (product == null)
                return false;

            // Find matching category
            var category = product.Categories
                .FirstOrDefault(c => c.CategoryId == categoryId);

            if (category == null)
                return false;

            // Remove from navigation collection
            product.Categories.Remove(category);

            await _db.SaveChangesAsync();
            return true;
        }
        public async Task<bool> AssignProductToCategoryAsync(int productId, int categoryId)
        {
            // load product with its category collection
            var product = await _db.Products
                .Include(p => p.Categories)
                .FirstOrDefaultAsync(p => p.Id == productId);

            if (product == null)
                return false;

            // load the category
            var category = await _db.Categories
                .FirstOrDefaultAsync(c => c.CategoryId == categoryId);

            if (category == null)
                return false;

            // check if already assigned
            if (product.Categories.Any(c => c.CategoryId == categoryId))
                return true;   // same as SP: no error if already exists

            // assign
            product.Categories.Add(category);

            await _db.SaveChangesAsync();
            return true;
        }

    }
}
