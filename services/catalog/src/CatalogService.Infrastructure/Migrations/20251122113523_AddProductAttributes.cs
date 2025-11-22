using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace CatalogService.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class AddProductAttributes : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "Attribute",
                columns: table => new
                {
                    AttributeID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Attribute", x => x.AttributeID);
                });

            migrationBuilder.CreateTable(
                name: "AttributeValue",
                columns: table => new
                {
                    AttributeValueID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    AttributeID = table.Column<int>(type: "int", nullable: false),
                    Value = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AttributeValue", x => x.AttributeValueID);
                    table.ForeignKey(
                        name: "FK_AttributeValue_Attribute_AttributeID",
                        column: x => x.AttributeID,
                        principalTable: "Attribute",
                        principalColumn: "AttributeID",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "ProductAttributeValue",
                columns: table => new
                {
                    ProductID = table.Column<int>(type: "int", nullable: false),
                    AttributeValueID = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_ProductAttributeValue", x => new { x.ProductID, x.AttributeValueID });
                    table.ForeignKey(
                        name: "FK_ProductAttributeValue_AttributeValue_AttributeValueID",
                        column: x => x.AttributeValueID,
                        principalTable: "AttributeValue",
                        principalColumn: "AttributeValueID",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_AttributeValue_AttributeID",
                table: "AttributeValue",
                column: "AttributeID");

            migrationBuilder.CreateIndex(
                name: "IX_ProductAttributeValue_AttributeValueID",
                table: "ProductAttributeValue",
                column: "AttributeValueID");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "ProductAttributeValue");

            migrationBuilder.DropTable(
                name: "AttributeValue");

            migrationBuilder.DropTable(
                name: "Attribute");
        }
    }
}
