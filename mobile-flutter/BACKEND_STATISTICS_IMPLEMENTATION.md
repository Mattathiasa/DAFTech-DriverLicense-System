# Backend Statistics Implementation Guide

## Overview
This guide shows you how to add the `/Driver/statistics` endpoint to your backend API so the Flutter app can display driver counts correctly.

---

## Step 1: Add Statistics Endpoint to Your Driver Controller

**File Location:** `YourBackendProject/Controllers/DriverController.cs`

Add this method to your `DriverController` class:

```csharp
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System;
using System.Linq;
using System.Threading.Tasks;

namespace YourNamespace.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class DriverController : ControllerBase
    {
        private readonly YourDbContext _context;

        public DriverController(YourDbContext context)
        {
            _context = context;
        }

        // ADD THIS NEW ENDPOINT
        [HttpGet("statistics")]
        public async Task<IActionResult> GetDriverStatistics()
        {
            try
            {
                // Count total drivers
                var totalDrivers = await _context.Drivers.CountAsync();
                
                // Count active drivers
                var activeDrivers = await _context.Drivers
                    .Where(d => d.Status.ToLower() == "active")
                    .CountAsync();
                
                // Count expired drivers
                var expiredDrivers = await _context.Drivers
                    .Where(d => d.Status.ToLower() == "expired")
                    .CountAsync();

                return Ok(new
                {
                    success = true,
                    data = new
                    {
                        totalDrivers = totalDrivers,
                        activeDrivers = activeDrivers,
                        expiredDrivers = expiredDrivers
                    }
                });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new 
                { 
                    success = false, 
                    message = ex.Message 
                });
            }
        }

        // ... your other existing endpoints ...
    }
}
```

---

## Step 2: Verify Your Database Table

Make sure your `Drivers` table has the `Status` column:

```sql
-- Check if Status column exists
SELECT COLUMN_NAME, DATA_TYPE 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'Drivers' AND COLUMN_NAME = 'Status';

-- If it doesn't exist, add it
ALTER TABLE Drivers 
ADD Status NVARCHAR(20) DEFAULT 'active';

-- Update existing records if needed
UPDATE Drivers 
SET Status = 'active' 
WHERE Status IS NULL;
```

---

## Step 3: Test the Endpoint

### Option A: Using Browser
Open your browser and navigate to:
```
http://localhost:5000/api/Driver/statistics
```
(Replace with your actual API URL and port)

### Option B: Using Postman
1. Create a new GET request
2. URL: `http://your-api-url/api/Driver/statistics`
3. Click Send

### Expected Response:
```json
{
  "success": true,
  "data": {
    "totalDrivers": 7,
    "activeDrivers": 4,
    "expiredDrivers": 3
  }
}
```

---

## Step 4: Alternative - Direct SQL Query Endpoint

If you prefer a simpler approach using raw SQL:

```csharp
[HttpGet("statistics")]
public async Task<IActionResult> GetDriverStatistics()
{
    try
    {
        var statistics = await _context.Database
            .SqlQueryRaw<DriverStatistics>(@"
                SELECT 
                    COUNT(*) as TotalDrivers,
                    SUM(CASE WHEN LOWER(Status) = 'active' THEN 1 ELSE 0 END) as ActiveDrivers,
                    SUM(CASE WHEN LOWER(Status) = 'expired' THEN 1 ELSE 0 END) as ExpiredDrivers
                FROM Drivers
            ")
            .FirstOrDefaultAsync();

        return Ok(new
        {
            success = true,
            data = new
            {
                totalDrivers = statistics?.TotalDrivers ?? 0,
                activeDrivers = statistics?.ActiveDrivers ?? 0,
                expiredDrivers = statistics?.ExpiredDrivers ?? 0
            }
        });
    }
    catch (Exception ex)
    {
        return StatusCode(500, new { success = false, message = ex.Message });
    }
}

// Add this class outside the controller
public class DriverStatistics
{
    public int TotalDrivers { get; set; }
    public int ActiveDrivers { get; set; }
    public int ExpiredDrivers { get; set; }
}
```

---

## Step 5: Restart Your Backend API

After adding the endpoint:
1. Save the file
2. Rebuild your backend project
3. Restart the API server

---

## Step 6: Update API URL in Flutter (if needed)

Check your Flutter app's API configuration:

**File:** `lib/config/api_config.dart`

Make sure the `baseUrl` points to your backend:
```dart
class ApiConfig {
  static const String baseUrl = 'http://your-api-url/api';
}
```

---

## Troubleshooting

### Issue: 404 Not Found
- ✅ Check the route: Should be `/api/Driver/statistics`
- ✅ Verify controller has `[Route("api/[controller]")]`
- ✅ Restart the backend server

### Issue: 500 Internal Server Error
- ✅ Check database connection
- ✅ Verify `Status` column exists in Drivers table
- ✅ Check backend logs for detailed error

### Issue: Still showing 0 in Flutter
- ✅ Test endpoint in browser/Postman first
- ✅ Check Flutter debug console for API errors
- ✅ Verify API URL is correct in Flutter app
- ✅ Check if authentication token is valid

---

## Verification Checklist

- [ ] Backend endpoint added to DriverController
- [ ] Backend project rebuilt and restarted
- [ ] Endpoint tested in browser/Postman and returns correct data
- [ ] Flutter app API URL is correct
- [ ] Flutter app shows correct numbers on home screen

---

## Flutter Side (Already Implemented)

The Flutter code is already updated in:
- ✅ `lib/services/driver_api_service.dart` - Has `getDriverStatistics()` method
- ✅ `lib/screens/home_screen.dart` - Calls the statistics endpoint
- ✅ Debug logging added to track the flow

Once you add the backend endpoint, the Flutter app will automatically work!

---

## Quick Test SQL Queries

Run these in your SQL Server to verify data:

```sql
-- Total drivers
SELECT COUNT(*) as TotalDrivers FROM Drivers;

-- Active drivers
SELECT COUNT(*) as ActiveDrivers 
FROM Drivers 
WHERE LOWER(Status) = 'active';

-- Expired drivers
SELECT COUNT(*) as ExpiredDrivers 
FROM Drivers 
WHERE LOWER(Status) = 'expired';

-- All statistics at once
SELECT 
    COUNT(*) as TotalDrivers,
    SUM(CASE WHEN LOWER(Status) = 'active' THEN 1 ELSE 0 END) as ActiveDrivers,
    SUM(CASE WHEN LOWER(Status) = 'expired' THEN 1 ELSE 0 END) as ExpiredDrivers
FROM Drivers;
```

---

## Need Help?

If you're still having issues:
1. Share the backend error logs
2. Share the Flutter debug console output
3. Share the Postman/browser response from the endpoint
