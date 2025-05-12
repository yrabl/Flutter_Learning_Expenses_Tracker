import 'package:flutter/material.dart';

class DeleteExpense extends StatelessWidget{
  const DeleteExpense({super.key, required this.onDeleteExpense, required this.onCancel});
  final void Function() onCancel;
  final void Function() onDeleteExpense;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Are you sure?'),
      content: const Text('Do you want to delete this expense?'),
      actions: [
        TextButton(
          onPressed: () {
            onCancel();
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            onDeleteExpense();
            Navigator.of(context).pop();
          },
          child: const Text('Delete'),
        ),
      ],
    );
  }
}