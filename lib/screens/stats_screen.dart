import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/stats_monthly_breakdown_main_screen.dart';

import 'stats_category_details_screen.dart';
import 'stats_wealth_pulse_screen.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (context) => const StatsMonthlyBreakdownMainScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Center(
                child: Text(
                  'All of my stats ✨',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            ListTile(
              title: const Row(
                children: [
                  Icon(Icons.calendar_month),
                  SizedBox(width: 10),
                  Text('Monthly breakdown'),
                ],
              ),
              onTap: () {
                Navigator.pop(context); // Close drawer
                _navigatorKey.currentState?.pushReplacement(
                  MaterialPageRoute(
                    builder:
                        (context) => const StatsMonthlyBreakdownMainScreen(),
                  ),
                );
              },
            ),
            ListTile(
              title: const Row(
                children: [
                  Icon(Icons.monitor_heart),
                  SizedBox(width: 10),
                  Text('Wealth Pulse'),
                ],
              ),
              onTap: () {
                Navigator.pop(context); // Close drawer
                _navigatorKey.currentState?.pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const StatsWealthPulseScreen(),
                  ),
                );
              },
            ),
            ListTile(
              title: const Row(
                children: [
                  Icon(Icons.donut_large_rounded),
                  SizedBox(width: 10),
                  Text('Category details'),
                ],
              ),
              onTap: () {
                Navigator.pop(context); // Close drawer
                _navigatorKey.currentState?.pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const StatsCategoryDetailsScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: Navigator(
        key: _navigatorKey,
        onGenerateRoute: (settings) {
          // Fallback for initial route (empty screen)
          return MaterialPageRoute(
            builder: (context) => const SizedBox.shrink(),
          );
        },
      ),
    );
  }
}
