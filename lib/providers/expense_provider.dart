import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/expense.dart';
import '../services/hive_service.dart';

class ExpenseProvider with ChangeNotifier {
  List<Expense> _expenses = [];

  List<Expense> get expenses => _expenses;

  void loadExpenses() {
    _expenses = HiveService.expensesBox.values.toList();
    notifyListeners();
  }

  void addExpense(Expense expense) {
    HiveService.expensesBox.add(expense);
    _expenses.add(expense);
    notifyListeners();
  }

  bool removeExpense(Expense expense) {
    final box = HiveService.expensesBox;
    final Map<dynamic, Expense> expenseMap = box.toMap();
    dynamic keyToDelete;

    expenseMap.forEach((key, value) {
      if (value.amount == expense.amount &&
          value.category == expense.category &&
          value.date == expense.date &&
          value.note == expense.note) {
        keyToDelete = key;
      }
    });

    if (keyToDelete != null) {
      box.delete(keyToDelete);
      _expenses.remove(expense);
      notifyListeners();
      return true; // Success
    }
    return false; // Failure
  }

  double getTotalSpentForMonth(int month, int year) {
    return _expenses.fold(0.0, (sum, expense) {
      if (expense.date.month == month && expense.date.year == year) {
        return sum + expense.amount;
      }
      return sum;
    });
  }

  double getTotalSpent() {
    return _expenses.fold(0.0, (sum, item) => sum + item.amount);
  }
}