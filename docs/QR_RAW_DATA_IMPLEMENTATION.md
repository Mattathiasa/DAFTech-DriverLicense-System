# QR Raw Data Implementation

## Overview
The system correctly stores QR raw data exactly as received from the QR scanner without any processing.

## Implementation Details

### 1. QR Scanner (mobile_scanner package)
**File:** `mobile-flutter/lib/screens/qr_scanner_screen.dart`

```dart
void _onDetect(BarcodeCapture capture) {
  if (isProcessing) return;

  final List<Barcode> barcodes = capture.barcodes;
  
  if (barcodes.isNotEmpty) {
    final code = barcodes.first.rawValue;  // ✅ Get raw value directly
    
    if (code != null && code.isNotEmpty) {
      setState(() {
        scannedData = code;  // ✅ Store exactly as received
        isProcessing = true;
      });
      
      _processQRData(code);  // Pass raw data for parsing
    }
  }
}
```

### 2. QR Data Parsing
**File:** `mobile-flutter/lib/services/ocr_service.dart`

```dart
static Map<String, String> parseQRData(String qrData) {
  final result = <String, String>{
    'licenseId': '',
    'fullName': '',
    'dateOfBirth': '',
    'address': '',
    'licenseType': '',
    'issueDate': '',
    'expiryDate': '',
    'qrRawData': qrData,  // ✅ Store raw QR data exactly as received
    'ocrRawText': qrData,
  };

  // Parse the data to extract fields
  // But ALWAYS keep the original raw data in 'qrRawData'
  
  return result;
}
```

### 3. Registration Screen
**File:** `mobile-flutter/lib/screens/register_driver_screen.dart`

```dart
// QR raw data controller initialized with prefilled data
_qrRawDataController = TextEditingController(
  text: widget.prefilledData?['qrRawData'] ?? '',  // ✅ Use raw data as-is
);

// When submitting, use the raw data directly
final qrData = _qrRawDataController.text.isNotEmpty
    ? _qrRawDataController.text  // ✅ Send exactly as stored
    : OCRService.generateQRData({...});  // Only generate if empty
```

### 4. API Service
**File:** `mobile-flutter/lib/services/driver_api_service.dart`

```dart
Future<int> registerDriver({
  required String licenseId,
  required String fullName,
  required String dateOfBirth,
  required String licenseType,
  required String expiryDate,
  required String qrRawData,  // ✅ Raw data parameter
  required String ocrRawText,
}) async {
  final response = await _apiService.post('/Driver/register', {
    'licenseId': licenseId,
    'fullName': fullName,
    'dateOfBirth': dateOfBirth,
    'licenseType': licenseType,
    'expiryDate': expiryDate,
    'qrRawData': qrRawData,  // ✅ Send raw data exactly as received
    'ocrRawText': ocrRawText,
  });
  
  // ...
}
```

### 5. Database Storage
**File:** `database/02-create-tables.sql`

```sql
CREATE TABLE Drivers (
    DriverID INT PRIMARY KEY IDENTITY(1,1),
    LicenseID NVARCHAR(50) NOT NULL,
    FullName NVARCHAR(100) NOT NULL,
    DateOfBirth DATE NOT NULL,
    LicenseType NVARCHAR(10) NOT NULL,
    ExpiryDate DATE NOT NULL,
    QRRawData NVARCHAR(MAX) NULL,  -- ✅ Stores full raw QR string
    OCRRawText NVARCHAR(MAX) NULL,
    CreatedDate DATETIME2 NOT NULL DEFAULT GETDATE(),
    RegisteredBy INT NOT NULL
);
```

## Data Flow

```
1. QR Scanner (mobile_scanner)
   ↓
   barcode.rawValue (e.g., "የአሽከርካሪው ስም :-ማታቲያስ አብርሃምየመንጃ ፍቃድ ቁጥር :-አዲስ አበባ-አውቶ-379171")
   ↓
2. Store in scannedData variable
   ↓
3. Pass to parseQRData()
   ↓
4. Extract fields (licenseId, fullName, etc.)
   BUT keep original in 'qrRawData' field
   ↓
5. Display in RegisterDriverScreen
   _qrRawDataController contains full raw string
   ↓
6. Submit to API
   POST /Driver/register with qrRawData field
   ↓
7. Backend stores in database
   QRRawData column contains exact string from scanner
```

## Example Data

### Input (from QR scanner):
```
"የአሽከርካሪው ስም :-ማታቲያስ አብርሃምየመንጃ ፍቃድ ቁጥር :-አዲስ አበባ-አውቶ-379171"
```

### Stored in Database:
```json
{
  "QRRawData": "የአሽከርካሪው ስም :-ማታቲያስ አብርሃምየመንጃ ፍቃድ ቁጥር :-አዲስ አበባ-አውቶ-379171",
  "LicenseID": "379171",
  "FullName": "ማታቲያስ አብርሃም",
  "LicenseType": "አውቶ"
}
```

## Key Points

✅ **NO Processing** - Raw QR data is stored exactly as received from `mobile_scanner`

✅ **Full String** - The complete QR code content is preserved in `qrRawData` field

✅ **Separate Parsing** - Extracted fields (licenseId, fullName, etc.) are stored separately but don't affect the raw data

✅ **Database Storage** - `NVARCHAR(MAX)` column can store any length of QR data

✅ **API Transfer** - Raw data is sent as-is in JSON payload to backend

## Package Used

```yaml
dependencies:
  mobile_scanner: ^latest_version
```

**Detection Method:**
```dart
MobileScanner(
  onDetect: (BarcodeCapture capture) {
    final String? raw = capture.barcodes.first.rawValue;
    // Store exactly as received ✔️
  }
)
```

## Verification

To verify the implementation is working correctly:

1. Scan a QR code
2. Check the `_qrRawDataController.text` in RegisterDriverScreen
3. Submit the registration
4. Query the database: `SELECT QRRawData FROM Drivers WHERE LicenseID = '...'`
5. Confirm the stored value matches the original QR code content exactly

## Conclusion

The system correctly implements QR raw data storage:
- ✅ Uses `mobile_scanner` package
- ✅ Captures `barcode.rawValue` directly
- ✅ Stores in `qrRawData` field without modification
- ✅ Sends to backend exactly as received
- ✅ Stores in database `QRRawData` column
- ✅ NO processing or transformation applied to raw data
