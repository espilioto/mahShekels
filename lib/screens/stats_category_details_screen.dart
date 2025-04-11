import 'package:flutter/material.dart';

class StatsCategoryDetailsScreen extends StatefulWidget {
  const StatsCategoryDetailsScreen({super.key});

  @override
  State<StatsCategoryDetailsScreen> createState() =>
      _StatsMonthlyBreakdownMainScreenState();
}

class _StatsMonthlyBreakdownMainScreenState
    extends State<StatsCategoryDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Text('StatsCategoryDetailsScreen'));
  }
}
