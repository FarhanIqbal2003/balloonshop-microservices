using Microsoft.AspNetCore.Mvc;
using CatalogService.Core.Interfaces;
using CatalogService.Core.DTOs;
using CatalogService.Core.Exceptions;

namespace CatalogService.Api.Controllers
{
    [ApiController]
    [Route("api/v1/[controller]")]
    public class CategoriesController : ControllerBase
    {
        private readonly ICategoryService _service;

        public CategoriesController(ICategoryService service)
        {
            _service = service;
        }

        [HttpGet]
        public async Task<IActionResult> GetAll() =>
            Ok(await _service.GetAllAsync());

        [HttpGet("{id:int}")]
        public async Task<IActionResult> Get(int id)
        {
            var result = await _service.GetByIdAsync(id);
            if (result == null)
                return NotFound();
            return Ok(result);
        }

        [HttpGet("department/{departmentId:int}")]
        public async Task<IActionResult> GetByDepartment(int departmentId)
        {
            var result = await _service.GetByDepartmentAsync(departmentId);

            if (result == null || !result.Any())
                return NotFound("No categories found for this department.");

            return Ok(result);
        }


        [HttpPost]
        public async Task<IActionResult> Create(CategoryDto dto)
        {
            var created = await _service.CreateAsync(dto);
            return CreatedAtAction(nameof(Get), new { id = created.CategoryId }, created);
        }

        [HttpPut("{id:int}")]
        public async Task<IActionResult> Update(int id, CategoryDto dto)
        {
            try
            {
                await _service.UpdateAsync(id, dto);
                return NoContent();
            }
            catch (NotFoundException ex)
            {
                return NotFound(ex.Message);
            }
        }

        [HttpDelete("{id:int}")]
        public async Task<IActionResult> Delete(int id)
        {
            try
            {
                await _service.DeleteAsync(id);
                return NoContent();
            }
            catch (NotFoundException ex)
            {
                return NotFound(ex.Message);
            }
        }
    }
}
