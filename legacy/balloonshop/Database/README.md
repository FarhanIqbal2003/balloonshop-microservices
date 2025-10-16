# BalloonShop Database Scripts

This folder contains SQL scripts to create and populate the BalloonShop database. The scripts are organized by chapters according to the original book structure.

Original source: beg-asp.net-e-commerce-in-csharp\ASPNETEcommerce

## Chapter Organization

- Chapter 4: Basic database setup (departments)
  - 04_01_create_department.sql
  - 04_02_populate_department.sql
  - 04_03_get_departments.sql

- Chapter 5: Categories and Products
  - 05_01_create_category.sql
  - 05_02_insert_categories.sql
  - 05_03_create_product.sql
  - 05_04_insert_products.sql
  - 05_05_create_productcategory.sql
  - 05_06_populate_productcategory.sql
  - 05_07_stored_procedures.sql

- Chapter 6: Product Attributes
  - 06_01_attribute.sql
  - 06_02_attribute_value.sql
  - 06_03_product_attribute_value.sql
  - 06_04_foreign_keys.sql
  - 06_05_catalog_get_product_attribute_values.sql

- Chapter 8: Search Functionality
  - 08_01_create_fulltext.sql
  - 08_02_SearchWord.sql
  - 08_03_SearchCatalog.sql

- Chapter 11-21: Additional Features
  - Shopping Cart
  - Orders
  - Admin Features
  - Shipping
  - Tax Calculations
  - User Management

## Current Files

1. Main Schema Files:
   - BalloonShopCreate.sql
   - BalloonShopPopulate.sql
   - BalloonShopMembership.sql
   - CreateAdminUser.sql

2. Chapter-specific Files:
   - Located in the `chapters` folder, organized by chapter number

## Note

The scripts in this folder are part of the legacy monolithic BalloonShop application. As we migrate to a microservices architecture, these scripts will be gradually split and reorganized according to service boundaries.