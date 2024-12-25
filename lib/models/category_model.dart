import 'package:flutter/material.dart';

class Category {
  final String name;
  final String type; // 'Income' or 'Expense'
  final double budget;
  final IconData icon;
  final Color color;
  final DateTime date; // Add this field

  Category({
    required this.name,
    required this.type,
    required this.budget,
    required this.icon,
    required this.color,
    required this.date, required subcategories, // Initialize this field
  });

  get subcategories => null;
}
