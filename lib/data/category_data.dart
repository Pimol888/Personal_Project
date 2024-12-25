import 'package:finance_tracker/models/category_model.dart';
import 'package:flutter/material.dart';

List<Category> categories = [
  Category(
    name: 'Food & Drink',
    icon: Icons.restaurant,
    color: Colors.orange,
    type: 'Expense',
    subcategories: ['Breakfast', 'Lunch', 'Dinner', 'Snacks', 'Coffee', 'Groceries'],
    budget: 100.0,
    date: DateTime(2024, 12, 1), // Add a date value here
  ),
  Category(
    name: 'Transportation',
    icon: Icons.directions_car,
    color: Colors.blue,
    type: 'Expense',
    subcategories: [],
    budget: 50.0,
    date: DateTime(2024, 12, 2), // Add a date value here
  ),
  Category(
    name: 'Shopping',
    icon: Icons.shopping_cart,
    color: Colors.purple,
    type: 'Expense',
    subcategories: [],
    budget: 200.0,
    date: DateTime(2024, 12, 3), // Add a date value here
  ),
  Category(
    name: 'Entertainment',
    icon: Icons.movie,
    color: Colors.green,
    type: 'Expense',
    subcategories: [],
    budget: 150.0,
    date: DateTime(2024, 12, 4), // Add a date value here
  ),
  Category(
    name: 'Salary',
    icon: Icons.work,
    color: Colors.green,
    type: 'Income',
    subcategories: [],
    budget: 0.0,
    date: DateTime(2024, 12, 5), // Add a date value here
  ),
  Category(
    name: 'Freelance',
    icon: Icons.laptop,
    color: Colors.lightBlue,
    type: 'Income',
    subcategories: [],
    budget: 0.0,
    date: DateTime(2024, 12, 6), // Add a date value here
  ),
];