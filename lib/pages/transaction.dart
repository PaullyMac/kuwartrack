import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart'; // Import for date formatting and parsing
import 'package:kuwartrack/transaction_expense_card.dart';
import 'package:kuwartrack/expense_class.dart';


class Transaction extends StatefulWidget {
  final Expenses expenses;
  final String user_id;
  // final Function(Expenses) onExpensesUpdated;

  const Transaction({super.key, required this.expenses, required this.user_id});

  @override
  State<Transaction> createState() => _TransactionState();
}

class _TransactionState extends State<Transaction> {
  Map data = {};
  late Expenses expenses;
  late List<Expense> expense_list;
  Map<String, double> category_total_expenses = {};
  Map<String, double> category_total_expenses_current_day = {};
  Map<String, double> category_total_expenses_current_week = {};
  Map<String, double> category_total_expenses_this_month = {};
  bool isLoading = true; // To manage loading state
  late double overallTotal;
  late double overallTotalThisWeek;
  late double overallTotalThisMonth;
  late double overallTotalThisDay;
  int _selectedIndexDate = 0;
  int transactions = 0;
  bool asc_or_desc = true; // ascending by default
  bool sort_by_type = true; // by default percentage
  int _selectedNavigationIndex = 0; // transaction page
  late String user_id;
  double todayBudget = 0;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    expenses = widget.expenses;
    expense_list = widget.expenses.expenses;

    // get default data
    category_total_expenses= expenses.getTotalExpensesForAllCategoriesInCurrentDay();
    overallTotal = category_total_expenses.values.fold(0, (accumulator, element) => accumulator + element);

    // get data for current week
    category_total_expenses_current_week = expenses.getTotalExpensesForAllCategoriesInCurrentWeek();
    overallTotalThisWeek = category_total_expenses_current_week.values.fold(0, (accumulator, element) => accumulator + element);

    // get data for current month
    category_total_expenses_this_month = expenses.getTotalExpensesForAllCategoriesInCurrentMonth();
    overallTotalThisMonth = category_total_expenses_this_month.values.fold(0, (accumulator, element) => accumulator + element);

    // get data for current day
    category_total_expenses_current_day = expenses.getTotalExpensesForAllCategoriesInCurrentDay();
    overallTotalThisDay = category_total_expenses_current_day.values.fold(0, (accumulator, element) => accumulator + element);


