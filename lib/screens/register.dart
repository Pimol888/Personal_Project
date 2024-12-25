import 'package:finance_tracker/screens/homepage.dart';
import 'package:flutter/material.dart';
import '../data/user_data.dart';
import '../widgets/alert.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final UserRepository userRepository = UserRepository();

  bool isPasswordVisible = false;

  void register(BuildContext context) {
    final username = usernameController.text;
    final password = passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      showDialog(
        context: context,
        builder: (ctx) => CustomAlert(
          title: 'Error',
          content: 'Please fill in all fields.',
        ),
      );
      return;
    }

    if (userRepository.addUser(username, password)) {
      debugPrint('New user added! username: $username, Password: $password');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(username: username, profilePicture: '',)),
      );
    } else {
      showDialog(
        context: context,
        builder: (ctx) => CustomAlert(
          title: 'Error',
          content: 'username already exists.',
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Card Budget!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Image.asset('assets/login/logo.png', height: 150, width: 400),
            TextFormField(
              controller: usernameController,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color.fromARGB(172, 134, 207, 238),
                labelText: 'Username',
                labelStyle: const TextStyle(color: Colors.black),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(Icons.account_circle, color: Colors.grey),
              ),
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color.fromARGB(172, 134, 207, 238),
                labelText: 'Password',
                labelStyle: const TextStyle(color: Colors.black),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                suffixIcon: IconButton(
                  icon: Icon(
                    isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      isPasswordVisible = !isPasswordVisible;
                    });
                  },
                ),
              ),
              obscureText: !isPasswordVisible,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => register(context),
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
