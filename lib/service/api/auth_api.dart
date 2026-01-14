import 'dart:convert';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:grocery_app/config/env_config.dart';
import 'package:grocery_app/models/auth_response.dart';
import 'package:grocery_app/models/user.dart';
import 'package:grocery_app/service/storage/token_storage.dart';
import 'package:grocery_app/utils/api_client.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

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

  Future<Map<String, dynamic>> loginGoogle(String idToken) async {
    try {
      final response = await _api.request(
        endpoint: "google_signin",
        method: "POST",
        data: {"idToken": idToken},
      );
      if (response.statusCode == 201) {
        final token = response.data['token'];
        _tokenStorage.setToken(token);
        return response.data;
      } else {
        return {};
      }
    } catch (err) {
      return {};
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final res = await _api.request(
        endpoint: "login",
        method: "POST",
        data: {'email': email, 'password': password},
      );
      if (res.statusCode == 200) {
        return res.data;
      } else {
        log("Login Failed: ${res.data['message']}");
        return {};
      }
    } catch (err) {
      log("Error Login $err");
      return {};
    }
  }

  // Future<Map<String, dynamic>> register(String username, String email, String password) async {
  //   try {
  //     final response = await _api.request(endpoint: "register", method: "POST");
  //     if (response.statusCode == 200) {
  //       return response.data;
  //     } else {
  //       log("Register Failed : ${response.data['message']}");
  //       return {};
  //     }
  //   } catch (err) {
  //     log("Error Register: $err");
  //     return {};
  //   }
  // }
  Future<Map<String, dynamic>> register(String email, String username, String password) async {
    try {
      final response = await _api.request(
        endpoint: "register",
        method: "POST",
        data: {"email": email, "username": username, "password": password},
      );

      final data = response.data;

      return {
        "success": data['success'] ?? false,
        "message": data['message'] ?? "Unknown error",
        "token": data['token'],
        "user": data['user'],
      };
    } catch (e) {
      return {"success": false, "message": "Register failed"};
    }
  }

  Future<Map<String, dynamic>> sentOtp(String email) async {
    try {
      final response = await _api.request(
        endpoint: "send_otp",
        method: "POST",
        data: {"email": email},
      );

      final data = response.data;

      return {
        "success": data['success'] ?? false,
        "message": data['message'] ?? "Unknown response",
      };
    } catch (err) {
      log("sendOtp error: $err");

      return {"success": false, "message": "Failed to send OTP. Please try again."};
    }
  }

  Future<Map<String, dynamic>> verifyOtp(String email, String otp) async {
    try {
      final response = await _api.request(
        endpoint: "verify_otp",
        method: "POST",
        data: {"email": email, "otp": otp},
      );

      final data = response.data;

      return {
        "success": data['success'] ?? false,
        "message": data['message'] ?? "Unknown response",
      };
    } catch (err) {
      log("verifyOtp error: $err");

      return {"success": false, "message": "OTP verification failed"};
    }
  }

  Future<User> getProfile() async {
    try {
      final res = await _api.request(endpoint: "profile", method: "GET");
      if (res.statusCode == 200) {
        final data = res.data;
        return User.fromJson(data);
      } else {
        log("Faild get profile: ${res.data['message']}");
        return User.empty();
      }
    } catch (err) {
      log("Error get profile: $err");
      return User.empty();
    }
  }

  Future<Map<String, dynamic>> editProfile({String? username, String? imagePath}) async {
    try {
      FormData formData = FormData.fromMap({
        "username": username,
        // if (imagePath != null)
        //   "picture": await MultipartFile.fromFile(imagePath, filename: imagePath.split('/').last),
        if (imagePath != null)
          "picture": await MultipartFile.fromFile(imagePath, filename: imagePath.split('/').last),
      });

      final response = await _api.request(
        endpoint: "/user/edit_profile",
        method: "POST",
        data: formData,
      );

      if (response.statusCode == 200) {
        return {
          "success": true,
          "message": response.data['message'] ?? "Profile updated successfully",
          "user": response.data['user'],
        };
      } else {
        return {
          "success": false,
          "message": response.data['message'] ?? "Failed to update profile",
          "user": null,
        };
      }
    } catch (err) {
      return {"success": false, "message": "Something went wrong: $err", "user": null};
    }
  }

  // Future<Map<String, dynamic>> verifyOtp(String email, String otp) async {
  //   try {
  //     final response = await _api.request(
  //       endpoint: "verify_otp",
  //       method: "POST",
  //       data: {"email": email, "otp": otp},
  //     );
  //     if (response.statusCode == 200) {
  //       Get.snackbar("success", response.data['message']);

  //       return response.data;
  //       // return AuthResponse(
  //       //   success: true,
  //       //   message: response.data['message'] ?? "OTP verified successfully",
  //       // );
  //     } else {
  //       // return AuthResponse(
  //       //   success: false,
  //       //   message: response.data['message'] ?? "Failed to verify OTP",
  //       // );
  //       log("Error verify OTP: ${response.data['message']}");
  //       return {};
  //     }
  //   } catch (err) {
  //     log(err.toString());
  //     return {};
  //     // return AuthResponse(success: false, message: err.toString());
  //   }
  // }

  // Future<void> login(String email, String password) async {
  //   try {
  //     final response = await _api.request(
  //       endpoint: "login",
  //       method: "POST",
  //       data: {"email": email, "password": password},
  //     );

  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       final token = response.data['token'];
  //       await _tokenStorage.setToken(token);
  //       log("JWT_TOKEN: $token");
  //       // return AuthResponse(
  //       //   success: true,
  //       //   message: response.data['message'] ?? "Login successful",
  //       //   token: token,
  //       //   user: response.data['user'] != null
  //       //       ? Map<String, dynamic>.from(response.data['user'])
  //       //       : null,
  //       // );
  //     }
  //     log("Error login: " + response.data['message']);
  //     // return AuthResponse(success: false, message: response.data['message'] ?? "Login failed");
  //   } catch (err) {
  //     log("Error Login: $err");
  //     // return AuthResponse(success: false, message: err.toString());
  //   }
  // }

  // Future<void> register(String username, String email, String password) async {
  //   try {
  //     final response = await _api.request(
  //       endpoint: "register",
  //       method: "POST",
  //       data: {"username": username, "email": email, "password": password},
  //     );
  //     if (response.statusCode! >= 200 && response.statusCode! < 300) {
  //       log(response.data['message']);
  //       // return AuthResponse(
  //       //   success: true,
  //       //   message: response.data['message'] ?? "Login successful",
  //       //   token: response.data['token'],
  //       //   user: response.data['user'] != null
  //       //       ? Map<String, dynamic>.from(response.data['user'])
  //       //       : null,
  //       // );
  //     } else {
  //       log("Error register: " + response.data['message']);
  //       // return AuthResponse(success: false, message: response.data['message'] ?? "Login failed");
  //     }
  //   } catch (err) {
  //     {
  //       log(err.toString());
  //       // return AuthResponse(success: false, message: err.toString());
  //     }
  //   }
  // }

  // Future<AuthResponse> loginGoogle(String idToken) async {
  //   try {
  //     final response = await _api.request(
  //       endpoint: "google_signin",
  //       method: "POST",
  //       data: {"idToken": idToken},
  //     );
  //     if (response.statusCode == 201) {
  //       final token = response.data['token'];
  //       _tokenStorage.setToken(token);
  //       return AuthResponse(
  //         success: true,
  //         message: response.data['message'] ?? "Login successful",
  //         token: token,
  //       );
  //     } else {
  //       return AuthResponse(success: false, message: response.data['message'] ?? "Login failed");
  //     }
  //   } catch (err) {
  //     return AuthResponse(success: false, message: err.toString());
  //   }
  // }
}
