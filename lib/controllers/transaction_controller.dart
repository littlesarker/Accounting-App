import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../models/transaction_model.dart';
import '../services/firestore_service.dart';

class TransactionController extends GetxController {
  final FirestoreService _fs = Get.find();

  // reactive list of transactions
  final RxList<TransactionModel> transactions = <TransactionModel>[].obs;

  // totals
  final RxDouble totalIncome = 0.0.obs;
  final RxDouble totalExpense = 0.0.obs;
  final RxDouble netBalance = 0.0.obs;

  Stream<List<TransactionModel>>? _stream;
  String? _uid;
  StreamSubscription<List<TransactionModel>>? _sub;

  void bindToUser(String uid) {
    // cancel previous
    _sub?.cancel();
    _uid = uid;
    _stream = _fs.streamTransactions(uid);
    _sub = _stream!.listen((list) {
      transactions.assignAll(list);
      _recalculate();
    }, onError: (err) {
      // handle errors
      debugPrint('Transaction stream error: $err');
    });
  }

  void _recalculate() {
    final income = transactions
        .where((t) => t.type == 'income')
        .fold<double>(0.0, (p, e) => p + e.amount);
    final expense = transactions
        .where((t) => t.type == 'expense')
        .fold<double>(0.0, (p, e) => p + e.amount);
    totalIncome.value = income;
    totalExpense.value = expense;
    netBalance.value = income - expense;
  }

  Future<void> addTransaction(TransactionModel model) {
    if (_uid == null) return Future.error('No user bound');
    return _fs.addTransaction(_uid!, model);
  }

  Future<void> updateTransaction(TransactionModel model) {
    if (_uid == null) return Future.error('No user bound');
    return _fs.updateTransaction(_uid!, model);
  }

  Future<void> deleteTransaction(String id) {
    if (_uid == null) return Future.error('No user bound');
    return _fs.deleteTransaction(_uid!, id);
  }

  @override
  void onClose() {
    _sub?.cancel();
    super.onClose();
  }
}
