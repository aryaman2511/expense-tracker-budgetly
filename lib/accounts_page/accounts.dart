enum AccountsCategory { card, cash, savings }

var accountsCategoryIcons = {
  AccountsCategory.card: 'assets/credit_card.png',
  AccountsCategory.cash: 'assets/cash.png',
  AccountsCategory.savings: 'assets/piggy_bank.png',
};

class Accounts {
  Accounts({
    required this.accountsCategory,
    double? balance,
  }) : balance = balance ?? 0.0;

  final AccountsCategory accountsCategory;
  double balance;

  void deductExpense(double amount) {
    if (balance >= amount) {
      balance -= amount;
    } else {
      print("Insufficient funds in ${accountsCategory.name} account.");
    }
  }
}
