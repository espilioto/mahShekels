import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/statement_category_model.dart';
import '../models/stats_category_analytics_chart_data.dart';
import '../providers/chart_data_provider.dart';
import '../providers/statement_provider.dart';
import '../widgets/stats_category_analytics_chart.dart';

class StatsCategoryDetailsScreen extends StatefulWidget {
  const StatsCategoryDetailsScreen({super.key});

  @override
  State<StatsCategoryDetailsScreen> createState() =>
      _StatsMonthlyBreakdownMainScreenState();
}

class _StatsMonthlyBreakdownMainScreenState
    extends State<StatsCategoryDetailsScreen> {
  int _selectedCategoryId = -1;
  late Future<List<StatsCategoryAnalyticsChartData>?> _chartDataFuture;

  @override
  Widget build(BuildContext context) {
    final statementProvider = context.watch<StatementProvider>();
    final chartDataProvider = context.watch<ChartDataProvider>();

    final categories =
        statementProvider.statements.map((s) => s.category).toSet().toList();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            DropdownButtonHideUnderline(
              child: DropdownButton<StatementCategory>(
                items: [
                  const DropdownMenuItem(
                    value: null,
                    child: Text('Categories'),
                  ),
                  ...categories.map(
                    (category) => DropdownMenuItem(
                      value: category,
                      child: Row(
                        children: [
                          _selectedCategoryId == category.id
                              ? const Icon(Icons.check, size: 20)
                              : const SizedBox(width: 20),
                          Text(category.name),
                        ],
                      ),
                    ),
                  ),
                ],
                onChanged: (StatementCategory? category) {
                  setState(() {
                    if (category != null) {
                      _selectedCategoryId = category.id;
                    }

                    _chartDataFuture = chartDataProvider
                        .fetchCategoryAnalyticsChartData(_selectedCategoryId);
                  });
                },
              ),
            ),
          ],
        ),
      ),
      body:
          _selectedCategoryId == -1
              ? Center(child: Text('Select a category'))
              : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: FutureBuilder<List<StatsCategoryAnalyticsChartData>?>(
                    future: _chartDataFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }

                      if (snapshot.data == null || snapshot.data!.isEmpty) {
                        return const Center(child: Text('No data available'));
                      }

                      return StatsCategoryAnalyticsChart(
                        chartData: snapshot.data!,
                      );
                    },
                  ),
                ),
              ),
    );
  }
}
