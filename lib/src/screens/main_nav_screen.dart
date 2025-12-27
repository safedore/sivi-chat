import 'package:flutter/material.dart';
import 'package:my_sivi_chat/src/screens/home_screen.dart';

class MainNavScreen extends StatefulWidget {
  const MainNavScreen({super.key, required this.title});

  final String title;

  @override
  State<MainNavScreen> createState() => _MainNavScreenState();
}

class _MainNavScreenState extends State<MainNavScreen> {
  int _selectedTabIndex = 0;
  final List<Widget> _tabs = [
    HomeScreen(),
    Center(child: Text('Offers', style: TextStyle(fontSize: 26))),
    Center(child: Text('Settings', style: TextStyle(fontSize: 26))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedTabIndex, children: _tabs),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTabIndex,
        onTap: (index) {
          setState(() {
            _selectedTabIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.sms_outlined),
            label: 'Home',
            activeIcon: Icon(Icons.sms_outlined, color: Colors.blueAccent),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_offer_outlined),
            label: 'Offers',
            activeIcon: Icon(
              Icons.local_offer_outlined,
              color: Colors.blueAccent,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: 'Settings',
            activeIcon: Icon(Icons.settings_outlined, color: Colors.blueAccent),
          ),
        ],
      ),
    );
  }
}
