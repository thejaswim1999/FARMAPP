import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:farm_buddy/pages/SignInPage.dart';
import 'package:farm_buddy/pages/HomePage.dart';
import 'package:farm_buddy/pages/HarvestPage.dart';
import 'package:farm_buddy/pages/CropProvider.dart';
import 'package:farm_buddy/pages/LocalStorageService.dart';
import 'package:farm_buddy/pages/CropModel.dart'; // Import Crop from classmodel.dart
import 'dart:html' as html;

// A class to manage the theme state
class ThemeNotifier extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeMode get currentTheme => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}

void storeCredentials(String username, String password) {
  html.window.localStorage['username'] = username;
  html.window.localStorage['password'] = password;
}

void printStoredCredentials() {
  final username = html.window.localStorage['username'];
  final password = html.window.localStorage['password'];

  print('Stored Username: $username');
  print('Stored Password: $password');
}

void main() {
  runApp(FarmBuddyApp());
}

class FarmBuddyApp extends StatelessWidget {
  void _logout(BuildContext context) async {
    final localStorageService = LocalStorageService();
    await localStorageService.clearUserCredentials();
    Navigator.pushReplacementNamed(context, '/signin');
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CropProvider()),
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),
      ],
      child: Consumer<ThemeNotifier>(
        builder: (context, themeNotifier, child) {
          return MaterialApp(
            theme: ThemeData(
              primarySwatch: Colors.green,
              brightness: Brightness.light,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            darkTheme: ThemeData(
              primarySwatch: Colors.green,
              brightness: Brightness.dark,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            themeMode: themeNotifier.currentTheme,
            initialRoute: '/signin',
            routes: {
              '/signin': (context) => SignInPage(),
              '/home': (context) => HomePage(),
              '/harvest': (context) => HarvestPage(),
              '/settings': (context) => SettingsPage(), // Add SettingsPage route
            },
            supportedLocales: [
              const Locale('en', ''), // English
              const Locale('es', ''), // Spanish
            ],
          );
        },
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Center(
        child: Consumer<ThemeNotifier>(
          builder: (context, themeNotifier, child) {
            return SwitchListTile(
              title: Text('Dark Mode'),
              value: themeNotifier.isDarkMode,
              onChanged: (value) {
                themeNotifier.toggleTheme();
              },
            );
          },
        ),
      ),
    );
  }
}
