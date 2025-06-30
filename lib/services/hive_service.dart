// // import 'package:hive_flutter/hive_flutter.dart';
// // import '../models/expense.dart';
// //
// // class HiveService {
// //   static Future<void> init() async {
// //     await Hive.initFlutter();
// //     Hive.registerAdapter(ExpenseAdapter());
// //     await Hive.openBox<Expense>('expenses');
// //     await Hive.openBox('budgets');
// //   }
// //
// //   static Box<Expense> get expensesBox => Hive.box<Expense>('expenses');
// //   static Box get budgetsBox => Hive.box('budgets');
// // }
// import 'package:hive_flutter/hive_flutter.dart';
// import '../models/expense.dart';
// import '../models/savings_goal.dart';
//
// class HiveService {
//   static Future<void> init() async {
//     await Hive.initFlutter();
//
//     // Register adapters
//     Hive.registerAdapter(ExpenseAdapter());
//     Hive.registerAdapter(SavingsGoalAdapter()); // Add this
//
//     // Open boxes
//     await Hive.openBox<Expense>('expenses');
//     await Hive.openBox<SavingsGoal>('savings_goals'); // Add this
//   }
//
//   static Box<Expense> get expensesBox => Hive.box<Expense>('expenses');
//   static Box<SavingsGoal> get savingsGoalsBox => Hive.box<SavingsGoal>('savings_goals');
// }

import 'package:hive_flutter/hive_flutter.dart';
import '../models/expense.dart';
import '../models/savings_goal.dart';

class HiveService {
  static late Box<double> _budgetsBox; // Add this

  static Future<void> init() async {
    await Hive.initFlutter();

    // Register adapters
    Hive.registerAdapter(ExpenseAdapter());
    Hive.registerAdapter(SavingsGoalAdapter());

    // Open boxes
    await Hive.openBox<Expense>('expenses');
    await Hive.openBox<SavingsGoal>('savings_goals');
    _budgetsBox = await Hive.openBox<double>('budgets'); // Add this
  }

  static Box<Expense> get expensesBox => Hive.box<Expense>('expenses');
  static Box<SavingsGoal> get savingsGoalsBox => Hive.box<SavingsGoal>('savings_goals');
  static Box<double> get budgetsBox => _budgetsBox; // Add this getter
}