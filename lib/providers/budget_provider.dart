import 'package:flutter/material.dart';
import '../services/hive_service.dart';

class BudgetProvider with ChangeNotifier {
  double _monthlyBudget = 0.0;

  double get monthlyBudget => _monthlyBudget;

  BudgetProvider() {
    loadBudget();
  }



  Future<void> loadBudget() async {
    _monthlyBudget = HiveService.budgetsBox.get('monthly_budget', defaultValue: 0.0)!;
    notifyListeners();
  }

  Future<void> setMonthlyBudget(double amount) async {
    await HiveService.budgetsBox.put('monthly_budget', amount);
    _monthlyBudget = amount;
    notifyListeners();
  }
}