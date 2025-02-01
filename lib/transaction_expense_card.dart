import 'package:flutter/material.dart';


class TransactionExpenseCard extends StatelessWidget {
  final String category;
  final String transactions;
  final String totalSpent;
  final String percentage;
  final Function() onTapEdit;

  TransactionExpenseCard({required this.category, required this.transactions, required this.totalSpent, required this.percentage, required this.onTapEdit});

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
                flex: 4,
                child: Padding(
                  padding: EdgeInsets.only(right: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        category,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis, // Truncate if too long
                        maxLines: 1, // Keep it in a single line
                        softWrap: false, // Prevents wrapping to the next line
                      ),
                      Padding(padding: EdgeInsets.only(left: 20),child: Text('${double.parse(percentage).toStringAsFixed(2)}%', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)))
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text('Transactions:', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('$transactions'),
                      Text('Total Spent: ', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('₱${double.parse(totalSpent).toStringAsFixed(2)}')
                    ]),
              ),

              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    // Edit
                    SizedBox(
                      width: 90,
                      height: 50,
                      child: ElevatedButton( // Use ElevatedButton directly
                        onPressed: () { /* Your edit action */ },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero, // Remove default padding
                          backgroundColor: Colors.transparent, // Make button background transparent
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: InkWell(
                          child: Ink(// Use Ink widget for gradient
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: const LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color(0xFFFBBEDE),
                                  Color(0xFFFF82C4),
                                ],
                              ),
                            ),
                            child: Container( // Container for padding and centering
                              padding: const EdgeInsets.symmetric(vertical: 10), // Add padding
                              child: const Center(
                                child: Text(
                                  'View',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),
                    // View
                    SizedBox(
                      width: 90,
                      height: 50,
                      child: ElevatedButton( // Use ElevatedButton directly
                        onPressed: () { /* Your edit action */ },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero, // Remove default padding
                          backgroundColor: Colors.transparent, // Make button background transparent
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: InkWell(
                          onTap: onTapEdit,
                          child: Ink( // Use Ink widget for gradient
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: const LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color(0xFFFBBEDE),
                                  Color(0xFFFF82C4),
                                ],
                              ),
                            ),
                            child: Container( // Container for padding and centering
                              padding: const EdgeInsets.symmetric(vertical: 10), // Add padding
                              child: const Center(
                                child: Text(
                                  'Edit',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
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