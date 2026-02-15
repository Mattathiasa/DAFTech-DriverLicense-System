-- Template for Adding Admin Users
-- 
-- INSTRUCTIONS:
-- 1. Make sure the API is running: cd backend\DriverLicenseSystem.API && dotnet run
-- 2. Generate password hash using PowerShell:
--    Invoke-RestMethod -Uri "http://localhost:5182/api/auth/register" -Method Post -Body '{"username":"temp","password":"YOUR_PASSWORD","fullName":"Temp","role":"admin"}' -ContentType "application/json" | Select -ExpandProperty data | Select -ExpandProperty passwordHash
-- 3. Copy the hash and paste it below
-- 4. Update the username, fullname, and role
-- 5. Execute this script in SSMS

USE DriverLicenseDB;
GO

-- Example: Add admin user
-- Replace the values below with your actual data
INSERT INTO Users (Username, PasswordHash, FullName, Role, Status)
VALUES (
    'john.admin',                                                           -- Username
    '$2a$11$PASTE_YOUR_GENERATED_HASH_HERE',                               -- Password Hash (generate using API)
    'John Administrator',                                                   -- Full Name
    'admin',                                                                -- Role: 'admin', 'officer', or 'user'
    'active'                                                                -- Status: 'active' or 'inactive'
);
GO

-- Verify the user was created
SELECT Username, FullName, Role, Status, CreatedDate 
FROM Users 
WHERE Username = 'john.admin';
GO

-- To add more users, copy the INSERT statement above and modify the values
