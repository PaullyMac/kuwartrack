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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child:
        Column(


        )

      )
    );
  }
}
