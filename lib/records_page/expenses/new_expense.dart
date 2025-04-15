import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:practice_space/records_page/expenses/expense.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:practice_space/categories.dart';
import 'package:uuid/uuid.dart'; // ✅ Import instead of redefining

class NewExpense extends ConsumerStatefulWidget {
  // ✅ Use ConsumerStatefulWidget
  const NewExpense({super.key, required this.onAddExpense});

  final void Function(Expense expense) onAddExpense;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NewExpenseState();
}

class _NewExpenseState extends ConsumerState<NewExpense> {
  // ✅ Use ConsumerState
  final formatter = DateFormat.yMd();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? selectedDate;
  Category _selectedCategory = Category.leisure;
  ExpenseAccount _selectedAccount = ExpenseAccount.cash;

  void presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: now,
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  void submitExpenseData() {
    final enteredAmount = double.tryParse(_amountController.text);

    if (_titleController.text.trim().isEmpty ||
        enteredAmount == null ||
        enteredAmount <= 0 ||
        selectedDate == null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid Input'),
          content: const Text(
              'Please make sure you have entered a valid amount, date, and title'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Okay'),
            ),
          ],
        ),
      );
      return;
    }

    // ✅ Pass ref when creating Expense
    widget.onAddExpense(
      Expense(
        id: const Uuid().v4(), // ✅ Generate a unique ID
        title: _titleController.text,
        date: selectedDate!,
        amount: enteredAmount,
        category: _selectedCategory,
        account: _selectedAccount,
      ),
    );

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
      child: Column(
        children: [
          TextField(
            controller: _titleController,
            maxLength: 50,
            decoration: const InputDecoration(
              label: Text('Title'),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: _amountController,
                  maxLength: 10,
                  decoration: const InputDecoration(
                    prefixText: '\₹ ',
                    label: Text('Amount'),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      selectedDate == null
                          ? 'No date selected'
                          : formatter.format(selectedDate!),
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
          const SizedBox(height: 16),
          Row(
            children: [
              DropdownButton<Category>(
                value: _selectedCategory,
                items: Category.values
                    .map(
                      (category) => DropdownMenuItem(
                        value: category,
                        child: Text(category.name.toUpperCase()),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value == null) return;
                  setState(() {
                    _selectedCategory = value;
                  });
                },
              ),
              const Spacer(),
              DropdownButton<ExpenseAccount>(
                value: _selectedAccount,
                items: ExpenseAccount.values
                    .map(
                      (account) => DropdownMenuItem(
                        value: account,
                        child: Text(account.name.toUpperCase()),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value == null) return;
                  setState(() {
                    _selectedAccount = value;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 50),
          Center(
            child: Row(
              children: [
                const Spacer(),
                ElevatedButton(
                  onPressed: submitExpenseData,
                  child: const Text('Save Expense'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
