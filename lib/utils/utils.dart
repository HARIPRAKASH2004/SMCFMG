import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:track/providers/user_provider.dart';
import '../models/notification_model.dart';

Future<void> handleNotification(RemoteMessage message, {BuildContext? context}) async {
  if (message.notification == null) return;

  final title = message.notification!.title ?? "No Title";
  final body = message.notification!.body ?? "No Body";
  final data = message.data;

  print("🔔 Notification received: $title - $body");
  print("📦 Payload: $data");

  // Create notification model
  final log = FcmLogModel(
    title: title,
    body: body,
    time: DateTime.now().toString(),
  );

  // Update Provider if context is passed (foreground only)
  if (context != null) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.addNotification(log);

    // Optional: update state based on data keys (e.g., new order)
    if (data.containsKey('orderId')) {
      final orderId = data['orderId'];
      userProvider.updateCurrentOrder(orderId);
    }

    if (data.containsKey('availability')) {
      userProvider.updateAvailability(data['availability']);
    }
  }

  // Background/terminated state logic can go here if needed later
}
