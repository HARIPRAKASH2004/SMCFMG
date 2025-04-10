import 'package:flutter/material.dart';
import 'order_details_page.dart';
import '/models/orders.dart';

class OrderPage extends StatefulWidget {
  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  List<OrderModel> orders = []; // Replace with your real data source
  String search = "";

  @override
  Widget build(BuildContext context) {
    final filteredOrders = orders
        .where((order) =>
        order.driverName.toLowerCase().contains(search.toLowerCase()))
        .toList();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Order History",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(12),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Balance & Total Earned
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text.rich(TextSpan(children: [
                          TextSpan(text: "Balance\n"),
                          TextSpan(
                              text: "00.00",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18)),
                        ])),
                        Text.rich(TextSpan(children: [
                          TextSpan(text: "Total Earned\n"),
                          TextSpan(
                              text: "00.00",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18)),
                        ])),
                      ],
                    ),
                    SizedBox(height: 15),
                    // Search box
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(10)),
                      child: TextField(
                        onChanged: (value) {
                          setState(() => search = value);
                        },
                        decoration: InputDecoration(
                            hintText: "Search here",
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 14)),
                      ),
                    ),
                    SizedBox(height: 10),
                    // Table headings
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("All Orders",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text("Date",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    SizedBox(height: 10),
                    // Orders List or Empty Box
                    Expanded(
                      child: filteredOrders.isEmpty
                          ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('assets/images/corrugated-box.png',
                                height: 190),
                            SizedBox(height: 10),
                            Text("No Orders Yet !",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18)),
                            SizedBox(height: 5),
                            Text("Start your work with us and place your first order")
                          ],
                        ),
                      )
                          : ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: filteredOrders.length,
                        itemBuilder: (context, index) {
                          final order = filteredOrders[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => OrderDetailPage(
                                        orderModel: order),
                                  ));
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 6),
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(order.driverName,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        Text("Invoice No:${order.orderId}",
                                            style: TextStyle(fontSize: 12)),
                                      ]),
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.end,
                                    children: [
                                      Text("₹${order.fare.toStringAsFixed(0)}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red)),
                                      Text(
                                        "${order.createdAt.day} ${_month(order.createdAt.month)},${order.createdAt.year}",
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

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
}
