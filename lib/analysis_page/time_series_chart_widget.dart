import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:practice_space/records_page/expenses/expense.dart';

class TimeSeriesChartWidget extends StatelessWidget {
  final List<Expense> expenses;

  const TimeSeriesChartWidget({super.key, required this.expenses});

  @override
  Widget build(BuildContext context) {
    final dailyExpenses = _calculateDailyExpenses();

    return Padding(
      padding: const EdgeInsets.only(top: 20.0), // Added extra top padding
      child: SizedBox(
        height: 250,
        width: 350,
        child: dailyExpenses.isNotEmpty
            ? LineChart(_buildLineChartData(dailyExpenses))
            : const Text(
                'No expenses recorded yet.',
                style: TextStyle(color: Colors.white),
              ),
      ),
    );
  }

  /// Ensures full month range is covered
  Map<DateTime, double> _calculateDailyExpenses() {
    final Map<DateTime, double> dailyExpenses = {};
    for (var expense in expenses) {
      DateTime date = DateTime(expense.date.year, expense.date.month, expense.date.day);
      dailyExpenses.update(date, (value) => value + expense.amount,
          ifAbsent: () => expense.amount);
    }

    // Ensure the full month is displayed
    DateTime startDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
    DateTime endDate = DateTime(DateTime.now().year, DateTime.now().month + 1, 0);

    DateTime currentDate = startDate;
    while (currentDate.isBefore(endDate) || currentDate.isAtSameMomentAs(endDate)) {
      dailyExpenses.putIfAbsent(currentDate, () => 0);
      currentDate = currentDate.add(const Duration(days: 1));
    }

    return dailyExpenses;
  }

  /// Builds the Line Chart with full month range
  LineChartData _buildLineChartData(Map<DateTime, double> dailyExpenses) {
    final sortedKeys = dailyExpenses.keys.toList()..sort();
    final spots = sortedKeys.asMap().entries.map((entry) {
      int index = entry.key;
      DateTime date = entry.value;
      return FlSpot(index.toDouble(), dailyExpenses[date]!);
    }).toList();

    // Determine the max Y value dynamically
    double maxY = dailyExpenses.values.isEmpty ? 10 : dailyExpenses.values.reduce((a, b) => a > b ? a : b);
    maxY += maxY * 0.2; // Add 20% buffer space at the top

    return LineChartData(
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              if (value.toInt() % 5 == 0) {
                DateTime date = sortedKeys[value.toInt()];
                return Text(DateFormat.MMMd().format(date), style: const TextStyle(color: Colors.white, fontSize: 10));
              }
              return const SizedBox.shrink();
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            getTitlesWidget: (value, meta) {
              return Text(value.toInt().toString(), style: const TextStyle(color: Colors.white, fontSize: 10));
            },
          ),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      gridData: const FlGridData(show: true, drawVerticalLine: false),
      borderData: FlBorderData(show: false),
      minY: 0, // Ensure Y-axis starts from 0
      maxY: maxY, // Dynamically adjust max Y to avoid overflow
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          color: Colors.yellowAccent,
          barWidth: 3,
          dotData: const FlDotData(show: true),
        ),
      ],
    );
  }
}
