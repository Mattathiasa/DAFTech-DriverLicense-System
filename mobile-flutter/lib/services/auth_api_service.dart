import 'package:shared_preferences/shared_preferences.dart';
import 'storage_service.dart';

class AuthApiService {
  static const String _demoUsername = 'demo';
  static const String _demoPassword = 'demo123';
  static const String _fakeToken = 'demo-token';

  final StorageService _storage = StorageService();

  Future<Map<String, dynamic>> login(String username, String password) async {
    await Future.delayed(const Duration(milliseconds: 400));
    if (username == _demoUsername && password == _demoPassword) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', _fakeToken);
      await prefs.setString('auth_username', _demoUsername);
      await _storage.setCurrentUser(_demoUsername);
      return {'token': _fakeToken, 'username': _demoUsername};
    }
    throw Exception('Login failed: Invalid credentials. Use demo / demo123');
  }

  Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_username');
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('auth_username');
    await _storage.logout();
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    return token != null && token.isNotEmpty;
  }
}
