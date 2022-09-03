import 'package:flutter/material.dart';

import 'package:flutter_hive_app/model/transaction_model.dart';

class TranasctionDialog extends StatefulWidget {
  final Transaction? transaction;
  final Function(String name, double amount, bool isExpense) onClickedDone;
  const TranasctionDialog({
    Key? key,
    this.transaction,
    required this.onClickedDone,
  }) : super(key: key);

  @override
  State<TranasctionDialog> createState() => _TranasctionDialogState();
}

class _TranasctionDialogState extends State<TranasctionDialog> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final amountController = TextEditingController();
  bool isExpense = true;

  @override
  void initState() {
    super.initState();
    if (widget.transaction != null) {
      final transaction = widget.transaction!;
      nameController.text = transaction.name;
      amountController.text = transaction.amount.toString();
      isExpense = transaction.isExpense;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isEditing = widget.transaction != null;
    final title = isEditing ? 'Edit Transaction' : 'Add Transaction';
    return AlertDialog(
      title: Text(title),
      content: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(
                height: 8,
              ),
              buildName(),
              const SizedBox(
                height: 8,
              ),
              buildAmount(),
              const SizedBox(
                height: 8,
              ),
              buildRadioButtons(),
            ],
          ),
        ),
      ),
      actions: [
        buildCancelButton(context),
        buildAddButton(context, isEditing: isEditing),
      ],
    );
  }

  Widget buildName() {
    return TextFormField(
      controller: nameController,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        hintText: 'Enter Name',
      ),
      validator: (name) {
        return name != null && name.isEmpty ? 'Enter a name' : null;
      },
    );
  }

  Widget buildAmount() {
    return TextFormField(
      controller: amountController,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        hintText: 'Enter Amount',
      ),
      validator: (amount) {
        return amount != null && double.tryParse(amount) == null
            ? 'Enter a Amount'
            : null;
      },
    );
  }

  Widget buildRadioButtons() {
    return Column(
      children: [
        RadioListTile<bool>(
          title: const Text('Expense'),
          value: true,
          groupValue: isExpense,
          onChanged: (value) {
            return setState(() {
              isExpense = value!;
            });
          },
        ),
        RadioListTile<bool>(
          title: const Text('Income'),
          value: false,
          groupValue: isExpense,
          onChanged: (value) {
            return setState(() {
              isExpense = value!;
            });
          },
        ),
      ],
    );
  }

  Widget buildCancelButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: const Text('Cancel'),
    );
  }

  Widget buildAddButton(BuildContext context, {required bool isEditing}) {
    final text = isEditing ? 'Save' : 'Add';
    return TextButton(
        onPressed: () async {
          final isValid = formKey.currentState!.validate();
          if (isValid) {
            final name = nameController.text;
            final amount = double.tryParse(amountController.text) ?? 0;
            widget.onClickedDone(name, amount, isExpense);
            Navigator.of(context).pop();
          }
        },
        child: Text(text));
  }
}
