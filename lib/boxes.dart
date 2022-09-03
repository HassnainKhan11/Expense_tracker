import 'package:flutter_hive_app/model/transaction_model.dart';
import 'package:hive/hive.dart';

class Boxes {
  static Box<Transaction> getTransactionBox() {
    return Hive.box<Transaction>('transactions');
  }
}
