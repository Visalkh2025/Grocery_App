import 'package:get/get.dart';
import 'package:grocery_app/models/user.dart';

class UserController extends GetxController {
  Rx<User> user = Rx(User.empty());

  final isLoading = false.obs;
}
