import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat('dd/MM/yyyy');

const uuid = Uuid();

enum Category { food, travel, leisure, work }

const categoryIcons = {
  Category.food: Icons.lunch_dining,
  Category.travel: Icons.flight_takeoff,
  Category.leisure: Icons.movie,
  Category.work: Icons.work,
};

const kCategoryColors = {
  Category.food: Color.fromARGB(255, 255, 204, 0),
  Category.travel: Color.fromARGB(255, 0, 204, 255),
  Category.leisure: Color.fromARGB(255, 255, 0, 204),
  Category.work: Color.fromARGB(255, 0, 255, 0),
};

const kDarkCategoryColors = {
  Category.food: Color.fromARGB(255, 151, 91, 0),
  Category.travel: Color.fromARGB(255, 0, 49, 82),
  Category.leisure: Color.fromARGB(255, 117, 0, 70),
  Category.work: Color.fromARGB(255, 0, 90, 0),
};

Map<Category, Color> getCategoryColors(BuildContext context) {
  final isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;
  return getCategoryColorsByMode(isDarkMode);
}

Map<Category, Color> getCategoryColorsByMode(bool isDarkMode) {
  return isDarkMode ? kDarkCategoryColors : kCategoryColors;
}

class Expense implements Comparable<Expense> {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Category category;

  Expense({
    String? id,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  }) : id = id ?? uuid.v4();

  String get formattedDate {
    return formatter.format(date);
  }

  IconData get categoryIcon {
    return categoryIcons[category] ?? Icons.error;
  }

  @override
  int compareTo(Expense other) {
    final dateComparison = date.compareTo(other.date);

    if (dateComparison != 0) {
      return dateComparison * -1; // Sort by date descending
    }
    return title.compareTo(other.title);
  }
}

class ExpenseBucket {
  final Category category;
  final List<Expense> expenses;
  const ExpenseBucket({required this.category, required this.expenses});

  ExpenseBucket.forCategory(List<Expense> allExpenses, this.category)
    : expenses =
          allExpenses.where((expense) => expense.category == category).toList();

  double get totalExpenses {
    double total = expenses.fold<double>(
      0.0,
      (previousTotal, expense) => previousTotal + expense.amount,
    );
    return total;
  }
}
