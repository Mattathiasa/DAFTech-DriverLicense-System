namespace DAFTech.DriverLicenseSystem.Api.Models.DTOs;

public class DriverResponseDto
{
    public int DriverId { get; set; }
    public string LicenseId { get; set; } = string.Empty;
    public string FullName { get; set; } = string.Empty;
    public DateTime DateOfBirth { get; set; }
    public string LicenseType { get; set; } = string.Empty;
    public DateTime ExpiryDate { get; set; }
    public DateTime CreatedDate { get; set; }
}
