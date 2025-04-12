import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class NoInternetPage extends StatefulWidget {
  const NoInternetPage({super.key});

  @override
  State<NoInternetPage> createState() => _NoInternetPageState();
}

class _NoInternetPageState extends State<NoInternetPage> {
  final Connectivity _connectivity = Connectivity();

  // ✅ Updated for connectivity_plus 6.0.3
  late StreamSubscription<List<ConnectivityResult>> _subscription;

  bool _isConnected = true;

  @override
  void initState() {
    super.initState();
    _checkInitialConnection();
    _subscription = _connectivity.onConnectivityChanged.listen((results) {
      // ✅ Check if any result is mobile or wifi
      final connected = results.contains(ConnectivityResult.mobile) ||
          results.contains(ConnectivityResult.wifi);

      setState(() {
        _isConnected = connected;
      });

      if (_isConnected) {
        Navigator.of(context).maybePop();
      }
    });
  }

  Future<void> _checkInitialConnection() async {
    final result = await _connectivity.checkConnectivity();
    final connected = result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi;

    setState(() {
      _isConnected = connected;
    });

    if (_isConnected) {
      Navigator.of(context).maybePop();
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.wifi_off, color: Colors.redAccent, size: 80),
                const SizedBox(height: 20),
                const Text(
                  'No Internet Connection',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Please check your internet settings and try again.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: _checkInitialConnection,
                  icon: const Icon(Icons.refresh),
                  label: const Text(
                    'Retry',
                    style: TextStyle(fontSize: 16),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
