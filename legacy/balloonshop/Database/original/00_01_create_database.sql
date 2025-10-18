-- Create database if it doesn't exist
IF DB_ID(N'BalloonShop') IS NULL
BEGIN
    CREATE DATABASE BalloonShop;
END
GO

USE BalloonShop;
GO