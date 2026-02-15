-- =====================================================
-- Constraints Script
-- Driver License Registration & Verification System
-- =====================================================

USE DriverLicenseDB;
GO

PRINT 'Adding constraints...';
PRINT '';

-- =====================================================
-- UNIQUE CONSTRAINTS
-- =====================================================
PRINT 'Adding UNIQUE constraints...';

-- Users: Username must be unique
ALTER TABLE Users
ADD CONSTRAINT UQ_Users_Username UNIQUE (Username);
PRINT '  - Added UQ_Users_Username';

-- Drivers: LicenseID must be unique
ALTER TABLE Drivers
ADD CONSTRAINT UQ_Drivers_LicenseID UNIQUE (LicenseID);
PRINT '  - Added UQ_Drivers_LicenseID';
GO

-- =====================================================
-- CHECK CONSTRAINTS
-- =====================================================
PRINT '';
PRINT 'Adding CHECK constraints...';

-- Users: Status must be 'active' or 'inactive'
ALTER TABLE Users
ADD CONSTRAINT CK_Users_Status CHECK (Status IN ('active', 'inactive'));
PRINT '  - Added CK_Users_Status';

-- Drivers: LicenseType must be valid (A, B, C, D, E)
ALTER TABLE Drivers
ADD CONSTRAINT CK_Drivers_LicenseType CHECK (LicenseType IN ('A', 'B', 'C', 'D', 'E'));
PRINT '  - Added CK_Drivers_LicenseType';

-- Drivers: ExpiryDate must be in the future at creation
ALTER TABLE Drivers
ADD CONSTRAINT CK_Drivers_ExpiryDate CHECK (ExpiryDate >= CAST(GETDATE() AS DATE));
PRINT '  - Added CK_Drivers_ExpiryDate';

-- VerificationLogs: VerificationStatus must be valid
ALTER TABLE VerificationLogs
ADD CONSTRAINT CK_VerificationLogs_Status CHECK (VerificationStatus IN ('real', 'fake', 'expired'));
PRINT '  - Added CK_VerificationLogs_Status';
GO

-- =====================================================
-- FOREIGN KEY CONSTRAINTS
-- =====================================================
PRINT '';
PRINT 'Adding FOREIGN KEY constraints...';

-- Drivers: RegisteredBy references Users
ALTER TABLE Drivers
ADD CONSTRAINT FK_Drivers_RegisteredBy 
FOREIGN KEY (RegisteredBy) REFERENCES Users(UserID)
ON DELETE NO ACTION
ON UPDATE NO ACTION;
PRINT '  - Added FK_Drivers_RegisteredBy';

-- VerificationLogs: CheckedBy references Users
ALTER TABLE VerificationLogs
ADD CONSTRAINT FK_VerificationLogs_CheckedBy 
FOREIGN KEY (CheckedBy) REFERENCES Users(UserID)
ON DELETE NO ACTION
ON UPDATE NO ACTION;
PRINT '  - Added FK_VerificationLogs_CheckedBy';
GO

-- =====================================================
-- DEFAULT CONSTRAINTS
-- =====================================================
PRINT '';
PRINT 'Default constraints already applied via table definitions:';
PRINT '  - Users.CreatedDate defaults to GETDATE()';
PRINT '  - Users.Status defaults to ''active''';
PRINT '  - Drivers.CreatedDate defaults to GETDATE()';
PRINT '  - VerificationLogs.CheckedDate defaults to GETDATE()';
GO

PRINT '';
PRINT '========================================';
PRINT 'All constraints created successfully!';
PRINT '========================================';
GO
