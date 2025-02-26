import 'package:e3_app/screens/Dashboard.dart';
import 'package:e3_app/screens/HomeScreen.dart';
import 'package:e3_app/screens/LoginScreen.dart';
import 'package:e3_app/screens/SplashScreen.dart';
import 'package:e3_app/services/shared_pref_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String? email = await SharedPrefService.getUserEmail();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp(isLoggedIn: email != null));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  MyApp({required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: "/splashscreen",
      routes: {
        "/splashscreen":(context) => SplashScreen(),
        "/login": (context) => LoginScreen(),
        "/home": (context) => HomeScreen(),
        '/dashboard': (context) => DashboardScreen(),
      },
    );
  }
}