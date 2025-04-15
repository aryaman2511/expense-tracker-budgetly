import 'package:flutter/material.dart';
import 'package:practice_space/records_page/expenses/expense.dart';
import 'package:practice_space/styling/home_screen_style.dart';
import 'pie_chart_widget.dart';
import 'time_series_chart_widget.dart';

class Chart extends StatelessWidget {
  final List<Expense> expenses;

  const Chart({super.key, required this.expenses});

  @override
  Widget build(BuildContext context) {
    return HomeScreenStyle(
      // Wrap your widget with HomeScreenStyle
      child: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF0A4D14),
                  Color(0xFF1E7A32),
                  Color(0xFF0C3A0E),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              color: const Color(0xFF2E7D32),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Expense Breakdown',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                PieChartWidget(expenses: expenses),
                const SizedBox(height: 40),

                // Divider Line for Separation
                const Divider(color: Colors.white, thickness: 1),
                const SizedBox(height: 40),

                const Text(
                  'Monthly Spending',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                TimeSeriesChartWidget(expenses: expenses),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
