import 'package:flutter/material.dart';

class BudgetProgress extends StatelessWidget {
  final double spent;
  final double budget;

  const BudgetProgress({
    super.key,
    required this.spent,
    required this.budget,
  });

  @override
  Widget build(BuildContext context) {
    double ratio = budget > 0 ? (spent / budget).clamp(0.0, 1.0) : 0;
    Color progressColor = ratio < 0.7 ? Colors.green : ratio < 0.9 ? Colors.orange : Colors.red;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Budget Progress',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Stack(
          children: [
            Container(
              height: 20,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOut,
              height: 20,
              width: MediaQuery.of(context).size.width * ratio,
              decoration: BoxDecoration(
                color: progressColor,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Positioned.fill(
              child: Center(
                child: Text(
                  '${(ratio * 100).toStringAsFixed(1)}%',
                  style: TextStyle(
                    color: ratio > 0.4 ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Spent: ₹${spent.toStringAsFixed(2)}'),
            Text('Budget: ₹${budget.toStringAsFixed(2)}'),
          ],
        ),
      ],
    );
  }
}