import 'package:flutter/material.dart';


class VehicleRegistrationPage extends StatelessWidget {
  const VehicleRegistrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehicle Registration'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: const Center(
        child: Text('Vehicle Registration Page'),
      ),
    );
  }
}
