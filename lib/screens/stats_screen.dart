import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/stats_monthly_breakdown_main_screen.dart';

import 'stats_category_details_screen.dart';
import 'stats_wealth_pulse_screen.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All of my stats ✨')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildStatsCard(
            context,
            icon: Icons.calendar_month,
            title: 'Monthly Breakdown',
            subtitle: 'View income & expenses by month',
            destination: const StatsMonthlyBreakdownMainScreen(),
          ),
          _buildStatsCard(
            context,
            icon: Icons.monitor_heart,
            title: 'Wealth Pulse',
            subtitle: 'Visualize your overall wealth',
            destination: const StatsWealthPulseScreen(),
          ),
          _buildStatsCard(
            context,
            icon: Icons.donut_large_rounded,
            title: 'Category Details',
            subtitle: 'Drill down into spending categories',
            destination: const StatsCategoryDetailsScreen(),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget destination,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: Icon(icon, size: 32),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination),
        ),
      ),
    );
  }
}
