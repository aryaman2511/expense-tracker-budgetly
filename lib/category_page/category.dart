import 'package:flutter/material.dart';
import 'package:practice_space/categories.dart';
import 'package:practice_space/records_page/expenses/expense.dart';

class Categories extends StatelessWidget {
  final List<Expense> expenses;

  const Categories({super.key, required this.expenses});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        const Center(
          child: Text(
            'Expense Categories',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white), // Changed to white
          ),
        ),
        const SizedBox(height: 10),
        // Changed to white
        Expanded(
          child: ListView.builder(
            itemCount: Category.values.length,
            itemBuilder: (context, index) {
              final category = Category.values[index];
              return _buildCategory(
                context,
                categoryIcons[category] ?? Icons.category,
                category.name,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategory(BuildContext context, IconData icon, String label) {
    return InkWell(
      onTap: () => _showExpenseHistoryPopup(context, label),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: ListTile(
          leading: Icon(icon, size: 32, color: Colors.white), // Changed to white
          title: Text(label, style: const TextStyle(fontSize: 18, color: Colors.white)), // Changed to white
          trailing: const Icon(Icons.more_vert, color: Colors.white), // Changed to white
        ),
      ),
    );
  }

  void _showExpenseHistoryPopup(BuildContext context, String categoryName) {
    final category = Category.values.firstWhere((c) => c.name == categoryName);
    final categoryExpenses =
        expenses.where((e) => e.category == category).toList();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black, // Optional: Dark background
          title: Text(
            '$categoryName Expense History',
            style: const TextStyle(color: Colors.white), // Changed to white
          ),
          content: categoryExpenses.isEmpty
              ? const Text(
                  'No expenses recorded for this category in this month.',
                  style: TextStyle(color: Colors.white), // Changed to white
                )
              : SizedBox(
                  height: 300,
                  width: 300,
                  child: ListView.builder(
                    itemCount: categoryExpenses.length,
                    itemBuilder: (context, index) {
                      final expense = categoryExpenses[index];
                      return ListTile(
                        title: Text(expense.title, style: const TextStyle(color: Colors.white)), // Changed to white
                        subtitle: Text(expense.formattedDate, style: const TextStyle(color: Colors.white)), // Changed to white
                        trailing: Text('\₹${expense.amount.toStringAsFixed(2)}',
                            style: const TextStyle(color: Colors.white)), // Changed to white
                      );
                    },
                  ),
                ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close', style: TextStyle(color: Colors.white)), // Changed to white
            ),
          ],
        );
      },
    );
  }
}
