import 'package:flutter/material.dart';
import '../../services/auth_services.dart';
import 'personal_info_page.dart';
import 'vehicle_registration_page.dart';
import 'change_password_page.dart';
import 'settings_page.dart';
import 'package:provider/provider.dart'; // Make sure this is imported

// Import your UserProvider
import '../../providers/user_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    // Access UserProvider to get the user data
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    if (user == null) {
      // Handle loading or null user case
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF2DDE2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: const Color(0xFF843744),
                    radius: 20,
                    child: Text(
                      user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U', // Display first letter of the user's name
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name, // Display the user's name
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        user.email, // Display the user's email
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),
          buildMenuItem(
            icon: Icons.person_outline,
            title: 'Personal Information',
            page: const PersonalInfoPage(),
          ),
          buildMenuItem(
            icon: Icons.directions_car_outlined,
            title: 'Vehicle Registration',
            page: const VehicleRegistrationPage(),
          ),
          buildMenuItem(
            icon: Icons.lock_outline,
            title: 'Change password',
            page: const ChangePasswordPage(),
          ),
          buildMenuItem(
            icon: Icons.settings_outlined,
            title: 'Settings',
            page: const SettingsPage(),
          ),
          buildMenuItem(
            icon: Icons.logout,
            title: 'Logout',
            page: const SettingsPage(),
          ),
        ],
      ),
    );
  }

  Widget buildMenuItem({
    required IconData icon,
    required String title,
    required Widget page,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(icon, color: Colors.black, size: 22),
            title: Text(
              title,
              style: const TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w400,
              ),
            ),
            trailing: const Icon(Icons.chevron_right, size: 20),
            onTap: () {
              if (title == 'Logout') {
                // Directly call the logout function from AuthService
                AuthService().logoutUser(context);
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => page),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
