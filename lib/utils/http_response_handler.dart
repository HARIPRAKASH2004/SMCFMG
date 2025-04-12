import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import '../utils/snackbar_util.dart';

typedef ResponseCallback = void Function();
typedef DataCallback = void Function(Map<String, dynamic> data);
typedef ErrorCallback = void Function(dynamic error);

class HTTPResponseHandler {
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 2);

  /// Handle general responses
  static Future<void> handleResponse({
    required BuildContext context,
    required http.Response response,
    required ResponseCallback on200,
    ResponseCallback? on201,
    ResponseCallback? on400,
    ResponseCallback? on401,
    ResponseCallback? on404,
    ResponseCallback? on500,
    ResponseCallback? onOther,
  }) async {
    try {
      final statusCode = response.statusCode;

      switch (statusCode) {
        case 200:
          on200();
          break;
        case 201:
          if (on201 != null) on201();
          break;
        case 400:
          final body = _decodeResponseBody(response.body);
          showSnackBar(context, body['message'] ?? 'Bad request.');
          if (on400 != null) on400();
          break;
        case 401:
          showSnackBar(context, 'Unauthorized. Please log in again.');
          if (on401 != null) on401();
          break;
        case 404:
          showSnackBar(context, 'Resource not found.');
          if (on404 != null) on404();
          break;
        case 500:
          showSnackBar(context, 'Server error. Please try again later.');
          if (on500 != null) on500();
          break;
        default:
          showSnackBar(context, 'Unexpected error: $statusCode');
          if (onOther != null) onOther();
          break;
      }
    } catch (e) {
      debugPrint('⚠️ Exception in handleResponse: $e');
      if (on500 != null) on500();
    }
  }

  /// Retry handler for network-sensitive requests
  static Future<void> handleRetry({
    required BuildContext context,
    required Future<http.Response> Function() request,
    required Function(http.Response response) onSuccess,
    required ErrorCallback onFailure,
    required ResponseCallback onNetworkError,
  }) async {
    int attempt = 0;

    while (attempt < maxRetries) {
      try {
        final response = await request();

        if (response.statusCode == 200 || response.statusCode == 201) {
          onSuccess(response);
          return;
        } else {
          debugPrint('Retry attempt $attempt failed: ${response.statusCode}');
          attempt++;
          await Future.delayed(retryDelay);
        }
      } on SocketException catch (e) {
        debugPrint('SocketException: $e');
        attempt++;
        if (attempt >= maxRetries) {
          onNetworkError();
        }
        await Future.delayed(retryDelay);
      } on TimeoutException catch (e) {
        debugPrint('TimeoutException: $e');
        attempt++;
        if (attempt >= maxRetries) {
          handleTimeoutError(context);
          onNetworkError();
        }
        await Future.delayed(retryDelay);
      } catch (e) {
        debugPrint('Unhandled exception: $e');
        onFailure(e);
        return;
      }
    }
  }

  /// Handle response for getUserData
  static Future<void> handleGetUserDataResponse({
    required BuildContext context,
    required http.Response response,
    required DataCallback on200,
    ResponseCallback? on400,
    ResponseCallback? on401,
    ResponseCallback? on500,
    ResponseCallback? onOther,
  }) async {
    try {
      final statusCode = response.statusCode;
      final body = _decodeResponseBody(response.body);

      switch (statusCode) {
        case 200:
        case 201:
          on200(body);
          break;
        case 400:
          showSnackBar(context, body['message'] ?? 'Invalid request.');
          if (on400 != null) on400();
          break;
        case 401:
          showSnackBar(context, 'Unauthorized access.');
          if (on401 != null) on401();
          break;
        case 500:
          showSnackBar(context, 'Server error.');
          if (on500 != null) on500();
          break;
        default:
          showSnackBar(context, 'Unexpected status code: $statusCode');
          if (onOther != null) onOther();
          break;
      }
    } catch (e) {
      debugPrint('⚠️ Exception in getUserData handler: $e');
      if (on500 != null) on500();
    }
  }

  /// Decode body safely
  static Map<String, dynamic> _decodeResponseBody(String body) {
    try {
      return jsonDecode(body) as Map<String, dynamic>;
    } catch (e) {
      debugPrint('Failed to decode response body: $e');
      return {};
    }
  }

  /// Error handlers
  static void handleNetworkError(BuildContext context) {
    showSnackBar(context, "Network issue. Please check your connection.");
  }

  static void handleTimeoutError(BuildContext context) {
    showSnackBar(context, "Request timed out. Try again later.");
  }

  static void handleGenericError(BuildContext context, String message) {
    showSnackBar(context, message);
  }
}
