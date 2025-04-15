import 'package:practice_space/records_page/expenses/expense.dart';
import 'package:flutter/material.dart';
import 'package:practice_space/categories.dart'; 

class ExpenseItem extends StatelessWidget {
  const ExpenseItem(this.expense, {super.key});

  final Expense expense;

  @override
  Widget build(context) {
    return Card(
      color: const Color.fromARGB(255, 212, 195, 195),
      margin: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 5,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              expense.title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(
              height: 4,
            ),
            Row(
              children: [
                Text(
                  " \₹${expense.amount.toStringAsFixed(2)}",
                ),
                const Spacer(),
                Row(
                  children: [
                    Icon(categoryIcons[expense.category]),
                    Text(
                      expense.formattedDate,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
