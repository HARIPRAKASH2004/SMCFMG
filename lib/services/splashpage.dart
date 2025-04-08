import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import '../utils/utils.dart' show handleNotification;
import '../modules/user/rootpage.dart';
import '../modules/admin/root.dart';
import '../modules/common/loginpage.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    initializeEverything();
  }

  Future<void> initializeEverything() async {
    try {
      // Firebase init
      await Firebase.initializeApp();

      // Notification permissions
      await [
        Permission.notification,
        Permission.locationWhenInUse,
      ].request();

      // Setup push notification handlers
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

      // Wait briefly then navigate
      Future.delayed(const Duration(seconds: 2), () => navigate());
    } catch (e) {
      debugPrint('Splash init error: $e');
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
        MaterialPageRoute(builder: (_) => const LoginPage()),
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
