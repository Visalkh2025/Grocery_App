import 'dart:developer';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:grocery_app/models/auth_response.dart';
import 'package:grocery_app/models/user.dart';
import 'package:grocery_app/pages/OTP_page.dart';
import 'package:grocery_app/service/api/auth_api.dart';
import 'package:grocery_app/service/google_signin_service.dart';
import 'package:grocery_app/service/storage/token_storage.dart';

class AuthController extends GetxController {
  final AuthApi _authApi = AuthApi();
  final isLoading = false.obs;
  final GoogleSigninService _googleSigninService = GoogleSigninService();
  final TokenStorage _tokenStorage = TokenStorage();
  final userCache = GetStorage();
  // Rx<User> user = Rx(User.empty());
  Rxn<User> user = Rxn<User>();

  RxBool isLoggedIn = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserFromCache();
  }

  Future<bool> loginGooglefir(String idToken) async {
    try {
      isLoading(true);

      final res = await _authApi.loginGoogle(idToken);

      if (res['success'] == true) {
        // 1️⃣ Save token
        await _tokenStorage.setToken(res['token']);

        // 2️⃣ Parse user
        final userData = User.fromJson(res['user']);

        // 3️⃣ Update RX
        user.value = userData;
        isLoggedIn.value = true;

        // 4️⃣ Cache user
        userCache.write('user', userData.toJson());
        return true;
      }

      return false;
    } catch (e) {
      return false;
    } finally {
      isLoading(false);
    }
  }

  Future<bool> handleLogin(Map<String, dynamic> res) async {
    if (res['success'] != true) return false;
    await _tokenStorage.setToken(res['token']);
    final userData = User.fromJson(res['user']);
    user.value = userData;
    isLoggedIn.value = true;
    //  Cache
    userCache.write('user', userData.toJson());

    return true;
  }

  // Future<bool> login(String email, String password) async {
  //   isLoading(true);
  //   final res = await _authApi.login(email, password);
  //   isLoading(false);
  //   return handleLogin(res);
  // }
  Future<Map<String, dynamic>> login(String email, String password) async {
    isLoading(true);
    final res = await _authApi.login(email, password);
    isLoading(false);

    if (res['success'] == true) {
      await handleLogin(res);
    }

    return res;
  }

  Future<Map<String, dynamic>> loginGoogle(String idToken) async {
    isLoading(true);
    final res = await _authApi.loginGoogle(idToken);
    isLoading(false);
    if (res['success'] == true) {
      await handleLogin(res);
    }
    return res;
  }

  Future<bool> register(String username, String password) async {
    if (!isOtpVerified.value) {
      Get.snackbar("Error", "Verify OTP first");
      return false;
    }

    final res = await _authApi.register(email.value, username, password);
    return handleLogin(res);
  }

  Future<void> logout() async {
    await _googleSigninService.signOut();
    await _tokenStorage.clearToken();

    await userCache.erase();

    user.value = User.empty();
    isLoggedIn.value = false;
  }

  // Sign in with email
  var email = "".obs;
  var otp = "".obs;
  var isOtpVerified = false.obs;

  Future<bool> sentOtp(String email) async {
    isLoading(true);
    final res = await _authApi.sentOtp(email);

    if (res['success'] == true) {
      this.email.value = email;
      return true;
    }
    Get.snackbar("Error", res['message'] ?? "Failed to send OTP");
    return false;
  }

  Future<bool> verifyOtp(String otp) async {
    isLoading(true);

    final res = await _authApi.verifyOtp(email.value, otp);

    isLoading(false);

    if (res['success'] == true) {
      isOtpVerified.value = true;
      return true;
    }

    Get.snackbar("Error", res['message']);
    return false;
  }

  Future<Map<String, dynamic>> editProfile(String? username, String? imagePath) async {
    // isLoading(true);

    final res = await _authApi.editProfile(username: username, imagePath: imagePath);
    if (res['success'] == true && res['user'] != null) {
      // Update user observable
      user.value = User.fromJson(res['user']);
      // Update cache
      userCache.write('user', user.value!.toJson());
    }
    return res;
  }

  // void sentOtp(final String email) async {
  //   isLoading(true);
  //   final res = await _authApi.sentOtp(email);
  //   if (res.success) {
  //     eamil.value = email;
  //     // Get.to(() => OtpPage());
  //     isLoading(false);
  //   }
  // }

  // Future<AuthResponse> sentOtp(final String email) async {
  //   isLoading(true);
  //   final res = await _authApi.sentOtp(email);
  //   if (res.success) {
  //     this.email.value = email;
  //     isLoading(false);
  //     return res;
  //   }
  //   isLoading(false);
  //   log(email);
  //   return res;
  // }

  // Future<void> verifyOtp(final String otp) async {
  //   log("Verifying OTP for email: ${email.value}");
  //   isLoading(true);
  //   final res = await _authApi.verifyOtp(email.value, otp);
  //   // if (res.success) {
  //   isOtpVerified(true);
  //   isLoading(false);
  //   return res;
  //   // }
  //   isLoading(false);
  //   // return res;
  // }

  // Future<void> register(String username, String password) async {
  //   isLoading(true);
  //   final res = await _authApi.register(username, email.value, password);
  //   // if (res.success) {
  //     isLoading(false);
  //     log("Registering user: $username with email: ${email.value}");

  //     return res;
  //   }
  //   // isLoading(false);
  //   // return res;
  // }

  // Future<void> login(String email, String password) async {
  //   isLoading(true);
  //   final res = await _authApi.login(email, password);
  //   if (res.success) {
  //     log("User logged in with email: $email");

  //     user.value = res.user as User;
  //     userCache.write('user', res.user?.toJson());
  //     isLoggedIn.value = true;
  //     isLoading(false);
  //     log("Token stored: ${res.token}");
  //     return res;
  //   }
  //   isLoading(false);
  //   return res;
  // }
  void loadUserFromCache() {
    final data = userCache.read('user');
    if (data != null) {
      log('Cached user: $data');

      user.value = User.fromJson(data);
      isLoggedIn.value = true;
    }
  }
}
