# Complete Setup Guide
## DAFTech Driver License Registration & Verification System

This guide will walk you through setting up the complete system from scratch.

---

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Database Setup](#database-setup)
3. [Backend Setup](#backend-setup)
4. [Mobile App Setup](#mobile-app-setup)
5. [Testing the System](#testing-the-system)
6. [Troubleshooting](#troubleshooting)

---

## Prerequisites

### Required Software

#### 1. Database
- **SQL Server 2019 or later**
  - Download: https://www.microsoft.com/sql-server/sql-server-downloads
  - Options: Developer Edition (free), Express (free), or Full
  - Install SQL Server Management Studio (SSMS) for easier management

#### 2. Backend (.NET)
- **.NET 8 SDK or later**
  - Download: https://dotnet.microsoft.com/download
  - Verify installation: `dotnet --version`

#### 3. Mobile App (Flutter)
- **Flutter SDK 3.11.0 or later**
  - Download: https://flutter.dev/docs/get-started/install
  - Verify installation: `flutter doctor`
- **Android Studio** (for Android development)
  - Download: https://developer.android.com/studio
  - Install Android SDK and emulator
- **Xcode** (for iOS development - macOS only)
  - Download from Mac App Store

#### 4. Development Tools (Optional but Recommended)
- **Visual Studio Code**
  - Download: https://code.visualstudio.com/
  - Extensions: Flutter, Dart, C#
- **Git**
  - Download: https://git-scm.com/downloads

### System Requirements

**Minimum:**
- OS: Windows 10/11, macOS 10.14+, or Linux
- RAM: 8GB
- Storage: 10GB free space
- Internet connection for package downloads

**Recommended:**
- RAM: 16GB
- SSD storage
- Stable internet connection

---

## Database Setup

### Step 1: Install SQL Server

1. Download SQL Server Developer Edition
2. Run the installer
3. Choose "Basic" installation type
4. Note the server name (usually `localhost` or `localhost\SQLEXPRESS`)

### Step 2: Install SQL Server Management Studio (SSMS)

1. Download SSMS from Microsoft
2. Install and launch SSMS
3. Connect to your SQL Server instance

### Step 3: Create Database

**Option A: Using SSMS (Recommended)**

1. Open SSMS
2. Connect to your SQL Server instance
3. Click **File → Open → File**
4. Navigate to `database/schema.sql`
5. Click **Execute** (F5)
6. Verify database creation:
   ```sql
   USE DriverLicenseDB;
   SELECT * FROM Users;
   ```

**Option B: Using Command Line**

```bash
# Navigate to project root
cd driver_license_registration_and_verification_system

# Execute schema
sqlcmd -S localhost -i database/schema.sql

# Or for SQL Server Express
sqlcmd -S localhost\SQLEXPRESS -i database/schema.sql
```

### Step 4: Verify Database

Check that these tables exist:
- ✅ Users
- ✅ Drivers
- ✅ VerificationLogs

**Default Admin Account:**
- Username: `admin`
- Password: `Admin@123`

---

## Backend Setup

### Step 1: Navigate to Backend Directory

```bash
cd backend/DAFTech.DriverLicenseSystem.Api
```

### Step 2: Configure Database Connection

Edit `appsettings.json`:

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=localhost;Database=DriverLicenseDB;Trusted_Connection=True;TrustServerCertificate=True;"
  }
}
```

**Connection String Options:**

**Windows Authentication (Recommended):**
```
Server=localhost;Database=DriverLicenseDB;Trusted_Connection=True;TrustServerCertificate=True;
```

**SQL Server Express:**
```
Server=localhost\SQLEXPRESS;Database=DriverLicenseDB;Trusted_Connection=True;TrustServerCertificate=True;
```

**SQL Authentication:**
```
Server=localhost;Database=DriverLicenseDB;User Id=sa;Password=YourPassword;TrustServerCertificate=True;
```

### Step 3: Restore Dependencies

```bash
dotnet restore
```

### Step 4: Build the Project

```bash
dotnet build
```

Expected output:
```
Build succeeded.
    0 Warning(s)
    0 Error(s)
```

### Step 5: Run the API

**Option A: Using PowerShell Script**
```powershell
cd ..
.\start-api.ps1
```

**Option B: Using dotnet CLI**
```bash
dotnet run
```

### Step 6: Verify API is Running

1. Open browser
2. Navigate to: `http://localhost:5182/swagger`
3. You should see Swagger API documentation

**Expected Endpoints:**
- POST /api/auth/login
- GET /api/driver
- GET /api/driver/{licenseId}
- POST /api/driver/register
- POST /api/verification/verify
- GET /api/verification/status/{licenseId}
- GET /api/verification/logs
- GET /api/verification/export

---

## Mobile App Setup

### Step 1: Install Flutter Dependencies

```bash
# Navigate to project root
cd driver_license_registration_and_verification_system

# Get Flutter packages
flutter pub get
```

### Step 2: Configure API Endpoint

Edit `lib/config/api_config.dart`:

**For Android Emulator:**
```dart
class ApiConfig {
  static const String baseUrl = 'http://10.0.2.2:5182/api';
}
```

**For Physical Android Device:**
1. Find your computer's IP address:
   ```bash
   # Windows
   ipconfig
   
   # macOS/Linux
   ifconfig
   ```
2. Update config:
   ```dart
   static const String baseUrl = 'http://192.168.1.100:5182/api';
   ```

**For iOS Simulator:**
```dart
static const String baseUrl = 'http://localhost:5182/api';
```

### Step 3: Set Up Android Emulator

1. Open Android Studio
2. Go to **Tools → Device Manager**
3. Click **Create Device**
4. Select a device (e.g., Pixel 5)
5. Download a system image (e.g., Android 13)
6. Click **Finish**
7. Start the emulator

### Step 4: Verify Flutter Setup

```bash
flutter doctor
```

Expected output:
```
[✓] Flutter (Channel stable, 3.11.0)
[✓] Android toolchain
[✓] Chrome - develop for the web
[✓] Android Studio
[✓] VS Code
[✓] Connected device
```

### Step 5: Run the App

**On Emulator:**
```bash
flutter run
```

**On Physical Device:**
1. Enable USB Debugging on your device
2. Connect via USB
3. Run:
   ```bash
   flutter devices
   flutter run -d <device-id>
   ```

### Step 6: Build APK (Optional)

```bash
flutter build apk --release
```

APK location: `build/app/outputs/flutter-apk/app-release.apk`

---

## Testing the System

### Test 1: Login

1. Open the mobile app
2. Enter credentials:
   - Username: `admin`
   - Password: `Admin@123`
3. Tap **Login**
4. ✅ Should navigate to home screen

### Test 2: Scan License (OCR)

1. From home screen, tap **Scan License**
2. Tap **Upload** (or **Capture** if using physical device)
3. Select a driver's license image
4. ✅ OCR should extract:
   - License ID
   - Full Name
   - Date of Birth
   - Grade
   - Expiry Date
5. ✅ Should auto-navigate to Register Driver screen

### Test 3: Register Driver

1. Review extracted data
2. Fill any missing fields
3. Tap **Register**
4. ✅ Should show success message
5. ✅ Driver should appear in "All Drivers" list

### Test 4: Verify License (QR Code)

1. From home screen, tap **Verify License**
2. Tap **Scan QR Code**
3. Scan a registered driver's QR code
4. ✅ Should show verification result:
   - **Real**: License exists and valid
   - **Fake**: License not found
   - **Expired**: License past expiry date

### Test 5: View All Drivers

1. From home screen, tap **All Drivers**
2. ✅ Should display list of registered drivers
3. Tap on a driver
4. ✅ Should show driver details

### Test 6: API Testing (Swagger)

1. Open browser: `http://localhost:5182/swagger`
2. Click **Authorize**
3. Login via `/api/auth/login`:
   ```json
   {
     "username": "admin",
     "password": "Admin@123"
   }
   ```
4. Copy the token from response
5. Paste in Authorization dialog: `Bearer {token}`
6. Test other endpoints

---

## Troubleshooting

### Database Issues

**Problem:** Cannot connect to SQL Server

**Solutions:**
1. Verify SQL Server is running:
   ```powershell
   Get-Service MSSQLSERVER
   ```
2. Check connection string in `appsettings.json`
3. Test connection:
   ```bash
   sqlcmd -S localhost -Q "SELECT @@VERSION"
   ```
4. Enable TCP/IP in SQL Server Configuration Manager

---

**Problem:** Database not found

**Solutions:**
1. Re-run schema script: `database/schema.sql`
2. Verify database exists:
   ```sql
   SELECT name FROM sys.databases WHERE name = 'DriverLicenseDB';
   ```

---

### Backend Issues

**Problem:** Port 5182 already in use

**Solutions:**
1. Change port in `appsettings.json`:
   ```json
   {
     "Urls": "http://0.0.0.0:5183"
   }
   ```
2. Update mobile app config accordingly

---

**Problem:** Build errors

**Solutions:**
```bash
dotnet clean
dotnet restore
dotnet build
```

---

### Mobile App Issues

**Problem:** Cannot connect to API

**Solutions:**
1. Verify backend is running
2. Check `api_config.dart` has correct IP
3. For physical device:
   - Ensure device and computer on same WiFi
   - Check firewall allows port 5182
4. For emulator:
   - Use `10.0.2.2` instead of `localhost`

---

**Problem:** OCR not working

**Solutions:**
1. Grant camera permissions
2. Use clear, well-lit images
3. Ensure Google ML Kit is installed:
   ```bash
   flutter pub get
   ```

---

**Problem:** QR Scanner not working

**Solutions:**
1. Grant camera permissions
2. Ensure QR code is clear and visible
3. Check lighting conditions

---

**Problem:** Flutter build errors

**Solutions:**
```bash
flutter clean
flutter pub get
flutter run
```

---

## Next Steps

After successful setup:

1. ✅ Test all features thoroughly
2. ✅ Create additional user accounts
3. ✅ Register sample drivers
4. ✅ Test verification with different scenarios
5. ✅ Review logs in database
6. ✅ Customize UI/branding if needed
7. ✅ Deploy to production (see deployment guide)

---

## Additional Resources

- **Main README**: `../README.md`
- **Backend README**: `../backend/README.md`
- **Database Schema**: `../database/schema.sql`
- **Architecture Notes**: `ARCHITECTURE.md`
- **Screenshots**: `SCREENSHOTS.md`

---

## Support

For issues or questions:
- Check troubleshooting section above
- Review API documentation in Swagger
- Check console logs for errors
- Verify database data

---

**Setup Complete! 🎉**

You now have a fully functional Driver License Registration & Verification System.
