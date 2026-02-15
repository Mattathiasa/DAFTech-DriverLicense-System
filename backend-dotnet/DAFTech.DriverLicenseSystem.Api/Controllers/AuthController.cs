using Microsoft.AspNetCore.Mvc;
using DAFTech.DriverLicenseSystem.Api.Models.DTOs;
using DAFTech.DriverLicenseSystem.Api.Services;
using DAFTech.DriverLicenseSystem.Api.Helpers;

namespace DAFTech.DriverLicenseSystem.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
public class AuthController : ControllerBase
{
    private readonly AuthenticationService _authService;
    private readonly ILogger<AuthController> _logger;

    public AuthController(
        AuthenticationService authService,
        ILogger<AuthController> logger)
    {
        _authService = authService;
        _logger = logger;
    }

    [HttpPost("login")]
    public async Task<ActionResult> Login([FromBody] LoginRequestDto request)
    {
        try
        {
            _logger.LogInformation("Login attempt for username: {Username}", request.Username);

            var user = await _authService.ValidateCredentials(request.Username, request.Password);
            
            if (user == null)
            {
                _logger.LogWarning("Failed login attempt for username: {Username}", request.Username);
                return ApiResponseHandler.Unauthorized("Invalid username or password");
            }

            var token = _authService.GenerateJwtToken(user.UserId, user.Username);
            
            var response = new LoginResponseDto
            {
                Token = token,
                ExpiresAt = DateTime.UtcNow.AddHours(24),
                UserId = user.UserId,
                Username = user.Username
            };

            _logger.LogInformation("Successful login for user: {Username}", request.Username);

            return ApiResponseHandler.Success(response, "Login successful");
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error during login for username: {Username}", request.Username);
            return ApiResponseHandler.Error("An error occurred during login");
        }
    }
}
