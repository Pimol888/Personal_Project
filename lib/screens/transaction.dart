import 'package:flutter/material.dart';
import 'package:finance_tracker/models/transaction_model.dart';

class BudgetPlanTab extends StatefulWidget {
  final List<Transaction> transactions;

  const BudgetPlanTab({Key? key, required this.transactions}) : super(key: key);

  @override
  _BudgetPlanTabState createState() => _BudgetPlanTabState();
}

class _BudgetPlanTabState extends State<BudgetPlanTab> {
  String _sortOrder = 'Ascending';

  void _sortTransactions() {
    if (_sortOrder == 'Ascending') {
      widget.transactions.sort((a, b) => a.date.compareTo(b.date));
    } else {
      widget.transactions.sort((a, b) => b.date.compareTo(a.date));
    }
  }

  @override
  void initState() {
    super.initState();
    _sortTransactions(); // Initial sort
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.blue,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Transactions',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                DropdownButton<String>(
                  value: _sortOrder,
                  dropdownColor: Colors.blue,
                  items: <String>['Ascending', 'Descending'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _sortOrder = newValue!;
                      _sortTransactions();
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.transactions.length,
              itemBuilder: (context, index) {
                final transaction = widget.transactions[index];
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(transaction.name),
                    subtitle: Text('Amount: \$${transaction.amount.toStringAsFixed(2)}\nDate: ${transaction.date.toLocal()}'.split(' ')[0]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}