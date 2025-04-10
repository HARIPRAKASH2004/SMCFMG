import 'package:flutter/material.dart';
import '/models/orders.dart';

class OrderDetailPage extends StatelessWidget {
  final OrderModel orderModel;

  const OrderDetailPage({required this.orderModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Order:${orderModel.orderId}")),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Invoice No:${orderModel.orderId}",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text("Date : ${_formatDate(orderModel.createdAt)}"),
              SizedBox(height: 10),
              Text("Invoice From :",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text("VINAYAK MAHADEV : 144 Dubai main road"),
              SizedBox(height: 10),
              Text("Invoice To :", style: TextStyle(fontWeight: FontWeight.bold)),
              Text("${orderModel.driverName} : ${orderModel.deliveryLocation}"),
              SizedBox(height: 20),
              ..._mockProductList(),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) =>
      "${dt.day} ${_month(dt.month)} ${dt.year}";

  String _month(int m) {
    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[m];
  }

  List<Widget> _mockProductList() {
    // Replace this with your real order item list
    List<Map<String, String>> items = [
      {"name": "Detergent products", "desc": "Tide, Rin, Surf Excel"},
      {"name": "Haircare products", "desc": "Shampoo, Oil"},
      {"name": "Body care products", "desc": "Soap, Lotion"},
      {"name": "Personal Care products", "desc": "Toothpaste, Deodorant"},
    ];

    return items
        .map(
          (e) => Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
            border: Border.all(), borderRadius: BorderRadius.circular(8)),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.green, shape: BoxShape.circle),
              child: Text("1", style: TextStyle(color: Colors.white)),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(e['name']!, style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(e['desc']!, maxLines: 2, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        ),
      ),
    )
        .toList();
  }
}
