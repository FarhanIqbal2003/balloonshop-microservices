using AutoMapper;
using CatalogService.Core.Interfaces;
using CatalogService.Core.Services;
using CatalogService.Infrastructure.Data;
using CatalogService.Infrastructure.Mappings;
using CatalogService.Infrastructure.Repositories;
using CatalogService.Infrastructure.Services;
using Microsoft.EntityFrameworkCore;

namespace CatalogService.Api
{
    public class Startup
    {
        private readonly IConfiguration _config;
        public Startup(IConfiguration configuration) => _config = configuration;

        public void ConfigureServices(IServiceCollection services)
        {
            services.AddControllers();
            services.AddEndpointsApiExplorer();
            services.AddSwaggerGen();

            services.AddHealthChecks().AddSqlServer(_config.GetConnectionString("CatalogDb"));

            services.AddDbContext<CatalogDbContext>(opts =>
                opts.UseSqlServer(_config.GetConnectionString("CatalogDb")));

            services.AddAutoMapper(typeof(MappingProfile));

            services.AddScoped<IProductRepository, ProductRepository>();
            services.AddScoped<IDepartmentRepository, DepartmentRepository>();
            services.AddScoped<ICategoryRepository, CategoryRepository>();
            
            services.AddScoped<IProductService, ProductService>();
            services.AddScoped<IDepartmentService, DepartmentService>();
            services.AddScoped<ICategoryService, CategoryService>();
        }

        public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
        {
            if (env.IsDevelopment())
            {
                app.UseSwagger();
                app.UseSwaggerUI();
            }

            app.UseRouting();
            app.UseAuthorization();
            app.UseEndpoints(endpoints =>
            {
                endpoints.MapControllers();
                endpoints.MapHealthChecks("/health");
            });
        }
    }
}