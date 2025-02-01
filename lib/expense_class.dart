import 'dart:convert';
import 'package:intl/intl.dart';


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


// Class for collection of expenses
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

  // Method to get total expenses for all categories this month
  Map<String, double> getTotalExpensesForAllCategoriesInCurrentMonth() {
    Map<String, double> categoryTotals = {};
    DateTime now = DateTime.now();
    DateTime startOfCurrentMonth = DateTime(now.year, now.month, 1); // Start of current month
    DateTime endOfCurrentMonth = DateTime(now.year, now.month + 1, 0); // End of current month

    for (Expense expense in expenses) {
      try {
        DateTime expenseDate = DateFormat('yyyy-MM-dd').parse(expense.date);

        if (expenseDate.isAfter(startOfCurrentMonth.subtract(Duration(days: 1))) && // Corrected condition
            expenseDate.isBefore(endOfCurrentMonth.add(Duration(days: 1)))) { // Corrected condition

          double amountSpent = double.parse(expense.money_spent);

          categoryTotals.update(
            expense.category,
                (existingTotal) => existingTotal + amountSpent,
            ifAbsent: () => amountSpent,
          );
        }
      } catch (e) {
        print("Error parsing date or amount: $e");
      }
    }
    return categoryTotals;
  }

  // Method to get total expenses for all categories this day
  Map<String, double> getTotalExpensesForAllCategoriesInCurrentDay() {
    Map<String, double> categoryTotals = {};
    DateTime now = DateTime.now();
    DateTime startOfDay = DateTime(now.year, now.month, now.day); // Start of today
    DateTime endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59); // End of today (almost)

    for (Expense expense in expenses) {
      try {
        DateTime expenseDate = DateFormat('yyyy-MM-dd').parse(expense.date); // Or skip if already DateTime

        if (expenseDate.isAfter(startOfDay.subtract(const Duration(seconds: 1))) &&
            expenseDate.isBefore(endOfDay.add(const Duration(seconds: 1)))) {
          double amountSpent = double.parse(expense.money_spent);

          categoryTotals.update(
            expense.category,
                (existingTotal) => existingTotal + amountSpent,
            ifAbsent: () => amountSpent,
          );
        }
      } catch (e) {
        print("Error parsing date or amount: $e");
      }
    }
    return categoryTotals;
  }

  // Method to get total expenses for all categories of a specific date
  Map<String, double> getTotalExpensesForAllCategoriesInSpecificDate(DateTime date) {
    Map<String, double> categoryTotals = {};
    DateTime startOfDay = DateTime(date.year, date.month, date.day); // Start of the given date
    DateTime endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59); // End of the given date (almost)

    for (Expense expense in expenses) {
      try {
        DateTime expenseDate = DateFormat('yyyy-MM-dd').parse(expense.date); // Or skip if already DateTime

        if (expenseDate.isAfter(startOfDay.subtract(const Duration(seconds: 1))) &&
            expenseDate.isBefore(endOfDay.add(const Duration(seconds: 1)))) {
          double amountSpent = double.parse(expense.money_spent);

          categoryTotals.update(
            expense.category,
                (existingTotal) => existingTotal + amountSpent,
            ifAbsent: () => amountSpent,
          );
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
  int getTotalTransactionsForCategoryOnSpecificDate(String category, DateTime date) {
    int counter = 0;
    DateTime startOfDay = DateTime(date.year, date.month, date.day);
    DateTime endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

    for (Expense expense in expenses) {
      try {
        DateTime expenseDate = DateFormat('yyyy-MM-dd').parse(expense.date); // Or skip if already DateTime

        if (expenseDate.isAfter(startOfDay.subtract(const Duration(seconds: 1))) &&
            expenseDate.isBefore(endOfDay.add(const Duration(seconds: 1)))) {
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