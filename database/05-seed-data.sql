-- =====================================================
-- Seed Data Script
-- Driver License Registration & Verification System
-- =====================================================

USE DriverLicenseDB;
GO

PRINT 'Inserting seed data...';
PRINT '';

-- =====================================================
-- SEED USERS
-- =====================================================
PRINT 'Inserting sample users...';

-- Note: These are placeholder password hashes
-- You must run the fix-passwords.sql script after this to set proper BCrypt hashes
INSERT INTO Users (Username, PasswordHash, Status)
VALUES 
    ('admin', 'PLACEHOLDER_HASH_UPDATE_REQUIRED', 'active'),
    ('officer1', 'PLACEHOLDER_HASH_UPDATE_REQUIRED', 'active'),
    ('officer2', 'PLACEHOLDER_HASH_UPDATE_REQUIRED', 'active');

PRINT '  - Inserted 3 users (admin, officer1, officer2)';
PRINT '  - WARNING: Password hashes are placeholders!';
PRINT '  - Run fix-passwords.sql to set proper BCrypt hashes';
GO

-- =====================================================
-- SEED DRIVERS
-- =====================================================
PRINT '';
PRINT 'Inserting sample drivers...';

INSERT INTO Drivers (LicenseID, FullName, DateOfBirth, LicenseType, ExpiryDate, RegisteredBy, QRRawData, OCRRawText)
VALUES 
    -- Active licenses
    ('DL123456', 'Abebe Kebede', '1985-05-15', 'B', '2026-05-15', 1,
     'DL123456|Abebe Kebede|1985-05-15|2026-05-15|B',
     'DRIVER LICENSE\nDL123456\nAbebe Kebede\nDOB: 15/05/1985\nEXP: 15/05/2026\nTYPE: B'),
    
    ('DL345678', 'Dawit Assefa', '1988-03-10', 'C', '2027-03-10', 1,
     'DL345678|Dawit Assefa|1988-03-10|2027-03-10|C',
     'DRIVER LICENSE\nDL345678\nDawit Assefa\nDOB: 10/03/1988\nEXP: 10/03/2027\nTYPE: C'),
    
    ('DL901234', 'Sara Mohammed', '1992-11-25', 'B', '2025-11-25', 2,
     'DL901234|Sara Mohammed|1992-11-25|2025-11-25|B',
     'DRIVER LICENSE\nDL901234\nSara Mohammed\nDOB: 25/11/1992\nEXP: 25/11/2025\nTYPE: B'),
    
    ('DL246810', 'Tigist Haile', '1990-09-08', 'A', '2026-09-08', 2,
     'DL246810|Tigist Haile|1990-09-08|2026-09-08|A',
     'DRIVER LICENSE\nDL246810\nTigist Haile\nDOB: 08/09/1990\nEXP: 08/09/2026\nTYPE: A'),
    
    -- Expired licenses
    ('DL789012', 'Almaz Tesfaye', '1990-08-20', 'A', '2024-08-20', 1,
     'DL789012|Almaz Tesfaye|1990-08-20|2024-08-20|A',
     'DRIVER LICENSE\nDL789012\nAlmaz Tesfaye\nDOB: 20/08/1990\nEXP: 20/08/2024\nTYPE: A'),
    
    ('DL567890', 'Yohannes Bekele', '1987-07-18', 'A', '2023-07-18', 2,
     'DL567890|Yohannes Bekele|1987-07-18|2023-07-18|A',
     'DRIVER LICENSE\nDL567890\nYohannes Bekele\nDOB: 18/07/1987\nEXP: 18/07/2023\nTYPE: A');

PRINT '  - Inserted 6 sample drivers (4 active, 2 expired)';
GO

-- =====================================================
-- SEED VERIFICATION LOGS
-- =====================================================
PRINT '';
PRINT 'Inserting sample verification logs...';

INSERT INTO VerificationLogs (LicenseID, VerificationStatus, CheckedBy)
VALUES 
    ('DL123456', 'real', 1),
    ('DL789012', 'expired', 1),
    ('DL999999', 'fake', 2),
    ('DL345678', 'real', 2),
    ('DL123456', 'real', 1),
    ('DL901234', 'real', 2),
    ('DL567890', 'expired', 1),
    ('DL888888', 'fake', 1);

PRINT '  - Inserted 8 sample verification logs';
GO

-- =====================================================
-- VERIFY SEED DATA
-- =====================================================
PRINT '';
PRINT '========================================';
PRINT 'Seed data inserted successfully!';
PRINT '========================================';
PRINT '';
PRINT 'Data Summary:';
SELECT 'Users' AS TableName, COUNT(*) AS RecordCount FROM Users
UNION ALL
SELECT 'Drivers', COUNT(*) FROM Drivers
UNION ALL
SELECT 'VerificationLogs', COUNT(*) FROM VerificationLogs;
PRINT '';
PRINT '========================================';
PRINT 'IMPORTANT: Default Login Credentials';
PRINT '========================================';
PRINT 'Username: admin';
PRINT 'Password: Admin@123';
PRINT '';
PRINT 'NOTE: You must run fix-passwords.sql';
PRINT 'to generate proper BCrypt password hashes!';
PRINT '========================================';
GO
