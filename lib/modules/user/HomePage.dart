import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(9.9252, 78.1198); // Madurai

  bool isOnline = false;

  @override
  void initState() {
    super.initState();
    _requestPermission();
  }

  Future<void> _requestPermission() async {
    await Permission.location.request();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            top: 2,
            child: _buildMap(),
          ),
          // Align(
          //   alignment: Alignment.topCenter,
          //   child: _buildCustomAppBar(),
          // ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _buildBottomContent(),
          ),
        ],
      ),
    );
  }



  Widget _buildMap() {
    return GoogleMap(
      onMapCreated: (controller) => mapController = controller,
      initialCameraPosition: CameraPosition(target: _center, zoom: 12.0),
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      zoomControlsEnabled: false,
    );
  }

  Widget _buildBottomContent() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        boxShadow: [
          BoxShadow(color: Colors.black12, offset: Offset(0, -2), blurRadius: 6)
        ],
      ),
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildProfileSection(),
          const SizedBox(height: 10),
          const Text("Welcome On Board",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 6),
          const Text("Mr. VINAYAK MAHADEV",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const Text("ID : SMG2025", style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 12),
          _buildSafeDriveText(),
          const SizedBox(height: 18),
          _buildGoOnlineButton(),
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        const CircleAvatar(
          radius: 35,
          backgroundColor: Colors.blueAccent,
          child: Icon(Icons.person, size: 40, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildSafeDriveText() {
    return RichText(
      textAlign: TextAlign.center,
      text: const TextSpan(
        style: TextStyle(color: Colors.black, fontSize: 14),
        children: [
          TextSpan(text: 'Have a '),
          TextSpan(
            text: 'SAFE',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          TextSpan(text: ' drive  !!\nCarefully carry your orders 😊'),
        ],
      ),
    );
  }

  Widget _buildGoOnlineButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            isOnline = !isOnline;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isOnline ? Colors.red : Colors.green,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          isOnline ? "Go Offline" : "Go Online",
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
