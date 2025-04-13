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

  void setUser(UserModel user) {
    _user = user;
    notifyListeners();
  }

  void updateUser(UserModel updatedUser) {
    _user = updatedUser;
    notifyListeners();
  }

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

  void updateAvailability(String availability) {
    if (_user != null) {
      _user = _user!.copyWith(availability: availability);
      notifyListeners();
    }
  }

  void updateCurrentOrder(String orderId) {
    if (_user != null) {
      _user = _user!.copyWith(currentOrderId: orderId);
      notifyListeners();
    }
  }

  // Add a method to update the Aadhaar number
  void updateAadhaarNumber(String newAadhaarNumber) {
    if (_user != null) {
      _user = _user!.copyWith(aadhaarNumber: newAadhaarNumber);
      notifyListeners();
    }
  }

  void clearUser() {
    _user = null;
    _vehicle = null;
    _currentOrder = null;
    _pastOrders = [];
    _notifications = [];
    _currentLocation = null;
    notifyListeners();
  }

  VehicleModel? _vehicle;
  VehicleModel? get vehicle => _vehicle;

  void setVehicle(VehicleModel vehicle) {
    _vehicle = vehicle;
    notifyListeners();
  }

  void updateVehicle(VehicleModel updatedVehicle) {
    _vehicle = updatedVehicle;
    notifyListeners();
  }

  OrderModel? _currentOrder;
  List<OrderModel> _pastOrders = [];

  OrderModel? get currentOrder => _currentOrder;
  List<OrderModel> get pastOrders => _pastOrders;

  void setCurrentOrder(OrderModel order) {
    _currentOrder = order;
    notifyListeners();
  }

  void completeCurrentOrder() {
    if (_currentOrder != null) {
      _pastOrders.add(_currentOrder!);
      _currentOrder = null;
      notifyListeners();
    }
  }

  void setPastOrders(List<OrderModel> orders) {
    _pastOrders = orders;
    notifyListeners();
  }

  void addPastOrder(OrderModel order) {
    _pastOrders.add(order);
    notifyListeners();
  }

  List<FcmLogModel> _notifications = [];
  List<FcmLogModel> get notifications => _notifications;

  void setNotifications(List<FcmLogModel> logs) {
    _notifications = logs;
    notifyListeners();
  }

  void addNotification(FcmLogModel log) {
    _notifications.insert(0, log);
    notifyListeners();
  }

  void clearNotifications() {
    _notifications.clear();
    notifyListeners();
  }

  LocationModel? _currentLocation;
  LocationModel? get currentLocation => _currentLocation;

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

  void clearLocation() {
    _currentLocation = null;
    notifyListeners();
  }
}
