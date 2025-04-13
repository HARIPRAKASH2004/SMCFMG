import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:track/services/splashpage.dart';

import '../main.dart';
import '../models/location_log_model.dart';
import '../models/orders.dart';
import '../models/users.dart';
import '../models/vechile.dart';
import '../modules/common/loginpage.dart';
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

          userProvider.setUser(UserModel.fromMap(user));

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














}
