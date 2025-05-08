import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/stats_breakdown_data_for_month_model.dart';
import '../providers/chart_data_provider.dart';
import '../models/statement_model.dart';
import '../widgets/donut_chart_with_legend_for_monthly_breakdown.dart';
import '../utils/extensions.dart';

class StatsYearlyBreakdownDetailScreen extends StatefulWidget {
  final int year;
  final bool ignoreInitsAndTransfers;
  final bool ignoreLoans;

  const StatsYearlyBreakdownDetailScreen({
    super.key,
    required this.year,
    required this.ignoreInitsAndTransfers,
    required this.ignoreLoans,
  });

  @override
  State<StatsYearlyBreakdownDetailScreen> createState() =>
      _StatsYearlyBreakdownDetailScreenState();
}

class _StatsYearlyBreakdownDetailScreenState
    extends State<StatsYearlyBreakdownDetailScreen> {
  late Future<StatsBreakdownDetailData?> _monthDataFuture;
  late ChartDataProvider _chartDataProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _chartDataProvider = Provider.of<ChartDataProvider>(context, listen: false);
    _monthDataFuture = _chartDataProvider.fetchBreakdownDataForYear(
      widget.year,
      widget.ignoreInitsAndTransfers,
      widget.ignoreLoans,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.year.toString())),
      body: FutureBuilder<StatsBreakdownDetailData?>(
        future: _monthDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || snapshot.data == null) {
            return Center(child: Text('Error loading data: ${snapshot.error}'));
          }

          final monthData = snapshot.data!;
          return _buildDetailContent(monthData);
        },
      ),
    );
  }

  Widget _buildDetailContent(StatsBreakdownDetailData monthData) {
    final sortedDonutData = List.of(monthData.donutData)
      ..sort((a, b) => a.value.compareTo(b.value));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          MonthlyBreakdownDonutChart(data: sortedDonutData),

          const SizedBox(height: 24),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildTotalCard(
                'Income',
                monthData.totalIncome,
                Colors.green,
                Theme.of(context).textTheme.bodySmall,
              ),
              _buildTotalCard(
                'Balance',
                monthData.balance,
                monthData.balance >= 0 ? Colors.green : Colors.red,
                Theme.of(context).textTheme.bodyLarge,
              ),
              _buildTotalCard(
                'Expenses',
                monthData.totalExpenses,
                Colors.red,
                Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),

          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 16),

          // Statements Section
          Text('Transactions', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Income Column
              Expanded(
                child: Column(
                  children: [
                    Text(
                      'Income',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    ...monthData.incomeStatements.map(
                      (statement) => _buildStatementItem(statement, true),
                    ),
                  ],
                ),
              ),

              // Expenses Column
              Expanded(
                child: Column(
                  children: [
                    Text(
                      'Expenses',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    ...monthData.expenseStatements.map(
                      (statement) => _buildStatementItem(statement, false),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTotalCard(
    String title,
    num amount,
    Color color,
    TextStyle? style,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(title, style: style),
            Text(
              amount.toStringAsFixed(2),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatementItem(Statement statement, bool isIncome) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        dense: true,
        title: Text(statement.description),
        subtitle: Text(
          DateFormat('dd MMMM').format(statement.date),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: Column(
          children: [
            Text(
              statement.category.name.breakOnSpace(),
              maxLines: 2,
              overflow: TextOverflow.fade,
            ),
            Text(
              isIncome ? '+${statement.amount}' : '${statement.amount}',
              style: TextStyle(
                color: isIncome ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              statement.account.name.breakOnSpace(),
              maxLines: 2,
              overflow: TextOverflow.fade,
            ),
          ],
        ),
      ),
    );
  }
}
