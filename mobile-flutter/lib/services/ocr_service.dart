import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class OCRService {
  static final _textRecognizer = TextRecognizer();

  /// Normalize OCR text before parsing
  /// - Remove extra line breaks
  /// - Join broken numbers (e.g., "30 5 1993" → "30/05/1993")
  /// - Fix common OCR errors
  static String _normalizeOCRText(String text) {
    // Step 1: Fix common OCR character errors
    String normalized = text
        .replaceAll('O', '0') // Letter O → Zero
        .replaceAll('o', '0')
        .replaceAll('l', '1') // Lowercase L → One
        .replaceAll('I', '1') // Uppercase I → One
        .replaceAll('S', '5') // S → 5 (in numbers)
        .replaceAll('Z', '2') // Z → 2
        .replaceAll('B', '8'); // B → 8

    // Step 2: Remove extra spaces and line breaks
    // Replace multiple spaces with single space
    normalized = normalized.replaceAll(RegExp(r'\s+'), ' ').trim();

    // Step 3: Join broken date numbers
    // Pattern: "30 5 1993" → "30/05/1993"
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

  /// Extract text from image using Google ML Kit
  static Future<Map<String, String>> extractDataFromImage(
    String imagePath,
  ) async {
    try {
      final inputImage = InputImage.fromFilePath(imagePath);
      final recognizedText = await _textRecognizer.processImage(inputImage);

      final fullText = recognizedText.text;

      // Normalize OCR text before parsing
      final normalizedText = _normalizeOCRText(fullText);

      // Parse using field anchors and fuzzy extraction
      final parsedData = _parseWithFieldAnchors(normalizedText);

      // Store original OCR text
      parsedData['ocrRawText'] = fullText;

      return parsedData;
    } catch (e) {
      return {
        'licenseId': '',
        'fullName': '',
        'dateOfBirth': '',
        'expiryDate': '',
        'licenseType': '',
        'sex': '',
        'ocrRawText': 'OCR extraction failed: ${e.toString()}',
      };
    }
  }

  /// Parse driver license text using field anchors and fuzzy extraction
  static Map<String, String> _parseWithFieldAnchors(String text) {
    final data = <String, String>{
      'licenseId': '',
      'fullName': '',
      'dateOfBirth': '',
      'expiryDate': '',
      'licenseType': '',
      'sex': '',
      'address': '',
    };

    // 1. Extract License Number (6 digits after "License No" or similar)
    final licensePatterns = [
      RegExp(r'License\s*No\.?\s*[:\-]?\s*(\d{6})', caseSensitive: false),
      RegExp(r'License\s*Number\s*[:\-]?\s*(\d{6})', caseSensitive: false),
      RegExp(r'DL\s*No\.?\s*[:\-]?\s*(\d{6})', caseSensitive: false),
      RegExp(r'ID\s*No\.?\s*[:\-]?\s*(\d{6})', caseSensitive: false),
      // Fallback: standalone 6-digit number
      RegExp(r'\b(\d{6})\b'),
    ];

    for (final pattern in licensePatterns) {
      final match = pattern.firstMatch(text);
      if (match != null && match.group(1) != null) {
        data['licenseId'] = match.group(1)!;
        break;
      }
    }

    // 2. Extract Full Name (2-3 uppercase words after "Full Name" or "Name")
    final namePatterns = [
      RegExp(
        r'Full\s*Name\s*[:\-]?\s*([A-Z]{2,}(?:\s+[A-Z]{2,}){1,3})',
        caseSensitive: false,
      ),
      RegExp(
        r'Name\s*[:\-]?\s*([A-Z]{2,}(?:\s+[A-Z]{2,}){1,3})',
        caseSensitive: false,
      ),
      // Amharic name pattern
      RegExp(
        r'የአሽከርካሪው\s*ስም\s*[:\-]?\s*([\u1200-\u137F\s]+?)(?=የመንጃ|$)',
        caseSensitive: false,
      ),
    ];

    for (final pattern in namePatterns) {
      final match = pattern.firstMatch(text);
      if (match != null && match.group(1) != null) {
        data['fullName'] = match.group(1)!.trim();
        break;
      }
    }

    // 3. Extract Date of Birth (Gregorian format after "DOB")
    final dobPatterns = [
      RegExp(
        r'DOB\s*[:\-]?\s*(\d{1,2}[\/\-]\d{1,2}[\/\-]\d{4})',
        caseSensitive: false,
      ),
      RegExp(
        r'Date\s*of\s*Birth\s*[:\-]?\s*(\d{1,2}[\/\-]\d{1,2}[\/\-]\d{4})',
        caseSensitive: false,
      ),
      RegExp(
        r'Birth\s*Date\s*[:\-]?\s*(\d{1,2}[\/\-]\d{1,2}[\/\-]\d{4})',
        caseSensitive: false,
      ),
    ];

    for (final pattern in dobPatterns) {
      final match = pattern.firstMatch(text);
      if (match != null && match.group(1) != null) {
        data['dateOfBirth'] = _formatDate(match.group(1)!);
        break;
      }
    }

    // 4. Extract Expiry Date (Gregorian format after "Expiry")
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
        r'Valid\s*Until\s*[:\-]?\s*(\d{1,2}[\/\-]\d{1,2}[\/\-]\d{4})',
        caseSensitive: false,
      ),
      RegExp(
        r'EXP\s*[:\-]?\s*(\d{1,2}[\/\-]\d{1,2}[\/\-]\d{4})',
        caseSensitive: false,
      ),
    ];

    for (final pattern in expiryPatterns) {
      final match = pattern.firstMatch(text);
      if (match != null && match.group(1) != null) {
        data['expiryDate'] = _formatDate(match.group(1)!);
        break;
      }
    }

    // 5. Extract License Type/Class (A, B, C, D, E)
    final typePatterns = [
      RegExp(r'Class\s*[:\-]?\s*([A-E])', caseSensitive: false),
      RegExp(r'Type\s*[:\-]?\s*([A-E])', caseSensitive: false),
      RegExp(r'Category\s*[:\-]?\s*([A-E])', caseSensitive: false),
      // Amharic license type
      RegExp(
        r'የመንጃ\s*ፍቃድ\s*ቁጥር\s*[:\-]?\s*[\u1200-\u137F\s]+-([^\-]+)-',
        caseSensitive: false,
      ),
    ];

    for (final pattern in typePatterns) {
      final match = pattern.firstMatch(text);
      if (match != null && match.group(1) != null) {
        data['licenseType'] = match.group(1)!.trim().toUpperCase();
        break;
      }
    }

    // 6. Extract Sex (M or F)
    final sexPatterns = [
      RegExp(r'Sex\s*[:\-]?\s*([MF])', caseSensitive: false),
      RegExp(r'Gender\s*[:\-]?\s*([MF])', caseSensitive: false),
      RegExp(r'Male|Female', caseSensitive: false),
    ];

    for (final pattern in sexPatterns) {
      final match = pattern.firstMatch(text);
      if (match != null) {
        final value = match.group(1) ?? match.group(0)!;
        data['sex'] = value.toUpperCase().startsWith('M') ? 'M' : 'F';
        break;
      }
    }

    // 7. Extract Address (multi-word text after "Address")
    final addressPattern = RegExp(
      r'Address\s*[:\-]?\s*([A-Z0-9\s,\.]{10,100})',
      caseSensitive: false,
    );
    final addressMatch = addressPattern.firstMatch(text);
    if (addressMatch != null && addressMatch.group(1) != null) {
      data['address'] = addressMatch.group(1)!.trim();
    }

    return data;
  }

  /// Format date to YYYY-MM-DD
  static String _formatDate(String date) {
    try {
      // Remove any non-digit, non-separator characters
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

        // Validate date
        if (month >= 1 && month <= 12 && day >= 1 && day <= 31) {
          return '$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
        }
      }
    } catch (e) {
      // Return original if parsing fails
    }
    return date;
  }

  /// Parse QR code data
  /// Supports both Amharic text format and pipe-separated format
  static Map<String, String> parseQRData(String qrData) {
    final result = <String, String>{
      'licenseId': '',
      'fullName': '',
      'dateOfBirth': '',
      'address': '',
      'licenseType': '',
      'issueDate': '',
      'expiryDate': '',
      'qrRawData': qrData, // Store raw QR data exactly as received
      'ocrRawText': qrData,
    };

    try {
      // PRIORITY 1: Check for Amharic QR format
      // Format: "የአሽከርካሪው ስም :-<name>የመንጃ ፍቃድ ቁጥር :-<license_id>"
      if (qrData.contains('የአሽከርካሪው') || qrData.contains('የመንጃ')) {
        // Extract full license string
        final licensePattern = RegExp(
          r'የመንጃ\s*ፍቃድ\s*ቁጥር\s*[:\-\s]*(.+)',
          caseSensitive: false,
          multiLine: true,
        );
        final licenseMatch = licensePattern.firstMatch(qrData);
        if (licenseMatch != null && licenseMatch.group(1) != null) {
          final fullLicenseString = licenseMatch.group(1)!.trim();

          // Parse Amharic license format: Region-Grade-LicenseNumber
          final licenseParts = fullLicenseString.split('-');

          if (licenseParts.length == 3) {
            result['licenseId'] = licenseParts[2].trim(); // License Number
            result['licenseType'] = licenseParts[1].trim(); // Grade
            result['address'] = licenseParts[0].trim(); // Region
          } else {
            result['licenseId'] = fullLicenseString;
          }
        }

        // Extract Name
        final namePattern = RegExp(
          r'የአሽከርካሪው\s*ስም\s*[:\-\s]*(.+?)የመንጃ\s*ፍቃድ\s*ቁጥር',
          caseSensitive: false,
          multiLine: true,
        );
        final nameMatch = namePattern.firstMatch(qrData);
        if (nameMatch != null && nameMatch.group(1) != null) {
          result['fullName'] = nameMatch.group(1)!.trim();
        }

        return result;
      }

      // PRIORITY 2: Try pipe-separated format
      final parts = qrData.split('|');
      if (parts.length >= 7) {
        return {
          'licenseId': parts[0].trim(),
          'fullName': parts[1].trim(),
          'dateOfBirth': parts[2].trim(),
          'address': parts[3].trim(),
          'licenseType': parts[4].trim(),
          'issueDate': parts[5].trim(),
          'expiryDate': parts[6].trim(),
          'qrRawData': qrData,
        };
      }
    } catch (e) {
      // Return result with raw data if parsing fails
    }

    return result;
  }

  /// Normalize license ID
  static String normalizeLicenseId(String licenseId) {
    return licenseId.trim().toUpperCase();
  }

  /// Generate QR data string from driver info
  static String generateQRData(Map<String, String> driverData) {
    return '${driverData['licenseId']}|'
        '${driverData['fullName']}|'
        '${driverData['dateOfBirth']}|'
        '${driverData['address']}|'
        '${driverData['licenseType']}|'
        '${driverData['issueDate']}|'
        '${driverData['expiryDate']}';
  }

  /// Dispose resources
  static void dispose() {
    _textRecognizer.close();
  }
}
