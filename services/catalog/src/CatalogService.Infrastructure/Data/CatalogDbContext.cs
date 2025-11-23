using CatalogService.Core.Entities;
using Microsoft.EntityFrameworkCore;

namespace CatalogService.Infrastructure.Data
{
    public class CatalogDbContext : DbContext
    {
        public CatalogDbContext(DbContextOptions<CatalogDbContext> options) : base(options) { }

        public DbSet<Product> Products { get; set; } = default!;
        public DbSet<Category> Categories { get; set; } = default!;
        public DbSet<Department> Departments { get; set; } = default!;
        public DbSet<AttributeEntity> Attributes { get; set; } = default!;
        public DbSet<AttributeValue> AttributeValues { get; set; } = default!;
        public DbSet<ProductAttributeValue> ProductAttributeValues { get; set; } = default!;

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            // Products table mapping (explicit to ensure it matches existing table)
            modelBuilder.Entity<Product>(eb =>
            {
                eb.ToTable("Products"); // existing table name
                eb.HasKey(p => p.Id);   // explicitly says Id is the PK
                eb.Property(p => p.Id).HasColumnName("Id"); // ensures EF doesn’t rename it

                eb.Property(p => p.Name).IsRequired().HasMaxLength(250);
                eb.Property(p => p.Description).IsRequired();
                eb.Property(p => p.Price).HasColumnType("decimal(18,2)");
                eb.Property(p => p.ImageUrl).HasColumnType("nvarchar(50)");
                eb.Property(p => p.Thumbnail).HasColumnType("nvarchar(50)");
                eb.Property(p => p.PromoFront).HasColumnType("bit");
                eb.Property(p => p.PromoDept).HasColumnType("bit");
            });
            modelBuilder.Entity<Category>(eb =>
            {
                eb.ToTable("Categories");
                eb.HasKey(c => c.CategoryId);
                eb.Property(c => c.Name).IsRequired().HasMaxLength(250);
                eb.Property(c => c.Description).HasColumnType("nvarchar(max)");
                eb.HasOne(c => c.Department)
                  .WithMany(d => d.Categories)
                  .HasForeignKey(c => c.DepartmentId)
                  .OnDelete(DeleteBehavior.Cascade);
            });

            modelBuilder.Entity<Department>(eb =>
            {
                eb.ToTable("Departments");
                eb.HasKey(d => d.DepartmentId);
                eb.Property(d => d.Name).IsRequired().HasMaxLength(250);
                eb.Property(d => d.Description).HasColumnType("nvarchar(max)");
            });

            modelBuilder.Entity<Product>()
            .HasMany(p => p.Categories)
            .WithMany(c => c.Products)
            .UsingEntity(j => j.ToTable("ProductCategories"));
        

        // Attribute
            modelBuilder.Entity<AttributeEntity>(b =>
            {
                b.ToTable("Attribute");
                b.HasKey(x => x.AttributeID);
                b.Property(x => x.AttributeID).HasColumnName("AttributeID");
                b.Property(x => x.Name)
                 .HasMaxLength(100)
                 .IsRequired()
                 .HasColumnName("Name");
                b.HasMany(a => a.AttributeValues)
                 .WithOne(av => av.Attribute!)
                 .HasForeignKey(av => av.AttributeID)
                 .OnDelete(DeleteBehavior.Cascade);
            });

            // AttributeValue
            modelBuilder.Entity<AttributeValue>(b =>
            {
                b.ToTable("AttributeValue");
                b.HasKey(x => x.AttributeValueID);
                b.Property(x => x.AttributeValueID).HasColumnName("AttributeValueID");
                b.Property(x => x.AttributeID).HasColumnName("AttributeID");
                b.Property(x => x.Value)
                 .HasMaxLength(100)
                 .IsRequired()
                 .HasColumnName("Value");
            });

            // ProductAttributeValue (bridge)
            modelBuilder.Entity<ProductAttributeValue>(b =>
            {
                b.ToTable("ProductAttributeValue");
                // composite primary key
                b.HasKey(x => new { x.ProductID, x.AttributeValueID });

                b.Property(x => x.ProductID).HasColumnName("ProductID");
                b.Property(x => x.AttributeValueID).HasColumnName("AttributeValueID");

                b.HasOne(pav => pav.AttributeValue)
                 .WithMany(av => av.ProductAttributeValues)
                 .HasForeignKey(pav => pav.AttributeValueID)
                 .OnDelete(DeleteBehavior.Cascade);

                // If you have ProductEntity in the model, configure the FK here:
                // b.HasOne(pav => pav.Product)
                //  .WithMany(p => p.ProductAttributeValues)
                //  .HasForeignKey(pav => pav.ProductID);
            });          
        }
    }
}
