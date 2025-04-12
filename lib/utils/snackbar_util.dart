import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String message,
    {Color backgroundColor = Colors.black, Duration duration = const Duration(seconds: 3)}) {
  final snackBar = SnackBar(
    content: Text(
      message,
      style: const TextStyle(color: Colors.white),
    ),
    backgroundColor: backgroundColor,
    duration: duration,
    behavior: SnackBarBehavior.floating,
    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  );

  ScaffoldMessenger.of(context).clearSnackBars(); // Prevent stacking
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
