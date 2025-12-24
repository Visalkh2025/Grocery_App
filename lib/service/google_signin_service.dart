import 'package:google_sign_in/google_sign_in.dart';
import 'package:grocery_app/config/env_config.dart';

class GoogleSigninService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    // serverClientId:
    //     "546234319014-2agh2jlrvcurs7mkf8ipmo2d2r0m7ska.apps.googleusercontent.com",
    serverClientId: Envconfig.googleClientId,
  );
  Future<GoogleSignInAccount?> signInWithGoogle() async {
    GoogleSignInAccount? user = await _googleSignIn.signIn();

    return user;
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }
}
