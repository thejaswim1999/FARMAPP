import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:farm_buddy/pages/LocalStorageService.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  void _signIn() async {
    // Save user data locally and navigate to the HomePage
    // This is where you would implement your local storage logic
    String username = _usernameController.text;
    String password = _passwordController.text;
     if (username.isNotEmpty && password.isNotEmpty) {
      // Save credentials
      final localStorageService = LocalStorageService();
      await localStorageService.saveUserCredentials(username, password);
      Navigator.pushReplacementNamed(context, '/home');}
     else {
        // Show error if credentials are not valid
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please enter both username and password')),
        );
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign In')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _signIn,
              child: Text('Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}
