-- =====================================================
-- Indexes Script
-- Driver License Registration & Verification System
-- =====================================================

USE DriverLicenseDB;
GO

PRINT 'Creating indexes for performance optimization...';
PRINT '';

-- =====================================================
-- USERS TABLE INDEXES
-- =====================================================
PRINT 'Creating indexes on Users table...';

-- Index on Username for login queries
CREATE INDEX IX_Users_Username ON Users(Username);
PRINT '  - Created IX_Users_Username';

-- Index on Status for filtering active users
CREATE INDEX IX_Users_Status ON Users(Status);
PRINT '  - Created IX_Users_Status';

-- Index on CreatedDate for reporting
CREATE INDEX IX_Users_CreatedDate ON Users(CreatedDate);
PRINT '  - Created IX_Users_CreatedDate';
GO

-- =====================================================
-- DRIVERS TABLE INDEXES
-- =====================================================
PRINT '';
PRINT 'Creating indexes on Drivers table...';

-- Index on LicenseID for verification lookups (most important)
CREATE INDEX IX_Drivers_LicenseID ON Drivers(LicenseID);
PRINT '  - Created IX_Drivers_LicenseID';

-- Index on RegisteredBy for user activity tracking
CREATE INDEX IX_Drivers_RegisteredBy ON Drivers(RegisteredBy);
PRINT '  - Created IX_Drivers_RegisteredBy';

-- Index on CreatedDate for date-based queries
CREATE INDEX IX_Drivers_CreatedDate ON Drivers(CreatedDate);
PRINT '  - Created IX_Drivers_CreatedDate';

-- Index on ExpiryDate for finding expired licenses
CREATE INDEX IX_Drivers_ExpiryDate ON Drivers(ExpiryDate);
PRINT '  - Created IX_Drivers_ExpiryDate';

-- Composite index for common queries
CREATE INDEX IX_Drivers_LicenseType_ExpiryDate ON Drivers(LicenseType, ExpiryDate);
PRINT '  - Created IX_Drivers_LicenseType_ExpiryDate';
GO

-- =====================================================
-- VERIFICATIONLOGS TABLE INDEXES
-- =====================================================
PRINT '';
PRINT 'Creating indexes on VerificationLogs table...';

-- Index on LicenseID for verification history
CREATE INDEX IX_VerificationLogs_LicenseID ON VerificationLogs(LicenseID);
PRINT '  - Created IX_VerificationLogs_LicenseID';

-- Index on CheckedBy for user activity tracking
CREATE INDEX IX_VerificationLogs_CheckedBy ON VerificationLogs(CheckedBy);
PRINT '  - Created IX_VerificationLogs_CheckedBy';

-- Index on CheckedDate for date-based queries
CREATE INDEX IX_VerificationLogs_CheckedDate ON VerificationLogs(CheckedDate);
PRINT '  - Created IX_VerificationLogs_CheckedDate';

-- Index on VerificationStatus for filtering
CREATE INDEX IX_VerificationLogs_Status ON VerificationLogs(VerificationStatus);
PRINT '  - Created IX_VerificationLogs_Status';

-- Composite index for common reporting queries
CREATE INDEX IX_VerificationLogs_Status_CheckedDate ON VerificationLogs(VerificationStatus, CheckedDate);
PRINT '  - Created IX_VerificationLogs_Status_CheckedDate';
GO

PRINT '';
PRINT '========================================';
PRINT 'All indexes created successfully!';
PRINT '========================================';
PRINT '';
PRINT 'Performance optimization complete.';
GO
