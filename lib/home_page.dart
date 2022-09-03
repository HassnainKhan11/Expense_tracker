import 'package:flutter/material.dart';
import 'package:flutter_hive_app/boxes.dart';
import 'package:flutter_hive_app/model/transaction_model.dart';
import 'package:flutter_hive_app/provider/transaction_provider.dart';
import 'package:flutter_hive_app/widgets/change_theme_button.dart';
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
        actions: const [ChangeThemeButton()],
        title: const Text('Expense Tracker'),
        centerTitle: true,
        backgroundColor: Colors.purple,
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
        backgroundColor: Colors.purple,
        child: Icon(
          Icons.add,
          color: Theme.of(context).iconTheme.color,
        ),
      ),

      ///body: ,
    );
  }
}
