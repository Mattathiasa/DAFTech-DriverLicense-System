using DAFTech.DriverLicenseSystem.Api.Models.Entities;
using DAFTech.DriverLicenseSystem.Api.Models.DTOs;
using DAFTech.DriverLicenseSystem.Api.Repositories;
using DAFTech.DriverLicenseSystem.Api.Data;
using Microsoft.EntityFrameworkCore;

namespace DAFTech.DriverLicenseSystem.Api.Services;

public class VerificationService
{
    private readonly DriverRepository _driverRepository;
    private readonly ApplicationDbContext _context;

    public VerificationService(
        DriverRepository driverRepository,
        ApplicationDbContext context)
    {
        _driverRepository = driverRepository;
        _context = context;
    }

    public async Task<VerificationResponseDto> VerifyLicense(string licenseId, string qrRawData, int checkedByUserId)
    {
        var driver = await _driverRepository.GetByLicenseId(licenseId);

        if (driver == null)
        {
            await LogVerification(licenseId, "fake", checkedByUserId);
            
            return new VerificationResponseDto
            {
                LicenseId = licenseId,
                VerificationStatus = "fake",
                DriverName = null,
                ExpiryDate = null,
                CheckedDate = DateTime.UtcNow
            };
        }

        // Compare QR data
        if (!string.IsNullOrEmpty(qrRawData) && !string.IsNullOrEmpty(driver.QRRawData) && 
            !CompareQRData(qrRawData, driver.QRRawData))
        {
            await LogVerification(licenseId, "fake", checkedByUserId);
            
            return new VerificationResponseDto
            {
                LicenseId = licenseId,
                VerificationStatus = "fake",
                DriverName = driver.FullName,
                ExpiryDate = driver.ExpiryDate,
                CheckedDate = DateTime.UtcNow
            };
        }

        // Check expiry status
        bool isExpired = driver.ExpiryDate < DateTime.UtcNow.Date;
        string status = isExpired ? "expired" : "real";

        await LogVerification(licenseId, status, checkedByUserId);

        return new VerificationResponseDto
        {
            LicenseId = licenseId,
            VerificationStatus = status,
            DriverName = driver.FullName,
            ExpiryDate = driver.ExpiryDate,
            CheckedDate = DateTime.UtcNow
        };
    }

    private bool CompareQRData(string scannedQR, string storedQR)
    {
        if (string.IsNullOrWhiteSpace(scannedQR) || string.IsNullOrWhiteSpace(storedQR))
            return false;

        return scannedQR.Trim().Equals(storedQR.Trim(), StringComparison.OrdinalIgnoreCase);
    }

    private async Task LogVerification(string licenseId, string verificationStatus, int checkedByUserId)
    {
        var log = new VerificationLog
        {
            LicenseId = licenseId,
            VerificationStatus = verificationStatus,
            CheckedBy = checkedByUserId,
            CheckedDate = DateTime.UtcNow
        };

        _context.VerificationLogs.Add(log);
        await _context.SaveChangesAsync();
    }
}
