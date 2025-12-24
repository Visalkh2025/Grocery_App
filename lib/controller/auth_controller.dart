import 'dart:developer';
import 'package:get/get.dart';
import 'package:grocery_app/models/auth_response.dart';
import 'package:grocery_app/service/api/auth_api.dart';
import 'package:grocery_app/service/google_signin_service.dart';
import 'package:grocery_app/service/storage/token_storage.dart';

class AuthController extends GetxController {
  final AuthApi _authApi = AuthApi();
  final isLoading = false.obs;
  final GoogleSigninService _googleSigninService = GoogleSigninService();
  final TokenStorage _tokenStorage = TokenStorage();

  // Future<AuthResponse> register(String username, String email, String password) async {
  //   isLoading(true);
  //   final res = await _authApi.register(username, email, password);
  //   isLoading(false);
  //   return res;
  // }

  Future<AuthResponse> loginGoogle(String idToken) async {
    isLoading(true);
    final res = await _authApi.loginGoogle(idToken);
    isLoading(false);
    return res;
  }

  Future<void> logout() async {
    await _googleSigninService.signOut();
    await _tokenStorage.clearToken();
  }

  // Sign in with email
  var email = "".obs;
  var otp = "".obs;
  var isOtpVerified = false.obs;

  // void sentOtp(final String email) async {
  //   isLoading(true);
  //   final res = await _authApi.sentOtp(email);
  //   if (res.success) {
  //     eamil.value = email;
  //     // Get.to(() => OtpPage());
  //     isLoading(false);
  //   }
  // }
  Future<AuthResponse> sentOtp(final String email) async {
    isLoading(true);
    final res = await _authApi.sentOtp(email);
    if (res.success) {
      this.email.value = email;
      isLoading(false);
      return res;
    }
    isLoading(false);
    log(email);
    return res;
  }

  Future<AuthResponse> verifyOtp(final String otp) async {
    log("Verifying OTP for email: ${email.value}");
    isLoading(true);
    final res = await _authApi.verifyOtp(email.value, otp);
    if (res.success) {
      isOtpVerified(true);
      isLoading(false);
      return res;
    }
    isLoading(false);
    return res;
  }

  Future<AuthResponse> register(String username, String password) async {
    isLoading(true);
    final res = await _authApi.register(username, email.value, password);
    if (res.success) {
      isLoading(false);
      log("Registering user: $username with email: ${email.value}");

      return res;
    }
    isLoading(false);
    return res;
  }

  Future<AuthResponse> login(String email, String password) async {
    isLoading(true);
    final res = await _authApi.login(email, password);
    if (res.success) {
      log("User logged in with email: $email");
      isLoading(false);
      log("Token stored: ${res.token}");
      return res;
    }
    isLoading(false);
    return res;
  }

  // void login(String email, password) async {
  //   isLoading(true);
  //   await _authApi.login(email, password);
  //   isLoading(false);
  // }

  // void register(String username, String email, String password) async {
  //   isLoading(true);
  //   await _authApi.register(username, email, password);
  //   isLoading(false);
  // }

  // void loginGoogle(String idToken) async {
  //   isLoading(true);
  //   await _authApi.loginGoogle(idToken);
  //   isLoading(false);
  // }
}
