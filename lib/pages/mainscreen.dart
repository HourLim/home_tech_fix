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
