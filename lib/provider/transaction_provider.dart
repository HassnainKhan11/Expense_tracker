import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../boxes.dart';
import '../model/transaction_model.dart';

class TransactionProvider extends ChangeNotifier {
  final List<Transaction> transactions = [];

// add transaction method
  Future addTransaction(String name, double amount, bool isExpense) async {
    final transaction = Transaction()
      ..name = name
      ..createDate = DateTime.now()
      ..amount = amount
      ..isExpense = isExpense;

    final box = Boxes.getTransactionBox();
    await box.add(transaction);
    notifyListeners();
  }

//edit transaction method
  void editTransaction(
      Transaction transaction, String name, double amount, bool isExpense) {
    transaction.name = name;
    transaction.amount = amount;
    transaction.isExpense = isExpense;
    transaction.save();
    notifyListeners();
  }

//delete transaction

  void deleteTransaction(Transaction transaction) {
    transaction.delete();
    notifyListeners();
  }
}
