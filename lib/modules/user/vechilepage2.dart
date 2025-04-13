import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart'; // Import provider
import '../../models/vechile.dart';
import '../../models/users.dart'; // Import user model
import '../../providers/user_provider.dart';

class VehicleDetailsFormPage extends StatefulWidget {
  final String selectedVehicle;  // Accept selected vehicle from the previous page

  const VehicleDetailsFormPage({super.key, required this.selectedVehicle});

  @override
  State<VehicleDetailsFormPage> createState() => _VehicleDetailsFormPageState();
}

class _VehicleDetailsFormPageState extends State<VehicleDetailsFormPage> {
  final TextEditingController modelController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController fuelController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  DateTime? manufactureDate;

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<UserProvider>(context).user;

    if (currentUser == null) {
      return Scaffold(
        body: Center(child: Text('No user is logged in.')),
      );
    }

    String userId = currentUser.id;

    Future<void> _selectDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime(2022, 1, 1),
        firstDate: DateTime(1990),
        lastDate: DateTime(2100),
      );
      if (picked != null) {
        setState(() {
          manufactureDate = picked;
          dateController.text = DateFormat('dd-MM-yyyy').format(picked);
        });
      }
    }

    void _handleSave() {
      VehicleModel vehicle = VehicleModel(
        id: null,
        userId: userId,
        vehicleNumber: numberController.text,
        vehicleType: widget.selectedVehicle,  // Use selected vehicle here
        model: modelController.text,
        brand: "Default Brand",
        year: manufactureDate?.year,
        rcBookUrl: null,
        insuranceUrl: null,
        insuranceExpiry: null,
        status: "active",
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Show the saved vehicle details (or send to API)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Saved Vehicle: ${vehicle.toMap()}')),
      );
    }

    const maroon = Color(0xFF800020);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Vehicle Registration"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: Image.asset(
                'assets/images/truck.png',
                height: 150,
                width: 150,
              ),
            ),
            const SizedBox(height: 30),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Vehicle Model', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 6),
            _buildInput(modelController, hint: "Enter Your Vehicle Model"),

            const SizedBox(height: 16),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Registration Number', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 6),
            _buildInput(numberController, hint: "Enter Your Vehicle Number"),

            const SizedBox(height: 16),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Fuel type', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 6),
            _buildInput(fuelController, hint: "Enter Your Fuel Type"),

            const SizedBox(height: 16),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Date of Manufacture', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: dateController,
              readOnly: true,
              onTap: () => _selectDate(context),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFF0F0F0),
                suffixIcon: const Icon(Icons.calendar_today_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: _handleSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: maroon,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text("Save", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildInput(TextEditingController controller, {required String hint}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFF0F0F0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
