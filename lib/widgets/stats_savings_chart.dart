import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../models/generic_chart_data_model.dart';
import '../models/stats_savings_chart_data.dart';

class StatsSavingsChart extends StatelessWidget {
  final StatsSavingsChartDataModel chartData;

  const StatsSavingsChart({super.key, required this.chartData});

  @override
  Widget build(BuildContext context) {
    // Ensure all lists have the same length and matching dates
    assert(
      chartData.incomeChart.length == chartData.expensesChart.length &&
          chartData.incomeChart.length == chartData.savingsChart.length,
    );

    return AspectRatio(
      aspectRatio: 1.7,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: true),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(sideTitles: _getBottomTitles()),
            leftTitles: AxisTitles(sideTitles: _getLeftTitles()),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: const Color(0xff37434d)),
          ),
          minX: 0,
          maxX: chartData.incomeChart.length.toDouble() - 1,
          minY: 0,
          maxY: _calculateMaxY(),
          lineBarsData: [
            // Income line
            LineChartBarData(
              spots: _convertToFlSpots(chartData.incomeChart),
              isCurved: true,
              color: Colors.green,
              barWidth: 4,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(show: false),
            ),
            // Expenses line
            LineChartBarData(
              spots: _convertToFlSpots(chartData.expensesChart),
              isCurved: true,
              color: Colors.red,
              barWidth: 4,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(show: false),
            ),
            // Savings line
            LineChartBarData(
              spots: _convertToFlSpots(chartData.savingsChart),
              isCurved: true,
              color: Colors.blue,
              barWidth: 4,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(show: false),
            ),
          ],
        ),
      ),
    );
  }

  double _calculateMaxY() {
    final allValues = [
      ...chartData.incomeChart.map((e) => e.value),
      ...chartData.expensesChart.map((e) => e.value),
      ...chartData.savingsChart.map((e) => e.value),
    ];
    return (allValues.reduce((a, b) => a > b ? a : b).toDouble() *
        1.2); // Add 20% padding
  }

  List<FlSpot> _convertToFlSpots(List<GenericChartDataModel> data) {
    return data.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.value.toDouble());
    }).toList();
  }

  SideTitles _getBottomTitles() {
    return SideTitles(
      showTitles: true,
      interval: 1,
      getTitlesWidget: (value, meta) {
        final index = value.toInt();
        if (index >= 0 && index < chartData.incomeChart.length) {
          return Text(
            chartData.incomeChart[index].key,
            style: const TextStyle(fontSize: 10),
          );
        }
        return const Text('');
      },
    );
  }

  SideTitles _getLeftTitles() {
    return SideTitles(
      showTitles: true,
      interval: _calculateMaxY() / 5, // Show ~5 labels on Y axis
      getTitlesWidget: (value, meta) {
        return Text(value.toInt().toString());
      },
    );
  }
}
