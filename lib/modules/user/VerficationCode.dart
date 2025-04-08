import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({super.key});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final TextEditingController otpController = TextEditingController();

  Widget buildHeader() {
    return const Column(
      children: [
        Text(
          'Verification',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 25),
        CircleAvatar(
          radius: 35,
          backgroundColor: Color(0xFF800038),
          child: Icon(Icons.mark_email_read_outlined,
              color: Colors.white, size: 35),
        ),
        SizedBox(height: 25),
        Text(
          'Verification Code',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        SizedBox(height: 5),
        Text(
          'Enter the code sent to your registered email',
          style: TextStyle(fontSize: 12.5, color: Colors.black87),
        ),
        SizedBox(height: 3),
        Text(
          'sample123@gmail.com',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget buildOtpField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: PinCodeTextField(
        appContext: context,
        length: 6,
        controller: otpController,
        autoDisposeControllers: false,
        animationType: AnimationType.none,
        enableActiveFill: true,
        keyboardType: TextInputType.number,
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(6),
          fieldHeight: 50,
          fieldWidth: 40,
          inactiveColor: Colors.grey.shade300,
          selectedColor: Colors.grey.shade600,
          activeFillColor: Colors.grey.shade300,
          inactiveFillColor: Colors.grey.shade300,
          selectedFillColor: Colors.grey.shade300,
          activeColor: Colors.grey.shade300,
        ),
        onChanged: (value) {},
      ),
    );
  }

  Widget buildVerifyButton() {
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
          // TODO: handle verify
        },
        child: const Text(
          'Verify',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget buildResendText() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Didn't get the code? ",
          style: TextStyle(
            fontSize: 12,
            color: Colors.black54,
          ),
        ),
        Text(
          "Resend",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Color(0xFF800038),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              buildHeader(),
              const SizedBox(height: 35),
              buildOtpField(),
              const SizedBox(height: 35),
              buildVerifyButton(),
              const SizedBox(height: 25),
              buildResendText(),
            ],
          ),
        ),
      ),
    );
  }
}
