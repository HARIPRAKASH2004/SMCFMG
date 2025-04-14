import 'package:flutter/material.dart';
import '../models/users.dart';
import '../models/orders.dart';
import '../models/vechile.dart';
import '../models/notification_model.dart';
import '../models/location_log_model.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;
  UserModel? get user => _user;

  bool get isLoggedIn => _user != null;
  bool get isAdmin => _user?.type == 'admin';
  bool get isDriver => _user?.type == 'driver';

  // Set the user data and notify listeners
  void setUser(UserModel user) {
    _user = user;
    notifyListeners();
  }

  // Update the user data and notify listeners
  void updateUser(UserModel updatedUser) {
    _user = updatedUser;
    notifyListeners();
  }

  // Update user location and notify listeners
  void updateLocation(double latitude, double longitude) {
    if (_user != null) {
      _user = _user!.copyWith(
        latitude: latitude,
        longitude: longitude,
        lastUpdated: DateTime.now(),
      );
      notifyListeners();
    }
  }

  // Update the user's availability and notify listeners
  void updateAvailability(String availability) {
    if (_user != null) {
      _user = _user!.copyWith(availability: availability);
      notifyListeners();
    }
  }

  // Update the current order ID for the user
  void updateCurrentOrder(String orderId) {
    if (_user != null) {
      _user = _user!.copyWith(currentOrderId: orderId);
      notifyListeners();
    }
  }

  // Update the user's Aadhaar number
  void updateAadhaarNumber(String newAadhaarNumber) {
    if (_user != null) {
      _user = _user!.copyWith(aadhaarNumber: newAadhaarNumber);
      notifyListeners();
    }
  }

  // Clear all user data (including vehicles, orders, and location)
  void clearUser() {
    _user = null;
    _vehicle = null;
    _currentOrder = null;
    _pastOrders = [];
    _notifications = [];
    _currentLocation = null;
    notifyListeners();
  }

  // Vehicle handling
  VehicleModel? _vehicle;
  VehicleModel? get vehicle => _vehicle;

  // Set a single vehicle
  void setVehicle(VehicleModel vehicle) {
    _vehicle = vehicle;
    notifyListeners();
  }

  // Update the current vehicle
  void updateVehicle(VehicleModel updatedVehicle) {
    _vehicle = updatedVehicle;
    notifyListeners();
  }

  // Handle orders (current and past)
  OrderModel? _currentOrder;
  List<OrderModel> _pastOrders = [];

  OrderModel? get currentOrder => _currentOrder;
  List<OrderModel> get pastOrders => _pastOrders;

  // Set a current order
  void setCurrentOrder(OrderModel order) {
    _currentOrder = order;
    notifyListeners();
  }

  // Complete the current order and move it to past orders
  void completeCurrentOrder() {
    if (_currentOrder != null) {
      _pastOrders.add(_currentOrder!);
      _currentOrder = null;
      notifyListeners();
    }
  }

  // Set multiple past orders
  void setPastOrders(List<OrderModel> orders) {
    _pastOrders = orders;
    notifyListeners();
  }

  // Add a new past order
  void addPastOrder(OrderModel order) {
    _pastOrders.add(order);
    notifyListeners();
  }

  // Notifications handling
  List<FcmLogModel> _notifications = [];
  List<FcmLogModel> get notifications => _notifications;

  // Set notifications
  void setNotifications(List<FcmLogModel> logs) {
    _notifications = logs;
    notifyListeners();
  }

  // Add a single notification
  void addNotification(FcmLogModel log) {
    _notifications.insert(0, log);  // Newest notifications at the top
    notifyListeners();
  }

  // Clear all notifications
  void clearNotifications() {
    _notifications.clear();
    notifyListeners();
  }

  // Location handling
  LocationModel? _currentLocation;
  LocationModel? get currentLocation => _currentLocation;

  // Set user location and update user data accordingly
  void setLocation(LocationModel location) {
    _currentLocation = location;
    if (_user != null) {
      _user = _user!.copyWith(
        latitude: location.latitude,
        longitude: location.longitude,
        lastUpdated: DateTime.now(),
      );
    }
    notifyListeners();
  }

  // Clear location
  void clearLocation() {
    _currentLocation = null;
    notifyListeners();
  }

  // Return the current user (getter)
  UserModel? getCurrentUser() {
    return _user;
  }

  // Handle vehicles in the user model
  List<VehicleModel>? _vehicles;
  List<VehicleModel>? get vehicles => _vehicles;

  // Set vehicles for the user
  void setVehicles(List<VehicleModel> vehicles) {
    _vehicles = vehicles;
    notifyListeners();
  }

  // Add a single vehicle to the user's list of vehicles
// Add a single vehicle to the user's list of vehicles
  void addVehicle(VehicleModel vehicle) {
    // Update _vehicles list
    if (_vehicles == null) {
      _vehicles = [vehicle];
    } else {
      _vehicles!.add(vehicle);
    }

    // Update user model's vehicle list as well
    if (_user != null) {
      final updatedList = [...?_user!.vehicles, vehicle];
      _user = _user!.copyWith(vehicles: updatedList);
    }

    notifyListeners();
  }


  // Update vehicle in the list by replacing it
  void updateVehicleInList(VehicleModel updatedVehicle) {
    if (_vehicles != null) {
      _vehicles = _vehicles!.map((v) {
        return v.id == updatedVehicle.id ? updatedVehicle : v;
      }).toList();
      notifyListeners();
    }
  }


  // Remove a vehicle from the user's list
  void removeVehicle(String vehicleId) {
    if (_vehicles != null) {
      _vehicles?.removeWhere((vehicle) => vehicle.id == vehicleId);
      notifyListeners();
    }
  }
}
