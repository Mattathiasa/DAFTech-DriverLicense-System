using System.ComponentModel.DataAnnotations;

namespace DAFTech.DriverLicenseSystem.Api.Models.DTOs;

public class VerificationRequestDto
{
    [Required(ErrorMessage = "License ID is required")]
    public string LicenseId { get; set; } = string.Empty;
    
    [Required(ErrorMessage = "QR raw data is required")]
    public string QRRawData { get; set; } = string.Empty;
}
