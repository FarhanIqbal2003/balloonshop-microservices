using AutoMapper;
using CatalogService.Core.DTOs;
using CatalogService.Core.Entities;
using CatalogService.Core.Exceptions;
using CatalogService.Core.Interfaces;

namespace CatalogService.Core.Services
{
    public class CategoryService : ICategoryService
    {
        private readonly ICategoryRepository _repository;
        private readonly IMapper _mapper;

        public CategoryService(ICategoryRepository repository, IMapper mapper)
        {
            _repository = repository;
            _mapper = mapper;
        }

        public async Task<IEnumerable<CategoryDto>> GetAllAsync()
        {
            var categories = await _repository.GetAllAsync();
            return categories.Select(p => _mapper.Map<CategoryDto>(p));
        }

        public async Task<CategoryDto?> GetByIdAsync(int id)
        {
            var p = await _repository.GetByIdAsync(id);
            return p == null ? null : _mapper.Map<CategoryDto>(p);
        }

        public async Task<IEnumerable<CategoryDto>> GetByDepartmentAsync(int departmentId)
        {
            var categories = await _repository.GetByDepartmentAsync(departmentId);
            return categories.Select(c => _mapper.Map<CategoryDto>(c));
        }

        public async Task<CategoryDto> CreateAsync(CategoryDto dto)
        {
            var entity = _mapper.Map<Category>(dto);
            await _repository.AddAsync(entity);
            return _mapper.Map<CategoryDto>(entity);
        }

        public async Task UpdateAsync(int id, CategoryDto dto)
        {
            var entity = await _repository.GetByIdAsync(id);
            if (entity == null)
                throw new NotFoundException($"Category with id {id} not found.");

            entity.Name = dto.Name;
            entity.Description = dto.Description ?? "";

            await _repository.UpdateAsync(entity);
        }

        public async Task DeleteAsync(int id)
        {
            var existing = await _repository.GetByIdAsync(id);
            if (existing == null)
                throw new NotFoundException($"Category with id {id} not found.");

            await _repository.DeleteAsync(id);
        }
    }
}
