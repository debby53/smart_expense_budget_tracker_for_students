import 'package:hive/hive.dart';

part 'savings_goal.g.dart';

@HiveType(typeId: 1)
class SavingsGoal {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final double targetAmount;

  @HiveField(2)
  double savedAmount;

  @HiveField(3)
  final DateTime targetDate;

  @HiveField(4)
  final String? description;

  SavingsGoal({
    required this.name,
    required this.targetAmount,
    required this.savedAmount,
    required this.targetDate,
    this.description,
  });

  double get progressPercentage => (savedAmount / targetAmount).clamp(0.0, 1.0);
}