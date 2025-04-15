import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:practice_space/categories.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const uuid = Uuid();
final formatter = DateFormat.yMd();

enum ExpenseAccount { card, cash, savings }

const accountIcons = {
  ExpenseAccount.card: Icons.credit_card,
  ExpenseAccount.cash: Icons.attach_money,
  ExpenseAccount.savings: Icons.savings,
};

class Expense {
  Expense({
    required this.id,
    required this.title,
    required this.date,
    required this.amount,
    required this.category,
    required this.account,
  });

  final String id;
  final String title;
  final DateTime date;
  final double amount;
  final Category category;
  final ExpenseAccount account;

  String get formattedDate => formatter.format(date);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'date': date.toIso8601String(),
      'amount': amount,
      'category': category.name,
      'account': account.index,
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      title: map['title'],
      date: DateTime.parse(map['date']),
      amount: map['amount'],
      category: Category.values.firstWhere((c) => c.name == map['category']),
      account: ExpenseAccount.values[map['account']],
    );
  }
}

class ExpenseBucket {
  const ExpenseBucket({required this.category, required this.expenses});

  final Category category;
  final List<Expense> expenses;

  ExpenseBucket.forCategory(List<Expense> allExpenses, this.category)
      : expenses = allExpenses
            .where((expense) => expense.category == category)
            .toList();

  double getTotalExpense() =>
      expenses.fold(0, (sum, expense) => sum + expense.amount);
}

enum AccountsCategory { card, cash, savings }

var accountsCategoryIcons = {
  AccountsCategory.card: 'assets/credit_card.png',
  AccountsCategory.cash: 'assets/cash.png',
  AccountsCategory.savings: 'assets/piggy_bank.png',
};

class AccountsProvider extends StateNotifier<Map<ExpenseAccount, double>> {
  AccountsProvider() : super({}) {
    loadAccountsFromFirestore();
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> loadAccountsFromFirestore() async {
    try {
      final snapshot = await _firestore.collection('accounts').get();
      Map<ExpenseAccount, double> loadedAccounts = {};

      for (var doc in snapshot.docs) {
        if (ExpenseAccount.values.any((e) => e.name == doc.id)) {
          final accountType =
              ExpenseAccount.values.firstWhere((e) => e.name == doc.id);
          loadedAccounts[accountType] = (doc['balance'] as num).toDouble();
        }
      }

      state = loadedAccounts;

      for (ExpenseAccount account in ExpenseAccount.values) {
        if (!state.containsKey(account)) {
          await _firestore.collection('accounts').doc(account.name).set({
            'balance': account == ExpenseAccount.card
                ? 1000.0
                : account == ExpenseAccount.cash
                    ? 500.0
                    : 2000.0,
          }, SetOptions(merge: true));
        }
      }

      await refreshAccounts();
    } catch (e) {
      print("❌ Error loading accounts from Firestore: $e");
    }
  }

  Future<void> refreshAccounts() async {
    final updatedSnapshot = await _firestore.collection('accounts').get();
    Map<ExpenseAccount, double> updatedAccounts = {};

    for (var doc in updatedSnapshot.docs) {
      if (ExpenseAccount.values.any((e) => e.name == doc.id)) {
        final accountType =
            ExpenseAccount.values.firstWhere((e) => e.name == doc.id);
        updatedAccounts[accountType] = (doc['balance'] as num).toDouble();
      }
    }

    state = updatedAccounts;
  }

  Future<void> updateBalanceInFirestore(
      ExpenseAccount account, double newBalance) async {
    try {
      await _firestore.collection('accounts').doc(account.name).set({
        'balance': newBalance,
      }, SetOptions(merge: true));

      await refreshAccounts();
    } catch (e) {
      print("❌ Error updating Firestore balance: $e");
    }
  }

  void deductExpense(ExpenseAccount account, double amount) {
    if (state[account] != null && state[account]! >= amount) {
      final newBalance = state[account]! - amount;
      state = {...state, account: newBalance};
      updateBalanceInFirestore(account, newBalance);
    } else {
      print("❌ Insufficient funds in \${account.name} account.");
    }
  }

  void addFunds(ExpenseAccount account, double amount) {
    if (state[account] != null) {
      final newBalance = state[account]! + amount;
      state = {...state, account: newBalance};
      updateBalanceInFirestore(account, newBalance);
    }
  }
}

final accountsProvider =
    StateNotifierProvider<AccountsProvider, Map<ExpenseAccount, double>>(
  (ref) => AccountsProvider(),
);