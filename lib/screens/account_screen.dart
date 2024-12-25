import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class AccountScreen extends StatefulWidget {
  final String username;
  final String profilePicture;

  const AccountScreen({
    required this.username,
    required this.profilePicture,
    Key? key,
  }) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  TextEditingController usernameController = TextEditingController();
  String? profilePicture;
  String? updatedUsername;

  @override
  void initState() {
    super.initState();
    usernameController.text = widget.username;
    profilePicture = widget.profilePicture;
    _loadData();
  }

  // Load saved data from SharedPreferences
  void _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    String? savedUsername = prefs.getString('username');
    String? savedProfilePicture = prefs.getString('profilePicture');

    setState(() {
      if (savedUsername != null) updatedUsername = savedUsername;
      if (savedProfilePicture != null) profilePicture = savedProfilePicture;
    });
  }

  // Image picker method
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        profilePicture = pickedFile.path;
      });
    }
  }

  // Save data and return updated data
  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('username', usernameController.text);
    if (profilePicture != null) {
      prefs.setString('profilePicture', profilePicture!);
    }

    // Return updated data to HomeScreen
    Navigator.pop(context, {
      'username': usernameController.text,
      'profilePicture': profilePicture,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile Section
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: profilePicture != null
                          ? FileImage(File(profilePicture!))
                          : null,
                      child: profilePicture == null
                          ? Icon(Icons.camera_alt, size: 40)
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: IconButton(
                          icon: Icon(Icons.edit, size: 18),
                          onPressed: _pickImage,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveData, // Save and go back to the HomeScreen
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
