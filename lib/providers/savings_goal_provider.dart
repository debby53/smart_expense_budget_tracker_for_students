import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/savings_goal.dart';
import '../services/hive_service.dart';

class SavingsGoalProvider with ChangeNotifier {
  List<SavingsGoal> _goals = [];

  List<SavingsGoal> get goals => _goals;

  void loadGoals() {
    _goals = HiveService.savingsGoalsBox.values.toList();
    notifyListeners();
  }

  void addGoal(SavingsGoal goal) {
    HiveService.savingsGoalsBox.add(goal);
    _goals.add(goal);
    notifyListeners();
  }

  void updateGoal(int index, SavingsGoal goal) {
    HiveService.savingsGoalsBox.putAt(index, goal);
    _goals[index] = goal;
    notifyListeners();
  }

  void deleteGoal(int index) {
    HiveService.savingsGoalsBox.deleteAt(index);
    _goals.removeAt(index);
    notifyListeners();
  }

  void addToSavings(int index, double amount) {
    final goal = _goals[index];
    goal.savedAmount += amount;
    updateGoal(index, goal);
  }
}