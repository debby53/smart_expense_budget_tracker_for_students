import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smart_expense_budget_tracker_for_students/models/expense.dart';
import 'package:smart_expense_budget_tracker_for_students/providers/expense_provider.dart';
import 'package:smart_expense_budget_tracker_for_students/providers/budget_provider.dart';
import 'package:smart_expense_budget_tracker_for_students/screens/add_expense.dart';
import 'package:smart_expense_budget_tracker_for_students/widgets/budget_progress.dart';
import 'package:smart_expense_budget_tracker_for_students/widgets/expense_chart.dart';
import 'package:smart_expense_budget_tracker_for_students/widgets/expense_list_item.dart';

import 'add_expense.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final currencyFormat = NumberFormat.currency(symbol: '₹', decimalDigits: 2);
  int _currentMonth = DateTime.now().month;

  @override
  void initState() {
    super.initState();
    // Load expenses if needed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ExpenseProvider>(context, listen: false).loadExpenses();
      Provider.of<BudgetProvider>(context, listen: false).loadBudget();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: _selectMonth,
            tooltip: 'Select Month',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddExpense(context),
        child: const Icon(Icons.add),
      ),
      body: Consumer2<ExpenseProvider, BudgetProvider>(
        builder: (context, expenseProvider, budgetProvider, child) {
          final expenses = expenseProvider.expenses;
          final monthlyExpenses = _getMonthlyExpenses(expenses);
          final totalSpent = monthlyExpenses.fold(0.0, (sum, e) => sum + e.amount);
          final budget = budgetProvider.monthlyBudget;
          final remaining = budget - totalSpent;

          return Column(
            children: [
              // Budget Summary Card
              _buildSummaryCard(totalSpent, budget, remaining),

              // Budget Progress Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: BudgetProgress(spent: totalSpent, budget: budget),
              ),

              // Spending Chart
              Expanded(
                flex: 2,
                child: ExpenseChart(expenses: monthlyExpenses),
              ),

              // Recent Expenses Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recent Expenses',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      '${monthlyExpenses.length} items',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),

              // Expenses List
              Expanded(
                flex: 3,
                child: monthlyExpenses.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                  itemCount: monthlyExpenses.length,
                  itemBuilder: (context, index) {
                    return ExpenseListItem(
                      expense: monthlyExpenses[index],
                      onDelete: () {
                        final success = expenseProvider.removeExpense(monthlyExpenses[index]);
                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Expense deleted'),
                              backgroundColor: Colors.red,
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSummaryCard(double totalSpent, double budget, double remaining) {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              DateFormat('MMMM yyyy').format(DateTime(DateTime.now().year, _currentMonth)),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryItem('Spent', totalSpent),
                _buildSummaryItem('Budget', budget),
                _buildSummaryItem('Remaining', remaining),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, double value) {
    final displayValue = currencyFormat.format(value);

    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        const SizedBox(height: 4),
        Text(
          displayValue,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: label == 'Remaining'
                ? (value >= 0 ? Colors.green : Colors.red)
                : null,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/empty.png', width: 150, height: 150),
          const SizedBox(height: 20),
          const Text(
            'No expenses recorded yet!',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const SizedBox(height: 10),
          const Text(
            'Tap the + button to add your first expense',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  List<Expense> _getMonthlyExpenses(List<Expense> expenses) {
    return expenses.where((expense) {
      return expense.date.month == _currentMonth &&
          expense.date.year == DateTime.now().year;
    }).toList();
  }

  void _navigateToAddExpense(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddExpenseScreen()),
    );
  }

  Future<void> _selectMonth() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(DateTime.now().year, _currentMonth),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.year,
    );

    if (picked != null) {
      setState(() {
        _currentMonth = picked.month;
      });
    }
  }
}