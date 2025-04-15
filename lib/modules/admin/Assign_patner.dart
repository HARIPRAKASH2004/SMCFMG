import 'package:flutter/material.dart';
import '../../utils/snackbar_util.dart';
import '/services/auth_services.dart';

class AssignOrderPage extends StatefulWidget {
  final String driverId;


  const AssignOrderPage({super.key, required this.driverId});

  @override
  State<AssignOrderPage> createState() => _AssignOrderPageState();
}

class _AssignOrderPageState extends State<AssignOrderPage> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  bool isLoading = false;
  List<Map<String, String>> allVendors = [];
  List<Map<String, String>> filteredVendors = [];
  String search = '';
  String? selectedVendorId;

  @override
  void initState() {
    super.initState();
    fetchActiveVendors();
  }

  Future<void> fetchActiveVendors() async {
    setState(() => isLoading = true);
    try {
      final vendors = await AuthService().fetchActiveVendors(context);
      if (vendors != null && vendors.isNotEmpty) {
        final vendorList = vendors.map((vendor) {
          return {
            'id': vendor.id ?? '',
            'name': vendor.name ?? '',
            'city': vendor.city ?? 'Unknown City',
          };
        }).toList();

        setState(() {
          allVendors = vendorList;
          filteredVendors = vendorList;
        });
      } else {
        showSnackBar(context, "No active vendors found.");
      }
    } catch (e) {
      debugPrint("Error fetching vendors: $e");
      showSnackBar(context, "Failed to fetch active vendors.");
    } finally {
      setState(() => isLoading = false);
    }
  }

  void filterVendors(String query) {
    setState(() {
      search = query;
      filteredVendors = allVendors.where((vendor) {
        return vendor['name']!.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  void assignOrder() async {
    final phone = phoneController.text.trim();
    final location = locationController.text.trim();

    if (phone.isEmpty || location.isEmpty || selectedVendorId == null) {
      showSnackBar(context, "Please fill all fields and select a vendor.");
      return;
    }
    final authservices = AuthService();
    final result = await authservices.assignOrder(
      context,
      driverId: widget.driverId,
      vendorId: selectedVendorId!,
      phone: phone,
      location: location,
    );

    if (result == true) {
      showSnackBar(context, "Order assigned to vendor $selectedVendorId");

      setState(() {
        selectedVendorId = null;
        phoneController.clear();
        locationController.clear();
        Navigator.pop(context);
      });
    }
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xFFF4F2F0),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 3,
        centerTitle: true,
        title: const Text(
          'Assign Order',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBar(),
            const SizedBox(height: 18),
            _buildVendorList(),
            const SizedBox(height: 28),
            _buildPhoneNumberField(),
            const SizedBox(height: 18),
            _buildLocationField(),
            const SizedBox(height: 28),
            _buildAssignButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: TextField(
        onChanged: filterVendors,
        decoration: InputDecoration(
          hintText: 'Search vendors...',
          prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          suffixIcon: search.isNotEmpty
              ? IconButton(
            icon: const Icon(Icons.clear, color: Colors.grey),
            onPressed: () {
              setState(() {
                search = '';
                filteredVendors = allVendors;
              });
            },
          )
              : null,
        ),
      ),
    );
  }

  Widget _buildVendorList() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 280,
      child: filteredVendors.isEmpty
          ? const Center(child: Text("No vendors found", style: TextStyle(color: Colors.grey)))
          : ListView.builder(
        itemCount: filteredVendors.length,
        itemBuilder: (context, index) {
          return _buildVendorCard(filteredVendors[index]);
        },
      ),
    );
  }

  Widget _buildVendorCard(Map<String, String> vendor) {
    final isSelected = vendor['id'] == selectedVendorId;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isSelected ? Colors.green.shade200 : Colors.grey.shade300,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: isSelected ? Colors.green.shade100 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          leading: CircleAvatar(
            radius: 24,
            backgroundColor: Colors.blue.shade50,
            child: Icon(Icons.store_mall_directory_outlined, color: Colors.blue.shade700),
          ),
          title: Text(
            vendor['name'] ?? 'Vendor Name',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          subtitle: Text(vendor['city'] ?? 'Unknown City', style: const TextStyle(color: Colors.black54)),
          trailing: isSelected
              ? const Icon(Icons.check_circle, color: Colors.green)
              : const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          onTap: () {
            setState(() {
              selectedVendorId = vendor['id'];
            });
          },
        ),
      ),
    );
  }

  Widget _buildPhoneNumberField() {
    return _buildInputField(
      controller: phoneController,
      label: 'Vendor Phone Number',
      icon: Icons.phone,
      inputType: TextInputType.phone,
    );
  }

  Widget _buildLocationField() {
    return _buildInputField(
      controller: locationController,
      label: 'Enter Google Location',
      icon: Icons.location_on,
    );
  }

  Widget _buildLatitudeLongitudeFields({
    required TextEditingController latitudeController,
    required TextEditingController longitudeController,
    required String latitudeLabel,
    required String longitudeLabel,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Latitude Input Field
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), // Rounded corners
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300.withOpacity(0.6),
                blurRadius: 20, // Softer shadow for modern aesthetics
                offset: Offset(0, 10), // Shadow to the bottom-right
              ),
            ],
          ),
          child: TextField(
            controller: latitudeController,
            keyboardType: TextInputType.number,
            style: TextStyle(fontSize: 18, color: Colors.black87, fontWeight: FontWeight.w500),
            decoration: InputDecoration(
              labelText: latitudeLabel,
              labelStyle: TextStyle(
                fontSize: 16,
                color: Colors.blue.shade600,
                fontWeight: FontWeight.w600,
              ),
              prefixIcon: Icon(Icons.location_on, color: Colors.blue.shade600, size: 24),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20), // Rounded input field
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.blue.shade600,
                  width: 2.5,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey.shade300,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              suffixIcon: latitudeController.text.isEmpty
                  ? null
                  : GestureDetector(
                onTap: () {
                  latitudeController.clear();
                },
                child: Icon(
                  Icons.clear,
                  color: Colors.blue.shade600,
                  size: 20,
                ),
              ),
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              focusColor: Colors.blue.shade600,
            ),
            onChanged: (text) {
              setState(() {});
            },
          ),
        ),
        SizedBox(height: 16),

        // Longitude Input Field
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300.withOpacity(0.6),
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: TextField(
            controller: longitudeController,
            keyboardType: TextInputType.number,
            style: TextStyle(fontSize: 18, color: Colors.black87, fontWeight: FontWeight.w500),
            decoration: InputDecoration(
              labelText: longitudeLabel,
              labelStyle: TextStyle(
                fontSize: 16,
                color: Colors.blue.shade600,
                fontWeight: FontWeight.w600,
              ),
              prefixIcon: Icon(Icons.location_on, color: Colors.blue.shade600, size: 24),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.blue.shade600,
                  width: 2.5,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey.shade300,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              suffixIcon: longitudeController.text.isEmpty
                  ? null
                  : GestureDetector(
                onTap: () {
                  longitudeController.clear();
                },
                child: Icon(
                  Icons.clear,
                  color: Colors.blue.shade600,
                  size: 20,
                ),
              ),
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              focusColor: Colors.blue.shade600,
            ),
            onChanged: (text) {
              setState(() {});
            },
          ),
        ),
      ],
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType inputType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20), // Rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300.withOpacity(0.6),
            blurRadius: 20, // Softer shadow for modern aesthetics
            offset: Offset(0, 10), // Shadow to the bottom-right
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: inputType,
        style: TextStyle(fontSize: 18, color: Colors.black87, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            fontSize: 16,
            color: Colors.blue.shade600,
            fontWeight: FontWeight.w600,
          ),
          prefixIcon: Icon(icon, color: Colors.blue.shade600, size: 24),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20), // Rounded input field
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.blue.shade600,
              width: 2.5,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey.shade300,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          suffixIcon: controller.text.isEmpty
              ? null
              : GestureDetector(
            onTap: () {
              controller.clear();
            },
            child: Icon(
              Icons.clear,
              color: Colors.blue.shade600,
              size: 20,
            ),
          ),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          focusColor: Colors.blue.shade600,
        ),
        onChanged: (text) {
          setState(() {});
        },
      ),
    );
  }

  Widget _buildAssignButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: assignOrder,
        icon: const Icon(
          Icons.check_circle_outline,
          size: 24, // Slightly bigger icon
          color: Colors.white,
        ),
        label: const Text(
          'Assign Order',
          style: TextStyle(
            fontSize: 18, // Increased font size for better readability
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30), // More rounded corners
          ),
          elevation: 10, // Slightly higher elevation for a more pronounced shadow
          shadowColor: Colors.green.shade300, // Softer shadow
          backgroundColor: Colors.green.shade700, // Slightly deeper green for better contrast
        ).copyWith(
          // Adding a smooth hover effect and an active state color change
          // surfaceTintColor: Colors.green.shade600, // For better visual response on tap
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.green.shade800; // Darker green when pressed
            }
            return Colors.green.shade700; // Normal state color
          }),
        ),
      ),
    );
  }

}
