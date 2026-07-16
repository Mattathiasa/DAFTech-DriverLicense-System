import '../models/verification_log.dart';
import 'storage_service.dart';

class VerificationResult {
  final bool isReal;
  final bool isActive;
  final String message;

  VerificationResult({
    required this.isReal,
    required this.isActive,
    required this.message,
  });
}

class VerificationApiService {
  final StorageService _storage = StorageService();

  Future<VerificationResult> verifyLicense({
    required String licenseId,
    required String qrRawData,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final driver = await _storage.getDriverByLicenseId(licenseId);
    final bool isReal = driver != null;
    final bool isActive = driver != null && driver.status == 'active';
    final String message = !isReal
        ? 'License not found in the registry.'
        : isActive
            ? 'License is genuine and active.'
            : 'License is real but has expired.';

    final log = VerificationLog(
      id: 'log-${DateTime.now().millisecondsSinceEpoch}',
      licenseId: licenseId,
      result: isReal ? (isActive ? 'active' : 'expired') : 'fake',
      timestamp: DateTime.now(),
      isReal: isReal,
      isActive: isActive,
      checkedByUsername: 'demo',
    );
    await _storage.addVerificationLog(log);

    return VerificationResult(isReal: isReal, isActive: isActive, message: message);
  }

  Future<Map<String, dynamic>> getLicenseStatus(String licenseId) async {
    final driver = await _storage.getDriverByLicenseId(licenseId);
    if (driver == null) throw Exception('Status check failed: License not found');
    return {
      'licenseId': driver.licenseId,
      'status': driver.status,
      'fullName': driver.fullName,
      'expiryDate': driver.expiryDate,
    };
  }

  Future<List<VerificationLog>> getVerificationLogs() async {
    final logs = await _storage.getVerificationLogs();
    return logs.reversed.toList();
  }

  Future<Map<String, dynamic>> getDashboardStats() async {
    final drivers = await _storage.getDrivers();
    final logs = await _storage.getVerificationLogs();
    return {
      'totalDrivers': drivers.length,
      'activeDrivers': drivers.where((d) => d.status == 'active').length,
      'expiredDrivers': drivers.where((d) => d.status == 'expired').length,
      'totalVerifications': logs.length,
      'realVerifications': logs.where((l) => l.isReal).length,
      'fakeVerifications': logs.where((l) => !l.isReal).length,
    };
  }

  Future<String?> exportLogs() async {
    final logs = await _storage.getVerificationLogs();
    final buffer = StringBuffer();
    buffer.writeln('Log ID,License ID,Result,Timestamp,Checked By');
    for (final log in logs) {
      buffer.writeln(
        '${log.id},${log.licenseId},${log.result},${log.timestamp.toIso8601String()},${log.checkedByUsername ?? "demo"}',
      );
    }
    return buffer.toString();
  }

  Future<bool> deleteLog(String logId) async {
    final logs = await _storage.getVerificationLogs();
    final filtered = logs.where((l) => l.id != logId).toList();
    await _storage.saveVerificationLogs(filtered);
    return true;
  }

  Future<bool> deleteLogs(List<String> logIds) async {
    final logs = await _storage.getVerificationLogs();
    final filtered = logs.where((l) => !logIds.contains(l.id)).toList();
    await _storage.saveVerificationLogs(filtered);
    return true;
  }
}
