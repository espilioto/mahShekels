import 'package:flutter/material.dart';
import 'package:mahshekels/widgets/stats_savings_chart.dart';
import 'package:provider/provider.dart';

import '../providers/chart_data_provider.dart';

class StatsSavingsScreen extends StatefulWidget {
  final bool ignoreInitsAndTransfers;
  final bool ignoreLoans;

  const StatsSavingsScreen({
    super.key,
    required this.ignoreInitsAndTransfers,
    required this.ignoreLoans,
  });

  @override
  State<StatsSavingsScreen> createState() =>
      _StatsMonthlyBreakdownMainScreenState();
}

class _StatsMonthlyBreakdownMainScreenState extends State<StatsSavingsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<ChartDataProvider>(context, listen: false);
      provider.fetchSavingsChartData(
        widget.ignoreInitsAndTransfers,
        widget.ignoreLoans,
      ); // Assuming this is an async method
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Jew Chart')),
      body: Consumer<ChartDataProvider>(
        builder: (context, provider, child) {
          if (provider.savingsChartData == null) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (provider.errorMessage != '') {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error: ${provider.errorMessage}'),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed:
                          () => provider.fetchSavingsChartData(
                            widget.ignoreInitsAndTransfers,
                            widget.ignoreLoans,
                          ),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }
          }
          return Column(
            children: [
              StatsSavingsChart(chartData: provider.savingsChartData!),
              const SizedBox(height: 20),
              _buildLegend(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _legendItem(Colors.green, 'Income'),
        const SizedBox(width: 20),
        _legendItem(Colors.red, 'Expenses'),
        const SizedBox(width: 20),
        _legendItem(Colors.blue, 'Savings'),
      ],
    );
  }

  Widget _legendItem(Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 16, height: 16, color: color),
        const SizedBox(width: 4),
        Text(text),
      ],
    );
  }
}
