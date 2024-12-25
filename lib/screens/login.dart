import 'package:finance_tracker/screens/homepage.dart';
import 'package:flutter/material.dart';
import '../data/user_data.dart';
import '../widgets/alert.dart';
import 'account_screen.dart'; // Import AccountScreen

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final UserRepository userRepository = UserRepository();

  bool isPasswordVisible = false;

  void login(BuildContext context) {
    final username = usernameController.text;
    final password = passwordController.text;

    if (userRepository.validateUser(username, password)) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(username: username, profilePicture: '',)),
      );
    } else {
      showDialog(
        context: context,
        builder: (ctx) => CustomAlert(
          title: 'Login Failed',
          content: 'Invalid username or password.',
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Card Budget!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              Image.asset(
                'assets/login/logo.png',
                height: 150,
                width: 400,
              ),
              const SizedBox(height: 16),
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
                onPressed: () => login(context),
                child: const Text(
                  'Login',
                  style: TextStyle(
                    color: Color.fromARGB(172, 6, 25, 75),
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Pass default profile picture when navigating to AccountScreen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AccountScreen(
                        username: usernameController.text,
                        profilePicture: 'assets/images/default_profile_picture.png', // Provide default value
                      ),
                    ),
                  );
                },
                child: const Text(
                  'Register',
                  style: TextStyle(
                    color: Color.fromARGB(172, 6, 25, 75),
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
