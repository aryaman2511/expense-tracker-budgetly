import 'package:practice_space/records_page/expenses/add_expense_button.dart';
import 'package:practice_space/records_page/expenses/expense.dart' as exp;
import 'package:practice_space/records_page/expenses/expenses_list.dart';
import 'package:practice_space/records_page/expenses/new_expense.dart';
import 'package:practice_space/accounts_page/accounts.dart' as acc;
import 'package:practice_space/styling/home_screen_style.dart';
import 'package:flutter/material.dart';

class Records extends StatefulWidget {
  const Records({
    super.key,
    required this.expenses,
    required this.onAddExpense,
    required this.onRemoveExpense,
    required this.accounts,
    required this.onUpdateAccounts,
  });

  final List<exp.Expense> expenses;
  final Function(exp.Expense) onAddExpense;
  final Function(exp.Expense) onRemoveExpense;
  final List<acc.Accounts> accounts;
  final VoidCallback onUpdateAccounts;

  @override
  State<Records> createState() => _RecordsState();
}

class _RecordsState extends State<Records> {
  void openExpenseOverlay() {
    Future.microtask(() {
      showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (ctx) => NewExpense(
          onAddExpense: widget.onAddExpense,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent = const Center(
      child: Text('No expense found, start adding expenses!'),
    );

    if (widget.expenses.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: widget.expenses,
        onRemoveExpense: widget.onRemoveExpense,
      );
    }

    return Scaffold(
      body: HomeScreenStyle(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Expanded(child: mainContent),
          ],
        ),
      ),
      floatingActionButton: AddExpenseButton(newRecord: openExpenseOverlay),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}