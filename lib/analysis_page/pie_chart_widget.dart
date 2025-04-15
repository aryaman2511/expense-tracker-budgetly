import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:practice_space/records_page/expenses/expense.dart';
import 'package:practice_space/categories.dart';

class PieChartWidget extends StatelessWidget {
  final List<Expense> expenses;

  const PieChartWidget({super.key, required this.expenses});

  @override
  Widget build(BuildContext context) {
    final categoryTotals = _calculateCategoryTotals();

    return Column(
      children: [
        SizedBox(
          height: 250,
          width: 250,
          child: categoryTotals.isNotEmpty
              ? PieChart(
                  PieChartData(
                    sections: categoryTotals.entries.map((entry) {
                      return PieChartSectionData(
                        value: entry.value,
                        title: '',
                        color: _getCategoryColor(entry.key),
                        radius: 70,
                        showTitle: false,
                      );
                    }).toList(),
                    sectionsSpace: 2,
                    centerSpaceRadius: 50,
                  ),
                )
              : const Text(
                  'No expenses recorded yet.',
                  style: TextStyle(color: Colors.white),
                ),
        ),
        const SizedBox(height: 16),
        _buildLegend(categoryTotals),
      ],
    );
  }

  /// Calculates total expenses per category
  Map<Category, double> _calculateCategoryTotals() {
    final Map<Category, double> totals = {};
    for (var expense in expenses) {
      totals.update(expense.category, (value) => value + expense.amount,
          ifAbsent: () => expense.amount);
    }
    return totals;
  }

  /// Generates a color for each category
  Color _getCategoryColor(Category category) {
    final colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.brown,
    ];
    return colors[category.index % colors.length];
  }

  /// Builds the legend (color + category name)
  Widget _buildLegend(Map<Category, double> categoryTotals) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 10,
      runSpacing: 6,
      children: categoryTotals.keys.map((category) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: _getCategoryColor(category),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              category.name,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        );
      }).toList(),
    );
  }
}
