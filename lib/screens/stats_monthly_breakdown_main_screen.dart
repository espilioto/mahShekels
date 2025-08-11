import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/chart_data_provider.dart';
import '../widgets/monthly_breakdown_summary_card.dart';
import 'stats_monthly_breakdown_detail_screen.dart';

class StatsMonthlyBreakdownMainScreen extends StatefulWidget {
  final bool ignoreInitsAndTransfers;
  final bool ignoreLoans;

  const StatsMonthlyBreakdownMainScreen({
    super.key,
    required this.ignoreInitsAndTransfers,
    required this.ignoreLoans,
  });

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
    ).fetchMonthlyBreakdownData(
      widget.ignoreInitsAndTransfers,
      widget.ignoreLoans,
      context
    );
  }

  @override
  Widget build(BuildContext context) {
    final chartDataProvider = context.watch<ChartDataProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Monthly Breakdown')),
      body: _buildContent(chartDataProvider),
    );
  }

  Widget _buildContent(ChartDataProvider provider) {
    if (provider.isLoading && provider.monthlyBreakdownData.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: _refreshData,
      child: _buildListView(provider),
    );
  }

  Widget _buildListView(ChartDataProvider provider) {
    return ListView.separated(
      itemCount: provider.monthlyBreakdownData.length,
      separatorBuilder: (context, index) => const Divider(height: 10),
      itemBuilder: (context, index) {
        final month = provider.monthlyBreakdownData[index];
        return InkWell(
          onTap:
              () => _navigateToDetailScreen(
                context,
                month.month,
                month.year,
                widget.ignoreInitsAndTransfers,
                widget.ignoreLoans,
              ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(child: MonthlyBreakdownSummaryCard(month: month)),
                const Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
          ),
        );
      },
    );
  }

  void _navigateToDetailScreen(
    BuildContext context,
    int month,
    int year,
    bool ignoreInitsAndTransfers,
    bool ignoreLoans,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => StatsMonthlyBreakdownDetailScreen(
              month: month,
              year: year,
              ignoreInitsAndTransfers: ignoreInitsAndTransfers,
              ignoreLoans: ignoreLoans,
            ),
      ),
    );
  }
}
