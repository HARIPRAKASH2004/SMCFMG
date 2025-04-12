import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import '../models/location_log_model.dart';
import '../models/orders.dart';
import '../models/users.dart';
import '../models/vechile.dart';
import '../providers/user_provider.dart';
import '../utils/snackbar_util.dart';
import '../utils/api_handler.dart';
import '../services/constants.dart';
import '../utils/http_response_handler.dart';

class AuthService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  /// Sign-up user and save token
  Future<bool?> signUpUser({
    required BuildContext context,
    required String email,
    required String username,
    required String password,
  }) async {
    try {
      // Get FCM token
      String? fcmToken = await _firebaseMessaging.getToken() ?? '';

      final Map<String, dynamic> userData = {
        "email": email,
        "username": username,
        "password": password,
        "fcmToken": fcmToken,
      };

      final http.Response res = await APIHandler.response(
        api: RESTURIConstants.register(),
        body: userData,
      );
      await HTTPResponseHandler.handleResponse(
            context: context,
            response: res,
            on200: () => showSnackBar(context, "Registration successful!"),
            on201: () => showSnackBar(context, "Registered!"),
            on400: () => showSnackBar(context, "Invalid data provided."),
            on401: () => showSnackBar(context, "Unauthorized access."),
            on404: () => showSnackBar(context, "Endpoint not found."),
            on500: () => showSnackBar(context, "Server error."),
            onOther: () => showSnackBar(context, "Unexpected error."),
          );

          if (res.statusCode == 200 || res.statusCode == 201) {
        final token = res.headers['x-auth-token'];
        if (token != null && token.isNotEmpty) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('x-auth-token', token);
        }
        await getUserData(context);
        return true;
      }


      return false;
    } catch (e) {
      debugPrint("Signup Error: $e");
      showSnackBar(context, "Something went wrong.");
      return null;
    }
  }

  /// Fetch and set user data after login or registration
  Future<bool?> getUserData(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('x-auth-token');

      // Log token for debugging
      debugPrint("Token: $token");

      if (token == null || token.isEmpty) {
        await prefs.remove('x-auth-token');
        showSnackBar(context, "Session expired. Please log in again.");
        return false;
      }

      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      // Log headers for debugging
      debugPrint("Request Headers: $headers");

      final http.Response res = await APIHandler.response(
        api: RESTURIConstants.getData(),
        headers: headers,
      );

      // Log response status code
      debugPrint("Response Status Code: ${res.statusCode}");

      // Log raw response body for debugging
      debugPrint("Response Body: ${res.body}");

      await HTTPResponseHandler.handleGetUserDataResponse(
        context: context,
        response: res,
        on200: (Map<String, dynamic> data) {
          final ctx = navigationKey.currentContext!;
          final userProvider = Provider.of<UserProvider>(ctx, listen: false);

          // Log the raw data for debugging
          debugPrint("Raw Data: $data");

          // Safely handle user data
          final user = data['user'] ?? {};
          debugPrint("User Data: $user");

          // Ensure userId is extracted and passed to models
          final userId = user['id'] ?? '';
          debugPrint("User ID: $userId");

          // Set user data in provider
          userProvider.setUser(UserModel.fromMap(user));

          // Safely handle vehicle data
          final vehicle = data['vehicle'];
          debugPrint("Vehicle Data: $vehicle");

          userProvider.setVehicle(vehicle != null
              ? VehicleModel.fromMap(vehicle).copyWith(userId: userId) // Pass userId explicitly
              : VehicleModel(
            id: '',
            userId: userId, // Ensure userId is passed
            vehicleNumber: '',
            vehicleType: '',
            model: '',
            brand: '',
            year: 0,
            rcBookUrl: '',
            insuranceUrl: '',
            insuranceExpiry: DateTime.now(),
            status: 'inactive',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ));

          // Safely handle current order data
          final currentOrder = data['currentOrder'];
          debugPrint("Current Order Data: $currentOrder");

          userProvider.setCurrentOrder(currentOrder != null
              ? OrderModel.fromMap(currentOrder).copyWith(driverId: userId) // Pass driverId explicitly
              : OrderModel(
            orderId: '',
            driverId: userId, // Ensure driverId is passed
            driverName: '',
            pickupLocation: '',
            deliveryLocation: '',
            status: 'pending',
            pickupTime: DateTime.now(),
            deliveryTime: DateTime.now(),
            distanceInKm: 0,
            loadWeightInTons: 0,
            goodsType: '',
            fare: 0,
            customerContact: '',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ));

          // Safely handle location data
          final location = data['location'];
          debugPrint("Location Data: $location");

          userProvider.setLocation(location != null
              ? LocationModel.fromMap(location)
              : LocationModel(
            latitude: 0.0,
            longitude: 0.0,
            address: '',
            lastUpdated: DateTime.now(),
          ));

          // Success message
          showSnackBar(ctx, "User data loaded successfully.");
        },
        on400: () => showSnackBar(context, "Bad request."),
        on401: () => showSnackBar(context, "Session expired. Please log in again."),
        on500: () => showSnackBar(context, "Internal server error."),
        onOther: () => showSnackBar(context, "Unexpected error."),
      );

      return true;
    } catch (e) {
      // Log error for debugging
      debugPrint("GetUserData Error: $e");
      showSnackBar(context, "Failed to load user data.");
      return false;
    }
  }







}
