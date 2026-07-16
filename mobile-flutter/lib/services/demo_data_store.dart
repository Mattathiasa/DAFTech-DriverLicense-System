import 'package:shared_preferences/shared_preferences.dart';
import '../models/driver.dart';
import '../models/verification_log.dart';
import 'storage_service.dart';

class DemoDataStore {
  static final DemoDataStore _instance = DemoDataStore._internal();
  factory DemoDataStore() => _instance;
  DemoDataStore._internal();

  static const String _seedDoneKey = 'demo_seed_done';

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(_seedDoneKey) == true) return;
    final storage = StorageService();
    await storage.saveDrivers(_seedDrivers());
    await storage.saveVerificationLogs(_seedLogs());
    await prefs.setBool(_seedDoneKey, true);
  }

  List<Driver> _seedDrivers() {
    return [
      Driver(
        id: '1',
        licenseId: 'DL-2024-001',
        fullName: 'Abebe Girma Tadesse',
        licenseType: 'B',
        expiryDate: '2027-12-31',
        qrData: 'DL-2024-001',
        ocrRawText: '',
        status: 'active',
        registeredAt: DateTime(2024, 3, 15),
        registeredBy: 'demo',
      ),
      Driver(
        id: '2',
        licenseId: 'DL-2024-002',
        fullName: 'Marta Kebede Alemu',
        licenseType: 'A',
        expiryDate: '2028-06-20',
        qrData: 'DL-2024-002',
        ocrRawText: '',
        status: 'active',
        registeredAt: DateTime(2024, 6, 20),
        registeredBy: 'demo',
      ),
      Driver(
        id: '3',
        licenseId: 'DL-2025-001',
        fullName: 'Yonas Teklu Haile',
        licenseType: 'C',
        expiryDate: '2027-03-15',
        qrData: 'DL-2025-001',
        ocrRawText: '',
        status: 'active',
        registeredAt: DateTime(2025, 1, 10),
        registeredBy: 'demo',
      ),
      Driver(
        id: '4',
        licenseId: 'DL-2023-001',
        fullName: 'Tigist Wolde Bekele',
        licenseType: 'B',
        expiryDate: '2024-08-01',
        qrData: 'DL-2023-001',
        ocrRawText: '',
        status: 'expired',
        registeredAt: DateTime(2023, 8, 1),
        registeredBy: 'demo',
      ),
      Driver(
        id: '5',
        licenseId: 'DL-2022-001',
        fullName: 'Solomon Negash Desta',
        licenseType: 'A',
        expiryDate: '2025-02-28',
        qrData: 'DL-2022-001',
        ocrRawText: '',
        status: 'expired',
        registeredAt: DateTime(2022, 2, 28),
        registeredBy: 'demo',
      ),
    ];
  }

  List<VerificationLog> _seedLogs() {
    return [
      VerificationLog(
        id: 'log-seed-1',
        licenseId: 'DL-2024-001',
        result: 'active',
        timestamp: DateTime(2026, 7, 14, 9, 15),
        isReal: true,
        isActive: true,
        checkedByUsername: 'demo',
      ),
      VerificationLog(
        id: 'log-seed-2',
        licenseId: 'DL-2023-001',
        result: 'expired',
        timestamp: DateTime(2026, 7, 15, 14, 30),
        isReal: true,
        isActive: false,
        checkedByUsername: 'demo',
      ),
      VerificationLog(
        id: 'log-seed-3',
        licenseId: 'FAKE-999',
        result: 'fake',
        timestamp: DateTime(2026, 7, 15, 16, 45),
        isReal: false,
        isActive: false,
        checkedByUsername: 'demo',
      ),
    ];
  }
}
