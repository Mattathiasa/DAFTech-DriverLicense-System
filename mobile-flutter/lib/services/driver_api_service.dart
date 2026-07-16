import '../models/driver.dart';
import 'storage_service.dart';

class DriverApiService {
  final StorageService _storage = StorageService();

  Future<int> registerDriver({
    required String licenseId,
    required String fullName,
    required String licenseType,
    required String expiryDate,
    required String qrRawData,
    required String ocrRawText,
  }) async {
    final exists = await _storage.licenseExists(licenseId);
    if (exists) {
      final existing = await _storage.getDriverByLicenseId(licenseId);
      final status = existing?.status.toUpperCase() ?? 'ACTIVE';
      throw Exception(
        'Registration failed: License $licenseId is already registered. Status: $status',
      );
    }

    final status = _deriveStatus(expiryDate);
    final newDriver = Driver(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      licenseId: licenseId,
      fullName: fullName,
      licenseType: licenseType,
      expiryDate: expiryDate,
      qrData: qrRawData,
      ocrRawText: ocrRawText,
      status: status,
      registeredAt: DateTime.now(),
      registeredBy: 'demo',
    );
    await _storage.addDriver(newDriver);
    return int.tryParse(newDriver.id) ?? 0;
  }

  Future<Driver?> getDriverByLicenseId(String licenseId) async {
    return _storage.getDriverByLicenseId(licenseId);
  }

  Future<List<Driver>> getAllDrivers() async {
    return _storage.getDrivers();
  }

  Future<bool> updateDriverStatus(String licenseId, String status) async {
    final drivers = await _storage.getDrivers();
    final index = drivers.indexWhere(
      (d) => d.licenseId.toLowerCase() == licenseId.toLowerCase(),
    );
    if (index == -1) return false;
    drivers[index] = drivers[index].copyWith(status: status);
    await _storage.saveDrivers(drivers);
    return true;
  }

  Future<Map<String, dynamic>> getDriverStatistics() async {
    final stats = await _storage.getStatistics();
    return {
      'totalDrivers': stats['total'] ?? 0,
      'activeDrivers': stats['active'] ?? 0,
      'expiredDrivers': stats['expired'] ?? 0,
    };
  }

  String _deriveStatus(String expiryDate) {
    final dt = DateTime.tryParse(expiryDate);
    if (dt != null) return dt.isBefore(DateTime.now()) ? 'expired' : 'active';
    return Driver.calculateStatus(expiryDate);
  }
}
