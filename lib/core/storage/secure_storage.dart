import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final String _keyToken = 'token';
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(),
  );
  Future<void> saveToken(String token) async {
    await _secureStorage.write(key: _keyToken, value: token);
  }

  Future<String?> readToken() async {
    final token = await _secureStorage.read(key: _keyToken);
    return token;
  }

  Future<String?> getToken() async {
    return await readToken();
  }

  Future<void> deleteToken() async {
    await _secureStorage.delete(key: _keyToken);
  }
}
