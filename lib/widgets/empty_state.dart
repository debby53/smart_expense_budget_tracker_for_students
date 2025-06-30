import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  final String message;
  final IconData icon;

  const EmptyState({Key? key, required this.message, required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 800),
      curve: Curves.easeInOutBack,
      padding: EdgeInsets.all(20),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 600),
              curve: Curves.elasticOut,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Colors.blue[50],
                  shape: BoxShape.circle
              ),
              child: Icon(icon, size: 60, color: Colors.blue),
            ),
            SizedBox(height: 20),
            Text(
              message,
              style: TextStyle(fontSize: 18, color: Colors.grey),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}