import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderDetailPage extends StatefulWidget {
  final String orderId;
  final double latitude;
  final double longitude;
  final String phoneNumber;

  const OrderDetailPage({
    Key? key,
    required this.orderId,
    required this.latitude,
    required this.longitude,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  late GoogleMapController _mapController;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  Position? _currentPosition;

  // ✅ Replace with your actual API key
  final String _googleApiKey = 'AIzaSyB4CbwMCStsfl9ToPxZTQRSzrx2d4ZIW9U';

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  void _initializeMap() async {
    _setVendorMarker();
    await _getCurrentLocation();
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _setVendorMarker() {
    _markers.add(
      Marker(
        markerId: const MarkerId('vendor'),
        position: LatLng(widget.latitude, widget.longitude),
        infoWindow: const InfoWindow(title: "Vendor Location"),
      ),
    );
  }

  Future<void> _getCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() => _currentPosition = position);

      _mapController.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(position.latitude, position.longitude),
          14,
        ),
      );
    } catch (e) {
      debugPrint("Error fetching location: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to get current location")),
        );
      }
    }
  }

  Future<void> _drawRoute() async {
    if (_currentPosition == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Fetching your location...")),
        );
      }
      return;
    }

    final polylinePoints = PolylinePoints();
    final result = await polylinePoints.getRouteBetweenCoordinates(
      _googleApiKey,
      PointLatLng(_currentPosition!.latitude, _currentPosition!.longitude),
      PointLatLng(widget.latitude, widget.longitude),
    );

    if (result.points.isEmpty) {
      debugPrint('No polyline points found. Error: ${result.errorMessage}');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch directions: ${result.errorMessage}')),
        );
      }
      return;
    }

    final polylineCoords = result.points
        .map((point) => LatLng(point.latitude, point.longitude))
        .toList();

    setState(() {
      _polylines.clear();
      _polylines.add(
        Polyline(
          polylineId: const PolylineId('route'),
          color: Colors.deepPurple,
          width: 5,
          points: polylineCoords,
        ),
      );

      _markers.add(
        Marker(
          markerId: const MarkerId('me'),
          position: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          infoWindow: const InfoWindow(title: "My Location"),
        ),
      );
    });

    _mapController.animateCamera(
      CameraUpdate.newLatLngBounds(
        _boundsFromLatLngList([
          LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          LatLng(widget.latitude, widget.longitude),
        ]),
        80,
      ),
    );
  }

  LatLngBounds _boundsFromLatLngList(List<LatLng> list) {
    final southwestLat = list.map((p) => p.latitude).reduce((a, b) => a < b ? a : b);
    final southwestLng = list.map((p) => p.longitude).reduce((a, b) => a < b ? a : b);
    final northeastLat = list.map((p) => p.latitude).reduce((a, b) => a > b ? a : b);
    final northeastLng = list.map((p) => p.longitude).reduce((a, b) => a > b ? a : b);

    return LatLngBounds(
      southwest: LatLng(southwestLat, southwestLng),
      northeast: LatLng(northeastLat, northeastLng),
    );
  }

  void _launchDialer(String number) async {
    final uri = Uri(scheme: 'tel', path: number);
    try {
      final canLaunchIt = await canLaunchUrl(uri);
      if (canLaunchIt) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch $uri';
      }
    } catch (e) {
      debugPrint("Launch error: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Cannot launch dialer: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final vendorPosition = LatLng(widget.latitude, widget.longitude);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Delivery Map',
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1,
          ),
        ),
        elevation: 6,
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)], // purple to rich blue
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: vendorPosition,
              zoom: 13,
            ),
            markers: _markers,
            polylines: _polylines,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            compassEnabled: true,
            zoomControlsEnabled: false,
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: _buildActionCard(),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(blurRadius: 10, color: Colors.black26)],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Vendor Location",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.directions,color: Colors.white),
                label: const Text("Start", style: TextStyle(fontSize: 16,color: Colors.white)),
                onPressed: _drawRoute,
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.call,color: Colors.white,),
                label: const Text("Call", style: TextStyle(fontSize: 16,color: Colors.white)),
                onPressed: () => _launchDialer(widget.phoneNumber),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
