import 'package:flutter/material.dart';
import 'package:practice_space/categories.dart';

class BudgetsList extends StatelessWidget {
  const BudgetsList({
    super.key,
    required this.budgets,
    required this.onSetBudget,
  });

  final Map<Category, double> budgets;
  final void Function(Category, double) onSetBudget;

  @override
  Widget build(BuildContext context) {
    List<Category> budgetedCategories = budgets.keys.toList();
    List<Category> nonBudgetedCategories =
        Category.values.where((c) => !budgets.containsKey(c)).toList();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Budgeted Categories'),
          if (budgetedCategories.isEmpty)
            _buildEmptyState('No budgets set yet'),
          ...budgetedCategories.map((category) =>
              _buildBudgetedCategory(category, budgets[category]!)),
          const SizedBox(height: 24),
          _buildSectionTitle('Not Budgeted This Month'),
          if (nonBudgetedCategories.isEmpty)
            _buildEmptyState('All categories have budgets'),
          ...nonBudgetedCategories
              .map((category) => _buildNonBudgetedCategory(context, category)),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
            fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        message,
        style: const TextStyle(color: Colors.white70, fontSize: 16),
      ),
    );
  }

  Widget _buildBudgetedCategory(Category category, double budget) {
    return Card(
      color: Colors.green.shade700,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Icon(categoryIcons[category], color: Colors.white),
        title: Text(
          category.name,
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white24,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '\₹${budget.toStringAsFixed(2)}',
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildNonBudgetedCategory(BuildContext context, Category category) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(categoryIcons[category], color: Colors.white),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              category.name,
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
          ElevatedButton(
            onPressed: () => _showBudgetDialog(context, category),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade500,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
            child: const Text('SET BUDGET'),
          ),
        ],
      ),
    );
  }

  void _showBudgetDialog(BuildContext context, Category category) {
  double budgetAmount = 0;

  showDialog(
    context: context,
    builder: (ctx) {
      return Dialog(
        backgroundColor: Colors.green.shade800,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16), // Add padding for better UI
          child: Column(
            mainAxisSize: MainAxisSize.min, // Ensures the dialog resizes properly
            children: [
              Text(
                'Set Budget for ${category.name}',
                style: const TextStyle(
                    color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextField(
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white, fontSize: 18),
                decoration: InputDecoration(
                  labelText: 'Enter Budget Amount',
                  labelStyle: const TextStyle(color: Colors.white70, fontSize: 16),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green.shade300),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green.shade100),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onChanged: (value) {
                  budgetAmount = double.tryParse(value) ?? 0;
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: const Text('Cancel',
                        style: TextStyle(color: Colors.white70, fontSize: 16)),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (budgetAmount > 0) {
                        onSetBudget(category, budgetAmount);
                        Navigator.of(ctx).pop();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade500,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                    child: const Text('Save', style: TextStyle(fontSize: 18)),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

}