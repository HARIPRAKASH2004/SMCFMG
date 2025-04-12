import 'package:flutter/material.dart';
import 'loginpage.dart';

class Welcome1Screen extends StatefulWidget {
  const Welcome1Screen({super.key});

  @override
  State<Welcome1Screen> createState() => _Welcome1ScreenState();
}

class _Welcome1ScreenState extends State<Welcome1Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Top circular background
          Positioned(
            top: -200,
            left: -120,
            child: Container(
              width: 430,
              height: 680,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFF7ECEE),
              ),
            ),
          ),
          Column(
            children: [
              const SizedBox(height: 90),

              // Bus image
              SizedBox(
                width: 320, // Set your desired width here
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/lory__logo.png',
                      height: 110,
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Solamalai\nGroup',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),


              const Spacer(),

              // Welcome message
              const Text(
                'Welcome',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: const Text(
                  'It’s a pleasure to meet you. We are excited that you’re here so let’s get started!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                    height: 1.5,
                  ),
                ),
              ),

              const SizedBox(height: 42),

              // Get Started Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF821D3C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'GET STARTED',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 60),
            ],
          ),
        ],
      ),
    );
  }
}
