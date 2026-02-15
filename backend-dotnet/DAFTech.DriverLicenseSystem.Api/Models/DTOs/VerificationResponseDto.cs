namespace DAFTech.DriverLicenseSystem.Api.Models.DTOs;

public class VerificationResponseDto
{
    public string LicenseId { get; set; } = string.Empty;
    public string VerificationStatus { get; set; } = string.Empty;
    public string? DriverName { get; set; }
    public DateTime? ExpiryDate { get; set; }
    public DateTime CheckedDate { get; set; }
}
