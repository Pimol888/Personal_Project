import 'package:finance_tracker/models/category_model.dart';
import 'package:flutter/material.dart';

class CategoryForm extends StatefulWidget {
  final void Function(Category) onCreated;
  final Category? initialCategory;

  const CategoryForm({required this.onCreated, this.initialCategory, Key? key}) : super(key: key);

  @override
  _CategoryFormState createState() => _CategoryFormState();
}

class _CategoryFormState extends State<CategoryForm> {
  late TextEditingController nameController;
  late TextEditingController budgetController;
  late Category category;
  Color selectedColor = Colors.grey; // Default color
  DateTime selectedDate = DateTime.now(); // Default date

  @override
  void initState() {
    super.initState();
    if (widget.initialCategory != null) {
      category = widget.initialCategory!;
      nameController = TextEditingController(text: category.name);
      budgetController = TextEditingController(text: category.budget.toString());
      selectedColor = category.color; // Set the initial selected color
      selectedDate = category.date; // Set the initial selected date
    } else {
      category = Category(
        name: '',
        icon: Icons.category,
        color: selectedColor,
        type: 'Expense',
        subcategories: [],
        budget: 0.0,
        date: selectedDate, // Initialize with the default date
      );
      nameController = TextEditingController();
      budgetController = TextEditingController();
    }
  }

  // Method to select a color from a list of colors
  void _selectColor(Color color) {
    setState(() {
      selectedColor = color;
    });
  }

  // Method to select a date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(labelText: 'Category Name'),
          ),
          TextField(
            controller: budgetController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Budget'),
          ),
          // Date picker button
          Row(
            children: [
              Text('Date: ${selectedDate.toLocal()}'.split(' ')[0]),
              IconButton(
                icon: Icon(Icons.calendar_today),
                onPressed: () => _selectDate(context),
              ),
            ],
          ),
          // Color selection buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () => _selectColor(Colors.red),
                child: Text('Red'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                onPressed: () => _selectColor(Colors.blue),
                child: Text('Blue'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                onPressed: () => _selectColor(Colors.green),
                child: Text('Green'),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              final newCategory = Category(
                name: nameController.text,
                icon: category.icon,
                color: selectedColor, // Use selected color
                type: category.type,
                subcategories: category.subcategories,
                budget: double.tryParse(budgetController.text) ?? 0.0,
                date: selectedDate, // Use selected date
              );
              widget.onCreated(newCategory);
              Navigator.of(context).pop(); // Close the modal after saving
            },
            child: Text(widget.initialCategory == null ? 'Add Category' : 'Save Changes'),
          ),
        ],
      ),
    );
  }
}