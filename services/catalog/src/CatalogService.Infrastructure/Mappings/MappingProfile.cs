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
            CreateMap<AttributeValue, AttributeValueResponse>()
            .ForMember(dest => dest.AttributeValueID, opt => opt.MapFrom(src => src.AttributeValueID))
            .ForMember(dest => dest.AttributeValue, opt => opt.MapFrom(src => src.Value))
            .ForMember(dest => dest.AttributeName, opt => opt.MapFrom(src => src.Attribute != null ? src.Attribute.Name : string.Empty));
            //CreateMap<AttributeEntity, AttributeDto>().ReverseMap();
            //CreateMap<AttributeValue, AttributeValueDto>().ReverseMap();
            // CreateMap<ProductAttributeValue, ProductAttributeValueDto>().ReverseMap();
        }
    }
}
