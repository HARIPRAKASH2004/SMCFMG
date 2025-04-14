import 'package:flutter/material.dart';


class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard")),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: SingleChildScrollView(
          child: Column(
            children: [
              DashboardCard(
                title: 'Total Orders',
                value: '245',
                icon: Icons.shopping_cart,
                change: '+12%',
                changeColor: Colors.green,
                changeText: 'Since last month',
                borderColor: Colors.blue,
              ),
              const SizedBox(height: 12),
              DashboardCard(
                title: 'Revenue',
                value: '₹8,52,548',
                icon: Icons.currency_rupee,
                change: '+8%',
                changeColor: Colors.green,
                changeText: 'Since last month',
                borderColor: Colors.green,
              ),
              const SizedBox(height: 12),
              DashboardCard(
                title: 'Active Vendors',
                value: '32',
                icon: Icons.storefront,
                change: '+4%',
                changeColor: Colors.green,
                changeText: 'Since last month',
                borderColor: Colors.orange,
              ),
              const SizedBox(height: 12),
              DashboardCard(
                title: 'Delivery Partners',
                value: '18',
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
        border: Border(
          left: BorderSide(color: borderColor, width: 4),
        ),
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
                    style: const TextStyle(fontSize: 16, color: Colors.grey)),
                Text(value,
                    style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
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
                    Text(
                      ' $change ',
                      style: TextStyle(color: changeColor),
                    ),
                    Text(changeText, style: const TextStyle(color: Colors.grey)),
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
