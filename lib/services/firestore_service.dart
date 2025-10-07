import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/transaction_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference userDoc(String uid) =>
      _db.collection('users').doc(uid).collection('transactions');

  Stream<List<TransactionModel>> streamTransactions(String uid) {
    return userDoc(uid)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snap) =>
        snap.docs.map((d) => TransactionModel.fromDoc(d)).toList());
  }

  Future<void> addTransaction(String uid, TransactionModel model) =>
      userDoc(uid).add(model.toMap());

  Future<void> updateTransaction(String uid, TransactionModel model) =>
      userDoc(uid).doc(model.id).update(model.toMap());

  Future<void> deleteTransaction(String uid, String transactionId) =>
      userDoc(uid).doc(transactionId).delete();
}
