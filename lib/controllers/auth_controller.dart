import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

import 'transaction_controller.dart';

class AuthController extends GetxController {
  final AuthService _authService = Get.find();
  final Rxn<User> firebaseUser = Rxn<User>();

  @override
  void onInit() {
    firebaseUser.bindStream(_authService.authStateChanges());
    ever(firebaseUser, _onAuthChanged);
    super.onInit();
  }

  void _onAuthChanged(User? user) {
    if (user == null) {
      // user signed out
      Get.offAllNamed('/'); // login
    } else {
      // user signed in
      Get.offAllNamed('/dashboard');
      // trigger transaction controller to load user-specific streams
      Get.find<TransactionController>().bindToUser(user.uid);
    }
  }


  Future<void> login(String email, String password) async {
    try {
      final cred = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = cred.user;
      if (user != null) {
        final txCtrl = Get.find<TransactionController>();
        txCtrl.bindToUser(user.uid);
        Get.offAllNamed('/dashboard'); // go to dashboard
      }
    } catch (e) {
      Get.snackbar('Login Error', e.toString());
    }
  }
  Future<void> register(String email, String password) async {
    try {
      final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = cred.user;
      if (user != null) {
        final txCtrl = Get.find<TransactionController>();
        txCtrl.bindToUser(user.uid);
        Get.offAllNamed('/dashboard');
      }
    } catch (e) {
      Get.snackbar('Register Error', e.toString());
    }
  }

  Future<void> logout() async {
    await _authService.logout();
  }

  User? get user => firebaseUser.value;
}
