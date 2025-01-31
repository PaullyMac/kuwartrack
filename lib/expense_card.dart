import 'package:flutter/material.dart';


class ExpenseCard extends StatelessWidget {
  final String category;
  final String transactions;
  final String totalSpent;
  final String percentage;

  ExpenseCard({required this.category, required this.transactions, required this.totalSpent, required this.percentage});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.purple[100],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(category, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('Transactions: $transactions'),
            Text('Total Spent: ₱${double.parse(totalSpent).toStringAsFixed(2)}'),
            Align(
              alignment: Alignment.centerRight,
              child: Text('${double.parse(percentage).toStringAsFixed(2)}%', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}