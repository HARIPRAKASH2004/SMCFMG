import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  Widget buildTextField({
    required String hintText,
    required IconData icon,
    required TextEditingController controller,
    bool obscureText = false,
    VoidCallback? toggleVisibility,
    bool showVisibilityIcon = false,
  }) {
    return Container(
      height: 45,
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black45),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Icon(icon, size: 20),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: obscureText,
              style: const TextStyle(fontSize: 13.5),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: const TextStyle(fontSize: 13),
                border: InputBorder.none,
              ),
            ),
          ),
          if (showVisibilityIcon)
            IconButton(
              icon: Icon(
                obscureText ? Icons.visibility_off : Icons.visibility,
                size: 20,
                color: Colors.black54,
              ),
              onPressed: toggleVisibility,
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Create Account',
                style: TextStyle(
                  fontSize: 29.5,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Join us and get started!',
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ),
              const SizedBox(height: 30),

              const Text(
                'Username',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
              ),
              const SizedBox(height: 6),
              buildTextField(
                hintText: 'USER NAME',
                icon: Icons.person,
                controller: usernameController,
              ),

              const Text(
                'Email or Phone Number',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
              ),
              const SizedBox(height: 6),
              buildTextField(
                hintText: 'Enter Email or Phone Number',
                icon: Icons.email_outlined,
                controller: emailController,
              ),

              const Text(
                'Create Password',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
              ),
              const SizedBox(height: 6),
              buildTextField(
                hintText: 'Enter your password',
                icon: Icons.vpn_key,
                controller: passwordController,
                obscureText: !_isPasswordVisible,
                showVisibilityIcon: true,
                toggleVisibility: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              ),

              const Text(
                'Re-Enter password',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
              ),
              const SizedBox(height: 6),
              buildTextField(
                hintText: 'Enter your password',
                icon: Icons.vpn_key,
                controller: confirmPasswordController,
                obscureText: !_isConfirmPasswordVisible,
                showVisibilityIcon: true,
                toggleVisibility: () {
                  setState(() {
                    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                  });
                },
              ),

              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF800038),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    // You can now access:
                    // usernameController.text.trim()
                    // emailController.text.trim()
                    // passwordController.text
                    // confirmPasswordController.text
                  },
                  child: const Text(
                    'Create Account',
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 18),
              const Center(
                child: Text(
                  'Or Login with',
                  style: TextStyle(fontSize: 13, color: Colors.black),
                ),
              ),
              const SizedBox(height: 14),

              Container(
                width: double.infinity,
                height: 45,
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F4F4),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: TextButton.icon(
                  onPressed: () {
                    // Google sign-in logic here
                  },
                  icon: Image.asset(
                    'assets/images/google.png',
                    width: 20,
                    height: 20,
                  ),
                  label: const Text(
                    'Sign in with Google',
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
