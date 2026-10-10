import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final String _token = 'token';
  FlutterSecureStorage storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(),
  );
  // ຂຽນລົງໄວ້ໃນ Secure Storage
  Future<void> saveToken(String token) async {
    await storage.write(key: _token, value: token);
  }

  // ອ່ານຂໍ້ມູນຈາກ Secure Storage
  Future<String?> readToken() async {
    final token = await storage.read(key: _token);
    return token;
  }

  // ລົບ token ອອກຈາກລະບົບ
  Future<void> clearToken() async{
    return await storage.delete(key: _token);
    // return await storage.deleteAll();
  }
}
