import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../providers/budget_provider.dart';
import '../providers/expense_provider.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
    await createNotificationChannel(); // Add this line
  }

  static Future<void> createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'budget_channel', // Channel ID (must match what you use in show)
      'Budget Alerts', // Channel name
      description: 'Notifications for budget warnings', // Channel description
      importance: Importance.high, // Importance level
      playSound: true, // Play sound for notifications
      showBadge: true, // Show badge on app icon
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  static void showBudgetAlert(BuildContext context) {
    final now = DateTime.now();
    final spent = Provider.of<ExpenseProvider>(context, listen: false)
        .getTotalSpentForMonth(now.month, now.year);
    final budget = Provider.of<BudgetProvider>(context, listen: false).monthlyBudget;

    if (budget > 0 && spent > budget * 0.9) {
      final format = NumberFormat.currency(symbol: '₹');
      final remaining = (budget - spent).clamp(0, double.infinity);

      flutterLocalNotificationsPlugin.show(
        0,
        'Budget Alert!',
        'You\'ve used ${(spent/budget*100).toStringAsFixed(0)}% of your budget\n'
            'Remaining: ${format.format(remaining)}',
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'budget_channel', // Must match channel ID
            'Budget Alerts', // Channel name
            channelDescription: 'Notifications for budget warnings',
            importance: Importance.high,
            priority: Priority.high,
            playSound: true,
            showWhen: true,
          ),
        ),
      );
    }
  }
}