    user_id = widget.user_id;
    isLoading = false;
  }

  // Navigation onTapped
  void _onNavigationTapped(int index) {
    setState(() {
      _selectedNavigationIndex = index; // Update the selected index
      // Navigate or perform actions based on the index:
      switch (index) {
        case 0:
          break;
        case 1:
          Navigator.pushReplacementNamed(context, '/home', arguments: {'user_id': user_id});
          break;
        case 2:
          break;
      }
    });
  }


  double currentSavings = 250;

  void setTodayBudget() {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController budgetController = TextEditingController();
        return AlertDialog(
          title: Text("Set Today's Budget"),
          content: TextField(
            controller: budgetController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: "Enter Amount",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  todayBudget = double.tryParse(budgetController.text) ?? todayBudget;
                });
                Navigator.of(context).pop();
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }



  // calendar
  Future<void> _pickDate(BuildContext context) async {
    // Use a fallback value if _selectedDate is null
    DateTime initialDate = _selectedDate ?? DateTime.now();

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate, // non-nullable DateTime
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        print("weave");
        _selectedDate = pickedDate; // _selectedDate is nullable, which is fine here

        category_total_expenses = expenses.getTotalExpensesForAllCategoriesInSpecificDate(_selectedDate!); // You can safely dereference with `!` because it's no longer null here
        overallTotal = category_total_expenses.values.fold(0, (accumulator, element) => accumulator + element);
      });
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  budgetBox("Day", overallTotalThisDay),
                  SizedBox(width: 10),
                  budgetBox("Week", overallTotalThisWeek),
                  SizedBox(width: 10),
                  budgetBox("Month", overallTotalThisMonth),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  savingsBox("CURRENT SAVINGS", currentSavings),
                  SizedBox(width: 10),
                  GestureDetector(
                    onTap: setTodayBudget,
                    child: savingsBox("Set Today's Budget", null),
                  ),
                  IconButton(
                    icon: Image.asset(
                      'assets/images/calendar.png', // Change to your actual image path
                      width: 50,
                      height: 50,
                    ),
                    onPressed: () => _pickDate(context),
                  )
                ],

              ),
              SizedBox(height: 20),


              Container(
                padding: EdgeInsets.fromLTRB(40, 16, 40, 16),
                decoration: BoxDecoration(
                  color: Color(0xFFFAC5FCA),
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(3, 3),
                    ),
                  ],
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 70, vertical: 10), // Added padding inside
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFFFFFFF), Color(0xFFCD8FF1)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(100), // Match the outer container's borderRadius
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // Prevents Column from stretching
                    mainAxisAlignment: MainAxisAlignment.center, // Centers content inside
                    children: [
                      Text(
                        "Today's Budget",
                        style: TextStyle(fontSize: 18, color: Colors.black),
                        textAlign: TextAlign.center, // Ensures text is centered
                      ),
                      SizedBox(height: 5),
                      Text(
                        "₱${todayBudget.toStringAsFixed(2)}",
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),



              Card(
                elevation: 4.0, // Add a subtle shadow (optional)
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(60),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFE9DDFE), Color(0xFF8484CE)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(100), // Match the Card's borderRadius
                  ),
                  child: Padding( // Use Padding inside the Card
                    padding: const EdgeInsets.fromLTRB(45, 25, 45, 25),
                    child: Column(
                      children: [
                        Text('Today', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ),



              Container(
                height: 260,
                margin: EdgeInsets.only(bottom:0, top: 50, left: 10, right: 10), // Keep your bottom margin
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Color(0xFFAE60CC),
                  borderRadius: BorderRadius.circular(20), // Fully rounded corners
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(3, 3), // Added slight offset for depth
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // ADD CATEGORY
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              // Define the action you want to perform on tap
                              print('Card clicked!');
                            },
                            child: Card(
                              elevation: 4.0, // Add a subtle shadow (optional)
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(60),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Color(0xFFFBBEDE), Color(0xFFFF82C4)],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                  borderRadius: BorderRadius.circular(100), // Match the Card's borderRadius
                                ),
                                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                                child: Column(children: [Text('Add', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), Text('Category', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))],),
                              ),
                            ),
                          ),

                          // DETAILS
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
                                    Text('${_selectedDate != null
                                        ? DateFormat('MMMM dd, yyyy').format(_selectedDate!)  // Format the selected date
                                        : DateFormat('MMMM dd, yyyy').format(DateTime.now())}')
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text('Overall Spent: ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                    Text('₱${overallTotal}')
                                  ],
                                )
                              ],),
                            ),
                          )
                        ],

                      ),
                    ),

                    // Expense list widgets
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children:
                          category_total_expenses.entries.map((entry) {
                            String category = entry.key;
                            double totalSpent = entry.value;
                            transactions = expenses.getTotalTransactionsForCategoryOnSpecificDate(entry.key, _selectedDate ?? DateTime.now());
                            double percentage = (overallTotal > 0) ? (totalSpent / overallTotal) * 100 : 0; // Calculate percentage

                            return TransactionExpenseCard(
                              category: category,
                              transactions: transactions.toString(),
                              totalSpent: totalSpent.toString(),
                              percentage: percentage.toString(),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              )

            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: _onNavigationTapped,
        backgroundColor: Color(0xFFF68F6D), // Set the background color
        selectedItemColor: Colors.white, // Color for the selected item
        unselectedItemColor: Colors.black, // Color for unselected items
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.attach_money, size: 50,), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.home, size: 50), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.settings, size: 50), label: ''),
        ],
      ),
    );
  }

  Widget budgetBox(String label, double amount) {
    return Container(
      padding: EdgeInsets.all(10),
      width: 100,
      decoration: BoxDecoration(
        color: Colors.purple.shade100,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
          SizedBox(height: 5),
          Text("₱${amount.toStringAsFixed(0)}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget savingsBox(String label, double? amount, {IconData? icon}) {
    return Container(
      padding: EdgeInsets.all(10),
      width: 140,
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF8DED1), Color(0xFFFFAE82)], // Gradient from light to dark orange
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black), textAlign: TextAlign.center,),
          SizedBox(height: 5),
          if (icon != amount)
            Text("₱${amount?.toStringAsFixed(0) ?? ''}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
        ],
      ),
    );
  }
}

