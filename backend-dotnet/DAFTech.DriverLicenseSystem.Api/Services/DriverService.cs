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

    public async Task<IEnumerable<Driver>> GetAllDrivers()
    {
        return await _driverRepository.GetAll();
    }

    public async Task<Driver?> GetDriverByLicenseId(string licenseId)
    {
        return await _driverRepository.GetByLicenseId(licenseId);
    }

    public async Task<bool> LicenseExists(string licenseId)
    {
        return await _driverRepository.ExistsByLicenseId(licenseId);
    }
}
