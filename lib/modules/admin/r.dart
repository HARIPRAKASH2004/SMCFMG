import 'package:flutter/material.dart';

class PartnersPage extends StatefulWidget {
  @override
  _PartnersPageState createState() => _PartnersPageState();
}

class _PartnersPageState extends State<PartnersPage> {
  final List<Map<String, String>> drivers = [
    {'id': '#D-001', 'name': 'John Driver', 'city': 'Chennai', 'vehicle': 'Truck - TN10 AB1234', 'status': 'Active', 'icon': '🚛'},
    {'id': '#D-002', 'name': 'Arun Kumar', 'city': 'Coimbatore', 'vehicle': 'Van - TN20 XY5678', 'status': 'Active', 'icon': '🚐'},
    {'id': '#D-003', 'name': 'Sara Ali', 'city': 'Madurai', 'vehicle': 'Pickup - KA01 CD4321', 'status': 'Pending', 'icon': '🚙'},
  ];

  List<Map<String, String>> filteredDrivers = [];
  String search = '';
  String selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    filteredDrivers = drivers;
  }

  void filterDrivers(String query) {
    setState(() {
      search = query;
      filteredDrivers = drivers.where((driver) {
        return driver['name']!.toLowerCase().contains(query.toLowerCase()) ||
            driver['city']!.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  void filterByStatus(String status) {
    setState(() {
      selectedFilter = status;
      filteredDrivers = drivers.where((driver) {
        return status == 'All' || driver['status'] == status;
      }).toList();
    });
  }

  Future<void> _refreshDrivers() async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate fetch
    setState(() {
      filteredDrivers = selectedFilter == 'All'
          ? drivers
          : drivers.where((driver) => driver['status'] == selectedFilter).toList();
    });
  }

  void _showDriverDetails(Map<String, String> driver) {
    final TextEditingController reasonController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 4,
                    width: 40,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: Colors.brown.shade100,
                    child: Text(
                      driver['icon'] ?? '👤',
                      style: const TextStyle(fontSize: 32),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    driver['name'] ?? '',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    driver['vehicle'] ?? '',
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  Text(
                    driver['city'] ?? '',
                    style: const TextStyle(fontSize: 14, color: Colors.black45),
                  ),
                  const SizedBox(height: 10),

                  // Status as a pill
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: getStatusColor(driver['status'] ?? ''),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      driver['status'] ?? '',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    driver['id'] ?? '',
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  ),

                  const SizedBox(height: 24),
                  const Divider(thickness: 1.2),
                  const SizedBox(height: 16),

                  // Action buttons
                  Wrap(
                    spacing: 14,
                    runSpacing: 14,
                    alignment: WrapAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.call, size: 20,color: Colors.white,),
                        label: const Text("Call", style: TextStyle(fontSize: 15,color: Colors.white,fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade600,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 2,
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Calling driver...')),
                          );
                        },
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.assignment, size: 20,color: Colors.white,),
                        label: const Text("Assign Order", style: TextStyle(fontSize: 15,color: Colors.white,fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade600,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 2,
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Assigning order...')),
                          );
                        },
                      ),
                      OutlinedButton.icon(
                        icon: const Icon(Icons.block, color: Colors.red, size: 20),
                        label: const Text("Block", style: TextStyle(color: Colors.red, fontSize: 15)),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.red),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                            ),
                            builder: (context) {
                              return Padding(
                                padding: MediaQuery.of(context).viewInsets,
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text(
                                        "Block Driver",
                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 12),
                                      TextField(
                                        controller: reasonController,
                                        decoration: const InputDecoration(
                                          labelText: "Reason for blocking",
                                          border: OutlineInputBorder(),
                                        ),
                                        maxLines: 2,
                                      ),
                                      const SizedBox(height: 14),
                                      ElevatedButton.icon(
                                        icon: const Icon(Icons.block),
                                        label: const Text("Confirm Block"),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          foregroundColor: Colors.white,
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text('Driver blocked: ${reasonController.text}')),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'Active':
        return Colors.green.shade600;
      case 'Pending':
        return Colors.orange.shade600;
      default:
        return Colors.grey.shade600;
    }
  }

  IconData getStatusIcon(String status) {
    switch (status) {
      case 'Active':
        return Icons.check_circle;
      case 'Pending':
        return Icons.hourglass_bottom;
      default:
        return Icons.block;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F2F0),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4F2F0),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Partners',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          _buildSearchBar(),
          const SizedBox(height: 8),
          _buildFilterChips(),
          const SizedBox(height: 10),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshDrivers,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: filteredDrivers.length,
                itemBuilder: (context, index) {
                  return _buildDriverCard(filteredDrivers[index]);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        onChanged: filterDrivers,
        decoration: InputDecoration(
          hintText: 'Search by name or city',
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 12,
        children: ['All', 'Active', 'Pending'].map((status) {
          final isSelected = selectedFilter == status;
          return ChoiceChip(
            label: Text(
              status,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.brown.shade800 : Colors.black87,
              ),
            ),
            selected: isSelected,
            selectedColor: Colors.brown.shade100,
            backgroundColor: Colors.grey.shade200,
            onSelected: (_) => filterByStatus(status),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            elevation: isSelected ? 2 : 0,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDriverCard(Map<String, String> driver) {
    final statusColor = getStatusColor(driver['status']!);
    final statusIcon = getStatusIcon(driver['status']!);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        elevation: 3,
        child: InkWell(
          onTap: () => _showDriverDetails(driver),
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: const Color(0xFFF0F0F0),
                  child: Text(driver['icon'] ?? '👤', style: const TextStyle(fontSize: 24)),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(driver['name'] ?? '', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      Text('${driver['vehicle']} • ${driver['city']}', style: const TextStyle(fontSize: 13.5, color: Colors.grey)),
                      const SizedBox(height: 4),
                      Text(driver['id'] ?? '', style: const TextStyle(fontSize: 12.5, color: Colors.grey)),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Icon(statusIcon, color: statusColor, size: 20),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        driver['status'] ?? '',
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
