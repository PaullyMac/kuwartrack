import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart'; // Import for date formatting and parsing
import 'package:kuwartrack/expense_card.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map data = {};
  late Expenses expenses;
  late List<Expense> expense_list;
  Map<String, double> category_total_expenses = {};
  bool isLoading = true; // To manage loading state
  late double overallTotal;
  late Map<String, double> pie_percentages;
  int _selectedIndexDate = 0;
  int transactions = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Fetch user ID and trigger data fetching
      data = ModalRoute.of(context)?.settings?.arguments as Map;
      if (data.containsKey('user_id')) {
        fetchExpenses(data['user_id']);
      }
    });
  }

  void _onPeriodChanged(int index) {
    setState(() {
      _selectedIndexDate = index;
      switch(_selectedIndexDate){
        case 0:
          pie_percentages = expenses.getCategoryPercentagesThisWeek();
          category_total_expenses = expenses.getTotalExpensesForAllCategoriesInCurrentWeek();
          overallTotal =  category_total_expenses.values.fold(0, (accumulator, element) => accumulator + element);
          break;
        case 1:
          pie_percentages = expenses.getCategoryPercentagesLastWeek();
          category_total_expenses = expenses.getTotalExpensesForAllCategoriesInLastWeek();
          overallTotal =  category_total_expenses.values.fold(0, (accumulator, element) => accumulator + element);
          break;
        case 2:
          pie_percentages = expenses.getCategoryPercentagesLastMonth();
          category_total_expenses = expenses.getTotalExpensesForAllCategoriesInLastMonth();
          overallTotal =  category_total_expenses.values.fold(0, (accumulator, element) => accumulator + element);
          break;
        default:
          pie_percentages = expenses.getCategoryPercentagesThisWeek(); break;
      }
    });
  }

  // initial render
  Future<void> fetchExpenses(String userId) async {
    try {
      setState(() {
        isLoading = true;
      });
      List<Expense> fetchedExpenses = await get_data(userId);
      setState(() {
        expense_list = fetchedExpenses;
        expenses = Expenses(fetchedExpenses);
        category_total_expenses = expenses.getTotalExpensesForAllCategoriesInCurrentWeek();
        // print("here?" + expense_list.length.toString());
        // get the total money spent for this week
        overallTotal =  category_total_expenses.values.fold(0, (accumulator, element) => accumulator + element);
        pie_percentages = expenses.getCategoryPercentagesThisWeek();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Handle error gracefully
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Show loader while waiting for data
          : SafeArea(
        child: Column(
          children: [

            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(

                children: [

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distribute space
                    children: [
                      Expanded( // Takes up available space
                        child: Padding(
                          padding:  const EdgeInsets.only(left: 80.0),
                          child: Center( // Centers the logo within the expanded space
                            child: Image.asset(
                              'assets/images/logo.png',
                              height: 120,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.logout, color: Color(0xFF53197B)),
                        onPressed: () {
                          Navigator.pop(context); // Navigator.pushReplacement, Navigator.push()
                        },
                        iconSize: 50,
                      ),
                    ],
                  ),

                  SizedBox(height: 20),
                ],
              ),
            ),

            Expanded(
              child: Container(
                child: Column(
                  children: [
                    MyToggleButtonExample(onPeriodChanged: _onPeriodChanged),
                    SizedBox(height: 20),

                    Text(
                      'You have saved [number] today!',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Expanded(child: PieChart(dataMap: pie_percentages.isNotEmpty? pie_percentages: {"No record yet": 0})),
                  ],
                )
              ),
            ),




            // Bottom Card
            Container(
              height: 260,
              margin: EdgeInsets.only(bottom: 60), // Keep your bottom margin
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color(0xFFAE60CC),
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.sort),
                        label: Text('Sort by'),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.arrow_upward),
                        label: Text('Ascending'),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children:

                        category_total_expenses.entries.map((entry) {
                          String category = entry.key;
                          double totalSpent = entry.value;
                          if(_selectedIndexDate==1){
                            transactions = expenses.getTotalTransactionsForAllCategoriesLastWeek(entry.key);
                          }
                          else if(_selectedIndexDate==2){
                            transactions = expenses.getTotalTransactionsForAllCategoriesLastMonth(entry.key);
                          }
                          else{
                            transactions = expenses.getTotalTransactionsForAllCategoriesThisWeek(entry.key);
                          }
                          double percentage = (overallTotal > 0) ? (totalSpent / overallTotal) * 100 : 0; // Calculate percentage

                          return ExpenseCard(
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
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.attach_money), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: ''),
        ],
      ),
    );
  }
}



Future<List<Expense>> get_data(String user_id) async {
  final url = Uri.parse("https://7611-130-105-115-165.ngrok-free.app/api/auth/post_data");

  final response = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({"user_id": user_id}),
  );
  

  if (response.statusCode == 200) {
    if (jsonDecode(response.body) != null) {
      // Decoding the JSON response
      final decodedResponse = jsonDecode(response.body) as List<dynamic>;
      final expenses = decodedResponse.map((expense) => Expense(
        expense[0] as String,
        expense[1] as String,
        expense[2] as String,
        expense[3] as String,
      )).toList();
      return expenses;
    } else {
      // Handle the case where the response is null
      return [];
    }
  } else {
    // Handle the case where the request fails
    throw Exception('Failed to get data');
  }
}

class MyToggleButtonExample extends StatefulWidget {
  final Function(int) onPeriodChanged; // Define the callback

  const MyToggleButtonExample({super.key, required this.onPeriodChanged});

  @override
  State<MyToggleButtonExample> createState() => _MyToggleButtonExampleState();
}

class _MyToggleButtonExampleState extends State<MyToggleButtonExample> {
  int _selectedIndex = 0; // Initialize with the first button selected

  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      borderRadius: BorderRadius.circular(20),
      selectedColor: Colors.white,
      fillColor: Colors.purple,
      color: Colors.grey, // Color of unselected buttons
      isSelected: _getIsSelectedList(), // Use a method to generate the list
      children: const [ // Use const for children that don't change
        Padding(padding: EdgeInsets.all(8), child: Text('This Week')),
        Padding(padding: EdgeInsets.all(8), child: Text('Last Week')),
        Padding(padding: EdgeInsets.all(8), child: Text('Last Month')),
      ],
      onPressed: (int index) {
        setState(() {
          _selectedIndex = index; // Update the selected index
        });
        // Do something based on the selected index:
        switch (index) {
          case 0:
            print("This Week selected");
            // Load data for this week
            break;
          case 1:
            print("Last Week selected");
            // Load data for last week
            break;
          case 2:
            print("Last Month selected");
            // Load data for last month
            break;
        }
        widget.onPeriodChanged(index);
      },
    );
  }

  List<bool> _getIsSelectedList() {
    return List.generate(3, (index) => index == _selectedIndex);
  }
}














