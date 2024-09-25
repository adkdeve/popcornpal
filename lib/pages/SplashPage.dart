// import 'package:flutter/material.dart';
// import 'package:splash_view/splash_view.dart';
// import 'MovieHomePage.dart';
//
// class SplashScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return SplashView(
//       backgroundColor: Colors.deepPurpleAccent,
//       logo: Image.asset('assets/images/app_icon.png'), // Your app logo here
//       title: const Text(
//         'Welcome to Movie App',
//         style: TextStyle(
//           color: Colors.white,
//           fontSize: 24,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//       subtitle: const Text(
//         'Your gateway to endless movie adventures!',
//         style: TextStyle(
//           color: Colors.white70,
//           fontSize: 16,
//         ),
//       ),
//       done: Done(
//         onTap: () {
//           // Navigate to the home screen after the splash screen
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => HomeScreen()), // Your home screen
//           );
//         },
//         child: const Text(
//           'Get Started',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 18,
//           ),
//         ),
//       ),
//       duration: const Duration(seconds: 4), // Duration of the splash screen
//     );
//   }
// }