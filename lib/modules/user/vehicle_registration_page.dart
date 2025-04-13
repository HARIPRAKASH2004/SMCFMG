import 'package:flutter/material.dart';
import 'package:track/modules/user/vechilepage2.dart';
 // Adjust the import path if necessary

class VehicleRegistrationPage extends StatefulWidget {
  const VehicleRegistrationPage({super.key});

  @override
  State<VehicleRegistrationPage> createState() => _VehicleRegistrationPageState();
}

class _VehicleRegistrationPageState extends State<VehicleRegistrationPage> {
  String selectedVehicle = 'Truck';  // Initially selected vehicle

  void _showVehicleSelectionSheet() {
    final vehicleList = ['Truck', 'Van', 'Mini Truck', 'Pickup', 'Lorry'];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Select Vehicle Type',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              ...vehicleList.map(
                    (vehicle) => ListTile(
                  title: Text(vehicle),
                  onTap: () {
                    setState(() {
                      selectedVehicle = vehicle;
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Vehicle Registration"),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          const SizedBox(height: 30),
          Center(
            child: Image.asset(
              'assets/images/truck.png', // Make sure this path is correct
              height: 150,
              width: 150,
            ),
          ),
          const SizedBox(height: 30),
          const Text(
            'Vehicle Registration',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: Text(
              'Submit your Vehicle Registration details\nto ensure and access essential services\nrelated to your vehicle.',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 30),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.local_shipping),
            title: Text(selectedVehicle),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: _showVehicleSelectionSheet,
          ),
          const Divider(height: 1),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VehicleDetailsFormPage(
                        selectedVehicle: selectedVehicle, // Pass selected vehicle here
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }
}