class Expenses {
  List<Expense> expenses;

  Expenses(this.expenses);

  // Methods for this week
  Map<String, double> getTotalExpensesForAllCategoriesInCurrentWeek() {
    Map<String, double> categoryTotals = {};
    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    DateTime endOfWeek = now.add(Duration(days: 7 - now.weekday));

    for (Expense expense in expenses) {
      try {

        DateTime expenseDate = DateFormat('yyyy-MM-dd').parse(expense.date);

        if (expenseDate.isAfter(startOfWeek.subtract(Duration(days:1))) &&
            expenseDate.isBefore(endOfWeek.add(Duration(days:1)))) {
          double amountSpent = double.parse(expense.money_spent);

          if (categoryTotals.containsKey(expense.category)) {
            categoryTotals[expense.category] = categoryTotals[expense.category]! + amountSpent;
          } else {
            categoryTotals[expense.category] = amountSpent;
          }
        }
      } catch (e) {
        print("Error parsing date or amount: $e");
      }
    }
    return categoryTotals;
  }

  // Method to get total expenses for all categories last week
  Map<String, double> getTotalExpensesForAllCategoriesInLastWeek() {
    Map<String, double> categoryTotals = {};
    DateTime now = DateTime.now();
    DateTime startOfLastWeek = now.subtract(Duration(days: now.weekday + 6)); // Start of last week
    DateTime endOfLastWeek = now.subtract(Duration(days: now.weekday)); // End of last week

    for (Expense expense in expenses) {
      try {
        DateTime expenseDate = DateFormat('yyyy-MM-dd').parse(expense.date);

        if (expenseDate.isAfter(startOfLastWeek.subtract(Duration(days: 1))) &&
            expenseDate.isBefore(endOfLastWeek.add(Duration(days: 1)))) {
          double amountSpent = double.parse(expense.money_spent);

          if (categoryTotals.containsKey(expense.category)) {
            categoryTotals[expense.category] = categoryTotals[expense.category]! + amountSpent;
          } else {
            categoryTotals[expense.category] = amountSpent;
          }
        }
      } catch (e) {
        print("Error parsing date or amount: $e");
      }
    }
    return categoryTotals;
  }

