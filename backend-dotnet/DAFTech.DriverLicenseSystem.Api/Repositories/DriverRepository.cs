using DAFTech.DriverLicenseSystem.Api.Data;
using DAFTech.DriverLicenseSystem.Api.Models.Entities;
using Microsoft.EntityFrameworkCore;

namespace DAFTech.DriverLicenseSystem.Api.Repositories;

public class DriverRepository
{
    private readonly ApplicationDbContext _context;

    public DriverRepository(ApplicationDbContext context)
    {
        _context = context;
    }

    public async Task<Driver?> GetByLicenseId(string licenseId)
    {
        return await _context.Drivers
            .Include(d => d.RegisteredByUser)
            .FirstOrDefaultAsync(d => d.LicenseId == licenseId);
    }

    public async Task<Driver?> GetById(int driverId)
    {
        return await _context.Drivers
            .Include(d => d.RegisteredByUser)
            .FirstOrDefaultAsync(d => d.DriverId == driverId);
    }

    public async Task<IEnumerable<Driver>> GetAll()
    {
        return await _context.Drivers
            .Include(d => d.RegisteredByUser)
            .OrderByDescending(d => d.CreatedDate)
            .ToListAsync();
    }

    public async Task<Driver> Create(Driver driver)
    {
        _context.Drivers.Add(driver);
        await _context.SaveChangesAsync();
        return driver;
    }

    public async Task<bool> ExistsByLicenseId(string licenseId)
    {
        return await _context.Drivers
            .AnyAsync(d => d.LicenseId == licenseId);
    }
}
