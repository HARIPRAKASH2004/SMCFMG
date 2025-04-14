import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

void main() => runApp(MaterialApp(home: VendorPage(), debugShowCheckedModeBanner: false));

class VendorPage extends StatefulWidget {
  @override
  State<VendorPage> createState() => _VendorPageState();
}

class _VendorPageState extends State<VendorPage> {
  final List<Map<String, dynamic>> allVendors = [
    {
      'id': '#V-001',
      'name': 'Chennai Fresh Market',
      'category': 'Grocery',
      'location': 'Chennai',
      'products': 124,
      'status': 'Active'
    },
    {
      'id': '#V-002',
      'name': 'Tamil Tasty Foods',
      'category': 'Restaurant',
      'location': 'Coimbatore',
      'products': 87,
      'status': 'Active'
    },
    {
      'id': '#V-003',
      'name': 'Chettinad Corner',
      'category': 'Restaurant',
      'location': 'Madurai',
      'products': 45,
      'status': 'Pending'
    },
    {
      'id': '#V-004',
      'name': 'Madurai Electronics',
      'category': 'Electronics',
      'location': 'Madurai',
      'products': 89,
      'status': 'Active'
    },
    {
      'id': '#V-005',
      'name': 'Coimbatore Home Needs',
      'category': 'Home Goods',
      'location': 'Coimbatore',
      'products': 156,
      'status': 'Suspended'
    },
  ];

  List<Map<String, dynamic>> filteredVendors = [];
  String search = '';
  String selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    filteredVendors = allVendors;
  }

  void filterVendors(String query) {
    setState(() {
      search = query;
      filteredVendors = allVendors.where((vendor) {
        final matchesSearch = vendor['name'].toLowerCase().contains(query.toLowerCase());
        final matchesCategory = selectedCategory == 'All' || vendor['category'] == selectedCategory;
        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  void filterByCategory(String category) {
    setState(() {
      selectedCategory = category;
      filterVendors(search);
    });
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'Active':
        return Colors.green;
      case 'Pending':
        return Colors.orange;
      case 'Suspended':
        return Colors.redAccent;
      default:
        return Colors.grey;
    }
  }

  String getActionText(String status) {
    switch (status) {
      case 'Active':
        return 'Suspend';
      case 'Pending':
        return 'Approve';
      case 'Suspended':
        return 'Activate';
      default:
        return '';
    }
  }

  IconData getCategoryIcon(String category) {
    switch (category) {
      case 'Grocery':
        return Icons.local_grocery_store;
      case 'Restaurant':
        return Icons.restaurant;
      case 'Electronics':
        return Icons.electrical_services;
      case 'Home Goods':
        return Icons.chair;
      default:
        return Icons.store;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff0f2f5),
      appBar: AppBar(
        title: Text('Vendors', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 3,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              onChanged: filterVendors,
              decoration: InputDecoration(
                hintText: 'Search vendors...',
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.all(14),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: ['All', 'Grocery', 'Restaurant', 'Electronics', 'Home Goods']
                  .map((category) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(category),
                  selected: selectedCategory == category,
                  onSelected: (_) => filterByCategory(category),
                  selectedColor: Colors.blueAccent.withOpacity(0.2),
                  backgroundColor: Colors.grey[200],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
              ))
                  .toList(),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: filteredVendors.length,
              itemBuilder: (context, index) {
                final vendor = filteredVendors[index];
                final statusColor = getStatusColor(vendor['status']);
                final actionText = getActionText(vendor['status']);
                final icon = getCategoryIcon(vendor['category']);

                return Slidable(
                  key: ValueKey(vendor['id']),
                  endActionPane: ActionPane(
                    motion: ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (_) {},
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        icon: Icons.edit,
                        label: 'Edit',
                      ),
                      SlidableAction(
                        onPressed: (_) {},
                        backgroundColor: statusColor,
                        foregroundColor: Colors.white,
                        icon: Icons.block,
                        label: actionText,
                      ),
                    ],
                  ),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    margin: EdgeInsets.only(bottom: 14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 12,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                        child: Container(
                          color: Colors.white.withOpacity(0.85),
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 22,
                                    backgroundColor: statusColor.withOpacity(0.2),
                                    child: Icon(icon, color: statusColor, size: 22),
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      vendor['name'],
                                      style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: statusColor,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      vendor['status'],
                                      style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Text(vendor['id'], style: TextStyle(color: Colors.grey[700])),
                              Text('${vendor['category']} • ${vendor['location']}'),
                              Text('Products: ${vendor['products']}'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
