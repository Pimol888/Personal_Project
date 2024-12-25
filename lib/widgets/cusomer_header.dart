import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomHeader extends StatefulWidget {
  final String username;
  final VoidCallback onMenuPressed;

  const CustomHeader({
    required this.username,
    required this.onMenuPressed,
    Key? key,
  }) : super(key: key);

  @override
  _CustomHeaderState createState() => _CustomHeaderState();
}

class _CustomHeaderState extends State<CustomHeader> {
  String _selectedPeriod = 'Daily';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.blue[700],
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(16),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          DropdownButton<String>(
            dropdownColor: Colors.blue[600],
            value: _selectedPeriod,
            items: const [
              DropdownMenuItem(
                value: 'Daily',
                child: Text('Daily', style: TextStyle(color: Colors.white)),
              ),
              DropdownMenuItem(
                value: 'Weekly',
                child: Text('Weekly', style: TextStyle(color: Colors.white)),
              ),
              DropdownMenuItem(
                value: 'Monthly',
                child: Text('Monthly', style: TextStyle(color: Colors.white)),
              ),
            ],
            onChanged: (value) {
              setState(() {
                _selectedPeriod = value!;
              });
            },
          ),
          Expanded(
            child: Center(
              child: Text(
                widget.username,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: widget.onMenuPressed,
          ),
        ],
      ),
    );
  }
}
