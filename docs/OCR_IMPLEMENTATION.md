# Improved OCR Implementation

## Overview
The OCR service has been completely rewritten to handle messy OCR text with better normalization and field extraction using keyword anchors.

## Key Improvements

### 1. Text Normalization
Before parsing, the OCR text is normalized to fix common issues:

```dart
static String _normalizeOCRText(String text) {
  // Fix common OCR character errors
  String normalized = text
      .replaceAll('O', '0')  // Letter O → Zero
      .replaceAll('o', '0')
      .replaceAll('l', '1')  // Lowercase L → One
      .replaceAll('I', '1')  // Uppercase I → One
      .replaceAll('S', '5')  // S → 5 (in numbers)
      .replaceAll('Z', '2')  // Z → 2
      .replaceAll('B', '8'); // B → 8

  // Remove extra spaces and line breaks
  normalized = normalized.replaceAll(RegExp(r'\s+'), ' ').trim();

  // Join broken date numbers: "30 5 1993" → "30/05/1993"
  normalized = normalized.replaceAllMapped(
    RegExp(r'(\d{1,2})\s+(\d{1,2})\s+(\d{4})'),
    (match) {
      final day = match.group(1)!.padLeft(2, '0');
      final month = match.group(2)!.padLeft(2, '0');
      final year = match.group(3)!;
      return '$day/$month/$year';
    },
  );

  return normalized;
}
```

### 2. Field Anchor Extraction
Uses keyword anchors to find and extract specific fields:

#### License Number
```dart
// Looks for patterns like:
// - "License No: 123456"
// - "License Number: 123456"
// - "DL No: 123456"
// - Standalone 6-digit number

final licensePatterns = [
  RegExp(r'License\s*No\.?\s*[:\-]?\s*(\d{6})', caseSensitive: false),
  RegExp(r'License\s*Number\s*[:\-]?\s*(\d{6})', caseSensitive: false),
  RegExp(r'DL\s*No\.?\s*[:\-]?\s*(\d{6})', caseSensitive: false),
  RegExp(r'\b(\d{6})\b'),  // Fallback
];
```

#### Full Name
```dart
// Extracts 2-3 uppercase words after "Full Name" or "Name"
final namePatterns = [
  RegExp(
    r'Full\s*Name\s*[:\-]?\s*([A-Z]{2,}(?:\s+[A-Z]{2,}){1,3})',
    caseSensitive: false,
  ),
  RegExp(
    r'Name\s*[:\-]?\s*([A-Z]{2,}(?:\s+[A-Z]{2,}){1,3})',
    caseSensitive: false,
  ),
  // Also supports Amharic names
  RegExp(
    r'የአሽከርካሪው\s*ስም\s*[:\-]?\s*([\u1200-\u137F\s]+?)(?=የመንጃ|$)',
    caseSensitive: false,
  ),
];
```

#### Date of Birth (Gregorian Only)
```dart
// Extracts dates after "DOB" keyword
// Supports formats: DD/MM/YYYY, DD-MM-YYYY
final dobPatterns = [
  RegExp(
    r'DOB\s*[:\-]?\s*(\d{1,2}[\/\-]\d{1,2}[\/\-]\d{4})',
    caseSensitive: false,
  ),
  RegExp(
    r'Date\s*of\s*Birth\s*[:\-]?\s*(\d{1,2}[\/\-]\d{1,2}[\/\-]\d{4})',
    caseSensitive: false,
  ),
];
```

#### Expiry Date (Gregorian Only)
```dart
// Extracts dates after "Expiry Date" or "EXP" keyword
final expiryPatterns = [
  RegExp(
    r'Expiry\s*Date\s*[:\-]?\s*(\d{1,2}[\/\-]\d{1,2}[\/\-]\d{4})',
    caseSensitive: false,
  ),
  RegExp(
    r'Expires?\s*[:\-]?\s*(\d{1,2}[\/\-]\d{1,2}[\/\-]\d{4})',
    caseSensitive: false,
  ),
  RegExp(
    r'EXP\s*[:\-]?\s*(\d{1,2}[\/\-]\d{1,2}[\/\-]\d{4})',
    caseSensitive: false,
  ),
];
```

#### License Type/Class
```dart
// Extracts A, B, C, D, or E after "Class" or "Type"
final typePatterns = [
  RegExp(r'Class\s*[:\-]?\s*([A-E])', caseSensitive: false),
  RegExp(r'Type\s*[:\-]?\s*([A-E])', caseSensitive: false),
  RegExp(r'Category\s*[:\-]?\s*([A-E])', caseSensitive: false),
];
```

