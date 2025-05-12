import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/chart/chart.dart';
import 'package:expense_tracker/widgets/expense_modal.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [];

  void _removeRow(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);
    if (expenseIndex < 0) {
      return;
    }
    setState(() {
      _registeredExpenses.remove(expense);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Expense deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _registeredExpenses.insert(expenseIndex, expense);
            });
          },
        ),
      ),
    );
  }

  void _onAddExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
      _registeredExpenses.sort((a, b) => a.compareTo(b));
    });
  }

  void _onUpdateExpense(Expense expense) {
    final index = _registeredExpenses.indexWhere(
      (element) => element.id == expense.id,
    );
    if (index >= 0) {
      setState(() {
        _registeredExpenses[index] = expense;
        _registeredExpenses.sort((a, b) => a.compareTo(b));
      });
    }
  }

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) => ExpenseModal.forNewExpense(onAddUpdateExpense: _onAddExpense),
    );
  }

  void _openUpdateExpenseOverlay(String expenseId) {
    final index = _registeredExpenses.indexWhere(
      (element) => element.id == expenseId,
    );
    if (index >= 0) {
      showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder:
            (ctx) => ExpenseModal(
              _registeredExpenses[index],
              onAddUpdateExpense: _onUpdateExpense,
            ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent = const Center(
      child: Text('No expenses found. Start adding some!'),
    );

    if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: _registeredExpenses,
        onRemoveExpense: _removeRow,
        onEditExpense: _openUpdateExpenseOverlay,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter ExpenseTracker'),
        actions: [
          IconButton(
            onPressed: _openAddExpenseOverlay,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Column(
        children: [
          Chart(expenses: _registeredExpenses),
          Expanded(child: mainContent),
        ],
      ),
    );
  }
}
