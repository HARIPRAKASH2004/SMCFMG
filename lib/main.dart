import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:loading_overlay/loading_overlay.dart';

import 'providers/user_provider.dart';
import 'services/splashpage.dart';
import 'modules/common/NoInternetPage.dart'; // <-- Import your NoInternetPage file

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoading = false;
  final Connectivity _connectivity = Connectivity();

  @override
  void initState() {
    super.initState();
    _listenToConnectivity();
  }

  void _listenToConnectivity() {
    _connectivity.onConnectivityChanged.listen((result) {
      final isOffline = result == ConnectivityResult.none;

      if (isOffline) {
        final currentRoute = ModalRoute.of(context)?.settings.name;
        if (currentRoute != '/no-internet') {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const NoInternetPage(),
              settings: const RouteSettings(name: '/no-internet'),
            ),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserProvider(),
      child: MaterialApp(
        title: 'Zomato App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.redAccent),
          scaffoldBackgroundColor: Colors.grey[50],
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0.5,
            centerTitle: true,
          ),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            selectedItemColor: Colors.redAccent,
            unselectedItemColor: Colors.grey[600],
            backgroundColor: Colors.white,
            elevation: 10,
          ),
        ),
        home: LoadingOverlay(
          isLoading: _isLoading,
          opacity: 0.6,
          progressIndicator: const CircularProgressIndicator(),
          child: const SplashPage(),
        ),
      ),
    );
  }
}
