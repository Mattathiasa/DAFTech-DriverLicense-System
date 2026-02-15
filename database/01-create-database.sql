-- =====================================================
-- Create Database Script
-- Driver License Registration & Verification System
-- =====================================================

USE master;
GO

-- Create database if it doesn't exist
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'DriverLicenseDB')
BEGIN
    CREATE DATABASE DriverLicenseDB;
    PRINT 'Database DriverLicenseDB created successfully.';
END
ELSE
BEGIN
    PRINT 'Database DriverLicenseDB already exists.';
END
GO

USE DriverLicenseDB;
GO

PRINT 'Switched to DriverLicenseDB database.';
GO
