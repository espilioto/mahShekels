import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/generic_chart_data_model.dart';
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
  int? _selectedCategoryId; // Track the selected category object
  late Future<List<GenericChartDataModel>?> _chartDataFuture;

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
              child: DropdownButton<int>(
                value: _selectedCategoryId,
                hint: const Text('Categories'),
                items: [
                  ...categories.map(
                    (category) => DropdownMenuItem(
                      value: category.id,
                      child: Row(children: [Text(category.name)]),
                    ),
                  ),
                ],
                onChanged: (int? categoryId) {
                  setState(() {
                    if (categoryId != null) {
                      _selectedCategoryId = categoryId;
                    } else {
                      _selectedCategoryId = null;
                    }

                    _chartDataFuture = chartDataProvider
                        .fetchCategoryAnalyticsChartData(_selectedCategoryId!);
                  });
                },
              ),
            ),
          ],
        ),
      ),
      body:
          _selectedCategoryId == null
              ? const Center(child: Text('Select a category'))
              : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: FutureBuilder<List<GenericChartDataModel>?>(
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
