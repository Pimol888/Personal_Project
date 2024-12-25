import 'package:flutter/material.dart';

class CustomAlert extends StatelessWidget {
  final String title;
  final String content;

  const CustomAlert({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('OK',
          style: TextStyle(
            color: const Color.fromARGB(172, 101, 138, 233)
          )
          ),
        ),
      ],
    );
  }
}
