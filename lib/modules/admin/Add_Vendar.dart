import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../models/Vendor.dart';
import '../../services/auth_services.dart';

 // Update with actual import

class AddVendorPage extends StatefulWidget {
  @override
  _AddVendorPageState createState() => _AddVendorPageState();
}

class _AddVendorPageState extends State<AddVendorPage> {
  final _formKey = GlobalKey<FormState>();

  // Text Controllers
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _productsController = TextEditingController();
  final _companyNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _gstController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _stateController = TextEditingController();
  final _contactPersonController = TextEditingController();
  final _cityController = TextEditingController();

  String _selectedCategory = 'Grocery';
  String _selectedStatus = 'Active';

  final List<String> categories = ['Grocery', 'Restaurant', 'Electronics', 'Home Goods'];
  final List<String> statuses = ['Active', 'Pending', 'Suspended'];

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      final vendor = VendorModel(
        name: _nameController.text.trim(),
        address: _locationController.text.trim(),
        phone: _phoneController.text.trim(),
        companyName: _companyNameController.text.trim(),
        status: _selectedStatus,
        city: _cityController.text.trim(),
        state: _stateController.text.trim(),
        pincode: _pincodeController.text.trim(),
        gstNumber: _gstController.text.trim(),
        contactPerson: _contactPersonController.text.trim(),
        email: _emailController.text.trim(),
        category: _selectedCategory,
        productCount: int.tryParse(_productsController.text.trim()) ?? 0,
      );

      bool? success = await AuthService().submitVendorDetails(context, vendor);

      if (success == true) {
        Navigator.pop(context); // Go back on success
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Vendor', style: GoogleFonts.montserrat(fontWeight: FontWeight.w700)),
        centerTitle: true,
        backgroundColor: const Color(0xff00695C),
        foregroundColor: Colors.white,
        elevation: 5,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 10,
            color: const Color(0xffF7F1E1),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildTextField(_nameController, 'Vendor Name', Icons.store, 'Enter vendor name'),
                    _buildTextField(_companyNameController, 'Company Name', Icons.business, 'Enter company name'),
                    _buildDropdown('Category', Icons.category, _selectedCategory, categories, (val) {
                      setState(() => _selectedCategory = val!);
                    }),
                    _buildTextField(_locationController, 'Address', Icons.location_on, 'Enter address'),
                    _buildTextField(_cityController, 'City', Icons.location_city, 'Enter city'),
                    _buildTextField(_stateController, 'State', Icons.map, 'Enter state'),
                    _buildTextField(_pincodeController, 'Pincode', Icons.pin_drop, 'Enter pincode', TextInputType.number),
                    _buildTextField(_productsController, 'Product Count', Icons.inventory, 'Enter product count', TextInputType.number),
                    _buildTextField(_phoneController, 'Phone', Icons.phone, 'Enter phone number', TextInputType.phone),
                    _buildTextField(_emailController, 'Email', Icons.email, 'Enter email', TextInputType.emailAddress),
                    _buildTextField(_gstController, 'GST Number', Icons.assignment, 'Enter GST number'),
                    _buildTextField(_contactPersonController, 'Contact Person', Icons.person, 'Enter contact person'),
                    _buildDropdown('Status', Icons.check_circle, _selectedStatus, statuses, (val) {
                      setState(() => _selectedStatus = val!);
                    }),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: _submitForm,
                      child: Text('Add Vendor',
                          style: GoogleFonts.montserrat(fontWeight: FontWeight.w600, fontSize: 16, color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff00695C),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller,
      String label,
      IconData icon,
      String hint, [
        TextInputType? keyboardType,
      ]) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: (value) => value!.isEmpty ? 'Please enter $label' : null,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon, color: const Color(0xffFF6F61)),
          labelStyle: GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.w500, color: const Color(0xff2C3E50)),
          hintStyle: GoogleFonts.montserrat(fontSize: 14, color: const Color(0xffB0B0B0)),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildDropdown(
      String label,
      IconData icon,
      String value,
      List<String> items,
      ValueChanged<String?> onChanged,
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: value,
        onChanged: onChanged,
        items: items.map((item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item, style: GoogleFonts.montserrat(fontSize: 16, color: const Color(0xff2C3E50))),
          );
        }).toList(),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: const Color(0xffFF6F61)),
          labelStyle: GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.w500, color: const Color(0xff2C3E50)),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}
