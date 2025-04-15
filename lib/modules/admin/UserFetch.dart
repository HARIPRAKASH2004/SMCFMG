import 'package:flutter/material.dart';
import '/services/auth_services.dart';
import 'Assign_patner.dart'; // Replace with actual path

class PartnersPage extends StatefulWidget {
  @override
  _PartnersPageState createState() => _PartnersPageState();
}

class _PartnersPageState extends State<PartnersPage> {
  final List<Map<String, String>> drivers = [];
  List<Map<String, String>> filteredDrivers = [];
  bool isLoading = false;
  String search = '';
  String selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    fetchDriversFromBackend();
  }


  Future<void> fetchDriversFromBackend() async {
    try {
      setState(() {
        isLoading = true; // Start loading
      });

      final fetchedDrivers = await AuthService().fetchDrivers(context); // Make API call

      drivers.clear();
      for (var driver in fetchedDrivers) {
        final firstVehicle = (driver.vehicles != null && driver.vehicles!.isNotEmpty)
            ? driver.vehicles!.first
            : null;

        drivers.add({
          'id': driver.id ?? '',
          'name': driver.name ?? '',
          'city': driver.city ?? '',
          'vehicle': firstVehicle != null
              ? '${firstVehicle.vehicleType ?? ''} - ${firstVehicle.vehicleNumber ?? ''}'
              : 'No Vehicle',
          'status': driver.status ?? 'Pending',
          'icon': '🚚',
        });
      }

      setState(() {
        filteredDrivers = selectedFilter == 'All'
            ? drivers
            : drivers.where((d) => d['status'] == selectedFilter).toList();
      });
    } catch (e) {
      debugPrint("Error fetching drivers: $e");
      // Optionally showSnackBar here
    } finally {
      setState(() {
        isLoading = false; // End loading
      });
    }
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
        final matchesStatus = status == 'All' || driver['status'] == status;
        final matchesSearch = driver['name']!.toLowerCase().contains(search.toLowerCase()) ||
            driver['city']!.toLowerCase().contains(search.toLowerCase());
        return matchesStatus && matchesSearch;
      }).toList();
    });
  }


  Future<void> _refreshDrivers() async {
    await fetchDriversFromBackend();
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
                  Wrap(
                    spacing: 14,
                    runSpacing: 14,
                    alignment: WrapAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.call, size: 20, color: Colors.white),
                        label: const Text("Call", style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold)),
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
                        icon: const Icon(Icons.assignment, size: 20, color: Colors.white),
                        label: const Text("Assign Order", style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade600,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 2,
                        ),
                        onPressed: () {
                          // Assuming the userId is stored in a variable called `userId`
                          // Replace with the actual userId you want to pass

                          // Navigate to AssignOrderPage and send the userId
                          print('Driver full object: $driver');

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AssignOrderPage(driverId: driver['id'] ?? ''),
                            ),
                          );



                          // Optionally, you can show a SnackBar or some other indication
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Assigning order...')),
                          );
                        },
                      ),

                      OutlinedButton.icon(
                        icon: const Icon(Icons.block, color: Colors.red, size: 20),
                        label: const Text("Delete", style: TextStyle(color: Colors.red, fontSize: 15)),
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
                                        "Delete Driver",
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
                                        label: const Text("Confirm Delete"),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          foregroundColor: Colors.white,
                                        ),
                                        onPressed: () async {
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          // First, close the current page (pop
                                          // Call the deleteUser function to delete the driver based on the entered reason
                                          String? userId = driver['id']; // Replace this with the actual driver ID you want to delete
                                          await AuthService().deleteUser(context, userId!);
                                          // Show the snackbar with the reason for blocking
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text('Driver deleted: ${reasonController.text}')),
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
        return Colors.green.shade600;
    }
  }

  IconData getStatusIcon(String status) {
    switch (status) {
      case 'Active':
        return Icons.check_circle;
      case 'Pending':
        return Icons.hourglass_bottom;
      default:
        return Icons.check_circle;
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
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(), // Show loading spinner
      )
          : Column(
        children: [
          const SizedBox(height: 10),
          _buildSearchBar(),
          const SizedBox(height: 8),
          _buildFilterChips(),
          const SizedBox(height: 10),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshDrivers,
              child: filteredDrivers.isEmpty
                  ? const Center(child: Text("No drivers found"))
                  : ListView.builder(
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
      margin: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        elevation: 6,
        shadowColor: Colors.black.withOpacity(0.08),
        child: InkWell(
          onTap: () => _showDriverDetails(driver),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: const Color(0xFFEAF0FA),
                  child: Text(
                    driver['icon'] ?? '👤',
                    style: const TextStyle(fontSize: 26),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        driver['name'] ?? '',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2D2D2D),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Icon(Icons.local_shipping_rounded, size: 14, color: Colors.grey[600]),
                          Text(
                            driver['vehicle'] ?? 'Unknown Vehicle',
                            style: const TextStyle(fontSize: 13.5, color: Colors.black54),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Icon(Icons.location_on_rounded, size: 14, color: Colors.grey[600]),
                          Text(
                            driver['city'] ?? 'Unknown City',
                            style: const TextStyle(fontSize: 13.5, color: Colors.black54),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'ID: ${driver['id'] ?? 'N/A'}',
                        style: const TextStyle(fontSize: 12.5, color: Colors.grey),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Flexible(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Icon(statusIcon, color: statusColor, size: 22),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          driver['status']?.toUpperCase() ?? '',
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 12.5,
                            letterSpacing: 0.4,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


}
