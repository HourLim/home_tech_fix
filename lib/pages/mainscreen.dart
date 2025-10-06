// import 'package:flutter/material.dart';
// import 'package:hometechfix/pages/choose_role.dart'; // Make sure this file exists

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'HomeTechFix',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFF09013)),
//         useMaterial3: true,
//         scaffoldBackgroundColor: const Color(0xFFFDF9F6),
//       ),
//       home: const MainScreen(), // 👈 start on Choose Role page
//     );
//   }
// }

// class MainScreen extends StatefulWidget {
//   const MainScreen({Key? key}) : super(key: key);

//   @override
//   State<MainScreen> createState() => _MainScreenState();
// }

// class _MainScreenState extends State<MainScreen> {
//   @override
//   Widget build(BuildContext context) {
//     // 👇 The app now loads directly into the Choose Role screen
//     return const Scaffold(
//       body: RoleSelectScreen(),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:hometechfix/pages/history_page.dart';
import 'package:hometechfix/pages/chat_page.dart';
import 'package:hometechfix/pages/homepages/homepage.dart';
import 'package:hometechfix/pages/profile_page.dart';
import 'package:hometechfix/pages/profile_edit_page.dart';
import 'package:hometechfix/pages/login_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // List of pages
  final List<Widget> _pages = [
    const LoginPage(),
    const HomeServiceScreen(),
    const HistoryScreen(),
    const MessagesScreen(),
    const ProfilePage(),
    const EditProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],

    );
  }
}
