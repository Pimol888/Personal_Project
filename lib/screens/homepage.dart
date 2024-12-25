
import 'package:finance_tracker/screens/transaction.dart';
import 'package:finance_tracker/widgets/category_form.dart';
import 'package:finance_tracker/widgets/cusomer_header.dart'; 
import 'package:finance_tracker/widgets/home.dart';
import 'package:flutter/material.dart';
import 'package:finance_tracker/data/category_data.dart'; // Import the category data
import 'package:finance_tracker/models/category_model.dart'; // Import the Category model
import 'package:finance_tracker/models/transaction_model.dart'; // Import the Transaction model
import 'package:finance_tracker/widgets/bottom_bar.dart';
import 'account_screen.dart';
import 'package:finance_tracker/widgets/add_button.dart'; // Import AddButton widget

class HomeScreen extends StatefulWidget {
  final String username;
  final String profilePicture;

  const HomeScreen({
    required this.username,
    required this.profilePicture,
    Key? key,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  late String currentUsername;
  late String currentProfilePicture;

  final List<Widget> _screens = [
    const HomeTab(),
    BudgetPlanTab(transactions: []), // Pass an empty list initially
  ];

  @override
  void initState() {
    super.initState();
    currentUsername = widget.username;
    currentProfilePicture = widget.profilePicture;
  }

  // Function to handle creating a new category
  void onExpenseCreated(Category newCategory) {
    setState(() {
      categories.add(newCategory); // Add the new category to the list
    });
  }

  // Function to handle removing a category
  void onExpenseRemoved(Category category) {
    setState(() {
      categories.remove(category); // Remove the category from the list
    });
  }

  // Function to extract transactions from expense categories
  List<Transaction> getExpenseTransactions() {
    return categories
        .where((category) => category.type == 'Expense')
        .map((category) => Transaction(
              name: category.name,
              amount: category.budget,
              date: category.date,
            ))
        .toList();
  }

  // Widget to display categories as cards
  Widget buildCategoryGrid() {
    List<Category> incomeCategories = categories.where((cat) => cat.type == 'Income').toList();
    List<Category> expenseCategories = categories.where((cat) => cat.type == 'Expense').toList();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (incomeCategories.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Income', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // 3 cards per row
                crossAxisSpacing: 10.0, // Space between columns
                mainAxisSpacing: 10.0, // Space between rows
                childAspectRatio: 0.7, // Adjust card size to make it rectangular
              ),
              itemCount: incomeCategories.length,
              itemBuilder: (context, index) {
                final category = incomeCategories[index];
                return buildCategoryCard(category);
              },
            ),
          ],
          if (expenseCategories.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Expense', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // 3 cards per row
                crossAxisSpacing: 10.0, // Space between columns
                mainAxisSpacing: 10.0, // Space between rows
                childAspectRatio: 0.7, // Adjust card size to make it rectangular
              ),
              itemCount: expenseCategories.length,
              itemBuilder: (context, index) {
                final category = expenseCategories[index];
                return buildCategoryCard(category);
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget buildCategoryCard(Category category) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: () {
          // You can add functionality to show more details if needed
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(category.icon, color: category.color, size: 40),
            const SizedBox(height: 8),
            Text(
              category.name,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Budget: \$${category.budget.toStringAsFixed(2)}',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              'Date: ${category.date.toLocal()}'.split(' ')[0], // Display the date
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 8),
            // Edit and delete buttons inside each card
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    // Open modal for editing the category (similar to adding)
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (ctx) => CategoryForm(
                        onCreated: (updatedCategory) {
                          onExpenseRemoved(category); // Remove the old category first
                          onExpenseCreated(updatedCategory); // Add the updated one
                        },
                        initialCategory: category, // Pass the existing category for editing
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => onExpenseRemoved(category), // Call remove
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      body: Stack(
        children: [
          Column(
            children: [
              CustomHeader(
                username: currentUsername,
                onMenuPressed: () async {
                  final updatedData = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AccountScreen(
                        username: currentUsername,
                        profilePicture: currentProfilePicture,
                      ),
                    ),
                  );
                  if (updatedData != null) {
                    setState(() {
                      currentUsername = updatedData['username'];
                      currentProfilePicture = updatedData['profilePicture'];
                    });
                  }
                },
              ),
              Expanded(
                child: _currentIndex == 0 ? buildCategoryGrid() : BudgetPlanTab(transactions: getExpenseTransactions()),
              ),
            ],
          ),
          if (_currentIndex == 0)
            Positioned(
              bottom: 80, // Adjust the distance above the bottom navigation bar
              right: 16,  // Distance from the right side of the screen
              child: AddButton(
                onCategoryAdded: onExpenseCreated, // Connect to the state management function
              ),
            ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}