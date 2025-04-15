import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:track/services/splashpage.dart';

import '../main.dart';
import '../models/Vendor.dart';
import '../models/location_log_model.dart';
import '../models/orders.dart';
import '../models/users.dart';
import '../models/vechile.dart';
import '../modules/common/loginpage.dart';
import '../providers/user_provider.dart';
import '../providers/vendor_provider.dart';
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

      debugPrint("Request Headers: $headers");

      final http.Response res = await APIHandler.response(
        api: RESTURIConstants.getData(),
        headers: headers,
      );

      debugPrint("Response Status Code: ${res.statusCode}");
      debugPrint("Response Body: ${res.body}");

      await HTTPResponseHandler.handleGetUserDataResponse(
        context: context,
        response: res,
        on200: (Map<String, dynamic> data) {
          final userProvider = Provider.of<UserProvider>(context, listen: false);

          debugPrint("Raw Data: $data");

          final user = data['user'] ?? {};
          final userId = user['id'] ?? '';
          final userType = user['type'] ?? 'unknown';

          debugPrint("User ID: $userId");
          debugPrint("User Type: $userType");

          if (userType == 'unknown') {
            showSnackBar(context, "User type is missing or invalid.");
            return;
          }

          // Parse vehicles if available
          final vehiclesData = data['vehicles'] ?? [];
          List<VehicleModel> vehicles = [];
          if (vehiclesData.isNotEmpty) {
            vehicles = List<VehicleModel>.from(
                vehiclesData.map((vehicleData) => VehicleModel.fromMap(vehicleData))
            );
          }

          // Update UserModel with vehicles
          userProvider.setUser(UserModel.fromMap(user).copyWith(vehicles: vehicles));

          // ✅ IMMEDIATE redirection to SplashPage
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const SplashPage()),
                (route) => false,
          );
        },
        on400: () => showSnackBar(context, "Bad request."),
        on401: () => showSnackBar(context, "Session expired. Please log in again."),
        on500: () => showSnackBar(context, "Internal server error."),
        onOther: () => showSnackBar(context, "Unexpected error."),
      );

      return true;
    } catch (e) {
      debugPrint("GetUserData Error: $e");
      showSnackBar(context, "Failed to load user data.");
      return false;
    }
  }

  Future<void> logoutUser(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('x-auth-token');

      if (token != null && token.isNotEmpty) {
        final headers = {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        };

        // Send DELETE request to backend logout endpoint
        final res = await APIHandler.response(
          api: RESTURIConstants.logout(), // points to /user/logout
          headers: headers,
        );

        debugPrint("Logout Response Code: ${res.statusCode}");
        debugPrint("Logout Response Body: ${res.body}");

        if (res.statusCode != 200) {
          showSnackBar(context, "Server logout failed.");
          return;
        }
      }

      // Clear all SharedPreferences
      await prefs.clear();

      // Clear all provider states
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.clearUser();

      // Navigate to LoginPage
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
            (route) => false,
      );

      showSnackBar(context, "Logged out successfully.");
    } catch (e) {
      debugPrint("Logout error: $e");
      showSnackBar(context, "Logout failed.");
    }
  }

  Future<bool?> loginUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      final fcmToken = await FirebaseMessaging.instance.getToken();

      final Map<String, dynamic> loginData = {
        "email": email,
        "password": password,
        "fcmToken": fcmToken, // ✅ Include FCM token
      };

      final http.Response res = await APIHandler.response(
        api: RESTURIConstants.login(),
        body: loginData,
      );

      await HTTPResponseHandler.handleResponse(
        context: context,
        response: res,
        on200: () => showSnackBar(context, "Login successful!"),
        on201: () => showSnackBar(context, "Logged in!"),
        on400: () => showSnackBar(context, "Invalid email or password."),
        on401: () => showSnackBar(context, "Unauthorized access."),
        on404: () => showSnackBar(context, "Endpoint not found."),
        on500: () => showSnackBar(context, "Server error."),
        onOther: () => showSnackBar(context, "Unexpected error."),
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        final token = res.headers['x-auth-token'] ?? '';
        if (token.isNotEmpty) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('x-auth-token', token);
          await getUserData(context); // Fetch user data
          return true;
        } else {
          showSnackBar(context, "Authentication failed. Please try again.");
          return false;
        }
      }

      return false;
    } catch (e) {
      debugPrint("Login Error: $e");
      showSnackBar(context, "Something went wrong.");
      return null;
    }
  }

  Future<bool?> updateOnlineStatus(BuildContext context, bool isOnline) async {
    try {
      // Retrieve the token from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('x-auth-token');

      if (token == null || token.isEmpty) {
        showSnackBar(context, "Session expired. Please log in again.");
        return false;
      }

      // Set headers for authorization and content type
      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      // Prepare the body with the online status flag
      final body = {'isOnline': isOnline}; // Don't encode here

      // Make the PUT request
      final http.Response res = await APIHandler.response(
        api: RESTURIConstants.updateOnlineStatus(),
        headers: headers,
        body: body, // Pass raw Map, let APIHandler handle encoding
      );

      // Debugging: Output response code and body
      debugPrint("Status Update Response Code: ${res.statusCode}");
      debugPrint("Status Update Response Body: ${res.body}");

      // If successful, update the user provider with new online status
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final bool isOnlineNow = data['isOnline'] ?? false;

        // Only update Provider *after* confirmation
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.setUser(userProvider.user!.copyWith(isOnline: isOnlineNow));
      }

      // Handle response errors based on status code
      await HTTPResponseHandler.handleResponse(
        context: context,
        response: res,
        on200: () {}, // Optional: Add more logic if needed
        on400: () => showSnackBar(context, "Invalid request."),
        on401: () => showSnackBar(context, "Unauthorized."),
        on500: () => showSnackBar(context, "Server error."),
        onOther: () => showSnackBar(context, "Something went wrong."),
      );

      return true;
    } catch (e) {
      debugPrint("UpdateOnlineStatus Error: $e");
      showSnackBar(context, "Failed to update online status.");
      return false;
    }
  }

  Future<bool?> updateAadhaarNumber(BuildContext context, String aadhaarNumber) async {
    try {
      // Retrieve the token from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('x-auth-token');

      if (token == null || token.isEmpty) {
        showSnackBar(context, "Session expired. Please log in again.");
        return false;
      }

      // Set headers for authorization and content type
      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      // Prepare the body with the updated Aadhaar number
      final body = {'aadhaarNumber': aadhaarNumber}; // Don't encode here

      // Make the PUT request
      final http.Response res = await APIHandler.response(
        api: RESTURIConstants.updateAadhaarNumber(),
        headers: headers,
        body: body, // Pass raw Map, let APIHandler handle encoding
      );

      // Debugging: Output response code and body
      debugPrint("Aadhaar Update Response Code: ${res.statusCode}");
      debugPrint("Aadhaar Update Response Body: ${res.body}");

      // If successful, update the user provider with the new Aadhaar number
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final String updatedAadhaarNumber = data['aadhaarNumber'] ?? '';

        // Only update Provider *after* confirmation
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.setUser(userProvider.user!.copyWith(aadhaarNumber: updatedAadhaarNumber));

        // Show success message
        showSnackBar(context, "Aadhaar updated successfully.");
      }

      // Handle response errors based on status code
      await HTTPResponseHandler.handleResponse(
        context: context,
        response: res,
        on200: () {}, // Optional: Add more logic if needed
        on400: () => showSnackBar(context, "Invalid Aadhaar number format."),
        on401: () => showSnackBar(context, "Unauthorized."),
        on500: () => showSnackBar(context, "Server error."),
        onOther: () => showSnackBar(context, "Something went wrong."),
      );

      return true;
    } catch (e) {
      debugPrint("UpdateAadhaarNumber Error: $e");
      showSnackBar(context, "Failed to update Aadhaar number.");
      return false;
    }
  }

  Future<bool?> registerVehicle(BuildContext context, VehicleModel vehicle) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('x-auth-token');

      if (token == null || token.isEmpty) {
        showSnackBar(context, "Session expired. Please log in again.");
        return false;
      }

      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      final body = vehicle.toMap();

      final http.Response res = await APIHandler.response(
        api: RESTURIConstants.registerVehicle(),
        headers: headers,
        body: body,
      );

      debugPrint("Vehicle Register Response Code: ${res.statusCode}");
      debugPrint("Vehicle Register Response Body: ${res.body}");

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final VehicleModel newVehicle = VehicleModel.fromMap(data['vehicle']);

        // ✅ Update UserProvider
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        final currentUser = userProvider.user!;

        // Update the list of vehicles
        final updatedVehicles = [...(currentUser.vehicles ?? []), newVehicle];
        userProvider.addVehicle(newVehicle);


        // Set updated user with new vehicles list
        // userProvider.setUser(currentUser.copyWith(vehicles: updatedVehicles));

        showSnackBar(context, "Vehicle registered successfully!");
      }

      await HTTPResponseHandler.handleResponse(
        context: context,
        response: res,
        on200: () {},
        on400: () => showSnackBar(context, "Invalid vehicle data."),
        on401: () => showSnackBar(context, "Unauthorized."),
        on500: () => showSnackBar(context, "Server error."),
        onOther: () => showSnackBar(context, "Something went wrong."),
      );

      return res.statusCode == 200;
    } catch (e) {
      debugPrint("RegisterVehicle Error: $e");
      showSnackBar(context, "Failed to register vehicle.");
      return false;
    }
  }

  Future<bool?> updatePassword(BuildContext context, String newPassword) async {
    try {
      // Retrieve the token from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('x-auth-token');

      if (token == null || token.isEmpty) {
        showSnackBar(context, "Session expired. Please log in again.");
        return false;
      }

      // Set headers for authorization and content type
      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      // Prepare the body with the new password
      final body = {'password': newPassword}; // Send plain Map

      // Make the PUT request
      final http.Response res = await APIHandler.response(
        api: RESTURIConstants.updatePassword(),
        headers: headers,
        body: body, // Let APIHandler handle encoding
      );

      // Debugging logs
      debugPrint("Password Update Response Code: ${res.statusCode}");
      debugPrint("Password Update Response Body: ${res.body}");

      if (res.statusCode == 200) {
        showSnackBar(context, "Password updated successfully.");
      }

      // Handle various response codes
      await HTTPResponseHandler.handleResponse(
        context: context,
        response: res,
        on200: () {}, // Optional: Add logic if needed
        on400: () => showSnackBar(context, "Invalid password format."),
        on401: () => showSnackBar(context, "Unauthorized."),
        on500: () => showSnackBar(context, "Server error."),
        onOther: () => showSnackBar(context, "Something went wrong."),
      );

      return true;
    } catch (e) {
      debugPrint("UpdatePassword Error: $e");
      showSnackBar(context, "Failed to update password.");
      return false;
    }
  }

  Future<bool?> loginWithGoogleToken({
    required BuildContext context,
    required String idToken,
  }) async {
    try {
      final fcmToken = await FirebaseMessaging.instance.getToken();

      final Map<String, dynamic> loginData = {
        "idToken": idToken,
        "fcmToken": fcmToken,
      };

      final http.Response res = await APIHandler.response(
        api: RESTURIConstants.googleLogin(), // Define this endpoint in your REST constants
        body: loginData,
      );

      await HTTPResponseHandler.handleResponse(
        context: context,
        response: res,
        on200: () => showSnackBar(context, "Google login successful!"),
        on201: () => showSnackBar(context, "Logged in with Google!"),
        on400: () => showSnackBar(context, "Invalid Google credentials."),
        on401: () => showSnackBar(context, "Unauthorized access."),
        on404: () => showSnackBar(context, "Endpoint not found."),
        on500: () => showSnackBar(context, "Server error."),
        onOther: () => showSnackBar(context, "Unexpected error."),
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        final token = res.headers['x-auth-token'] ?? '';
        if (token.isNotEmpty) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('x-auth-token', token);
          await getUserData(context); // Fetch user data after Google login
          return true;
        } else {
          showSnackBar(context, "Authentication failed. Please try again.");
          return false;
        }
      }

      return false;
    } catch (e) {
      debugPrint("Google Login Error: $e");
      showSnackBar(context, "Something went wrong.");
      return null;
    }
  }

  Future<List<UserModel>> fetchDrivers(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('x-auth-token');

      debugPrint("Token: $token");

      if (token == null || token.isEmpty) {
        await prefs.remove('x-auth-token');
        showSnackBar(context, "Session expired. Please log in again.");
        return [];
      }

      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      debugPrint("Request Headers: $headers");

      final http.Response res = await APIHandler.response(
        api: RESTURIConstants.getAllUsers(),
        headers: headers,
      );

      debugPrint("Response Status Code: ${res.statusCode}");
      debugPrint("Response Body: ${res.body}");

      if (res.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(res.body);
        final List<UserModel> drivers = [];

        final usersData = data['users'] ?? [];
        for (var userData in usersData) {
          final user = userData['user'] ?? {};
          final userType = user['type'] ?? 'unknown';

          if (userType == 'driver') {
            final vehiclesData = userData['vehicles'] ?? [];
            List<VehicleModel> vehicles = [];
            if (vehiclesData.isNotEmpty) {
              vehicles = List<VehicleModel>.from(
                vehiclesData.map((vehicleData) => VehicleModel.fromMap(vehicleData)),
              );
            }

            // Extract city (from user or userData depending on structure)
            final String? city = user['city'] ?? userData['city'] ?? null;

            // Update UserModel with city if it's part of your model
            final updatedUser = UserModel.fromMap(user).copyWith(
              vehicles: vehicles,
              city: city,
            );

            drivers.add(updatedUser);
          }
        }

        if (drivers.isNotEmpty) {
          final userProvider = Provider.of<UserProvider>(context, listen: false);
          userProvider.setDrivers(drivers);
        }

        return drivers;
      } else {
        showSnackBar(context, "Failed to fetch drivers. Error: ${res.statusCode}");
        return [];
      }
    } catch (e) {
      debugPrint("Error fetching drivers: $e");
      showSnackBar(context, "Error fetching drivers.");
      return [];
    }
  }

  Future<List<VendorModel>> fetchVendorsWithProducts(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('x-auth-token');

      debugPrint("Token: $token");

      if (token == null || token.isEmpty) {
        await prefs.remove('x-auth-token');
        showSnackBar(context, "Session expired. Please log in again.");
        return [];
      }

      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      debugPrint("Request Headers: $headers");

      final http.Response res = await APIHandler.response(
        api: RESTURIConstants.getAllVendors(), // e.g., '/api/vendors'
        headers: headers,
      );

      debugPrint("Response Status Code: ${res.statusCode}");
      debugPrint("Response Body: ${res.body}");

      if (res.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(res.body);
        final List<VendorModel> vendors = [];

        final vendorsData = data['vendors'] ?? [];
        for (var vendorData in vendorsData) {
          final vendor = vendorData['vendor'] ?? {};
          final productsData = vendorData['products'] ?? [];

          // Extract products from the response data
          List<ProductModel> products = [];
          if (productsData.isNotEmpty) {
            products = List<ProductModel>.from(
              productsData.map((product) => ProductModel.fromMap(product)),
            );
          }

          // Create VendorModel instance and set the products
          final updatedVendor = VendorModel.fromMap(vendor).copyWith(
            products: products,  // Ensure products are assigned here
          );

          vendors.add(updatedVendor);
        }

        // If vendors are fetched successfully, update VendorProvider
        if (vendors.isNotEmpty) {
          final vendorProvider = Provider.of<VendorProvider>(context, listen: false);
          vendorProvider.setVendors(vendors.cast<UserModel>());  // Set the vendors in VendorProvider
        }

        return vendors;
      } else {
        showSnackBar(context, "Failed to fetch vendors. Error: ${res.statusCode}");
        return [];
      }
    } catch (e) {
      debugPrint("Error fetching vendors: $e");
      showSnackBar(context, "Error fetching vendors.");
      return [];
    }
  }

  Future<bool?> submitVendorDetails(BuildContext context, VendorModel vendor) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('x-auth-token');

      if (token == null || token.isEmpty) {
        showSnackBar(context, "Session expired. Please log in again.");
        return false;
      }

      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      // Convert the VendorModel to JSON
      final body = vendor.toMap(); // Ensure your VendorModel has a toMap() method

      // Send the request (POST for new vendor, or PUT for update)
      final http.Response res = await APIHandler.response(
        api: RESTURIConstants.submitVendorDetails(), // Example: '/api/vendors' or '/api/vendors/:id'
        headers: headers,
        body: body, // APIHandler should handle JSON encoding
         // or 'PUT' if updating an existing vendor
      );

      debugPrint("Vendor Submit Response Code: ${res.statusCode}");
      debugPrint("Vendor Submit Response Body: ${res.body}");

      if (res.statusCode == 200 || res.statusCode == 201) {
        showSnackBar(context, "Vendor submitted successfully.");
      }

      await HTTPResponseHandler.handleResponse(
        context: context,
        response: res,
        on200: () {}, // Optional
        on201: () {}, // Optional
        on400: () => showSnackBar(context, "Invalid vendor data."),
        on401: () => showSnackBar(context, "Unauthorized."),
        on500: () => showSnackBar(context, "Server error."),
        onOther: () => showSnackBar(context, "Something went wrong."),
      );

      return true;
    } catch (e) {
      debugPrint("SubmitVendorDetails Error: $e");
      showSnackBar(context, "Failed to submit vendor.");
      return false;
    }
  }









}
