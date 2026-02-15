namespace DAFTech.DriverLicenseSystem.Api.Models.DTOs;

public class LicenseStatusDto
{
    public string Status { get; set; } = string.Empty;
    public DriverDto? LicenseDetails { get; set; }
}
