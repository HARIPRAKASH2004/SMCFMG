import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '/services/auth_services.dart'; // Adjust the path as needed
import '../providers/user_provider.dart';
import '../utils/utils.dart' show handleNotification, showSnackBar;
import '../utils/api_handler.dart'; // Make sure getUserData is here
import '../modules/user/rootpage.dart';
import '../modules/admin/root.dart';
import '../modules/common/startpage.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    initializeEverything();
  }

  Future<void> initializeEverything() async {
    try {
      await Firebase.initializeApp();

      await [
        Permission.notification,
        Permission.locationWhenInUse,
      ].request();

      FirebaseMessaging.onMessage.listen((message) async {
        await handleNotification(message);
      });

      FirebaseMessaging.onMessageOpenedApp.listen((message) async {
        if (message.data['plan'] == null) {
          await handleNotification(message);
        }
      });

      FirebaseMessaging.instance.getInitialMessage().then((message) async {
        if (message != null && message.data['plan'] == null) {
          await handleNotification(message);
        }
      });

      // ✅ Wait for user data to load before navigating
      final authService = AuthService();
      final success = await authService.getUserData(context);

      if (success == true) {
        navigate();
      } else {
        // Invalid session or error - go to welcome screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const Welcome1Screen()),
        );
      }
    } catch (e) {
      debugPrint('Splash init error: $e');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Welcome1Screen()),
      );
    }
  }

  void navigate() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    if (userProvider.isDriver) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const UserPage()),
      );
    } else if (userProvider.isAdmin) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AdminPage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Welcome1Screen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
