import 'package:flutter/material.dart';
import 'package:hometechfix/pages/chat_page.dart';
import 'package:hometechfix/pages/history_page.dart';
import 'package:hometechfix/pages/homepages/homepage.dart';
import 'package:hometechfix/pages/profile_page.dart';

class MainNavigationPage extends StatefulWidget {
  final int initialIndex;
  const MainNavigationPage({super.key, this.initialIndex = 0});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  late int _selectedIndex;

  // Add navigation pages here
  final List<Widget> _pages = const [
    HomeServiceScreen(),
    HistoryScreen(),
    MessagesScreen(),
    ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    const orangeColor = Color(0xFFF39C12);

    return Scaffold(
      body: _pages[_selectedIndex],

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: orangeColor,
          unselectedItemColor: Colors.grey,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          backgroundColor: Colors.white,
          elevation: 0,
          items: [
            _buildNavItem(Icons.home_rounded, 0),
            _buildNavItem(Icons.history_rounded, 1),
            _buildNavItem(Icons.message_rounded, 2),
            _buildNavItem(Icons.person_rounded, 3),
          ],
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(IconData icon, int index) {
    const double selectedSize = 30;
    const double unselectedSize = 26;
    const orangeColor = Color(0xFFF39C12);

    final bool isSelected = _selectedIndex == index;

    return BottomNavigationBarItem(
      label: '',
      icon: AnimatedScale(
        scale: isSelected ? 1.15 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        child: Icon(
          icon,
          size: isSelected ? selectedSize : unselectedSize,
          color: isSelected ? orangeColor : Colors.grey,
        ),
      ),
    );
  }
}