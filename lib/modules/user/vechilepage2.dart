import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/vechile.dart';
import '../../providers/user_provider.dart';
import '../../services/auth_services.dart';

class VehicleDetailsFormPage extends StatefulWidget {
  final String selectedVehicle;

  const VehicleDetailsFormPage({super.key, required this.selectedVehicle});

  @override
  State<VehicleDetailsFormPage> createState() => _VehicleDetailsFormPageState();
}

class _VehicleDetailsFormPageState extends State<VehicleDetailsFormPage> {
  final TextEditingController modelController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController fuelController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController brandController = TextEditingController();

  DateTime? manufactureDate;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentUser = Provider.of<UserProvider>(context, listen: false).user;
      if (currentUser != null) {
        final vehicle = currentUser.vehicles?.firstWhere(
              (v) => v.vehicleType == widget.selectedVehicle,
          // orElse: () => null,
        );
        _populateFields(vehicle);
      }
    });
  }

  @override
  void dispose() {
    modelController.dispose();
    numberController.dispose();
    fuelController.dispose();
    dateController.dispose();
    brandController.dispose();
    super.dispose();
  }

  void _populateFields(VehicleModel? vehicle) {
    if (vehicle != null) {
      modelController.text = vehicle.model ?? "";
      numberController.text = vehicle.vehicleNumber ?? "";
      fuelController.text = vehicle.fuelType ?? "";
      brandController.text = vehicle.brand ?? "";
      if (vehicle.manufactureDate != null) {
        manufactureDate = vehicle.manufactureDate!;
        dateController.text = DateFormat('dd-MM-yyyy').format(manufactureDate!);
      }
    }
  }

  void _handleSave(String userId) async {
    if (modelController.text.isEmpty ||
        numberController.text.isEmpty ||
        fuelController.text.isEmpty ||
        manufactureDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all the required fields.')),
      );
      return;
    }

    VehicleModel vehicle = VehicleModel(
      userId: userId,
      vehicleNumber: numberController.text.trim(),
      vehicleType: widget.selectedVehicle,
      model: modelController.text.trim(),
      brand: brandController.text.trim().isNotEmpty
          ? brandController.text.trim()
          : "Default Brand",
      fuelType: fuelController.text.trim(),
      year: manufactureDate?.year,
      rcBookUrl: null,
      insuranceUrl: null,
      insuranceExpiry: null,
      status: "active",
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final success = await AuthService().registerVehicle(context, vehicle);

    if (success == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vehicle registered successfully!')),
      );
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.addVehicle(vehicle);

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to register vehicle.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<UserProvider>(context).user;

    if (currentUser == null) {
      return const Scaffold(
        body: Center(child: Text('No user is logged in.')),
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
            _label('Vehicle Model'),
            _buildInput(modelController, hint: "Enter Vehicle Model"),
            const SizedBox(height: 16),
            _label('Registration Number'),
            _buildInput(numberController, hint: "Enter Vehicle Number"),
            const SizedBox(height: 16),
            _label('Fuel Type'),
            _buildInput(fuelController, hint: "Enter Fuel Type"),
            const SizedBox(height: 16),
            _label('Brand (Optional)'),
            _buildInput(brandController, hint: "Enter Brand Name"),
            const SizedBox(height: 16),
            _label('Date of Manufacture'),
            TextField(
              controller: dateController,
              readOnly: true,
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: manufactureDate ?? DateTime.now(),
                  firstDate: DateTime(1990),
                  lastDate: DateTime(2100),
                );

                if (picked != null && picked != manufactureDate) {
                  setState(() {
                    manufactureDate = picked;
                    dateController.text = DateFormat('dd-MM-yyyy').format(picked);
                  });
                }
              },
              decoration: InputDecoration(
                hintText: "Select Date",
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => _handleSave(currentUser.id),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: maroon,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 5,
                    shadowColor: Colors.black.withOpacity(0.2),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    minimumSize: const Size(150, 50),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.save, size: 20, color: Colors.white),
                      SizedBox(width: 8),
                      Text('Save', style: TextStyle(fontSize: 16, color: Colors.white)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
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

  Widget _label(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }
}
