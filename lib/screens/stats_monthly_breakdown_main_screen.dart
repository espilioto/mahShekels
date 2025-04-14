import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/chart_data_provider.dart';
import '../widgets/monthly_summary_card.dart';

class StatsMonthlyBreakdownMainScreen extends StatefulWidget {
  const StatsMonthlyBreakdownMainScreen({super.key});

  @override
  State<StatsMonthlyBreakdownMainScreen> createState() =>
      _StatsMonthlyBreakdownMainScreenState();
}

class _StatsMonthlyBreakdownMainScreenState
    extends State<StatsMonthlyBreakdownMainScreen> {
  Future<void> _refreshData() async {
    await Provider.of<ChartDataProvider>(
      context,
      listen: false,
    ).fetchMonthlyBreakdownData();
  }

  @override
  Widget build(BuildContext context) {
    final chartDataProvider = context.watch<ChartDataProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Monthly Breakdown')),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: _buildListView(chartDataProvider),
      ),
    );
  }

  Widget _buildListView(ChartDataProvider provider) {
    if (provider.isLoading && provider.monthlyBreakdownData.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: _refreshData, // Pull-to-refresh
      child: ListView.separated(
        itemCount: provider.monthlyBreakdownData.length,
        separatorBuilder: (context, index) => const Divider(height: 24),
        itemBuilder: (context, index) {
          final month = provider.monthlyBreakdownData[index];
          return MonthlySummaryCard(month: month); // Reuse your card widget
        },
      ),
    );
  }
}
