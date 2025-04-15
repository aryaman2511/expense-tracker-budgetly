import 'package:flutter/material.dart';
import 'package:practice_space/records_page/expenses/expense.dart' as exp;

class AccountsList extends StatelessWidget {
  const AccountsList({
    super.key,
    required this.accountType,
    required this.balance,
    required this.onExpenseAdded,
    required this.onBalanceChange,
  });

  final exp.ExpenseAccount accountType;
  final double balance;
  final ValueChanged<double> onExpenseAdded;
  final Function(exp.ExpenseAccount, double) onBalanceChange;

  void _showEditBalanceDialog(BuildContext context) {
    final balanceController = TextEditingController(text: balance.toString());

    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return Dialog(
          backgroundColor: Colors.green.shade800,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Set Account Balance",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: balanceController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                  decoration: InputDecoration(
                    labelText: "Enter new balance",
                    labelStyle:
                        const TextStyle(color: Colors.white70, fontSize: 16),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green.shade300),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green.shade100),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: const Text("Cancel",
                          style:
                              TextStyle(color: Colors.white70, fontSize: 16)),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        final newBalance =
                            double.tryParse(balanceController.text);
                        if (newBalance != null) {
                          onBalanceChange(accountType, newBalance);
                          Navigator.of(ctx).pop();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade500,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                      ),
                      child: const Text("Save", style: TextStyle(fontSize: 18)),
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

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF388E3C), // A richer, more appealing green
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              _getAccountIcon(accountType),
              size: 40,
              color: Colors.white,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  accountType.name.toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Balance: ₹${balance.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.white),
              onPressed: () => _showEditBalanceDialog(context),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getAccountIcon(exp.ExpenseAccount category) {
    switch (category) {
      case exp.ExpenseAccount.card:
        return Icons.credit_card;
      case exp.ExpenseAccount.cash:
        return Icons.account_balance_wallet;
      case exp.ExpenseAccount.savings:
        return Icons.savings;
    }
  }
}
