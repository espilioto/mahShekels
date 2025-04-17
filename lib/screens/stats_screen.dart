import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/chart_data_provider.dart';
import 'stats_monthly_breakdown_main_screen.dart';
import 'stats_category_details_screen.dart';
import 'stats_wealth_pulse_screen.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  bool _ignoreInitsAndTransfers = true; // Default value set to true
  bool _ignoreLoans = true; // Default value for ignore loans is false

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All of my stats ✨'),
        actions: [
          PopupMenuButton<int>(
            tooltip: 'Ignore filters',
            onSelected: (value) {
              setState(() {
                if (value == 1) {
                  _ignoreInitsAndTransfers = !_ignoreInitsAndTransfers;
                } else if (value == 2) {
                  _ignoreLoans = !_ignoreLoans;
                }

                Provider.of<ChartDataProvider>(
                  context,
                  listen: false,
                ).fetchMonthlyBreakdownData(
                  _ignoreInitsAndTransfers,
                  _ignoreLoans,
                );
              });
            },
            itemBuilder:
                (context) => [
                  CheckedPopupMenuItem(
                    value: 1,
                    checked: _ignoreInitsAndTransfers,
                    child: const Text('Ignore initial filter'),
                  ),
                  CheckedPopupMenuItem(
                    value: 2,
                    checked: _ignoreLoans,
                    child: const Text('Ignore loans'),
                  ),
                ],
            icon: const Icon(Icons.filter_alt),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildStatsCard(
            context,
            icon: Icon(Icons.calendar_month, color: Colors.blueAccent, size: 32,),
            title: 'Monthly Breakdown',
            subtitle: 'View income & expenses by month',
            destination: StatsMonthlyBreakdownMainScreen(
              ignoreInitsAndTransfers: _ignoreInitsAndTransfers,
              ignoreLoans: _ignoreLoans,
            ),
          ),
          _buildStatsCard(
            context,
            icon: Icon(Icons.monitor_heart, color: Colors.red, size: 32,),
            title: 'Jew Pulse',
            subtitle: 'Visualize your savings rate',
            destination: StatsWealthPulseScreen(),
          ),
          _buildStatsCard(
            context,
            icon: Icon(Icons.donut_large_rounded, color: Colors.amber, size: 32,),
            title: 'Category Details',
            subtitle: 'Drill down into spending categories',
            destination: StatsCategoryDetailsScreen(),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard(
    BuildContext context, {
    required Icon icon,
    required String title,
    required String subtitle,
    required Widget destination,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: icon,
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => destination),
            ),
      ),
    );
  }
}
