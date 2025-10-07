import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/transaction_model.dart';
import '../../routes.dart';

class TransactionItem extends StatelessWidget {
  final TransactionModel model;
  const TransactionItem({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(model.title),
      subtitle: Text('${model.category} • ${model.date.toLocal().toIso8601String().substring(0,10)}'),
      trailing: Text('${model.type == 'income' ? '+' : '-'}${model.amount.toStringAsFixed(2)}'),
      onTap: () => Get.toNamed(Routes.addEdit, arguments: model),
    );
  }
}
