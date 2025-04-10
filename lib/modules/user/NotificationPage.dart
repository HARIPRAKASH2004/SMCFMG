import 'package:flutter/material.dart';
import '/models/notification_model.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<FcmLogModel> notifications = [
      FcmLogModel(
        title: "New Order !",
        body: "You have canceled an order at",
        time: "06 Jul,2025 |20:40 pm",
      ),
      FcmLogModel(
        title: "Delivery Successful !",
        body: "You have canceled an order at",
        time: "06 Jul,2025 |20:40 pm",
      ),
      FcmLogModel(
        title: "Delivery Successful !",
        body: "You have canceled an order at",
        time: "06 Jul,2025 |20:40 pm",
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Notification", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          children: [
            const SizedBox(height: 12),
            const Text("Recent", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text(
              "check ...",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
                color: Colors.black45,
              ),
            ),
            const SizedBox(height: 16),
            ...notifications.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return _notificationItem(item, isNew: index == 0);
            }),
          ],
        ),
      ),
    );
  }

  Widget _notificationItem(FcmLogModel data, {bool isNew = false}) {
    IconData icon = data.title.toLowerCase().contains("new") ? Icons.shopping_cart : Icons.check_circle;
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey.shade300,
            child: Icon(icon, color: Colors.black),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        data.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    if (isNew)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Color(0xFF6A1B9A),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          "New",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  data.time,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  data.body,
                  style: const TextStyle(
                    fontSize: 13,
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
