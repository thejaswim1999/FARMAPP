import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:farm_buddy/pages/SignInPage.dart';
import 'package:farm_buddy/pages/HomePage.dart';
import 'package:farm_buddy/pages/HarvestPage.dart';
import 'package:farm_buddy/pages/CropProvider.dart';
import 'package:farm_buddy/pages/LocalStorageService.dart';
import 'dart:html' as html;

void storeCredentials(String username, String password) {
  html.window.localStorage['username'] = us ername;
  html.window.localStorage['password'] = password;
}
// import 'dart:html' as html;

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
    Navigator.pushReplacementNamed(context, '/login');
  }
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CropProvider(),
      child: MaterialApp(
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        themeMode: ThemeMode.system,
        initialRoute: '/signin',
        routes: {
          '/signin': (context) => SignInPage(),
          '/home': (context) => HomePage(),
          '/harvest': (context) => HarvestPage(),
        },
        localizationsDelegates: [
          // AppLocalization.delegate, // Your localization delegate here
          // GlobalMaterialLocalizations.delegate,
          // GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en', ''), // English
          const Locale('es', ''), // Spanish
        ],
      ),
    );
  }
}
