import 'package:flutter/material.dart';
import 'package:movieapp/pages/MovieHomePage.dart';
import 'package:splash_view/splash_view.dart';
import 'package:provider/provider.dart';
import 'providers/theme_notifier.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeNotifier(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late ThemeNotifier themeNotifier;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    themeNotifier = Provider.of<ThemeNotifier>(context);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PopcornPal',
      themeMode: themeNotifier.themeMode, // Updated to use themeMode from the notifier
      theme: _lightTheme(),
      darkTheme: _darkTheme(),
      home: SplashView(
        showStatusBar: true,
        logo: Image.asset(
          'assets/LOGO-Recovered.png',
          width: 150,
          height: 150,
        ),
        done: Done(const HomeScreen()),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  ThemeData _lightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.deepPurpleAccent,
      colorScheme: const ColorScheme.light(
        secondary: Colors.purpleAccent,
      ),
      appBarTheme: const AppBarTheme(
        color: Colors.deepPurpleAccent,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.deepPurpleAccent,
        unselectedItemColor: Colors.grey,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.black87),
        bodyMedium: TextStyle(color: Colors.black54),
        titleMedium: TextStyle(color: Colors.black87),
      ),
    );
  }

  ThemeData _darkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.deepPurpleAccent,
      colorScheme: const ColorScheme.dark(
        secondary: Colors.purpleAccent,
      ),
      appBarTheme: AppBarTheme(
        color: Colors.deepPurpleAccent[800],
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.purpleAccent,
        unselectedItemColor: Colors.grey,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Colors.grey),
        titleMedium: TextStyle(color: Colors.white),
      ),
    );
  }
}
