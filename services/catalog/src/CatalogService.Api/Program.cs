using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.DependencyInjection;
using CatalogService.Infrastructure.Data; // ✅ adjust namespace where CatalogDbContext is located
using Microsoft.EntityFrameworkCore;

namespace CatalogService.Api
{
    public class Program
    {
        public static void Main(string[] args)
        {
            var host = CreateHostBuilder(args).Build();

            // ✅ Apply pending migrations automatically at startup
            using (var scope = host.Services.CreateScope())
            {
                var services = scope.ServiceProvider;
                try
                {
                    var context = services.GetRequiredService<CatalogDbContext>();
                    context.Database.Migrate(); // 👈 runs pending migrations if DB exists
                }
                catch (Exception ex)
                {
                    Console.WriteLine($"Migration failed: {ex.Message}");
                    throw;
                }
            }

            host.Run();
        }

        public static IHostBuilder CreateHostBuilder(string[] args) =>
            Host.CreateDefaultBuilder(args)
                .ConfigureWebHostDefaults(webBuilder =>
                {
                    webBuilder.UseStartup<Startup>();
                });
    }
}
