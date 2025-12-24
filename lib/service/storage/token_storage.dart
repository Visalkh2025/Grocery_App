import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  final storage = FlutterSecureStorage();
  String tokenKey = "token";
  // set token bro
  Future<void> setToken(String token) async {
    await storage.write(key: tokenKey, value: token);
  }

  // get token bro
  Future<String?> getToken() async {
    return await storage.read(key: tokenKey);
  }

  // clear token bro
  Future<void> clearToken() async {
    await storage.delete(key: tokenKey);
  }
}
