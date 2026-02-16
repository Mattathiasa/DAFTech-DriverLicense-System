using DAFTech.DriverLicenseSystem.Api.Models.Entities;
using DAFTech.DriverLicenseSystem.Api.Models.DTOs;
using DAFTech.DriverLicenseSystem.Api.Repositories;

namespace DAFTech.DriverLicenseSystem.Api.Services;

public class DriverService
{
    private readonly DriverRepository _driverRepository;

    public DriverService(DriverRepository driverRepository)
    {
        _driverRepository = driverRepository;
    }

    public async Task<Driver> RegisterDriver(DriverRegistrationDto dto, int registeredByUserId)
    {
        var driver = new Driver
        {
            LicenseId = dto.LicenseId,
            FullName = dto.FullName,
            DateOfBirth = dto.DateOfBirth,
            LicenseType = dto.LicenseType,
            ExpiryDate = dto.ExpiryDate,
            QRRawData = dto.QRRawData,
            OCRRawText = dto.OCRRawText,
            RegisteredBy = registeredByUserId,
            CreatedDate = DateTime.UtcNow
        };

        return await _driverRepository.Create(driver);
    }

    public async Task<IEnumerable<DriverDto>> GetAllDrivers()
    {
        var drivers = await _driverRepository.GetAll();
        
        // Map to DTO to avoid circular references
        return drivers.Select(d => new DriverDto
        {
            DriverId = d.DriverId,
            LicenseId = d.LicenseId,
            FullName = d.FullName,
            DateOfBirth = d.DateOfBirth,
            LicenseType = d.LicenseType,
            ExpiryDate = d.ExpiryDate,
            QRRawData = d.QRRawData,
            OCRRawText = d.OCRRawText,
            CreatedDate = d.CreatedDate,
            RegisteredBy = d.RegisteredBy,
            Status = DetermineStatus(d.ExpiryDate),
            RegisteredByUsername = d.RegisteredByUser?.Username ?? "Unknown"
        });
    }

    public async Task<DriverDto?> GetDriverByLicenseId(string licenseId)
    {
        var driver = await _driverRepository.GetByLicenseId(licenseId);
        
        if (driver == null)
            return null;

        // Map to DTO to avoid circular references
        return new DriverDto
        {
            DriverId = driver.DriverId,
            LicenseId = driver.LicenseId,
            FullName = driver.FullName,
            DateOfBirth = driver.DateOfBirth,
            LicenseType = driver.LicenseType,
            ExpiryDate = driver.ExpiryDate,
            QRRawData = driver.QRRawData,
            OCRRawText = driver.OCRRawText,
            CreatedDate = driver.CreatedDate,
            RegisteredBy = driver.RegisteredBy,
            Status = DetermineStatus(driver.ExpiryDate),
            RegisteredByUsername = driver.RegisteredByUser?.Username ?? "Unknown"
        };
    }

    private static string DetermineStatus(DateTime expiryDate)
    {
        return expiryDate >= DateTime.UtcNow ? "active" : "expired";
    }

    public async Task<bool> LicenseExists(string licenseId)
    {
        return await _driverRepository.ExistsByLicenseId(licenseId);
    }
}
