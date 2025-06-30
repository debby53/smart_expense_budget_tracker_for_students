import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/budget_provider.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    // Initialize controller in initState
    final budget = Provider.of<BudgetProvider>(context, listen: false).monthlyBudget;
    _controller = TextEditingController(text: budget.toStringAsFixed(2));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Monthly Budget')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Monthly Budget',
                prefixText: '₹ ',
                border: OutlineInputBorder(), // Added border for better UI
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final value = double.tryParse(_controller.text) ?? 0.0;
                Provider.of<BudgetProvider>(context, listen: false)
                    .setMonthlyBudget(value);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                'Save Budget',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}