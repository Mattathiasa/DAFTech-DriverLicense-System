# DAFTech Driver License System - Backend API

## Overview

ASP.NET Core Web API for the Driver License Registration & Verification System. This backend provides secure authentication, driver registration with duplicate detection, and real/fake license verification capabilities.

## Architecture

The solution follows **Clean Architecture** principles with a **single-project structure** for simplicity and maintainability:

**DAFTech.DriverLicenseSystem.Api** - Complete API with:
- **Controllers/**: API endpoints (Auth, Driver, Verification)
- **Models/**: Domain entities and DTOs
  - **Entities/**: Database models (User, Driver, VerificationLog)
  - **DTOs/**: Data transfer objects for API requests/responses
- **Services/**: Business logic layer
- **Repositories/**: Data access layer
- **Data/**: Database context and initialization
- **Helpers/**: Utility classes (JWT, API Response Handler)
- **Middleware/**: Global exception handling

### Design Principles

✅ **Separation of Concerns**: Controllers → Services → Repositories → Database  
✅ **Dependency Injection**: All services registered and injected via constructor  
✅ **Clean Code**: Consistent naming, clear structure, easy to navigate  
✅ **Scalable**: Easy to add new features and endpoints  

## Core Features

### 1. Driver Registration
- Register new drivers with OCR-extracted data
- Store QR raw data and OCR raw text
- Automatic duplicate detection before registration
- Returns conflict error if license already exists

### 2. Duplicate Detection
- Checks database by License ID before creating new record
- Prevents duplicate license entries
- Returns HTTP 409 Conflict with details if duplicate found

### 3. Real/Fake Verification
- Verifies license exists in database
- Compares scanned QR data with stored QR data
- Validates expiry date
- Returns status: **Real**, **Fake**, or **Expired**
- Logs all verification attempts with timestamp

## Prerequisites

- **.NET 8 SDK** or later - [Download](https://dotnet.microsoft.com/download)
- **SQL Server** (LocalDB, Express, or Full) - [Download](https://www.microsoft.com/sql-server/sql-server-downloads)
- **Visual Studio 2022** or **VS Code** (optional)

## Quick Start

### 1. Database Setup

Run the database schema script:

```bash
# Using SQL Server Management Studio (SSMS)
# 1. Open SSMS and connect to your SQL Server
# 2. Open file: ../database/schema.sql
# 3. Execute (F5)

# Or using sqlcmd
sqlcmd -S localhost -i ../database/schema.sql
```

**Default Admin Credentials:**
- Username: `admin`
- Password: `Admin@123`

### 2. Configure Connection String

Edit `DAFTech.DriverLicenseSystem.Api/appsettings.json`:

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=localhost;Database=DriverLicenseDB;Trusted_Connection=True;TrustServerCertificate=True;"
  }
}
```

**For SQL Server Express:**
```
Server=localhost\\SQLEXPRESS;Database=DriverLicenseDB;Trusted_Connection=True;TrustServerCertificate=True;
```

**For SQL Authentication:**
```
Server=localhost;Database=DriverLicenseDB;User Id=sa;Password=YourPassword;TrustServerCertificate=True;
```

### 3. Run the API

**Option 1: Using PowerShell Script (Recommended)**
```powershell
.\start-api.ps1
```

**Option 2: Using .NET CLI**
```bash
cd DAFTech.DriverLicenseSystem.Api
dotnet restore
dotnet build
dotnet run
```

**Option 3: Using Visual Studio**
1. Open `DriverLicenseSystem.sln`
2. Set `DAFTech.DriverLicenseSystem.Api` as startup project
3. Press F5

### 4. Access API

The API will be available at:
- **HTTP**: `http://localhost:5182`
- **Swagger UI**: `http://localhost:5182/swagger`

## API Endpoints

### Authentication

#### POST /api/auth/login
Login with username and password to receive JWT token.

**Request:**
```json
{
  "username": "admin",
  "password": "Admin@123"
}
```

**Response:**
```json
{
  "success": true,
  "message": "Login successful",
  "data": {
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "expiresAt": "2024-02-15T10:30:00Z",
    "userId": 1,
    "username": "admin"
  }
}
```

### Driver Management

#### GET /api/driver
Get all registered drivers (requires authentication).

**Headers:**
```
Authorization: Bearer {token}
```

**Response:**
```json
{
  "success": true,
  "message": "Retrieved 5 drivers",
  "data": [
    {
      "driverId": 1,
      "licenseId": "123456",
      "fullName": "John Doe",
      "dateOfBirth": "1990-01-15",
      "licenseType": "B",
      "expiryDate": "2026-01-15",
      "createdDate": "2024-02-14T08:00:00Z"
    }
  ]
}
```

#### GET /api/driver/{licenseId}
Get driver details by license ID (requires authentication).

**Response:**
```json
{
  "success": true,
  "message": "Driver retrieved successfully",
  "data": {
    "driverId": 1,
    "licenseId": "123456",
    "fullName": "John Doe",
    "dateOfBirth": "1990-01-15",
    "licenseType": "B",
    "expiryDate": "2026-01-15",
    "qrRawData": "የአሽከርካሪው ስም :-John Doe የመንጃ ፍቃድ ቁጥር :-123456",
    "ocrRawText": "DRIVER LICENSE\nDL123456\nJohn Doe...",
    "createdDate": "2024-02-14T08:00:00Z"
  }
}
```

#### POST /api/driver/register
Register a new driver with duplicate detection (requires authentication).

**Request:**
```json
{
  "licenseId": "123456",
  "fullName": "John Doe",
  "dateOfBirth": "1990-01-15",
  "licenseType": "B",
  "expiryDate": "2026-01-15",
  "qrRawData": "የአሽከርካሪው ስም :-John Doe የመንጃ ፍቃድ ቁጥር :-123456",
  "ocrRawText": "DRIVER LICENSE\nLICENSE ID: 123456\nNAME: John Doe\nDOB: 1990-01-15..."
}
```

**Success Response (201 Created):**
```json
{
  "success": true,
  "message": "Driver registered successfully",
  "data": {
    "driverId": 10
  }
}
```

**Duplicate Response (409 Conflict):**
```json
{
  "success": false,
  "message": "License ID 123456 already exists in the system",
  "data": null
}
```

### Verification

#### POST /api/verification/verify
Verify a license by ID and optional QR data (requires authentication).

**Request:**
```json
{
  "licenseId": "123456",
  "qrRawData": "የአሽከርካሪው ስም :-John Doe የመንጃ ፍቃድ ቁጥር :-123456"
}
```

**Response - Real License:**
```json
{
  "success": true,
  "message": "Verification completed",
  "data": {
    "licenseId": "123456",
    "verificationStatus": "real",
    "driverName": "John Doe",
    "expiryDate": "2026-01-15",
    "checkedDate": "2024-02-15T10:30:00Z"
  }
}
```

**Response - Fake License:**
```json
{
  "success": true,
  "message": "Verification completed",
  "data": {
    "licenseId": "999999",
    "verificationStatus": "fake",
    "driverName": null,
    "expiryDate": null,
    "checkedDate": "2024-02-15T10:30:00Z"
  }
}
```

**Response - Expired License:**
```json
{
  "success": true,
  "message": "Verification completed",
  "data": {
    "licenseId": "123456",
    "verificationStatus": "expired",
    "driverName": "John Doe",
    "expiryDate": "2023-01-15",
    "checkedDate": "2024-02-15T10:30:00Z"
  }
}
```

#### GET /api/verification/status/{licenseId}
Quick status check for a license (requires authentication).

#### GET /api/verification/logs
Get verification logs with optional filters (requires authentication).

**Query Parameters:**
- `startDate`: Filter by start date (optional)
- `endDate`: Filter by end date (optional)
- `userId`: Filter by user ID (optional)
- `licenseId`: Filter by license ID (optional)

**Example:**
```
GET /api/verification/logs?startDate=2024-02-01&endDate=2024-02-15&licenseId=123456
```

**Response:**
```json
{
  "success": true,
  "message": "Retrieved 3 verification logs",
  "data": [
    {
      "logId": 1,
      "licenseId": "123456",
      "verificationStatus": "real",
      "checkedBy": 1,
      "checkedDate": "2024-02-15T10:30:00Z"
    }
  ]
}
```

#### GET /api/verification/export
Export verification logs as CSV file (requires authentication).

**Response:** CSV file download

## Configuration

### JWT Settings

Located in `appsettings.json`:

```json
{
  "JwtSettings": {
    "SecretKey": "YourSuperSecretKeyThatIsAtLeast32CharactersLongForHS256Algorithm",
    "ExpirationMinutes": 1440,
    "Issuer": "DriverLicenseSystem",
    "Audience": "DriverLicenseSystemClients"
  }
}
```

**For Production:**
- Change `SecretKey` to a strong, unique value
- Store in environment variables or Azure Key Vault
- Reduce `ExpirationMinutes` if needed

### CORS Configuration

Currently allows all origins for development. Located in `Program.cs`:

```csharp
builder.Services.AddCors(options =>
{
    options.AddPolicy("FlutterApp", policy =>
    {
        policy.AllowAnyOrigin()
              .AllowAnyMethod()
              .AllowAnyHeader();
    });
});
```

**For Production:**
```csharp
policy.WithOrigins("https://your-app-domain.com")
      .AllowAnyMethod()
      .AllowAnyHeader();
```

## Project Structure

```
DAFTech.DriverLicenseSystem.Api/
├── Controllers/
│   ├── AuthController.cs           # Authentication endpoints
│   ├── DriverController.cs         # Driver management endpoints
│   └── VerificationController.cs   # Verification endpoints
├── Models/
│   ├── Entities/
│   │   ├── User.cs                 # User entity
│   │   ├── Driver.cs               # Driver entity
│   │   └── VerificationLog.cs      # Verification log entity
│   └── DTOs/
│       ├── LoginRequestDto.cs      # Login request
│       ├── LoginResponseDto.cs     # Login response
│       ├── DriverRegistrationDto.cs # Driver registration
│       ├── DriverDto.cs            # Driver response
│       ├── VerificationRequestDto.cs # Verification request
│       └── VerificationResponseDto.cs # Verification response
├── Services/
│   ├── AuthenticationService.cs    # Authentication logic
│   ├── DriverService.cs            # Driver business logic
│   └── VerificationService.cs      # Verification logic
├── Repositories/
│   ├── UserRepository.cs           # User data access
│   ├── DriverRepository.cs         # Driver data access
│   └── VerificationLogRepository.cs # Log data access
├── Data/
│   ├── ApplicationDbContext.cs     # EF Core context
│   └── DatabaseInitializer.cs      # Database seeding
├── Helpers/
│   ├── JwtHelper.cs                # JWT token generation
│   └── ApiResponseHandler.cs       # Standardized API responses
├── Middleware/
│   └── GlobalExceptionMiddleware.cs # Error handling
├── Program.cs                       # Application startup
├── appsettings.json                 # Configuration
└── appsettings.Development.json     # Development config
```

## Testing

### Using Swagger UI

1. Navigate to `http://localhost:5182/swagger`
2. Click "Authorize" button
3. Login via `/api/auth/login` to get token
4. Copy the token
5. Paste in Authorization dialog as: `Bearer {token}`
6. Test all endpoints interactively

### Using Postman

1. Create a new request collection
2. Add login request to get token
3. Set Authorization header: `Bearer {token}`
4. Test all endpoints

### Using curl

```bash
# Login
curl -X POST http://localhost:5182/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"Admin@123"}'

# Register Driver
curl -X POST http://localhost:5182/api/driver/register \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer {token}" \
  -d '{
    "licenseId": "999999",
    "fullName": "Test User",
    "dateOfBirth": "1995-05-20",
    "licenseType": "B",
    "expiryDate": "2027-05-20",
    "qrRawData": "Test QR Data",
    "ocrRawText": "Test OCR Text"
  }'

# Verify License
curl -X POST http://localhost:5182/api/verification/verify \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer {token}" \
  -d '{
    "licenseId": "999999",
    "qrRawData": "Test QR Data"
  }'
```

## Troubleshooting

### Database Connection Issues

**Problem:** Cannot connect to SQL Server

**Solutions:**
1. Verify SQL Server is running:
   ```powershell
   Get-Service MSSQLSERVER
   # or for Express
   Get-Service MSSQL$SQLEXPRESS
   ```

2. Test connection:
   ```bash
   sqlcmd -S localhost -Q "SELECT @@VERSION"
   ```

3. Check connection string in `appsettings.json`
4. Ensure TCP/IP is enabled in SQL Server Configuration Manager

### JWT Token Issues

**Problem:** 401 Unauthorized errors

**Solutions:**
1. Ensure token is included in header: `Authorization: Bearer {token}`
2. Check token hasn't expired (default: 24 hours)
3. Verify `SecretKey` in `appsettings.json` is at least 32 characters
4. Login again to get a fresh token

### Build Errors

**Problem:** Build fails with missing dependencies

**Solutions:**
```bash
# Clean and restore
dotnet clean
dotnet restore
dotnet build
```

### Port Already in Use

**Problem:** Port 5182 is already in use

**Solutions:**
1. Change port in `appsettings.json`:
   ```json
   {
     "Urls": "http://0.0.0.0:5183"
   }
   ```

2. Or kill the process using the port:
   ```powershell
   # Find process
   netstat -ano | findstr :5182
   # Kill process (replace PID)
   taskkill /PID <PID> /F
   ```

## Security Best Practices

### For Production

✅ **Change JWT Secret**: Use a strong, unique secret key  
✅ **Use HTTPS**: Enable SSL/TLS certificates  
✅ **Environment Variables**: Store secrets in environment variables  
✅ **Rate Limiting**: Implement rate limiting for login attempts  
✅ **Input Validation**: Validate all user inputs  
✅ **SQL Injection**: Use parameterized queries (already implemented via EF Core)  
✅ **CORS**: Restrict to specific origins  
✅ **Logging**: Implement comprehensive logging and monitoring  
✅ **Updates**: Regularly update NuGet packages  

### Current Security Features

✅ JWT-based authentication  
✅ BCrypt password hashing  
✅ Global exception handling  
✅ SQL injection protection via EF Core  
✅ CORS configuration  
✅ Request validation  

## Performance Optimization

- **Database Indexing**: Indexes on LicenseID, Username, CheckedDate
- **Async/Await**: All database operations are asynchronous
- **Connection Pooling**: Enabled by default in EF Core
- **Caching**: Consider adding Redis for frequently accessed data

## Deployment

### Publishing the API

```bash
# Publish for production
dotnet publish -c Release -o ./publish

# The output will be in ./publish folder
```

### Docker Deployment (Optional)

Create `Dockerfile`:
```dockerfile
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY ["DAFTech.DriverLicenseSystem.Api.csproj", "./"]
RUN dotnet restore
COPY . .
RUN dotnet build -c Release -o /app/build

FROM build AS publish
RUN dotnet publish -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "DAFTech.DriverLicenseSystem.Api.dll"]
```

Build and run:
```bash
docker build -t daftech-api .
docker run -p 5182:80 daftech-api
```

## Support

For issues or questions:
- Check Swagger UI: `http://localhost:5182/swagger`
- Review logs in console output
- Check database connection and data
- Refer to main project README: `../README.md`

## License

This project is part of the DAFTech Driver License System internship evaluation.
