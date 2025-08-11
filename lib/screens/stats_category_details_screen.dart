import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/generic_chart_data_model.dart';
import '../models/stats_category_details_data_model.dart';
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
  late Future<StatsCategoryDetailsDataModel?> _screenDataFuture;

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

                    _screenDataFuture = chartDataProvider
                        .fetchCategoryAnalyticsChartData(_selectedCategoryId!, context);
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
                  child: FutureBuilder<StatsCategoryDetailsDataModel?>(
                    future: _screenDataFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }

                      if (snapshot.data == null ||
                          snapshot.data!.yearSums.isEmpty) {
                        return const Center(child: Text('No data available'));
                      }

                      return Column(
                        children: [
                          StatsCategoryAnalyticsChart(
                            chartData: snapshot.data!.chartData,
                          ),
                          SizedBox(height: 30),
                          _buildAveragesDataTable(snapshot.data!.yearSums),
                        ],
                      );
                    },
                  ),
                ),
              ),
    );
  }

  _buildAveragesDataTable(List<GenericKeyValueModel> data) {
    return Column(
      children: [
        Text('Yearly sums', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 20),
        DataTable(
          columnSpacing: 0,
          horizontalMargin: 10,
          headingRowHeight: 40,
          columns: [
            DataColumn(
              label: Text(
                'Year',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            DataColumn(
              label: Text(
                'Amount',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              numeric: true,
            ),
          ],
          rows:
              data.map((yearSum) {
                return DataRow(
                  cells: [
                    DataCell(
                      SizedBox(
                        width: 65,
                        child: Text(yearSum.key, textAlign: TextAlign.center),
                      ),
                    ),
                    DataCell(
                      SizedBox(
                        width: 85,
                        child: Text(
                          '${yearSum.value.toStringAsFixed(0)}€',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
        ),
      ],
    );
  }
}
