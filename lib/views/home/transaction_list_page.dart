import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controllers/transaction_controller.dart';
import '../../models/transaction_model.dart';
import '../widgets/transaction_item.dart';


class TransactionListPage extends StatelessWidget {
  TransactionListPage({super.key});
  final TransactionController _tx = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f6f9),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          'Transactions',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
      body: Column(
        children: [
          // 🧾 Summary Header
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xff2196f3), Color(0xff64b5f6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Obx(() {
              final income = _tx.totalIncome.value;
              final expense = _tx.totalExpense.value;
              final balance = _tx.netBalance.value;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Net Balance',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '৳ ${balance.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _summaryCard('Income', income, Colors.greenAccent),
                      _summaryCard('Expense', expense, Colors.redAccent),
                    ],
                  ),
                ],
              );
            }),
          ),

          // 💰 Transaction List
          Expanded(
            child: Obx(() {
              final list = _tx.transactions;
              if (list.isEmpty) {
                return const Center(
                  child: Text(
                    'No transactions yet',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                itemCount: list.length,
                itemBuilder: (_, i) => _transactionCard(context, list[i]),
              );
            }),
          ),
        ],
      ),

      // ➕ Floating Action Button
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed('/add-edit'),
        backgroundColor: const Color(0xff2196f3),
        shape: const CircleBorder(),
        child: const Icon(Icons.add, size: 28, color: Colors.white),
      ),
    );
  }

  // 📊 Summary Card Widget
  Widget _summaryCard(String label, double value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70)),
        const SizedBox(height: 2),
        Text(
          '৳ ${value.toStringAsFixed(2)}',
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  // 💵 Transaction Item Card
  Widget _transactionCard(BuildContext context, TransactionModel model) {
    final isIncome = model.type == 'income';
    final color = isIncome ? Colors.green : Colors.red;

    return Dismissible(
      key: Key(model.id),
      background: Container(
        color: Colors.red.shade400,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      secondaryBackground: Container(
        color: Colors.red.shade400,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) async {
        try {
          await _tx.deleteTransaction(model.id);
          Get.snackbar('Deleted', 'Transaction removed',
              snackPosition: SnackPosition.BOTTOM);
        } catch (e) {
          Get.snackbar('Error', e.toString(),
              snackPosition: SnackPosition.BOTTOM);
        }
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 6),
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: CircleAvatar(
            backgroundColor: color.withOpacity(0.15),
            radius: 24,
            child: Icon(
              isIncome ? Icons.arrow_downward : Icons.arrow_upward,
              color: color,
              size: 20,
            ),
          ),
          title: Text(
            model.title,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            '${model.category} • ${DateFormat.yMMMd().format(model.date)}',
            style: const TextStyle(color: Colors.black54, fontSize: 13),
          ),
          trailing: Text(
            (isIncome ? '+ ' : '- ') + '৳${model.amount.toStringAsFixed(2)}',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          onTap: () => Get.toNamed('/add-edit', arguments: model),
        ),
      ),
    );
  }
}

