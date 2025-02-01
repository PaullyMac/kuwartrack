import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart'; // Import for date formatting and parsing
import 'package:kuwartrack/transaction_expense_card.dart';
import 'package:kuwartrack/expense_class.dart';


class Edit extends StatefulWidget {
  final Expenses expenses;
  final List<Expense> expense_list;
  final String user_id;

  const Edit({super.key, required this.expenses, required this.expense_list, required this.user_id});

  @override
  State<Edit> createState() => _EditState();
}

class _EditState extends State<Edit> {
  late Expenses expenses_data;
  late List<Expense> expense_list_data;
  late Expenses expenses_data_category;
  late Expense sample_data;
  late DateTime date;
  late String date_formatted;
  late double totalSpentCategory;
  Map<String, double> all_category_total_expenses = {};
  late double overallTotal;
  int transactions = 0;
  double todayBudget = 0;
  String percentage = '0';



  @override void initState() {
    // TODO: implement initState
    super.initState();

    expense_list_data = widget.expense_list;
    expenses_data = widget.expenses;
    expenses_data_category = Expenses(expense_list_data);
    if(expense_list_data.isNotEmpty){
      sample_data = expense_list_data.first;
      date = DateTime.parse(sample_data.date);
      date_formatted = DateFormat('MMMM dd, yyyy').format(date);
      all_category_total_expenses= expenses_data.getTotalExpensesForAllCategoriesInSpecificDate(date);
      overallTotal = all_category_total_expenses.values.fold(0, (accumulator, element) => accumulator + element);
      percentage = expenses_data.getCategoryPercentagesForCategoryOnSpecificDate(sample_data.category, sample_data.date).toStringAsFixed(2);
      totalSpentCategory = expense_list_data.fold(0, (sum, expense) => sum + (double.tryParse(expense.money_spent) ?? 0));
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView( // Add this for scrolling
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 3,
                          child: IconButton(
                            icon: Icon(Icons.arrow_back_rounded, color: Color(0xFF53197B)),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            iconSize: 50,
                          ),
                        ),
                        Expanded(
                          flex: 10,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 50),
                            child: Center(
                              child: Column(
                                children: [
                                  Text('Date: ', style: TextStyle(fontSize: 20)),
                                  expense_list_data.isNotEmpty
                                      ? Text(date_formatted, style: TextStyle(fontSize: 22))
                                      : Text(''),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(flex: 1, child: SizedBox())
                      ],
                    ),

                    // Flexible container that adapts to content
                    Container(
                      margin: EdgeInsets.only(bottom: 0, top: 50, left: 10, right: 10),
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Color(0xFFAE60CC),
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(3, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Card(
                                  color: Colors.purple[100],
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text('Date: ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                            Text(date_formatted)
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text('Overall Spent: ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                            Text('₱${overallTotal}')
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),

                          // SingleChildScrollView for transactions list
                          SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Card(
                                color: Colors.purple[100],
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                child: Column(
                                  children: [
                                    // Category and Transaction Summary
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(sample_data.category),
                                              Text(percentage + "%"),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("Transactions: " + expense_list_data.length.toString()),
                                              Text("Total Spent: ₱" + totalSpentCategory.toString()),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),

                                    // Specific Transactions List with Separator
                                    Column(
                                      children: expense_list_data.map((expense) {
                                        return Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Divider(
                                                color: Colors.black, // Change color if needed
                                                thickness: 2,        // Change thickness if needed
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                              child: ListTile(
                                                title: Text(expense.transaction, style: TextStyle(fontWeight: FontWeight.bold)),
                                                subtitle: Text("Spent: ₱${expense.money_spent} "),
                                                leading: Icon(Icons.shopping_bag), // Example icon
                                              ),
                                            ),
                                          ],
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

}
