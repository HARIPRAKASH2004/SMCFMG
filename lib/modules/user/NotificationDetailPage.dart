import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/models/orders.dart';
import 'package:intl/intl.dart';

class NotificationDetailPage extends StatelessWidget {
  final OrderModel order;

  const NotificationDetailPage({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vendor = order.vendor;
    final location = order.location;
    final createdAt = DateFormat('yyyy-MM-dd hh:mm a').format(order.createdAt);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Notification Details",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white), // Define back button color here
          onPressed: () {
            Navigator.pop(context); // Back button action
          },
        ),
      ),
        body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCard(context, Icons.store, "Vendor Name", vendor.name),
            _buildCard(context, Icons.business, "Company", vendor.companyName),
            _buildCard(context, Icons.phone, "Phone", vendor.phone),
            _buildCard(context, Icons.email, "Email", vendor.email),
            _buildCard(context, Icons.location_city, "Vendor Address", vendor.address),
            _buildCard(context, Icons.receipt_long, "GST Number", vendor.gstNumber),
            _buildCard(context, Icons.tag, "Order ID", order.orderId),
            _buildCard(context, Icons.sync, "Status", order.status),
            _buildCard(context, Icons.category, "Goods Type", order.goodsType),
            _buildCard(context, Icons.monetization_on, "Fare", "₹${order.fare}"),
            _buildCard(context, Icons.location_on, "Pickup Location", order.pickupLocation.isNotEmpty ? order.pickupLocation : "N/A"),
            _buildCard(context, Icons.location_pin, "Delivery Location", order.deliveryLocation.isNotEmpty ? order.deliveryLocation : "N/A"),
            _buildCard(context, Icons.straighten, "Distance (Km)", order.distanceInKm.toStringAsFixed(2)),
            _buildCard(context, Icons.scale, "Load Weight (Tons)", order.loadWeightInTons.toStringAsFixed(2)),
            _buildCard(context, Icons.map, "Coordinates", "${location.latitude}, ${location.longitude}"),
            _buildCard(context, Icons.access_time, "Created At", createdAt),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, IconData icon, String title, String value) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.deepPurple.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.deepPurple),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}