import 'package:flutter/material.dart';




class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key}); // added const

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("History Page")); // more useful than Placeholder
  }
}

