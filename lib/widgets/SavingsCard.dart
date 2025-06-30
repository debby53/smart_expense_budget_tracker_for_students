import 'package:flutter/material.dart';
import '../models/savings_goal.dart';

class SavingsCard extends StatelessWidget {
  final SavingsGoal goal;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const SavingsCard({
    super.key,
    required this.goal,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final progress = goal.progressPercentage;
    final daysRemaining = goal.targetDate.difference(DateTime.now()).inDays;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutBack,
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
        BoxShadow(
        color: Colors.blue.withOpacity(0.1),
        blurRadius: 10,
        offset: const Offset(0, 4),
        ),

        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  goal.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (onDelete != null)
                IconButton(
                  icon: const Icon(Icons.delete, size: 20),
                  onPressed: onDelete,
                  color: Colors.red,
                ),
            ],
          ),

          if (goal.description != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                goal.description!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ),

          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[200],
            color: progress > 0.75
                ? Colors.green
                : progress > 0.5
                ? Colors.blue
                : Colors.orange,
            minHeight: 12,
            borderRadius: BorderRadius.circular(6),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '₹${goal.savedAmount.toStringAsFixed(2)} saved',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                ),
              ),
              Text(
                '₹${goal.targetAmount.toStringAsFixed(2)} target',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${(progress * 100).toStringAsFixed(1)}% completed',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                daysRemaining > 0
                    ? '$daysRemaining days left'
                    : 'Target date passed',
                style: TextStyle(
                  color: daysRemaining > 0 ? Colors.green : Colors.red,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
    );
  }
}