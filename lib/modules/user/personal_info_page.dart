import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';

class PersonalInfoPage extends StatefulWidget {
  const PersonalInfoPage({super.key});

  @override
  State<PersonalInfoPage> createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  bool _obscurePassword = true;
  TextEditingController? _aadhaarController;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<UserProvider>(context, listen: false).user;
    if (user != null) {
      _aadhaarController = TextEditingController(
        text: user.aadhaarNumber ?? '',
      );
    }
  }

  @override
  void dispose() {
    _aadhaarController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Ensure controller is initialized once user is available
    _aadhaarController ??= TextEditingController(text: user.aadhaarNumber ?? '');

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Personal Information",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        leading: const BackButton(),
      ),
      body: SingleChildScrollView( // Make the body scrollable
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 40,
                backgroundColor: const Color(0xFF7B2C3B),
                child: Text(
                  user.name.isNotEmpty ? user.name[0].toUpperCase() : '',
                  style: const TextStyle(color: Colors.white, fontSize: 36),
                ),
              ),
            ),
            const SizedBox(height: 32),

            _buildLabel("Username"),
            _buildDisabledField(
              icon: Icons.person_outline,
              text: user.name,
            ),
            const SizedBox(height: 20),

            _buildLabel("Email"),
            _buildDisabledField(
              icon: Icons.email_outlined,
              text: user.email,
            ),
            const SizedBox(height: 20),

            _buildLabel("Password"),
            _buildDisabledField(
              icon: Icons.lock_outline,
              text: "********",
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),

            _buildLabel("Aadhaar Card"),
            _buildEditableField(
              icon: Icons.credit_card,
              controller: _aadhaarController!,
              hintText: "Enter Aadhaar Number",
            ),
            const SizedBox(height: 60),

            // Save Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Save the Aadhaar number here
                  String aadhaarNumber = _aadhaarController!.text;
                  if (aadhaarNumber.isNotEmpty) {
                    // Save the Aadhaar number logic goes here
                    userProvider.updateAadhaarNumber(aadhaarNumber);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Aadhaar updated successfully")),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please enter a valid Aadhaar number")),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Color(0xFF7B2C3B), // Text color
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 30), // Padding
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Rounded corners
                  ),
                  elevation: 5, // Shadow effect for depth
                  shadowColor: Colors.black.withOpacity(0.3), // Shadow color
                ),
                child: const Text(
                  "Save",
                  style: TextStyle(
                    fontSize: 16, // Font size
                    fontWeight: FontWeight.bold, // Font weight for emphasis
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildDisabledField({
    required IconData icon,
    required String text,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: TextEditingController(text: text),
      enabled: false,
      obscureText: text == "********" && _obscurePassword,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.grey.shade200,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
      ),
    );
  }

  Widget _buildEditableField({
    required IconData icon,
    required TextEditingController controller,
    String? hintText,
  }) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.grey.shade200,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
      ),
    );
  }
}
