import 'package:flutter_dotenv/flutter_dotenv.dart';

class Envconfig {
  static String apiBaseUrl = dotenv.env['BASE_URL'] ?? "http://localhost:8000/api/";
  // static String get googleClientId {
  //   final value = dotenv.env['GOOGLE_CLIENT_ID'];
  //   return value ?? (throw Exception("Env not found"));
  // }

  static String get googleClientId {
    return dotenv.env['GOOGLE_CLIENT_ID'] ??
        (throw Exception("GOOGLE_CLIENT_ID is required and missing."));
  }
}
