import 'package:grocery_app/models/user.dart';

class AuthResponse {
  final bool success;
  final String message;
  final String? token;
  final User? user;

  AuthResponse({required this.success, required this.message, this.token, this.user});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      token: json['token'],
      user: json['user'],
    );
  }
}
