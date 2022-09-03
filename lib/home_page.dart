import 'package:flutter/material.dart';
import 'package:flutter_hive_app/boxes.dart';
import 'package:flutter_hive_app/model/transaction_model.dart';
import 'package:flutter_hive_app/provider/transaction_provider.dart';
import 'package:flutter_hive_app/widgets/transaction_dialog.dart';
import 'package:flutter_hive_app/widgets/transaction_widgets.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Transaction> transactions = [];

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 130, 0, 153),
      ),
      body: ValueListenableBuilder<Box<Transaction>>(
        valueListenable: Boxes.getTransactionBox().listenable(),
        builder: (context, box, _) {
          final transaction = box.values.toList().cast<Transaction>();
          return buildContent(transaction);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return TranasctionDialog(
                  onClickedDone: (name, amount, isExpense) async {
                    await transactionProvider.addTransaction(
                        name, amount, isExpense);
                  },
                );
              });
        },
        backgroundColor: const Color.fromARGB(255, 130, 0, 153),
        child: const Icon(Icons.add),
      ),

      ///body: ,
    );
  }
}

// Widget buildContent(List<Transaction> transactions) {
//   if (transactions.isEmpty) {
//     return const Center(
//       child: Text(
//         'No expensess yet',
//         style: TextStyle(fontSize: 24),
//       ),
//     );
//   } else {
//     final netExpense = transactions.fold<double>(
//         0,
//         (previousValue, transaction) => transaction.isExpense
//             ? previousValue - transaction.amount
//             : previousValue + transaction.amount);
//     final netExpenseString = '\$${netExpense.toStringAsFixed(2)}';
//     final color = netExpense > 0 ? Colors.green : Colors.red;

//     return Column(
//       children: [
//         const SizedBox(
//           height: 24,
//         ),
//         Text(
//           'Net Expense: $netExpenseString',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 20,
//             color: color,
//           ),
//         ),
//         const SizedBox(
//           height: 24,
//         ),
//         Expanded(
//           child: ListView.builder(
//             padding: const EdgeInsets.all(8),
//             itemCount: transactions.length,
//             itemBuilder: (BuildContext context, index) {
//               final transaction = transactions[index];
//               return buildTransaction(context, transaction);
//             },
//           ),
//         )
//       ],
//     );
//   }
// }

// Widget buildTransaction(
//   BuildContext context,
//   Transaction transaction,
// ) {
//   final color = transaction.isExpense ? Colors.red : Colors.green;
//   final date = DateFormat.yMMMd().format(transaction.createDate);
//   return Card(
//     color: Colors.white,
//     child: ExpansionTile(
//       title: Text(
//         transaction.name,
//         maxLines: 2,
//         style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//       ),
//       subtitle: Text(date),
//       trailing: Text(
//         transaction.amount.toString(),
//         style: TextStyle(
//           color: color,
//           fontWeight: FontWeight.bold,
//           fontSize: 16,
//         ),
//       ),
//       children: [
//         buildButtons(context, transaction),
//       ],
//     ),
//   );
// }

// Widget buildButtons(BuildContext context, Transaction transaction) {
//   return Row(
//     children: [
//       Expanded(
//         child: TextButton.icon(
//           onPressed: () {
//             Navigator.of(context).push(MaterialPageRoute(builder: ((context) {
//               return TranasctionDialog(
//                 transaction: transaction,
//                 onClickedDone: (name, amount, isExpense) {
//                   editTransaction(transaction, name, amount, isExpense);
//                 },
//               );
//             })));
//           },
//           icon: const Icon(Icons.edit),
//           label: const Text('Edit'),
//         ),
//       ),
//       Expanded(
//         child: TextButton.icon(
//           onPressed: () {
//             deleteTransaction(transaction);
//           },
//           icon: const Icon(Icons.delete),
//           label: const Text('Delete'),
//         ),
//       ),
//     ],
//   );
// }

// // add transaction method
// Future addTransaction(String name, double amount, bool isExpense) async {
//   final transaction = Transaction()
//     ..name = name
//     ..createDate = DateTime.now()
//     ..amount = amount
//     ..isExpense = isExpense;

//   final box = Boxes.getTransactionBox();
//   box.add(transaction);
// }

// //edit transaction method
// void editTransaction(
//     Transaction transaction, String name, double amount, bool isExpense) {
//   transaction.name = name;
//   transaction.amount = amount;
//   transaction.isExpense = isExpense;
//   transaction.save();
// }

// //delete transaction

// void deleteTransaction(Transaction transaction) {
//   transaction.delete();
// }
