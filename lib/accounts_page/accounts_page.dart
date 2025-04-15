import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:practice_space/records_page/expenses/expense.dart' as exp;
import 'package:practice_space/accounts_page/accounts_list.dart';

class AccountsPage extends ConsumerWidget {
  const AccountsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accounts = ref.watch(exp.accountsProvider);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
      child: Column(
        children: [
          const Text(
            'Accounts',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          ...accounts.entries.map((entry) => Column(
                children: [
                  AccountsList(
                    accountType: entry.key,
                    balance: entry.value,
                    onExpenseAdded: (double amount) {
                      ref.read(exp.accountsProvider.notifier).deductExpense(entry.key, amount);
                    },
                    onBalanceChange: (exp.ExpenseAccount account, double newBalance) {
                      ref.read(exp.accountsProvider.notifier).addFunds(account, newBalance - accounts[account]!);
                    },
                  ),
                  const SizedBox(height: 10),
                ],
              )),
        ],
      ),
    );
  }
}