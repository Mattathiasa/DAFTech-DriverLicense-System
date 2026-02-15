using BCrypt.Net;
using DAFTech.DriverLicenseSystem.Api.Models.Entities;
using DAFTech.DriverLicenseSystem.Api.Repositories;
using DAFTech.DriverLicenseSystem.Api.Helpers;

namespace DAFTech.DriverLicenseSystem.Api.Services;

public class AuthenticationService
{
    private readonly UserRepository _userRepository;
    private readonly JwtHelper _jwtHelper;
    private readonly IConfiguration _configuration;
    
    public AuthenticationService(
        UserRepository userRepository,
        JwtHelper jwtHelper,
        IConfiguration configuration)
    {
        _userRepository = userRepository;
        _jwtHelper = jwtHelper;
        _configuration = configuration;
    }
    
    public async Task<User?> ValidateCredentials(string username, string password)
    {
        var user = await _userRepository.GetByUsername(username);
        
        if (user == null || !VerifyPassword(password, user.PasswordHash))
        {
            return null;
        }
        
        return user;
    }
    
    public string GenerateJwtToken(int userId, string username)
    {
        var secretKey = _configuration["JwtSettings:SecretKey"] 
            ?? throw new InvalidOperationException("JWT SecretKey is not configured");
        var expirationMinutes = int.Parse(_configuration["JwtSettings:ExpirationMinutes"] ?? "60");
        var issuer = _configuration["JwtSettings:Issuer"] 
            ?? throw new InvalidOperationException("JWT Issuer is not configured");
        var audience = _configuration["JwtSettings:Audience"] 
            ?? throw new InvalidOperationException("JWT Audience is not configured");
        
        return _jwtHelper.GenerateToken(userId, username, secretKey, expirationMinutes, issuer, audience);
    }
    
    public string HashPassword(string password)
    {
        return BCrypt.Net.BCrypt.HashPassword(password, BCrypt.Net.BCrypt.GenerateSalt());
    }
    
    public bool VerifyPassword(string password, string hash)
    {
        try
        {
            return BCrypt.Net.BCrypt.Verify(password, hash);
        }
        catch
        {
            return false;
        }
    }
}
