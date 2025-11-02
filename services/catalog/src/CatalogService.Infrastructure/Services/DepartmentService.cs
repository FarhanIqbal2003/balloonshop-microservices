using AutoMapper;
using CatalogService.Core.DTOs;
using CatalogService.Core.Entities;
using CatalogService.Core.Exceptions;
using CatalogService.Core.Interfaces;

namespace CatalogService.Core.Services
{
    public class DepartmentService : IDepartmentService
    {
        private readonly IDepartmentRepository _repository;
        private readonly IMapper _mapper;

        public DepartmentService(IDepartmentRepository repo, IMapper mapper)
        {
            _repository = repo;
            _mapper = mapper;
        }

        public async Task<IEnumerable<DepartmentDto>> GetAllAsync()
        {
            var departments = await _repository.GetAllAsync();
            return departments.Select(p => _mapper.Map<DepartmentDto>(p));
        }

        public async Task<DepartmentDto?> GetByIdAsync(int id)
        {
            
            var p = await _repository.GetByIdAsync(id);
            return p == null ? null : _mapper.Map<DepartmentDto>(p);
        }

        public async Task<DepartmentDto> CreateAsync(DepartmentDto dto)
        {
            var entity = _mapper.Map<Department>(dto);
            await _repository.AddAsync(entity);
            return _mapper.Map<DepartmentDto>(entity);
        }

        public async Task UpdateAsync(int id, DepartmentDto dto)
        {
            var entity = await _repository.GetByIdAsync(id);
            if (entity == null)
                throw new NotFoundException($"Department with id {id} not found.");

            entity.Name = dto.Name;
            entity.Description = dto.Description ?? "";

            await _repository.UpdateAsync(entity);
        }

        public async Task DeleteAsync(int id)
        {
            var existing = await _repository.GetByIdAsync(id);
            if (existing == null)
                throw new NotFoundException($"Department with id {id} not found.");

            await _repository.DeleteAsync(id);
        }
    }
}
