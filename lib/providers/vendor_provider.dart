import 'package:flutter/material.dart';
import '../models/users.dart';
import '../models/vechile.dart';
import '../models/orders.dart';
import '../models/notification_model.dart';
import '../models/location_log_model.dart';

class VendorProvider with ChangeNotifier {
  // Stores the list of vendors
  List<UserModel> _vendors = [];
  List<UserModel> get vendors => _vendors; // Public getter to access vendors

  // Stores the list of vehicles
  List<VehicleModel> _vehicles = [];
  List<VehicleModel> get vehicles => _vehicles; // Public getter to access vehicles

  // Stores the list of orders for vendors
  List<OrderModel> _orders = [];
  List<OrderModel> get orders => _orders; // Public getter to access orders

  // Stores notifications for vendors
  List<FcmLogModel> _notifications = [];
  List<FcmLogModel> get notifications => _notifications; // Public getter for notifications

  // Set the list of vendors
  void setVendors(List<UserModel> vendors) {
    _vendors = vendors;
    notifyListeners();
  }

  // Add a new vendor to the list of vendors
  void addVendor(UserModel vendor) {
    if (!_vendors.contains(vendor)) {
      _vendors.add(vendor);
      notifyListeners();
    }
  }

  // Update a vendor in the list
  void updateVendor(UserModel updatedVendor) {
    final index = _vendors.indexWhere((vendor) => vendor.id == updatedVendor.id);
    if (index != -1) {
      _vendors[index] = updatedVendor;
      notifyListeners();
    }
  }

  // Remove a vendor by ID
  void removeVendor(String vendorId) {
    _vendors.removeWhere((vendor) => vendor.id == vendorId);
    notifyListeners();
  }

  // Add a vehicle to the vendor's fleet
  void addVehicle(VehicleModel vehicle) {
    if (!_vehicles.contains(vehicle)) {
      _vehicles.add(vehicle);
      notifyListeners();
    }
  }

  // Update a vehicle in the list
  void updateVehicle(VehicleModel updatedVehicle) {
    final index = _vehicles.indexWhere((vehicle) => vehicle.id == updatedVehicle.id);
    if (index != -1) {
      _vehicles[index] = updatedVehicle;
      notifyListeners();
    }
  }

  // Remove a vehicle by ID
  void removeVehicle(String vehicleId) {
    _vehicles.removeWhere((vehicle) => vehicle.id == vehicleId);
    notifyListeners();
  }

  // Add an order to the vendor's list of orders
  void addOrder(OrderModel order) {
    if (!_orders.contains(order)) {
      _orders.add(order);
      notifyListeners();
    }
  }

  // Update an existing order in the list
  void updateOrder(OrderModel updatedOrder) {
    final index = _orders.indexWhere((order) => order.orderId == updatedOrder.orderId);
    if (index != -1) {
      _orders[index] = updatedOrder;
      notifyListeners();
    }
  }

  // Remove an order by ID
  void removeOrder(String orderId) {
    _orders.removeWhere((order) => order.orderId == orderId);
    notifyListeners();
  }

  // Set the notifications for the vendor
  void setNotifications(List<FcmLogModel> notifications) {
    _notifications = notifications;
    notifyListeners();
  }

  // Add a single notification to the list (insert at the top)
  void insertNotification(FcmLogModel notification) {
    _notifications.insert(0, notification); // Add to the top of the list
    notifyListeners();
  }

  // Clear all notifications
  void clearNotifications() {
    _notifications.clear();
    notifyListeners();
  }

  // Clear all vendor-related data
  void clearVendorData() {
    _vendors.clear();
    _vehicles.clear();
    _orders.clear();
    _notifications.clear();
    notifyListeners();
  }
}
