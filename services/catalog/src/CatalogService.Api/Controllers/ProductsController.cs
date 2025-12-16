using Microsoft.AspNetCore.Mvc;
using CatalogService.Core.Interfaces;
using CatalogService.Core.DTOs;
using CatalogService.Core.Exceptions;

namespace CatalogService.Api.Controllers
{
    [ApiController]
    [Route("api/v1/[controller]")]
    public class ProductsController : ControllerBase
    {
        private readonly IProductService _service;

        public ProductsController(IProductService service)
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

        [HttpGet("filter")]
        [ProducesResponseType(typeof(PagedResponse<ProductDto>), StatusCodes.Status200OK)]
        public async Task<IActionResult> GetProducts([FromQuery] ProductsRequest request)
        {
            var response = await _service.GetProductsAsync(request);
            return Ok(response);
        }

        // GET: api/products/{productId}/attributes
        [HttpGet("{productId}/attributes")]
        public async Task<IActionResult> GetProductAttributes(int productId)
        {
            var attributes = await _service.GetProductAttributes(productId);

            if (attributes == null || !attributes.Any())
            {
                return NotFound($"No attributes found for product ID: {productId}");
            }

            return Ok(attributes);
        }

        [HttpGet("{productId}/categories")]
        public async Task<IActionResult> GetCategoriesForProduct(int productId)
        {
            var result = await _service.GetCategoriesForProduct(productId);

            if (result == null || !result.Any())
                return NotFound($"No categories found for product {productId}");

            return Ok(result);
        }


        [HttpPost]
        public async Task<IActionResult> Create(ProductDto dto)
        {
            var created = await _service.CreateAsync(dto);
            return CreatedAtAction(nameof(Get), new { id = created.Id }, created);
        }

        [HttpPost("api/v1/products/{productId}/categories/{categoryId}")]
        public async Task<IActionResult> AssignProductToCategory(
    int productId, int categoryId)
        {
            await _service.AssignProductToCategoryAsync(productId, categoryId);
            return NoContent();
        }


        [HttpPut("{id:int}")]
        public async Task<IActionResult> Update(int id, ProductDto dto)
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

        [HttpDelete("{productId}/categories/{categoryId}")]
        public async Task<IActionResult> RemoveProductFromCategory(int productId, int categoryId)
        {
            await _service.RemoveProductFromCategoryAsync(productId, categoryId);
            return NoContent();
        }
        [HttpGet("{productId}/categories/unassigned")]
        public async Task<IActionResult> GetUnassignedCategories(int productId)
        {
            var categories = await _service.GetCategoriesWithoutProductAsync(productId);
            return Ok(categories);
        }

        [HttpPut("{productId}/categories/move")]
        public async Task<IActionResult> MoveProductToCategory(int productId, [FromBody] MoveProductCategoryRequest request)
        {
            await _service.MoveProductToCategoryAsync(productId, request.OldCategoryId, request.NewCategoryId);
            return NoContent();
        }
        public class MoveProductCategoryRequest
        {
            public int OldCategoryId { get; set; }
            public int NewCategoryId { get; set; }
        }
    }
}
