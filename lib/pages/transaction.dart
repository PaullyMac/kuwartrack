import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart'; // Import for date formatting and parsing
import 'package:kuwartrack/expense_card.dart';


class Transaction extends StatefulWidget {
  const Transaction({super.key});

  @override
  State<Transaction> createState() => _TransactionState();
}

class _TransactionState extends State<Transaction> {
  Map data = {};
  late Expenses expenses;
  late List<Expense> expense_list;
  Map<String, double> category_total_expenses = {};
  bool isLoading = true; // To manage loading state
  late double overallTotal;
  late Map<String, double> pie_percentages;
  int _selectedIndexDate = 0;
  int transactions = 0;
  bool asc_or_desc = true; // ascending by default
  bool sort_by_type = true; // by default percentage

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
    return const Placeholder();
  }
}
