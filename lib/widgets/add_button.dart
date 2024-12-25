import 'package:finance_tracker/data/icon_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../models/category_model.dart';

class AddButton extends StatefulWidget {
  final void Function(Category) onCategoryAdded;

  const AddButton({required this.onCategoryAdded, Key? key}) : super(key: key);

  @override
  _AddButtonState createState() => _AddButtonState();
}

class _AddButtonState extends State<AddButton> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();

  IconData _icon = Icons.category;
  Color _color = Colors.blue;
  String _type = 'Expense';
  List<String> _subcategories = [];
  DateTime _selectedDate = DateTime.now(); // Default date

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _showAddCategoryDialog(context),
      backgroundColor: Colors.blue,
      child: const Icon(Icons.add, color: Colors.white),
    );
  }

  void _showAddCategoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Category'),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(
                  controller: _nameController,
                  label: 'Name',
                  validator: (value) => value == null || value.isEmpty ? 'Name is required' : null,
                ),
                const SizedBox(height: 16),
                _buildRow(
                  label: 'Icon',
                  child: IconButton(
                    icon: Icon(_icon),
                    onPressed: () async {
                      IconData? icon = await FlutterIconPicker.showIconPicker(context);
                      if (icon != null) {
                        setState(() {
                          _icon = icon;
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(height: 16),
                _buildRow(
                  label: 'Color',
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Pick a color'),
                          content: SingleChildScrollView(
                            child: BlockPicker(
                              pickerColor: _color,
                              onColorChanged: (color) {
                                setState(() {
                                  _color = color;
                                });
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ),
                      );
                    },
                    child: CircleAvatar(
                      backgroundColor: _color,
                      child: Icon(_icon, color: Colors.white), // Display the selected icon
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _buildRow(
                  label: 'Type',
                  child: DropdownButton<String>(
                    value: _type,
                    onChanged: (value) => setState(() => _type = value!),
                    items: const [
                      DropdownMenuItem(value: 'Expense', child: Text('Expense')),
                      DropdownMenuItem(value: 'Income', child: Text('Income')),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _budgetController,
                  label: 'Budget',
                  keyboardType: TextInputType.number,
                  validator: (value) => value == null || double.tryParse(value) == null ? 'Enter a valid budget' : null,
                ),
                const SizedBox(height: 16),
                _buildRow(
                  label: 'Date',
                  child: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
                ),
                const SizedBox(height: 16),
                _buildSubcategorySection(),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: _addCategory,
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _addCategory() {
    if (_formKey.currentState!.validate()) {
      final newCategory = Category(
        name: _nameController.text,
        icon: _icon,
        color: _color,
        type: _type,
        subcategories: _subcategories,
        budget: double.parse(_budgetController.text),
        date: _selectedDate, // Use selected date
      );
      widget.onCategoryAdded(newCategory);
      Navigator.pop(context);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      validator: validator,
    );
  }

  Widget _buildRow({required String label, required Widget child}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        child,
      ],
    );
  }

  Widget _buildSubcategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Subcategories'),
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: [
            for (String subcategory in _subcategories)
              Chip(
                label: Text(subcategory),
                onDeleted: () => setState(() => _subcategories.remove(subcategory)),
              ),
            GestureDetector(
              onTap: () async {
                final newSubcategory = await _showSubcategoryDialog();
                if (newSubcategory != null && newSubcategory.isNotEmpty) {
                  setState(() => _subcategories.add(newSubcategory));
                }
              },
              child: const Chip(label: Text('+')),
            ),
          ],
        ),
      ],
    );
  }

  Future<String?> _showSubcategoryDialog() {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Subcategory'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Enter subcategory'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}