import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:practice_space/accounts_page/accounts_page.dart';
import 'package:practice_space/analysis_page/chart.dart';
import 'package:practice_space/budgets_page/budgets.dart';
import 'package:practice_space/category_page/category.dart';
import 'package:practice_space/login_page/login_page.dart';
import 'package:practice_space/records_page/records.dart';
import 'package:practice_space/records_page/expenses/add_expense_button.dart';
import 'package:practice_space/records_page/expenses/new_expense.dart';
import 'package:practice_space/records_page/expenses/expense.dart' as exp;
import 'package:practice_space/accounts_page/accounts.dart' as acc;
import 'package:practice_space/styling/home_screen_style.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  int selectedIndex = 0;
  DateTime _selectedMonth = DateTime.now();

  final List<exp.Expense> _registeredExpenses = [];
  final List<acc.Accounts> _accounts = [];

  List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  Future<void> _loadExpenses() async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('expenses')
        .get();
    final expenses =
        snapshot.docs.map((doc) => exp.Expense.fromMap(doc.data())).toList();
    setState(() {
      _registeredExpenses.addAll(expenses);
      _updatePages();
    });
  }

  void addExpense(exp.Expense expense) async {
    setState(() {
      _registeredExpenses.add(expense);
      _updatePages();
    });

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('expenses')
        .doc(expense.id)
        .set(expense.toMap());
  }

  void removeExpense(exp.Expense expense) async {
    setState(() {
      _registeredExpenses.remove(expense);
      _updatePages();
    });

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('expenses')
        .doc(expense.id)
        .delete();
  }

  void _updatePages() {
    setState(() {
      _pages = [
        Records(
          expenses: _filteredExpenses,
          onAddExpense: addExpense,
          onRemoveExpense: removeExpense,
          accounts: _accounts,
          onUpdateAccounts: _updateAccounts,
        ),
        Chart(expenses: _filteredExpenses),
        Budgets(
          selectedMonth: _selectedMonth,
          expenses: _filteredExpenses,
        ),
        const AccountsPage(),
        Categories(expenses: _filteredExpenses),
      ];
    });
  }

  void _updateAccounts() {
    setState(() {});
  }

  List<exp.Expense> get _filteredExpenses {
    return _registeredExpenses.where((expense) {
      return expense.date.year == _selectedMonth.year &&
          expense.date.month == _selectedMonth.month;
    }).toList();
  }

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  void _changeMonth(int change) {
    setState(() {
      _selectedMonth = DateTime(
        _selectedMonth.year,
        _selectedMonth.month + change,
      );
      _updatePages();
    });
  }

  void openExpenseOverlay() {
    Future.microtask(() {
      showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (ctx) => NewExpense(
          onAddExpense: addExpense,
        ),
      );
    });
  }

  void _logout() async {
    bool? confirmLogout = await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirmLogout == true) {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 44, 43, 43),
        title: const Text('BudgetLy', style: TextStyle(fontSize: 24)),
        leading: Container(
          margin: const EdgeInsets.all(5),
          child: ClipOval(
            child: Image.asset(
              'assets/logo.webp',
              fit: BoxFit.cover,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: _logout,
          ),
        ],
      ),
      body: HomeScreenStyle(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              color: const Color.fromARGB(255, 44, 43, 43),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_left, size: 28),
                    onPressed: () => _changeMonth(-1),
                  ),
                  Text(
                    DateFormat.yMMM().format(_selectedMonth),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_right, size: 28),
                    onPressed: () => _changeMonth(1),
                  ),
                ],
              ),
            ),
            Expanded(
              child: IndexedStack(
                index: selectedIndex,
                children: _pages,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color.fromARGB(255, 44, 43, 43),
        selectedItemColor: Colors.tealAccent,
        unselectedItemColor: Colors.grey,
        iconSize: 30,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.monetization_on),
            label: 'Records',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_sharp),
            label: 'Analysis',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate_rounded),
            label: 'Budgets',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wallet),
            label: 'Accounts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category_sharp),
            label: 'Categories',
          ),
        ],
      ),
      floatingActionButton: AddExpenseButton(newRecord: openExpenseOverlay),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}