import 'package:get/get.dart';
import 'views/auth/login_page.dart';
import 'views/auth/register_page.dart';
import 'views/home/dashboard_page.dart';
import 'views/home/add_edit_transaction_page.dart';
import 'views/home/transaction_list_page.dart';

class Routes {
  static const login = '/';
  static const register = '/register';
  static const dashboard = '/dashboard';
  static const addEdit = '/add-edit';
  static const list = '/list';
}

class AppPages {
  static final pages = [
    GetPage(name: Routes.login, page: () => LoginPage()),
    GetPage(name: Routes.register, page: () => RegisterPage()),
    GetPage(name: Routes.dashboard, page: () => DashboardPage()),
    GetPage(name: Routes.addEdit, page: () => AddEditTransactionPage()),
    GetPage(name: Routes.list, page: () => TransactionListPage()),
  ];
}