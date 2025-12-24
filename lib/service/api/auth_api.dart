import 'dart:convert';
import 'package:grocery_app/config/env_config.dart';
import 'package:grocery_app/models/auth_response.dart';
import 'package:grocery_app/service/storage/token_storage.dart';
import 'package:grocery_app/utils/api_client.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';

class AuthApi {
  Future<void> loginwithHttp(String email, String password) async {
    try {
      final url = Uri.parse("${Envconfig.apiBaseUrl}login");
      final response = await http.post(
        headers: {"Content-Type": "application/json"},
        url,
        // convert dart to json object
        body: jsonEncode({"email": email, "password": password}),
      );
      if (response.statusCode == 201) {
        // convert json to dart object
        final token = jsonDecode(response.body)['token'];
        log("JWT_TOKEN: $token");
      } else {
        log(response.body);
      }
    } catch (err) {
      log("Error Login: $err");
    }
  }

  final ApiClient _api = ApiClient();

  final _tokenStorage = TokenStorage();
  Future<AuthResponse> sentOtp(String email) async {
    try {
      final response = await _api.request(
        endpoint: "send_otp",
        method: "POST",
        data: {"email": email},
      );
      if (response.statusCode == 200) {
        return AuthResponse(
          success: true,
          message: response.data['message'] ?? "OTP sent successfully",
        );
      } else {
        return AuthResponse(
          success: false,
          message: response.data['message'] ?? "Failed to send OTP",
        );
      }
    } catch (err) {
      log("Error: " + err.toString());
      return AuthResponse(success: false, message: err.toString());
    }
  }

  Future<AuthResponse> verifyOtp(String email, String otp) async {
    try {
      final response = await _api.request(
        endpoint: "verify_otp",
        method: "POST",
        data: {"email": email, "otp": otp},
      );
      if (response.statusCode == 200) {
        return AuthResponse(
          success: true,
          message: response.data['message'] ?? "OTP verified successfully",
        );
      } else {
        return AuthResponse(
          success: false,
          message: response.data['message'] ?? "Failed to verify OTP",
        );
      }
    } catch (err) {
      log(err.toString());
      return AuthResponse(success: false, message: err.toString());
    }
  }

  Future<AuthResponse> login(String email, String password) async {
    try {
      final response = await _api.request(
        endpoint: "login",
        method: "POST",
        data: {"email": email, "password": password},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final token = response.data['token'];
        await _tokenStorage.setToken(token);
        log("JWT_TOKEN: $token");
        return AuthResponse(
          success: true,
          message: response.data['message'] ?? "Login successful",
          token: token,
          user: response.data['user'] != null
              ? Map<String, dynamic>.from(response.data['user'])
              : null,
        );
      }
      log("Error login: " + response.data['message']);
      return AuthResponse(success: false, message: response.data['message'] ?? "Login failed");
    } catch (err) {
      log("Error Login: $err");
      return AuthResponse(success: false, message: err.toString());
    }
  }

  Future<AuthResponse> register(String fullName, String email, String password) async {
    try {
      final response = await _api.request(
        endpoint: "register",
        method: "POST",
        data: {"fullName": fullName, "email": email, "password": password},
      );
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        log(response.data['message']);
        return AuthResponse(
          success: true,
          message: response.data['message'] ?? "Login successful",
          token: response.data['token'],
          user: response.data['user'] != null
              ? Map<String, dynamic>.from(response.data['user'])
              : null,
        );
      } else {
        log("Error register: " + response.data['message']);
        return AuthResponse(success: false, message: response.data['message'] ?? "Login failed");
      }
    } catch (err) {
      {
        log(err.toString());
        return AuthResponse(success: false, message: err.toString());
      }
    }
  }

  Future<AuthResponse> loginGoogle(String idToken) async {
    try {
      final response = await _api.request(
        endpoint: "google_signin",
        method: "POST",
        data: {"idToken": idToken},
      );
      if (response.statusCode == 201) {
        final token = response.data['token'];
        _tokenStorage.setToken(token);
        return AuthResponse(
          success: true,
          message: response.data['message'] ?? "Login successful",
          token: token,
        );
      } else {
        return AuthResponse(success: false, message: response.data['message'] ?? "Login failed");
      }
    } catch (err) {
      return AuthResponse(success: false, message: err.toString());
    }
  }
}
