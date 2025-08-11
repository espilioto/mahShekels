import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/chart_data_provider.dart';
import '../widgets/yearly_breakdown_summary_card.dart';
import 'stats_yearly_breakdown_detail_screen.dart';

class StatsYearlyBreakdownMainScreen extends StatefulWidget {
  final bool ignoreInitsAndTransfers;
  final bool ignoreLoans;

  const StatsYearlyBreakdownMainScreen({
    super.key,
    required this.ignoreInitsAndTransfers,
    required this.ignoreLoans,
  });

  @override
  State<StatsYearlyBreakdownMainScreen> createState() =>
      _StatsYearlyBreakdownMainScreenState();
}

class _StatsYearlyBreakdownMainScreenState
    extends State<StatsYearlyBreakdownMainScreen> {
  Future<void> _refreshData() async {
    await Provider.of<ChartDataProvider>(
      context,
      listen: false,
    ).fetchYearlyBreakdownData(
      widget.ignoreInitsAndTransfers,
      widget.ignoreLoans,
      context
    );
  }

  @override
  Widget build(BuildContext context) {
    final chartDataProvider = context.watch<ChartDataProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Yearly Breakdown')),
      body: _buildContent(chartDataProvider),
    );
  }

  Widget _buildContent(ChartDataProvider provider) {
    if (provider.isLoading && provider.yearlyBreakdownData.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: _refreshData,
      child: _buildListView(provider),
    );
  }

  Widget _buildListView(ChartDataProvider provider) {
    return ListView.separated(
      itemCount: provider.yearlyBreakdownData.length,
      separatorBuilder: (context, index) => const Divider(height: 10),
      itemBuilder: (context, index) {
        final year = provider.yearlyBreakdownData[index];
        return InkWell(
          onTap:
              () => _navigateToDetailScreen(
                context,
                year.year,
                widget.ignoreInitsAndTransfers,
                widget.ignoreLoans,
              ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(child: YearlyBreakdownSummaryCard(year: year)),
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
    int year,
    bool ignoreInitsAndTransfers,
    bool ignoreLoans,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => StatsYearlyBreakdownDetailScreen(
              year: year,
              ignoreInitsAndTransfers: ignoreInitsAndTransfers,
              ignoreLoans: ignoreLoans,
            ),
      ),
    );
  }
}
