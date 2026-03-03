import 'package:get/get.dart';
import '../../app/routes/app_routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import '../../data/datasources/firebase_user_datasource.dart';
import '../../domain/entities/user_entity.dart';

class AuthController extends GetxController {
  final email = ''.obs;
  final password = ''.obs;
  final confirmPassword = ''.obs;
  final isLoading = false.obs;
  final isGoogleLoading = false.obs;
  final isFacebookLoading = false.obs;
  final obscurePassword = true.obs;
  final obscureConfirm = true.obs;
  final isLogin = true.obs; // toggle between Login & Sign Up

  void toggleMode() => isLogin.toggle();
  void togglePasswordVisibility() => obscurePassword.toggle();
  void toggleConfirmVisibility() => obscureConfirm.toggle();

  final FirebaseUserDatasource _userDatasource = FirebaseUserDatasource();

  Future<void> _handleAuthSuccess(User firebaseUser, {String? name}) async {
    UserEntity? user = await _userDatasource.getUser(firebaseUser.uid);

    if (user == null) {
      // Create new user record
      user = UserEntity(
        id: firebaseUser.uid,
        name: name ?? firebaseUser.displayName ?? 'Customer',
        email: firebaseUser.email ?? '',
        profileImageUrl: firebaseUser.photoURL,
        role: 'customer', // default role
        createdAt: DateTime.now(),
      );
      await _userDatasource.createUserOrUpdate(user);
    }

    Get.offAllNamed(AppRoutes.shell);
  }

  Future<void> submit() async {
    if (isLoading.value) return;

    // Basic validation
    if (email.value.isEmpty || password.value.isEmpty) {
      Get.snackbar(
        'Missing fields',
        'Please fill in all required fields.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    if (!isLogin.value && password.value != confirmPassword.value) {
      Get.snackbar(
        'Password mismatch',
        'Passwords do not match.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;
    try {
      if (isLogin.value) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email.value.trim(), password: password.value);
        await _handleAuthSuccess(FirebaseAuth.instance.currentUser!);
      } else {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: email.value.trim(), password: password.value);
        await _handleAuthSuccess(FirebaseAuth.instance.currentUser!,
            name: email.value.trim().split('@').first);
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', e.message ?? 'Authentication failed',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signInWithGoogle() async {
    if (isGoogleLoading.value || isFacebookLoading.value) return;

    isGoogleLoading.value = true;
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        // User canceled the login
        isGoogleLoading.value = false;
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      await _handleAuthSuccess(FirebaseAuth.instance.currentUser!,
          name: googleUser.displayName);
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Google Login Failed', e.message ?? 'Unknown error occurred',
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error', 'Failed to sign in with Google: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isGoogleLoading.value = false;
    }
  }

  Future<void> signInWithFacebook() async {
    if (isGoogleLoading.value || isFacebookLoading.value) return;

    isFacebookLoading.value = true;
    try {
      final LoginResult result = await FacebookAuth.instance.login();
      if (result.status == LoginStatus.success) {
        final AccessToken accessToken = result.accessToken!;
        final OAuthCredential credential =
            FacebookAuthProvider.credential(accessToken.tokenString);

        await FirebaseAuth.instance.signInWithCredential(credential);
        await _handleAuthSuccess(FirebaseAuth.instance.currentUser!);
      } else if (result.status == LoginStatus.cancelled) {
        // User canceled login
      } else {
        Get.snackbar(
            'Facebook Login Failed', result.message ?? 'Unknown error occurred',
            snackPosition: SnackPosition.BOTTOM);
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
          'Facebook Login Failed', e.message ?? 'Unknown error occurred',
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error', 'Failed to sign in with Facebook.',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isFacebookLoading.value = false;
    }
  }

  Future<void> continueAsGuest() async {
    Get.offAllNamed(AppRoutes.shell);
  }
}
