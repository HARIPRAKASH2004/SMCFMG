import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '/services/auth_services.dart';

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

  bool isEmailValid(String input) {
    return RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(input);
  }
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
    // force account picker every time
    signInOption: SignInOption.standard,
  );

  void _handleGoogleSignIn(BuildContext context) async {
    try {
      // Force account picker
      await _googleSignIn.signOut();

      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account != null) {
        final GoogleSignInAuthentication auth = await account.authentication;
        final idToken = auth.idToken;

        if (idToken != null) {
          // Send ID token to your backend
          await AuthService().loginWithGoogleToken(
            context: context,
            idToken: idToken,
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Unable to retrieve Google ID token')),
          );
        }
      }
    } catch (error) {
      print("Google sign-in error: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to sign in with Google')),
      );
    }
  }
  void _register() async {
    String username = usernameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text;
    String confirmPassword = confirmPasswordController.text;

    if (username.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _showError("All fields are required!");
      return;
    }

    if (!isEmailValid(email)) {
      _showError("Invalid email format!");
      return;
    }

    if (password.length < 6) {
      _showError("Password must be at least 6 characters long!");
      return;
    }

    if (password != confirmPassword) {
      _showError("Passwords do not match!");
      return;
    }

    try {
      await AuthService().signUpUser(
        context: context,
        email: email,
        username: username,
        password: password,
      );
    } catch (e) {
      _showError("Something went wrong. Please try again.");
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
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
              buildHeader(),
              const SizedBox(height: 30),
              buildUsernameField(),
              const SizedBox(height: 20),
              buildEmailField(),
              const SizedBox(height: 20),
              buildPasswordField(),
              const SizedBox(height: 20),
              buildConfirmPasswordField(),
              const SizedBox(height: 28),
              buildCreateAccountButton(),
              const SizedBox(height: 25),
              buildLoginDivider(),
              const SizedBox(height: 14),
              buildGoogleButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Create Account',
          style: TextStyle(fontSize: 19.5, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5),
        Text(
          'Join us and get started!',
          style: TextStyle(fontSize: 12.5, color: Colors.black54),
        ),
      ],
    );
  }

  Widget buildUsernameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Username', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5)),
        const SizedBox(height: 6),
        buildTextField(
          hintText: 'Enter Your Name',
          icon: Icons.person_outline,
          controller: usernameController,
        ),
      ],
    );
  }

  Widget buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Email ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5)),
        const SizedBox(height: 6),
        buildTextField(
          hintText: 'Enter  Your Email ',
          icon: Icons.alternate_email,
          controller: emailController,
        ),
      ],
    );
  }

  Widget buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Create Password', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5)),
        const SizedBox(height: 6),
        buildTextField(
          hintText: 'Enter your password',
          icon: Icons.vpn_key,
          controller: passwordController,
          obscureText: !_isPasswordVisible,
          showVisibilityIcon: true,
          toggleVisibility: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
        ),
      ],
    );
  }

  Widget buildConfirmPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Re-Enter password', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5)),
        const SizedBox(height: 6),
        buildTextField(
          hintText: 'Enter your password',
          icon: Icons.vpn_key,
          controller: confirmPasswordController,
          obscureText: !_isConfirmPasswordVisible,
          showVisibilityIcon: true,
          toggleVisibility: () => setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible),
        ),
      ],
    );
  }

  Widget buildCreateAccountButton() {
    return SizedBox(
      width: double.infinity,
      height: 47,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF800038),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: _register,
        child: const Text(
          'Create Account',
          style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold,color: Colors.white),
        ),
      ),
    );
  }

  Widget buildLoginDivider() {
    return const Center(
      child: Text(
        'Or Login with',
        style: TextStyle(fontSize: 12.5, color: Colors.black),
      ),
    );
  }

  Widget buildGoogleButton(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 46,
      decoration: BoxDecoration(
        color: const Color(0xFFF4F4F4),
        borderRadius: BorderRadius.circular(6),
      ),
      child: TextButton.icon(
        onPressed: () => _handleGoogleSignIn(context),
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
    );
  }

  Widget buildTextField({
    required String hintText,
    required IconData icon,
    required TextEditingController controller,
    bool obscureText = false,
    bool showVisibilityIcon = false,
    VoidCallback? toggleVisibility,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: const Color(0xFFF4F4F4),
        prefixIcon: Icon(icon),
        suffixIcon: showVisibilityIcon
            ? IconButton(
          icon: Icon(
            obscureText ? Icons.visibility_off : Icons.visibility,
            size: 20,
          ),
          onPressed: toggleVisibility,
        )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
