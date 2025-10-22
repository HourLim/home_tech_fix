import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hometechfix/pages/login_page.dart';
import 'package:hometechfix/pages/signup_page.dart';
import 'package:hometechfix/auth_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HomeTechFix',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E88E5)),
        useMaterial3: true,
      ),
      
      home: const AuthWrapper(),
      routes: {
        '/login': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
          final isTechnician = args?['isTechnician'] ?? false;
          return LoginPage(isTechnician: isTechnician);
        },
        '/signup': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
          final isTechnician = args?['isTechnician'] ?? false;
          return SignUpPage(isTechnician: isTechnician);
        },
      },
    );
  }
}