import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/auth_services.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool isLoading = true;
  int totalOrders = 0;
  int revenue = 0;
  int activeVendors = 0;
  int deliveryPartners = 0;

  final RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    fetchDashboardData();
  }

  Future<void> fetchDashboardData({bool isRefresh = false}) async {
    final authservice = AuthService();
    final summary = await authservice.fetchDashboardSummary(context);

    if (summary != null) {
      setState(() {
        totalOrders = summary['totalOrders'] ?? 0;
        revenue = summary['revenue'] ?? 0;
        activeVendors = summary['totalVendors'] ?? 0;
        deliveryPartners = summary['totalDeliveryPartners'] ?? 0;
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
    }

    if (isRefresh) _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Dashboard",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        header: const WaterDropHeader(
          waterDropColor: Colors.deepPurple,
          complete:
          Text("Refreshed!", style: TextStyle(color: Colors.black)),
        ),
        onRefresh: () => fetchDashboardData(isRefresh: true),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: SingleChildScrollView(
            child: Column(
              children: [
                DashboardCard(
                  title: 'Total Orders',
                  value: '$totalOrders',
                  icon: Icons.shopping_cart,
                  change: '+0%',
                  changeColor: Colors.green,
                  changeText: 'Since last month',
                  borderColor: Colors.blue,
                ),
                const SizedBox(height: 12),
                DashboardCard(
                  title: 'Revenue',
                  value: '₹$revenue',
                  icon: Icons.currency_rupee,
                  change: '+0%',
                  changeColor: Colors.green,
                  changeText: 'Since last month',
                  borderColor: Colors.green,
                ),
                const SizedBox(height: 12),
                DashboardCard(
                  title: 'Active Vendors',
                  value: '$activeVendors',
                  icon: Icons.storefront,
                  change: '+4%',
                  changeColor: Colors.green,
                  changeText: 'Since last month',
                  borderColor: Colors.orange,
                ),
                const SizedBox(height: 12),
                DashboardCard(
                  title: 'Delivery Partners',
                  value: '$deliveryPartners',
                  icon: Icons.local_shipping,
                  change: '-2%',
                  changeColor: Colors.red,
                  changeText: 'Since last month',
                  borderColor: Colors.red,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final String change;
  final Color changeColor;
  final String changeText;
  final Color borderColor;

  const DashboardCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.change,
    required this.changeColor,
    required this.changeText,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: borderColor, width: 4)),
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: Row(
        children: [
          Icon(icon, size: 40, color: borderColor),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: GoogleFonts.poppins(
                        fontSize: 16, color: Colors.grey)),
                Text(value,
                    style: GoogleFonts.poppins(
                        fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      changeColor == Colors.green
                          ? Icons.arrow_upward
                          : Icons.arrow_downward,
                      size: 16,
                      color: changeColor,
                    ),
                    Text(' $change ',
                        style: GoogleFonts.poppins(color: changeColor)),
                    Text(changeText,
                        style: GoogleFonts.poppins(color: Colors.grey)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
