import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';

class ExpenseModal extends StatefulWidget {
  ExpenseModal(this.expanse, {super.key, required this.onAddUpdateExpense});
  Expense? expanse;

  ExpenseModal.forNewExpense({
    super.key,
    required this.onAddUpdateExpense,
  });

  final void Function(Expense expanse) onAddUpdateExpense;

  @override
  State<ExpenseModal> createState() => _ExpenseModalState();
}

class _ExpenseModalState extends State<ExpenseModal> {
  final _titleFocus = FocusNode();
  final _amountFocus = FocusNode();
  final _selectedCategoryFocus = FocusNode();
  final _saveExpenseFocus = FocusNode();

  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.food;

  @override
  void initState() {
    super.initState();
    if(widget.expanse == null) {
      return;
    }
    _selectedCategory = widget.expanse!.category;
    _titleController.text = widget.expanse!.title;
    _amountController.text = widget.expanse!.amount.toString();
    _selectedDate = widget.expanse!.date;
  }

  void _submitData() {
    final enteredTitle = _titleController.text;
    final enteredAmount = double.tryParse(_amountController.text);

    if (enteredTitle.isEmpty ||
        enteredAmount == null ||
        enteredAmount <= 0 ||
        _selectedDate == null) {
      return;
    }
    
    var outputExpense;
    if (widget.expanse == null) {
      outputExpense = Expense(
        title: enteredTitle,
        amount: enteredAmount,
        date: _selectedDate!,
        category: _selectedCategory,
      );
    } else {
    outputExpense = Expense(
      id: widget.expanse!.id,
      title: enteredTitle,
      amount: enteredAmount,
      date: _selectedDate!,
      category: _selectedCategory,
    );}
    widget.onAddUpdateExpense(outputExpense);
    Navigator.pop(context);
  }

  void switchFocus() {
    final scope = FocusScope.of(context);

    if (_titleFocus.hasFocus) {
      scope.requestFocus(_amountFocus);
    } else if (_amountFocus.hasFocus) {
      _amountFocus.unfocus();
      presentDatePicker();
    } else if (_selectedCategoryFocus.hasFocus) {
      _selectedCategoryFocus.unfocus();
    } else {
      scope.requestFocus(_saveExpenseFocus);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _titleFocus.dispose();
    _amountFocus.dispose();
    _selectedCategoryFocus.dispose();
    _saveExpenseFocus.dispose();
    super.dispose();
  }

  void presentDatePicker() {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: now,
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
        FocusScope.of(context).requestFocus(_selectedCategoryFocus);
      });
    });
  }

  void setSelectedCategory(Category category) {
    setState(() {
      _selectedCategory = category;
      switchFocus();
    });
  }

  void _cancel() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          16,
          16,
          16,
          MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              focusNode: _titleFocus,
              textInputAction: TextInputAction.next,
              maxLength: 50,
              decoration: const InputDecoration(label: Text('Title')),
              controller: _titleController,
              onSubmitted: (_) => switchFocus(),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    focusNode: _amountFocus,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      prefixText: '\$ ',
                      label: Text('Amount'),
                    ),
                    keyboardType: TextInputType.number,
                    controller: _amountController,
                    onSubmitted: (_) => switchFocus(),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        _selectedDate == null
                            ? 'Select Date'
                            : formatter.format(_selectedDate!),
                      ),
                      IconButton(
                        onPressed: presentDatePicker,
                        icon: const Icon(Icons.calendar_month),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                DropdownButton(
                  items:
                      Category.values
                          .map(
                            (category) => DropdownMenuItem<Category>(
                              value: category,
                              child: Text(category.name.toUpperCase()),
                            ),
                          )
                          .toList(),
                  value: _selectedCategory,
                  onChanged: (category) {
                    if (category == null) {
                      return;
                    }
                    setSelectedCategory(category);
                  },
                  focusNode: _selectedCategoryFocus,
                ),
                const Spacer(),
                TextButton(onPressed: _cancel, child: const Text('Cancel')),
                ElevatedButton(
                  onPressed: _submitData,
                  focusNode: _saveExpenseFocus,
                  child: Text("Save Expense"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
