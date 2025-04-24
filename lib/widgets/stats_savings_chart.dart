import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../models/generic_chart_data_model.dart';
import '../models/stats_savings_data_model.dart';

class StatsSavingsChart extends StatelessWidget {
  final StatsSavingsDataModel chartData;

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
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipItems: (List<LineBarSpot> touchedSpots) {
                if (touchedSpots.isEmpty) return [];

                // Get data from the first valid spot
                final spot = touchedSpots.first;
                final xIndex = spot.x.toInt();
                final date = chartData.incomeChart[xIndex].key;
                final incomeValue = chartData.incomeChart[xIndex].value;
                final expensesValue = chartData.expensesChart[xIndex].value;
                final savingsValue = chartData.savingsChart[xIndex].value;

                // Create just ONE tooltip item but return it for all spots
                return touchedSpots.asMap().entries.map((entry) {
                  final index = entry.key;

                  // Only show content for the first entry
                  if (index == 0) {
                    return LineTooltipItem(
                      '',
                      const TextStyle(color: Colors.white),
                      children: [
                        TextSpan(
                          text: '$date\n',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: 'Income: $incomeValue€\n',
                          style: const TextStyle(color: Colors.green),
                        ),
                        TextSpan(
                          text: 'Expenses: $expensesValue€\n',
                          style: const TextStyle(color: Colors.red),
                        ),
                        TextSpan(
                          text: 'Savings: $savingsValue€',
                          style: const TextStyle(color: Colors.blue),
                        ),
                      ],
                    );
                  } else {
                    // Return empty tooltip for other entries
                    return null;
                  }
                }).toList();
              },
            ),
            handleBuiltInTouches: true,
          ),
          lineBarsData: [
            // Income line
            LineChartBarData(
              spots: _convertToFlSpots(chartData.incomeChart),
              isCurved: true,
              color: Colors.green,
              barWidth: 2,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(show: false),
            ),
            // Expenses line
            LineChartBarData(
              spots: _convertToFlSpots(chartData.expensesChart),
              isCurved: true,
              color: Colors.red,
              barWidth: 2,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(show: false),
            ),
            // Savings line
            LineChartBarData(
              spots: _convertToFlSpots(chartData.savingsChart),
              isCurved: true,
              color: Colors.blue,
              barWidth: 2,
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
