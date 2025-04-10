import 'package:flutter/material.dart';
import '/modules/user/HistoryPage.dart';
import '/modules/user/ProfilePage.dart';
import '../user/HomePage.dart';
import '../user/OrdersPage.dart';
import '../user/NotificationPage.dart';



class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);


  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  int _currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void onTabTapped(int index) {
    setState(() => _currentIndex = index);
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(), // disable swipe
          children: const [
            HomePage(),
            // OrdersPage(),
            NotificationPage(),
            ProfilePage(),
            HistoryPage(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.black87,
        backgroundColor: Colors.white,
        items: const [

          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_shipping),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notification',
          ),
          BottomNavigationBarItem(
            icon: CircleAvatar(
              radius: 12,
              // backgroundImage: AssetImage('assets/images/profile.jpeg'),
            ),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Earnings',
          ),
        ],
      ),
    );
  }
}
