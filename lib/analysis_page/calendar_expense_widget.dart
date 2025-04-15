import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:practice_space/records_page/expenses/expense.dart';

class CalendarExpenseWidget extends StatefulWidget {
  final List<Expense> expenses;

  const CalendarExpenseWidget({super.key, required this.expenses});

  @override
  State<CalendarExpenseWidget> createState() => _CalendarExpenseWidgetState();
}

class _CalendarExpenseWidgetState extends State<CalendarExpenseWidget> {
  late Map<DateTime, double> _dailyExpenses;
  DateTime _selectedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    _dailyExpenses = _calculateDailyExpenses();
  }

  /// Calculates total expenses per day
  Map<DateTime, double> _calculateDailyExpenses() {
    final Map<DateTime, double> dailyExpenses = {};
    for (var expense in widget.expenses) {
      DateTime date =
          DateTime(expense.date.year, expense.date.month, expense.date.day);
      dailyExpenses.update(date, (value) => value + expense.amount,
          ifAbsent: () => expense.amount);
    }
    return dailyExpenses;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        TableCalendar(
          firstDay: DateTime.utc(2023, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: _selectedDay,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
            });
          },
          calendarStyle: const CalendarStyle(
            todayDecoration: BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
            selectedDecoration: BoxDecoration(
              color: Colors.orange,
              shape: BoxShape.circle,
            ),
          ),
          headerStyle: const HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
          ),
          calendarBuilders: CalendarBuilders(
            defaultBuilder: (context, date, _) {
              double? totalSpent = _dailyExpenses[date];
              return Stack(
                alignment: Alignment.center,
                children: [
                  Text(
                    date.day.toString(),
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  if (totalSpent != null)
                    Positioned(
                      bottom: -5,
                      child: Text(
                        '₹${totalSpent.toStringAsFixed(0)}', // Show amount spent below date
                        style: TextStyle(
                            color: Colors.yellow,
                            fontSize: 10,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 20),
        _buildExpenseList(),
      ],
    );
  }

  /// Shows a list of expenses for the selected day
  Widget _buildExpenseList() {
    List<Expense> selectedExpenses = widget.expenses
        .where((e) =>
            e.date.year == _selectedDay.year &&
            e.date.month == _selectedDay.month &&
            e.date.day == _selectedDay.day)
        .toList();

    return Expanded(
      child: selectedExpenses.isNotEmpty
          ? ListView.builder(
              itemCount: selectedExpenses.length,
              itemBuilder: (context, index) {
                Expense expense = selectedExpenses[index];
                return ListTile(
                  title: Text(
                    expense.category.name,
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    '₹${expense.amount.toStringAsFixed(2)}',
                    style: const TextStyle(color: Colors.greenAccent),
                  ),
                );
              },
            )
          : const Center(
              child: Text('No expenses for this day.',
                  style: TextStyle(color: Colors.white)),
            ),
    );
  }
}
