import 'package:flutter/material.dart';
import 'package:flutter_hive_app/provider/transaction_provider.dart';
import 'package:flutter_hive_app/widgets/transaction_dialog.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../model/transaction_model.dart';

Widget buildContent(List<Transaction> transactions) {
  if (transactions.isEmpty) {
    return const Center(
      child: Text(
        'No expensess yet',
        style: TextStyle(fontSize: 24),
      ),
    );
  } else {
    final netExpense = transactions.fold<double>(
        0,
        (previousValue, transaction) => transaction.isExpense
            ? previousValue - transaction.amount
            : previousValue + transaction.amount);
    final netExpenseString = '\$${netExpense.toStringAsFixed(2)}';
    final color = netExpense > 0 ? Colors.green : Colors.red;

    return Column(
      children: [
        const SizedBox(
          height: 24,
        ),
        Text(
          'Net Expense: $netExpenseString',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: color,
          ),
        ),
        const SizedBox(
          height: 24,
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: transactions.length,
            itemBuilder: (BuildContext context, index) {
              final transaction = transactions[index];
              return buildTransaction(context, transaction);
            },
          ),
        )
      ],
    );
  }
}

Widget buildButtons(BuildContext context, Transaction transaction) {
  final transactionProvider = Provider.of<TransactionProvider>(context);
  return Row(
    children: [
      Expanded(
        child: TextButton.icon(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: ((context) {
              return TranasctionDialog(
                transaction: transaction,
                onClickedDone: (name, amount, isExpense) {
                  // editTransaction(transaction, name, amount, isExpense);
                  transactionProvider.editTransaction(
                      transaction, name, amount, isExpense);
                },
              );
            })));
          },
          icon: const Icon(Icons.edit),
          label: const Text('Edit'),
        ),
      ),
      Expanded(
        child: TextButton.icon(
          onPressed: () {
            transactionProvider.deleteTransaction(transaction);
          },
          icon: const Icon(Icons.delete),
          label: const Text('Delete'),
        ),
      ),
    ],
  );
}

Widget buildTransaction(
  BuildContext context,
  Transaction transaction,
) {
  final color = transaction.isExpense ? Colors.red : Colors.green;
  final date = DateFormat.yMMMd().format(transaction.createDate);
  return Card(
    color: Colors.white,
    child: ExpansionTile(
      title: Text(
        transaction.name,
        maxLines: 2,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      subtitle: Text(date),
      trailing: Text(
        transaction.amount.toString(),
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      children: [
        buildButtons(context, transaction),
      ],
    ),
  );
}
