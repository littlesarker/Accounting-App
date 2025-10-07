import 'package:cloud_firestore/cloud_firestore.dart';

// class TransactionModel {
//   String id;
//   String title;
//   double amount;
//   String type; // 'income' or 'expense'
//   String category;
//   DateTime date;
//   DateTime createdAt;
//
//   TransactionModel({
//     required this.id,
//     required this.title,
//     required this.amount,
//     required this.type,
//     required this.category,
//     required this.date,
//     required this.createdAt,
//   });
//
//   factory TransactionModel.fromDoc(DocumentSnapshot doc) {
//     final data = doc.data() as Map<String, dynamic>;
//     return TransactionModel(
//       id: doc.id,
//       title: data['title'] ?? '',
//       amount: (data['amount'] ?? 0).toDouble(),
//       type: data['type'] ?? 'expense',
//       category: data['category'] ?? '',
//       date: (data['date'] as Timestamp).toDate(),
//       createdAt: (data['createdAt'] as Timestamp).toDate(),
//     );
//   }
//
//   Map<String, dynamic> toMap() {
//     return {
//       'title': title,
//       'amount': amount,
//       'type': type,
//       'category': category,
//       'date': Timestamp.fromDate(date),
//       'createdAt': Timestamp.fromDate(createdAt),
//     };
//   }
// }


class TransactionModel {
  String id;
  String userId; // ✅ NEW FIELD
  String title;
  double amount;
  String type; // 'income' or 'expense'
  String category;
  DateTime date;
  DateTime createdAt;

  TransactionModel({
    required this.id,
    required this.userId, // ✅
    required this.title,
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
    required this.createdAt,
  });

  factory TransactionModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TransactionModel(
      id: doc.id,
      userId: data['userId'] ?? '', // ✅ get userId from Firestore
      title: data['title'] ?? '',
      amount: (data['amount'] ?? 0).toDouble(),
      type: data['type'] ?? 'expense',
      category: data['category'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId, // ✅ save userId to Firestore
      'title': title,
      'amount': amount,
      'type': type,
      'category': category,
      'date': Timestamp.fromDate(date),
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}

