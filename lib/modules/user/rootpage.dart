import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '/modules/user/ProfilePage.dart';
import './HomePage.dart';
import './OrdersPage.dart';
import 'NotificationPage.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  int _currentIndex = 0;
  late PageController _pageController;

  bool isOnline = false;

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
    HapticFeedback.lightImpact(); // ✅ Better haptic
    setState(() => _currentIndex = index);
    _pageController.jumpToPage(index);
  }

  Widget _buildCustomAppBar() {
    final userProvider = Provider.of<UserProvider>(context);

    bool isOnline = userProvider.user?.isOnline ?? false;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black26),
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.circle,
                        size: 10,
                        color: isOnline ? Colors.green : Colors.grey,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        isOnline ? "Online" : "Offline",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: const Icon(Icons.help_outline, size: 22),
            ),
          ],
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(55),
        child: _buildCustomAppBar(),
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          HomePage(),
          OrderPage(),
          NotificationPage(),
          ProfilePage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color.fromRGBO(160, 50, 50, 1),
        unselectedItemColor: Colors.black87,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: _currentIndex == 0 ? 28 : 24),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_shipping, size: _currentIndex == 1 ? 28 : 24),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications, size: _currentIndex == 2 ? 28 : 24),
            label: 'Notification',
          ),
          BottomNavigationBarItem(
            icon: CircleAvatar(
              radius: 12,
              backgroundImage: AssetImage('assets/images/profile.png'),
              backgroundColor: Colors.transparent,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
