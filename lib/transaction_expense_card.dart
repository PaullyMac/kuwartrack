import 'package:flutter/material.dart';


class TransactionExpenseCard extends StatelessWidget {
  final String category;
  final String transactions;
  final String totalSpent;
  final String percentage;

  TransactionExpenseCard({required this.category, required this.transactions, required this.totalSpent, required this.percentage});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.purple[100],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: 40),
                  child: Column(
                    children: [
                      Text(
                        category,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis, // Truncate if too long
                        maxLines: 1, // Keep it in a single line
                        softWrap: false, // Prevents wrapping to the next line
                      ),
                      Padding(padding: EdgeInsets.only(left: 20),child: Text('${double.parse(percentage).toStringAsFixed(2)}%', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)))
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text('Transactions:'),
                      Text('$transactions'),
                      Text('Total Spent: '),
                      Text('₱${double.parse(totalSpent).toStringAsFixed(2)}')
                    ]),
              ),

            ]),
      ),
    );
  }
}

// Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// ,
// ,
// Align(
// alignment: Alignment.centerRight,
// child: ,
// ),
// ],
// )