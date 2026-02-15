using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using DAFTech.DriverLicenseSystem.Api.Models.DTOs;
using DAFTech.DriverLicenseSystem.Api.Services;
using DAFTech.DriverLicenseSystem.Api.Helpers;
using System.Security.Claims;

namespace DAFTech.DriverLicenseSystem.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class DriverController : ControllerBase
{
    private readonly DriverService _driverService;
    private readonly ILogger<DriverController> _logger;

    public DriverController(
        DriverService driverService,
        ILogger<DriverController> logger)
    {
        _driverService = driverService;
        _logger = logger;
    }

    [HttpGet]
    public async Task<ActionResult> GetAllDrivers()
    {
        try
        {
            _logger.LogInformation("Fetching all drivers");

            var drivers = await _driverService.GetAllDrivers();

            return ApiResponseHandler.Success(drivers, $"Retrieved {drivers.Count()} drivers");
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error fetching all drivers");
            return ApiResponseHandler.Error("An error occurred while fetching drivers");
        }
    }

    [HttpGet("{licenseId}")]
    public async Task<ActionResult> GetDriver(string licenseId)
    {
        try
        {
            _logger.LogInformation("Fetching driver with license ID: {LicenseId}", licenseId);

            var driver = await _driverService.GetDriverByLicenseId(licenseId);

            if (driver == null)
            {
                return ApiResponseHandler.NotFound($"No driver found with license ID: {licenseId}");
            }

            return ApiResponseHandler.Success(driver, "Driver retrieved successfully");
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error fetching driver with license ID: {LicenseId}", licenseId);
            return ApiResponseHandler.Error("An error occurred while fetching driver");
        }
    }

    [HttpPost("register")]
    public async Task<ActionResult> RegisterDriver([FromBody] DriverRegistrationDto request)
    {
        try
        {
            var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            if (string.IsNullOrEmpty(userIdClaim) || !int.TryParse(userIdClaim, out int userId))
            {
                return ApiResponseHandler.Unauthorized("Invalid user authentication");
            }

            _logger.LogInformation("Driver registration attempt for license ID: {LicenseId} by user: {UserId}",
                request.LicenseId, userId);

            // Check for duplicate
            var existingDriver = await _driverService.GetDriverByLicenseId(request.LicenseId);
            if (existingDriver != null)
            {
                _logger.LogWarning("Duplicate license ID registration attempt: {LicenseId}", request.LicenseId);
                return ApiResponseHandler.Conflict($"License ID {request.LicenseId} already exists in the system");
            }

            // Register driver
            var driverId = await _driverService.RegisterDriver(request, userId);

            _logger.LogInformation("Driver registered successfully with ID: {DriverId}", driverId);

            return ApiResponseHandler.Success(new { DriverId = driverId }, "Driver registered successfully");
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error registering driver with license ID: {LicenseId}", request.LicenseId);
            return ApiResponseHandler.Error("An error occurred during registration");
        }
    }
}