  // Method to get total expenses for all categories last month
  Map<String, double> getTotalExpensesForAllCategoriesInLastMonth() {
    Map<String, double> categoryTotals = {};
    DateTime now = DateTime.now();
    DateTime startOfLastMonth = DateTime(now.year, now.month - 1, 1); // Start of last month
    DateTime endOfLastMonth = DateTime(now.year, now.month, 0); // End of last month

    for (Expense expense in expenses) {
      try {
        DateTime expenseDate = DateFormat('yyyy-MM-dd').parse(expense.date);

        if (expenseDate.isAfter(startOfLastMonth.subtract(Duration(days: 1))) &&
            expenseDate.isBefore(endOfLastMonth.add(Duration(days: 1)))) {
          double amountSpent = double.parse(expense.money_spent);

          if (categoryTotals.containsKey(expense.category)) {
            categoryTotals[expense.category] = categoryTotals[expense.category]! + amountSpent;
          } else {
            categoryTotals[expense.category] = amountSpent;
          }
        }
      } catch (e) {
        print("Error parsing date or amount: $e");
      }
    }
    return categoryTotals;
  }




  // get percentages
  Map<String, double> getCategoryPercentagesThisWeek(){
    Map<String, double> percentages = {};
    Map<String, double> categoryTotals = this.getTotalExpensesForAllCategoriesInCurrentWeek();
    double totalExpense = categoryTotals.values.fold(0, (accumulator, element) => accumulator + element);
    print("length is " + totalExpense.toString());

    categoryTotals.forEach((key, value){
      percentages[key] = (value/totalExpense)*100;
    });


    return percentages;
  }

  Map<String, double> getCategoryPercentagesLastWeek(){
    Map<String, double> percentages = {};
    Map<String, double> categoryTotals = this.getTotalExpensesForAllCategoriesInLastWeek();
    double totalExpense = categoryTotals.values.fold(0, (accumulator, element) => accumulator + element);
    print("length is " + totalExpense.toString());

    categoryTotals.forEach((key, value){
      percentages[key] = (value/totalExpense)*100;
    });


    return percentages;
  }

  Map<String, double> getCategoryPercentagesLastMonth(){
    Map<String, double> percentages = {};
    Map<String, double> categoryTotals = this.getTotalExpensesForAllCategoriesInLastMonth();
    double totalExpense = categoryTotals.values.fold(0, (accumulator, element) => accumulator + element);

    categoryTotals.forEach((key, value){
      percentages[key] = (value/totalExpense)*100;
    });

    return percentages;
  }

  // get total transactions
  int getTotalTransactionsForAllCategoriesThisWeek(String category) {
    int counter = 0;
    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    DateTime endOfWeek = now.add(Duration(days: 7 - now.weekday)); // End of last week

    for (Expense expense in expenses) {
      try {
        DateTime expenseDate = DateFormat('yyyy-MM-dd').parse(expense.date);

        if (expenseDate.isAfter(startOfWeek.subtract(Duration(days: 1))) &&
            expenseDate.isBefore(endOfWeek.add(Duration(days: 1)))) {
          if (category == expense.category) {
            counter++;
          }
        }
      } catch (e) {
        print("Error parsing date or amount: $e");
      }
    }
    return counter;
  }

  int getTotalTransactionsForAllCategoriesLastWeek(String category) {
    int counter = 0;
    DateTime now = DateTime.now();
    DateTime startOfLastWeek = now.subtract(Duration(days: now.weekday + 6)); // Start of last week
    DateTime endOfLastWeek = now.subtract(Duration(days: now.weekday)); // End of last week

    for (Expense expense in expenses) {
      try {
        DateTime expenseDate = DateFormat('yyyy-MM-dd').parse(expense.date);

        if (expenseDate.isAfter(startOfLastWeek.subtract(Duration(days: 1))) &&
            expenseDate.isBefore(endOfLastWeek.add(Duration(days: 1)))) {
          if (category == expense.category) {
            counter++;
          }
        }
      } catch (e) {
        print("Error parsing date or amount: $e");
      }
    }
    return counter;
  }

  int getTotalTransactionsForAllCategoriesLastMonth(String category) {
    int counter = 0;
    DateTime now = DateTime.now();
    DateTime startOfLastMonth = DateTime(now.year, now.month - 1, 1); // Start of last month
    DateTime endOfLastMonth = DateTime(now.year, now.month, 0); // End of last week

    for (Expense expense in expenses) {
      try {
        DateTime expenseDate = DateFormat('yyyy-MM-dd').parse(expense.date);

        if (expenseDate.isAfter(startOfLastMonth.subtract(Duration(days: 1))) &&
            expenseDate.isBefore(endOfLastMonth.add(Duration(days: 1)))) {
          if (category == expense.category) {
            counter++;
          }
        }
      } catch (e) {
        print("Error parsing date or amount: $e");
      }
    }
    return counter;
  }

}


class Expense{
  late String category;
  late String transaction;
  late String money_spent;
  late String date;


  Expense(String in_category, String in_transaction, String in_money_spent, String in_date){
    this.category = in_category;
    this.transaction = in_transaction;
    this.money_spent = in_money_spent;
    this.date = in_date;}


}