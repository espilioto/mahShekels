import 'dart:math' as math;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../models/generic_chart_data_model.dart';

class StatsCategoryAnalyticsChart extends StatelessWidget {
  final List<GenericKeyValueModel> chartData;

  const StatsCategoryAnalyticsChart({super.key, required this.chartData});

  @override
  Widget build(BuildContext context) {
    if (chartData.isEmpty) {
      return const Center(child: Text('No data available'));
    }

    return AspectRatio(
      aspectRatio: 0.8,
      child: Padding(
        padding: const EdgeInsets.only(right: 16),
        child: LineChart(
          LineChartData(
            minX: 0,
            maxX: (chartData.length - 1).toDouble(),
            minY: 0,
            maxY: chartData.map((e) => e.value).reduce(math.max) * 1.1,
            gridData: const FlGridData(show: true),
            titlesData: FlTitlesData(
              rightTitles: const AxisTitles(),
              topTitles: const AxisTitles(),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    if (value.toInt() < chartData.length) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Transform.rotate(
                          angle: -45,
                          child: Text(
                            chartData[value.toInt()].key,
                            style: const TextStyle(fontSize: 10),
                          ),
                        ),
                      );
                    }
                    return const Text('');
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    return Text(value.toInt().toString());
                  },
                ),
              ),
            ),
            borderData: FlBorderData(show: true),
            lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                getTooltipItems: (List<LineBarSpot> touchedSpots) {
                  return touchedSpots.map((spot) {
                    final data = chartData[spot.x.toInt()];
                    return LineTooltipItem(
                      '${data.key}\n${data.value.toStringAsFixed(2)}€',
                      const TextStyle(color: Colors.white),
                    );
                  }).toList();
                },
              ),
            ),
            lineBarsData: [
              LineChartBarData(
                spots:
                    chartData.asMap().entries.map((entry) {
                      return FlSpot(
                        entry.key.toDouble(),
                        entry.value.value.toDouble(),
                      );
                    }).toList(),
                isCurved: false,
                color:
                    Colors.primaries[Random().nextInt(Colors.primaries.length)],
                barWidth: 3,
                isStrokeCapRound: true,
                dotData: const FlDotData(show: false),
                belowBarData: BarAreaData(
                  show: true,
                  color: Colors
                      .primaries[Random().nextInt(Colors.primaries.length)]
                      .withAlpha(80),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
