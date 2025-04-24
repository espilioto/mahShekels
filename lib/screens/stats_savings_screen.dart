import 'package:flutter/material.dart';
import 'package:mahshekels/models/stats_savings_data_model.dart';
import 'package:mahshekels/models/stats_savings_year_average_model.dart';
import 'package:mahshekels/widgets/donut_chart_indicator.dart';
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
      );
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
              const SizedBox(height: 30),
              _buildChart(provider.savingsChartData!),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 20),
              Expanded(
                // Add Expanded here
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: _buildAveragesDataTable(provider.savingsChartData!),
                ),
              ),
              const SizedBox(height: 30),
            ],
          );
        },
      ),
    );
  }

  _buildChart(StatsSavingsDataModel chartData) {
    return Column(
      children: [
        StatsSavingsChart(chartData: chartData),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Indicator(
              color: Colors.green,
              text: 'Income',
              isSquare: true,
              textStyle: TextStyle(),
            ),
            const SizedBox(width: 20),
            Indicator(
              color: Colors.red,
              text: 'Expenses',
              isSquare: true,
              textStyle: TextStyle(),
            ),
            const SizedBox(width: 20),
            Indicator(
              color: Colors.blue,
              text: 'Savings',
              isSquare: true,
              textStyle: TextStyle(),
            ),
          ],
        ),
      ],
    );
  }

  _buildAveragesDataTable(StatsSavingsDataModel data) {
    return Column(
      children: [
        Text('Yearly averages', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 20),
        DataTable(
          columnSpacing: 0,
          horizontalMargin: 10,
          headingRowHeight: 40,
          columns: [
            DataColumn(
              label: SizedBox(
                width: 65,
                child: Text(
                  'Year',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            DataColumn(
              label: SizedBox(
                width: 85,
                child: Text(
                  'Income',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              numeric: true,
            ),
            DataColumn(
              label: SizedBox(
                width: 85,
                child: Text(
                  'Expenses',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              numeric: true,
            ),
            DataColumn(
              label: SizedBox(
                width: 85,
                child: Text(
                  'Savings',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              numeric: true,
            ),
            DataColumn(
              label: SizedBox(
                width: 64,
                child: Text(
                  'Saved %',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              numeric: true,
            ),
          ],
          rows:
              data.yearAverage.map((summary) {
                return DataRow(
                  cells: [
                    DataCell(
                      SizedBox(
                        width: 65,
                        child: Text(summary.year, textAlign: TextAlign.center),
                      ),
                    ),
                    DataCell(
                      SizedBox(
                        width: 85,
                        child: Text(
                          '${summary.incomeAmount.toStringAsFixed(0)}€',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    DataCell(
                      SizedBox(
                        width: 85,
                        child: Text(
                          '${summary.expensesAmount.toStringAsFixed(0)}€',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    DataCell(
                      SizedBox(
                        width: 85,
                        child: Text(
                          '${summary.savingsAmount.toStringAsFixed(0)}€',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    DataCell(
                      SizedBox(
                        width: 64,
                        child: Text(
                          '${summary.savingsPercent.toStringAsFixed(0)}%',
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
