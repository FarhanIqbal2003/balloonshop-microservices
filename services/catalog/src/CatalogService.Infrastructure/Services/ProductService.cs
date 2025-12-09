using AutoMapper;
using CatalogService.Core.DTOs;
using CatalogService.Core.Entities;
using CatalogService.Core.Exceptions;
using CatalogService.Core.Interfaces;

namespace CatalogService.Infrastructure.Services
{
    public class ProductService : IProductService
    {
        private readonly IProductRepository _repo;
        private readonly IMapper _mapper;

        public ProductService(IProductRepository repo, IMapper mapper)
        {
            _repo = repo;
            _mapper = mapper;
        }

        public async Task<IEnumerable<ProductDto>> GetAllAsync()
        {
            var products = await _repo.GetAllAsync();
            return products.Select(p => _mapper.Map<ProductDto>(p));
        }

        public async Task<ProductDto?> GetByIdAsync(int id)
        {
            var p = await _repo.GetByIdAsync(id);
            return p == null ? null : _mapper.Map<ProductDto>(p);
        }

        public async Task<ProductDto> CreateAsync(ProductDto dto)
        {
            var entity = _mapper.Map<Product>(dto);
            await _repo.AddAsync(entity, dto.CategoryId ?? 0);
            return _mapper.Map<ProductDto>(entity);
        }

        public async Task UpdateAsync(int id, ProductDto dto)
        {
            var entity = await _repo.GetByIdAsync(id);
            if (entity == null)
                throw new NotFoundException($"Product with id {id} not found.");

            entity.Name = dto.Name;
            entity.Description = dto.Description ?? "";
            entity.Price = dto.Price;
            entity.ImageUrl = dto.ImageUrl;
            entity.Thumbnail = dto.Thumbnail;
            entity.PromoFront = dto.PromoFront;
            entity.PromoDept = dto.PromoDept;

            await _repo.UpdateAsync(entity);
        }

        public async Task DeleteAsync(int id)
        {
            var entity = await _repo.GetByIdAsync(id);
            if (entity == null)
                throw new NotFoundException($"Product with id {id} not found.");

            await _repo.DeleteAsync(id);
        }
        public async Task<PagedResponse<ProductDto>> GetProductsAsync(ProductsRequest request)
        {
            var (items, totalCount) = await _repo.GetProductsAsync(
                request.PageNumber, request.PageSize, request.DescriptionLength, request.DepartmentId, 
                request.CategoryId, request.Search, request.AllWords
            );

            var dtos = items.Select(p => _mapper.Map<ProductDto>(p)).ToList();

            return new PagedResponse<ProductDto>
            {
                Items = dtos,
                TotalCount = totalCount,
                PageNumber = request.PageNumber,
                PageSize = request.PageSize
            };
        }
        public async Task<IEnumerable<AttributeValueResponse>> GetProductAttributes(int productId)
        {
            var attributeValues = await _repo.GetProductAttributes(productId);
            return attributeValues.Select(p => _mapper.Map<AttributeValueResponse>(p));
        }

        public async Task<IEnumerable<CategoryDto>> GetCategoriesForProduct(int productId)
        {
            var categories = await _repo.GetCategoriesForProduct(productId);
            return categories.Select(c => _mapper.Map<CategoryDto>(c));
        }
    }
}