#### Sex/Gender
```dart
// Extracts M or F after "Sex" or "Gender"
final sexPatterns = [
  RegExp(r'Sex\s*[:\-]?\s*([MF])', caseSensitive: false),
  RegExp(r'Gender\s*[:\-]?\s*([MF])', caseSensitive: false),
  RegExp(r'Male|Female', caseSensitive: false),
];
```

### 3. Date Formatting
Automatically formats dates to YYYY-MM-DD:

```dart
static String _formatDate(String date) {
  final cleaned = date.replaceAll(RegExp(r'[^\d\/\-]'), '');
  final parts = cleaned.split(RegExp(r'[\/\-]'));

  if (parts.length == 3) {
    int day = int.parse(parts[0]);
    int month = int.parse(parts[1]);
    int year = int.parse(parts[2]);

    // Handle 2-digit years
    if (year < 100) {
      year += (year > 50) ? 1900 : 2000;
    }

    // Validate and format
    if (month >= 1 && month <= 12 && day >= 1 && day <= 31) {
      return '$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
    }
  }
  
  return date;
}
```

## Example Usage

### Input (Messy OCR Text)
```
FEDERAL DEMOCRATIC REPUBLIC OF ETHIOPIA
DRIVER LICENSE
Full Name MATTATHIAS ABRAHAM
License No 379171
DOB 30 5 1993
Expiry Date 15 09 2025
Class B
Sex M
```

### After Normalization
```
FEDERAL DEMOCRATIC REPUBLIC OF ETHIOPIA DRIVER LICENSE Full Name MATTATHIAS ABRAHAM License No 379171 DOB 30/05/1993 Expiry Date 15/09/2025 Class B Sex M
```

### Extracted Data
```dart
{
  'licenseId': '379171',
  'fullName': 'MATTATHIAS ABRAHAM',
  'dateOfBirth': '1993-05-30',
  'expiryDate': '2025-09-15',
  'licenseType': 'B',
  'sex': 'M',
  'ocrRawText': '...original messy text...'
}
```

## Handling Broken Numbers

The normalization step automatically joins broken date numbers:

| Before | After |
|--------|-------|
| `30 5 1993` | `30/05/1993` |
| `15 09 2025` | `15/09/2025` |
| `1 1 2000` | `01/01/2000` |

## Gregorian vs Ethiopian Dates

The system focuses on **Gregorian dates only** (years ≥ 1900):

- **DOB**: Looks for dates between 1950-2010
- **Expiry Date**: Looks for future dates (current year to +20 years)
- Ethiopian dates (EC) are ignored in favor of Gregorian dates

## Common OCR Errors Fixed

| OCR Error | Correction |
|-----------|------------|
| `O` (letter) | `0` (zero) |
| `l` (lowercase L) | `1` (one) |
| `I` (uppercase i) | `1` (one) |
| `S` | `5` |
| `Z` | `2` |
| `B` | `8` |

## QR Code Handling

QR raw data is stored **exactly as received** without any processing:

```dart
static Map<String, String> parseQRData(String qrData) {
  final result = <String, String>{
    'qrRawData': qrData,  // ✅ Store raw QR data exactly as received
    // ... other fields extracted from QR data
  };
  
  // Parse Amharic or pipe-separated format
  // But ALWAYS keep original in 'qrRawData'
  
  return result;
}
```

## Benefits

1. **Cleaner Parsing**: Normalized text is easier to parse with regex
2. **Better Accuracy**: Fixes common OCR character errors
3. **Joined Numbers**: Automatically reconstructs broken date numbers
4. **Keyword Anchors**: Uses field labels to find correct data
5. **Fuzzy Extraction**: Handles variations in spacing and formatting
6. **Gregorian Focus**: Prioritizes Gregorian dates over Ethiopian
7. **Validation**: Validates dates before formatting

## Testing

To test the improved OCR:

1. Take a photo of a driver's license
2. Check the extracted fields in the registration screen
3. Verify dates are properly formatted (YYYY-MM-DD)
4. Confirm broken numbers are joined correctly
5. Check that OCR errors are fixed (O→0, l→1, etc.)

## Future Improvements

- **Fuzzy String Matching**: Match extracted names against a known database
- **Multiple Language Support**: Better handling of Amharic text
- **Confidence Scores**: Return confidence levels for each extracted field
- **Machine Learning**: Train a model on Ethiopian driver's licenses
