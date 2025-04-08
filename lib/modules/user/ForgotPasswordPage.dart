import 'package:flutter/material.dart';
import '/modules/user/VerficationCode.dart'; // Adjust your import path if needed

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController emailController = TextEditingController();

  Widget buildTitleSection() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 12),
        Text(
          'Forget Password',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25.5,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Enter your mail id for authentication',
          style: TextStyle(
            fontSize: 15.5,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  Widget buildInputLabel() {
    return const Text(
      'Email or Phone Number',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 13.5,
      ),
    );
  }

  Widget buildEmailInput() {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: const Color(0xFFF4F4F4),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: CircleAvatar(
              radius: 12,
              backgroundColor: Colors.black,
              child: Icon(Icons.email, size: 14, color: Colors.white),
            ),
          ),
          Expanded(
            child: TextField(
              controller: emailController,
              style: const TextStyle(fontSize: 13.5),
              decoration: const InputDecoration(
                hintText: 'Sample123@gmail.com',
                hintStyle: TextStyle(fontSize: 13),
                border: InputBorder.none,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 10),
            child: Icon(Icons.check_circle, size: 18, color: Colors.green),
          ),
        ],
      ),
    );
  }

  Widget buildSendCodeButton() {
    return SizedBox(
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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const VerificationPage(),
            ),
          );
        },
        child: const Text(
          'Send Code',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
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
              buildTitleSection(),
              const SizedBox(height: 48),
              buildInputLabel(),
              const SizedBox(height: 20),
              buildEmailInput(),
              const SizedBox(height: 40),
              buildSendCodeButton(),
            ],
          ),
        ),
      ),
    );
  }
}
