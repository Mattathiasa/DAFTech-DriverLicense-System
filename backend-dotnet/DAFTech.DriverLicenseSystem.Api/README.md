# DAFTech.DriverLicenseSystem.Api

## Project Structure

This project follows clean architecture principles with proper separation of concerns.

```
DAFTech.DriverLicenseSystem.Api/
├── Controllers/                    # HTTP Request Handlers
│   ├── AuthController.cs          # Authentication endpoints
│   ├── DriverController.cs        # Driver management endpoints
│   └── VerificationController.cs  # License verification endpoints
│
├── Models/                         # Data Models
│   ├── Entities/                  # Database Entity Models
│   │   ├── User.cs                # User entity
│   │   ├── Driver.cs              # Driver entity
│   │   └── VerificationLog.cs     # Verification log entity
│   └── DTOs/                      # Data Transfer Objects
│       ├── LoginRequestDto.cs
│       ├── LoginResponseDto.cs
│       ├── DriverRegistrationDto.cs
│       ├── DriverResponseDto.cs
│       ├── DriverDto.cs
│       ├── VerificationRequestDto.cs
│       ├── VerificationResponseDto.cs
│       ├── VerificationLogDto.cs
│       ├── LicenseStatusDto.cs
│       └── CreateUserDto.cs
│
├── Data/                           # Database Layer
│   ├── ApplicationDbContext.cs    # EF Core DbContext
│   └── DatabaseInitializer.cs     # Database seeding/initialization
│
├── Services/                       # Business Logic Layer
│   ├── AuthenticationService.cs   # Authentication business logic
│   ├── DriverService.cs           # Driver management business logic
│   └── VerificationService.cs     # Verification business logic
│
├── Repositories/                   # Data Access Layer
│   ├── UserRepository.cs          # User data access
│   ├── DriverRepository.cs        # Driver data access
│   └── VerificationLogRepository.cs # Verification log data access
│
├── Helpers/                        # Utility Classes
│   ├── JwtHelper.cs               # JWT token generation/validation
│   └── ApiResponseHandler.cs      # Standardized API responses
│
├── Middleware/                     # Request Pipeline Middleware
│   └── GlobalExceptionMiddleware.cs # Global error handling
│
└── Configuration/                  # Application Configuration
    ├── appsettings.json           # Production settings
    ├── appsettings.Development.json # Development settings
    └── Program.cs                 # Application startup & DI configuration
```

## Architecture Principles

### 1. Separation of Concerns
- **Controllers**: Handle HTTP requests/responses only, no business logic
- **Services**: Contain all business logic and orchestration
- **Repositories**: Handle data access and database operations
- **Models**: Define data structures (Entities for DB, DTOs for API)
- **Middleware**: Handle cross-cutting concerns (logging, error handling)

### 2. Clean Code Practices
- Single Responsibility Principle: Each class has one clear purpose
- Dependency Inversion: Depend on abstractions, not concrete implementations
- Consistent naming conventions throughout
- Clear folder structure for easy navigation

### 3. Dependency Injection
All dependencies are registered in `Program.cs`:
```csharp
// Repositories
builder.Services.AddScoped<UserRepository>();
builder.Services.AddScoped<DriverRepository>();
builder.Services.AddScoped<VerificationLogRepository>();

// Services
builder.Services.AddScoped<AuthenticationService>();
builder.Services.AddScoped<DriverService>();
builder.Services.AddScoped<VerificationService>();

// Helpers
builder.Services.AddSingleton<JwtHelper>();
```

### 4. Scalable Architecture
- Layered structure allows easy expansion
- Repository pattern abstracts data access
- Service layer isolates business logic
- Middleware provides extensible request pipeline
- DTOs separate internal models from API contracts

## Database Design

The database follows the required structure with three main tables:

### Users Table
- UserID (Primary Key)
- Username (Unique)
- PasswordHash
- CreatedDate
- Status

### Drivers Table
- DriverID (Primary Key)
- LicenseID (Unique)
- FullName
- DateOfBirth
- LicenseType (Grade)
- ExpiryDate
- QRRawData
- OCRRawText
- CreatedDate
- RegisteredBy (Foreign Key to Users)

### VerificationLogs Table
- LogID (Primary Key)
- LicenseID
- VerificationStatus
- CheckedBy (Foreign Key to Users)
- CheckedDate

## API Endpoints

### Authentication
- `POST /api/auth/login` - User login
- `POST /api/auth/register` - User registration

### Driver Management
- `POST /api/driver/register` - Register new driver
- `GET /api/driver/all` - Get all drivers
- `GET /api/driver/{licenseId}` - Get driver by license ID

### Verification
- `POST /api/verification/verify` - Verify a license
- `GET /api/verification/status/{licenseId}` - Get license status
- `GET /api/verification/logs` - Get verification logs
- `GET /api/verification/export` - Export logs to CSV

## Running the Application

1. Update connection string in `appsettings.json`
2. Run database migrations or execute schema.sql
3. Start the application:
   ```bash
   dotnet run
   ```
4. Access Swagger UI at: `http://localhost:5000/swagger`

## Configuration

### JWT Settings (appsettings.json)
```json
{
  "JwtSettings": {
    "SecretKey": "your-secret-key-here",
    "Issuer": "DAFTech.DriverLicenseSystem",
    "Audience": "DAFTech.DriverLicenseSystem.Users",
    "ExpiryMinutes": 60
  }
}
```

### Database Connection
```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=localhost;Database=DriverLicenseDB;Trusted_Connection=True;TrustServerCertificate=True;"
  }
}
```

## Security Features

- JWT-based authentication
- BCrypt password hashing
- CORS configuration for Flutter app
- Global exception handling
- Input validation with Data Annotations

## Testing

The application can be tested using:
- Swagger UI (built-in)
- Postman/Thunder Client
- Automated tests (to be added)

## Notes

This structure demonstrates:
✅ Proper separation of concerns
✅ Clean code practices
✅ Dependency injection throughout
✅ Scalable and maintainable architecture
✅ Industry best practices
