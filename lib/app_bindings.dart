import 'package:get/get.dart';
import 'services/auth_service.dart';
import 'services/firestore_service.dart';
import 'controllers/auth_controller.dart';
import 'controllers/transaction_controller.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    // Services
    Get.lazyPut<AuthService>(() => AuthService(),fenix :true);
    Get.lazyPut<FirestoreService>(() => FirestoreService(),fenix: true);

    // Controllers
    Get.lazyPut<AuthController>(() => AuthController(), fenix: true);

    Get.lazyPut<TransactionController>(() => TransactionController(),fenix: true);
  }
}
