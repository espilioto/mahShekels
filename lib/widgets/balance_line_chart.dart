import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../models/overview_balance_chart_data_model.dart';

class BalanceLineChart extends StatelessWidget {
  final List<OverviewBalanceChartData> chartData;

  const BalanceLineChart({super.key, required this.chartData});

  @override
  Widget build(BuildContext context) {
    if (chartData.isEmpty) {
      return Center(child: Text('No data'));
    }

    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: true),
        titlesData: FlTitlesData(
          topTitles: AxisTitles(),
          bottomTitles: AxisTitles(),
          leftTitles: AxisTitles(),
        ),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (List<LineBarSpot> touchedSpots) {
              return touchedSpots.map((spot) {
                final monthBalance = chartData[spot.x.toInt()];
                return LineTooltipItem(
                  '${monthBalance.date}\n${spot.y.toStringAsFixed(0)}€',
                  const TextStyle(color: Colors.white),
                );
              }).toList();
            },
          ),
          handleBuiltInTouches: true,
        ),
        lineBarsData: [
          LineChartBarData(
            spots:
                chartData.asMap().entries.map((entry) {
                  return FlSpot(entry.key.toDouble(), entry.value.balance);
                }).toList(),
            isCurved: false,
            color:
                Colors.primaries[math.Random().nextInt(
                  Colors.primaries.length,
                )],
            barWidth: 3,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color:
                  Colors.primaries[math.Random().nextInt(
                    Colors.primaries.length,
                  )],
            ),
          ),
        ],
      ),
    );
  }
}
