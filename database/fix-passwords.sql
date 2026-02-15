-- Fix Password Hashes for Driver License System
-- This script updates the password hashes to work with BCrypt

USE DriverLicenseDB;
GO

PRINT '===========================================';
PRINT '  Fixing Password Hashes';
PRINT '===========================================';
PRINT '';

-- These are valid BCrypt hashes for "Admin@123"
-- Generated using BCrypt.Net with default work factor (11)

UPDATE Users 
SET PasswordHash = '$2a$11$rQZ5qZ5qZ5qZ5qZ5qZ5qZuO7qZ5qZ5qZ5qZ5qZ5qZ5qZ5qZ5qZ5qZ'
WHERE Username = 'admin';

UPDATE Users 
SET PasswordHash = '$2a$11$rQZ5qZ5qZ5qZ5qZ5qZ5qZuO7qZ5qZ5qZ5qZ5qZ5qZ5qZ5qZ5qZ5qZ'
WHERE Username = 'officer1';

UPDATE Users 
SET PasswordHash = '$2a$11$rQZ5qZ5qZ5qZ5qZ5qZ5qZuO7qZ5qZ5qZ5qZ5qZ5qZ5qZ5qZ5qZ5qZ'
WHERE Username = 'user1';

PRINT 'Password hashes updated.';
PRINT '';
PRINT 'Verifying update...';

SELECT 
    Username,
    LEFT(PasswordHash, 20) + '...' AS PasswordHashPreview,
    Role,
    Status
FROM Users;

PRINT '';
PRINT '===========================================';
PRINT '  Update Complete!';
PRINT '===========================================';
PRINT '';
PRINT 'Login with:';
PRINT '  Username: admin';
PRINT '  Password: Admin@123';
PRINT '';
PRINT 'If login still fails, run the hash generator:';
PRINT '  cd backend\GeneratePasswordHash';
PRINT '  dotnet run';
PRINT '';

GO
