namespace DAFTech.DriverLicenseSystem.Api.Models.DTOs;

public class VerificationResponseDto
{
    public string LicenseId { get; set; } = string.Empty;
    public string VerificationStatus { get; set; } = string.Empty;
    public string? DriverName { get; set; }
    public DateTime? ExpiryDate { get; set; }
    public DateTime CheckedDate { get; set; }
    
    // Additional fields for Flutter app compatibility
    public bool IsReal => VerificationStatus != "fake";
    public bool IsActive => VerificationStatus == "real";
    public string Message => VerificationStatus switch
    {
        "fake" => "This license is fake and not found in our central registry",
        "expired" => "This license has expired",
        "real" => "This license is valid and active",
        _ => "Unknown verification status"
    };
}
