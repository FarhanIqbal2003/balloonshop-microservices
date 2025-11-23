using AutoMapper;
using CatalogService.Core.DTOs;
using CatalogService.Core.Entities;

namespace CatalogService.Infrastructure.Mappings
{
    public class MappingProfile : Profile
    {
        public MappingProfile()
        {
            CreateMap<Product, ProductDto>().ReverseMap();
            CreateMap<Category, CategoryDto>().ReverseMap();
            CreateMap<Department, DepartmentDto>().ReverseMap();
            //CreateMap<AttributeEntity, AttributeDto>().ReverseMap();
            // CreateMap<AttributeValue, AttributeValueDto>().ReverseMap();
            // CreateMap<ProductAttributeValue, ProductAttributeValueDto>().ReverseMap();
        }
    }
}
