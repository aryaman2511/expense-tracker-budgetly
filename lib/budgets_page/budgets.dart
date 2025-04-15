import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:practice_space/categories.dart';
import 'package:practice_space/budgets_page/budgets_list.dart';
import 'package:practice_space/records_page/expenses/expense.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Budgets extends StatefulWidget {
  final DateTime selectedMonth;
  final List<Expense> expenses;

  const Budgets({super.key, required this.selectedMonth, required this.expenses});

  @override
  State<Budgets> createState() => _BudgetsState();
}

class _BudgetsState extends State<Budgets> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<Category, double> currentBudgets = {};

  @override
  void initState() {
    super.initState();
    _loadBudgets();
  }

  Future<void> _loadBudgets() async {
    String monthKey = DateFormat.yMMM().format(widget.selectedMonth);
    var doc = await _firestore.collection('budgets').doc(monthKey).get();
    if (doc.exists) {
      setState(() {
        currentBudgets = (doc.data() as Map<String, dynamic>).map(
          (key, value) => MapEntry(Category.values.firstWhere((c) => c.name == key), value.toDouble()),
        );
      });
    }
  }

  double get totalBudget => currentBudgets.values.fold(0.0, (sum, value) => sum + value);

  double get totalSpent {
    return widget.expenses
        .where((expense) =>
            expense.date.year == widget.selectedMonth.year &&
            expense.date.month == widget.selectedMonth.month)
        .fold(0.0, (sum, expense) => sum + expense.amount);
  }

  void setBudget(Category category, double amount) async {
    setState(() {
      currentBudgets[category] = amount;
    });
    String monthKey = DateFormat.yMMM().format(widget.selectedMonth);
    await _firestore.collection('budgets').doc(monthKey).set(
      {category.name: amount},
      SetOptions(merge: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            color: const Color.fromARGB(255, 44, 43, 43),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        const Text(
                          'TOTAL BUDGET',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '\₹${totalBudget.toStringAsFixed(2)}',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const Text(
                          'TOTAL SPENT',
                          style: TextStyle(color: Colors.redAccent, fontSize: 16),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '\₹${totalSpent.toStringAsFixed(2)}',
                          style: const TextStyle(
                              color: Colors.redAccent,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          BudgetsList(
            budgets: currentBudgets,
            onSetBudget: setBudget,
          ),
        ],
      ),
    );
  }
}
