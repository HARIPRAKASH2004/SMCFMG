import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../providers/user_provider.dart';
import '../../services/auth_services.dart';
import '../../utils/snackbar_util.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late GoogleMapController mapController;

  @override
  void initState() {
    super.initState();
    _requestPermission();
  }

  Future<void> _requestPermission() async {
    final status = await Permission.location.request();
    if (status.isDenied) {
      // You can handle the denied permission here if needed
      showSnackBar(context, "Location permission is denied.");
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
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

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            top: 2,
            child: _buildMap(
              user.latitude != 0.0 ? user.latitude : 9.9252,
              user.longitude != 0.0 ? user.longitude : 78.1198,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _buildBottomContent(userProvider, context),
          ),
        ],
      ),
    );
  }

  Widget _buildMap(double lat, double lng) {
    // Default to Madurai if coordinates are invalid
    final LatLng target = (lat != 0.0 && lng != 0.0)
        ? LatLng(lat, lng)
        : const LatLng(9.9252, 78.1198); // Madurai coordinates

    // Add a marker for Madurai
    // final Marker maduraiMarker = Marker(
    //   markerId: MarkerId('madurai'),
    //   position: target,
    //   infoWindow: InfoWindow(title: 'Madurai'), // This adds the label to the marker
    // );

    return GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: target,
        zoom: 12, // Adjusted zoom level for a broader view
      ),
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      zoomControlsEnabled: false,
      compassEnabled: true,
      mapToolbarEnabled: false,
      // markers: {maduraiMarker}, // Add the Madurai marker to the map
    );
  }



  Widget _buildBottomContent(UserProvider userProvider, BuildContext context) {
    final user = userProvider.user!;
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
          _buildProfileSection(user.profileImageUrl),
          const SizedBox(height: 10),
          const Text(
            "Welcome On Board",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 6),
          Text(
            "Mr. ${user.name}",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text("ID : ${user.id}", style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 12),
          _buildSafeDriveText(),
          const SizedBox(height: 18),
          _buildGoOnlineButton(userProvider, context)
        ],
      ),
    );
  }


  Widget _buildProfileSection(String? imageUrl) {
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        CircleAvatar(
          radius: 35,
          backgroundColor: Colors.blueAccent,
          backgroundImage: imageUrl != null ? NetworkImage(imageUrl) : null,
          child: imageUrl == null
              ? const Icon(Icons.person, size: 40, color: Colors.white)
              : null,
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

  Widget _buildGoOnlineButton(UserProvider userProvider, BuildContext context) {
    final user = userProvider.user!;
    final isOnline = user.isOnline;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          final authService = AuthService();
          final success = await authService.updateOnlineStatus(context, !isOnline);

          // ❌ No need to update provider here — it’s handled inside AuthService
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
