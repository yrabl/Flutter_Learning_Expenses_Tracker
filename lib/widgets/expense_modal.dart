import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';

class ExpenseModal extends StatefulWidget {
  ExpenseModal(this.expanse, {super.key, required this.onAddUpdateExpense});
  Expense? expanse;

  ExpenseModal.forNewExpense({super.key, required this.onAddUpdateExpense});

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

  bool _isTitleInvalid = false;
  bool _isAmountInvalid = false;
  bool _isSelectedDateInvalid = false;

  @override
  void initState() {
    super.initState();
    if (widget.expanse == null) {
      return;
    }
    _selectedCategory = widget.expanse!.category;
    _titleController.text = widget.expanse!.title;
    _amountController.text = widget.expanse!.amount.toString();
    _selectedDate = widget.expanse!.date;
  }

  void _submitData() {
    final enteredTitle = _titleController.text.trim();
    final enteredAmount = double.tryParse(_amountController.text);
    bool isTitleInvalid = enteredTitle.isEmpty;
    bool isAmountInvalid = enteredAmount == null || enteredAmount <= 0;
    bool isSelectedDateInvalid = _selectedDate == null;

    if (isTitleInvalid || isAmountInvalid || isSelectedDateInvalid) {
      setState(() {
        _isTitleInvalid = isTitleInvalid;
        _isAmountInvalid = isAmountInvalid;
        _isSelectedDateInvalid = isSelectedDateInvalid;
      });

      return;
    }

    final outputExpense = Expense(
      id: widget.expanse?.id,
      title: enteredTitle,
      amount: enteredAmount,
      date: _selectedDate!,
      category: _selectedCategory,
    );

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
              decoration: InputDecoration(
                label: Text('Title'),
                errorText: _isTitleInvalid ? 'Title is required' : null,
              ),
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                color: Theme.of(context).colorScheme.onSecondaryContainer,
              ),
              controller: _titleController,
              onSubmitted: (_) => switchFocus(),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    focusNode: _amountFocus,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      prefixText: '\$ ',
                      label: Text('Amount'),
                      errorText: _isAmountInvalid ? 'Amount is required' : null,
                    ),
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
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
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          color:
                              _isSelectedDateInvalid
                                  ? Theme.of(context).colorScheme.error
                                  : Theme.of(
                                    context,
                                  ).colorScheme.onSecondaryContainer,
                        ),
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
                              child: Text(
                                category.name.toUpperCase(),
                                style: Theme.of(
                                  context,
                                ).textTheme.labelLarge!.copyWith(
                                  color:
                                      _selectedCategory == category
                                          ? Theme.of(
                                            context,
                                          ).colorScheme.onSecondaryContainer
                                          : Theme.of(
                                            context,
                                          ).colorScheme.onPrimaryContainer,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                  value: _selectedCategory,
                  dropdownColor:
                      Theme.of(context).colorScheme.secondaryContainer,
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
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
