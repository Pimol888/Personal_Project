import 'package:flutter/material.dart';
import 'package:finance_tracker/models/transaction_model.dart';

class TransactionForm extends StatefulWidget {
  final Transaction? initialTransaction;
  final Function(Transaction) onSubmit;

  const TransactionForm({
    Key? key,
    this.initialTransaction,
    required this.onSubmit,
  }) : super(key: key);

  @override
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _amountController;
  DateTime _selectedDate = DateTime.now(); // Default date

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialTransaction?.name ?? '');
    _amountController = TextEditingController(text: widget.initialTransaction?.amount.toString() ?? '0.0');
    if (widget.initialTransaction != null) {
      _selectedDate = widget.initialTransaction!.date; // Set the initial date if editing
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final transaction = Transaction(
        name: _nameController.text,
        amount: double.tryParse(_amountController.text) ?? 0.0,
        date: _selectedDate, // Use selected date
      );
      widget.onSubmit(transaction);
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Transaction Name'),
                validator: (value) => value == null || value.isEmpty ? 'Name is required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Amount'),
                validator: (value) => value == null || double.tryParse(value) == null ? 'Enter a valid amount' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text('Date: ${_selectedDate.toLocal()}'.split(' ')[0]),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: Text(widget.initialTransaction == null ? 'Add Transaction' : 'Update Transaction'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}