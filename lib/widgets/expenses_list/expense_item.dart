import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/Material.dart';

class ExpenseItem extends StatelessWidget {
  const ExpenseItem({
    super.key,
    required this.expense,
    required this.onEditExpense,
  });

  final Expense expense;
  final void Function(String expenseId) onEditExpense;

  void editExpense() {
    onEditExpense(expense.id);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onLongPress: editExpense,
        onDoubleTap: editExpense,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                expense.title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    '\$${expense.amount.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Icon(expense.categoryIcon),
                      const SizedBox(width: 8),
                      Text(
                        expense.formattedDate,
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
