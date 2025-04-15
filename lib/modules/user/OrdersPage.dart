import 'package:flutter/material.dart';
import '../../services/auth_services.dart';
import '../../utils/snackbar_util.dart';
import '/models/orders.dart';

class OrderPage extends StatefulWidget {
  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  List<OrderModel> orders = [];
  String search = "";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    try {
      final authservices = AuthService();
      final fetchedOrders = await authservices.fetchOrders(context);
      setState(() {
        orders = fetchedOrders;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showSnackBar(context, "Failed to load orders.");
      print("Error fetching orders: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredOrders = orders
        .where((order) => order.driverName.toLowerCase().contains(search.toLowerCase()))
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
          return Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBalanceRow(),
                SizedBox(height: 15),
                _buildSearchBox(),
                SizedBox(height: 10),
                _buildTableHeadings(),
                SizedBox(height: 10),
                Expanded(
                  child: isLoading
                      ? Center(child: CircularProgressIndicator())
                      : filteredOrders.isEmpty
                      ? _buildEmptyState()
                      : _buildOrderList(filteredOrders),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBalanceRow() {
    return Row(
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
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        ])),
      ],
    );
  }

  Widget _buildSearchBox() {
    return Container(
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
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14)),
      ),
    );
  }

  Widget _buildTableHeadings() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("All Orders", style: TextStyle(fontWeight: FontWeight.bold)),
        Text("Date", style: TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/corrugated-box.png', height: 190),
          SizedBox(height: 10),
          Text("No Orders Yet!",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          SizedBox(height: 5),
          Text("Start your work with us and place your first order"),
        ],
      ),
    );
  }

  Widget _buildOrderList(List<OrderModel> orders) {
    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        final date = order.createdAt; // Assumes createdAt is a DateTime

        return Card(
          margin: EdgeInsets.symmetric(vertical: 6),
          child: ListTile(
            contentPadding: EdgeInsets.all(12),
            title: Text(order.driverName, style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 4),
                Text("Order ID: ${order.orderId}"),
              ],
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${date.day} ${_month(date.month)}",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text("${date.year}", style: TextStyle(fontSize: 12)),
              ],
            ),
          ),
        );
      },
    );
  }

  String _month(int m) {
    const months = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[m];
  }
}
