import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_expense_budget_tracker_for_students/providers/budget_provider.dart';
import 'package:smart_expense_budget_tracker_for_students/providers/expense_provider.dart';
import 'package:smart_expense_budget_tracker_for_students/providers/savings_goal_provider.dart';
import 'package:smart_expense_budget_tracker_for_students/screens/add_expense.dart';
import 'package:smart_expense_budget_tracker_for_students/screens/splash_screen.dart';
import 'package:smart_expense_budget_tracker_for_students/screens/home_screen.dart';
import 'package:smart_expense_budget_tracker_for_students/screens/add_expense.dart';
import 'package:smart_expense_budget_tracker_for_students/screens/budget_screen.dart';
import 'package:smart_expense_budget_tracker_for_students/screens/reports_screen.dart';
import 'package:smart_expense_budget_tracker_for_students/services/hive_service.dart';
import 'package:smart_expense_budget_tracker_for_students/services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await HiveService.init(); // Initialize Hive database
    await NotificationService.init(); // Initialize notifications
    runApp(const MyApp());
  } catch (e) {
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('Initialization failed: $e'),
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) {
          final provider = ExpenseProvider();
          provider.loadExpenses();
          return provider;
        }),
        ChangeNotifierProvider(create: (_) => SavingsGoalProvider()..loadGoals()),
        ChangeNotifierProvider(create: (_) => BudgetProvider()..loadBudget()),
      ],
      child: MaterialApp(
        title: 'Student Expense Tracker',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          useMaterial3: true,
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.deepPurple,
            accentColor: Colors.amber,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
          ),
        ),
        home: const SplashScreen(),
        routes: {
          '/home': (ctx) => const HomeScreen(),
          '/add-expense': (ctx) => const AddExpenseScreen(),
          '/budgets': (ctx) => const BudgetScreen(),
          '/reports': (ctx) => const ReportsScreen(),
        },
      ),
    );
  }
}