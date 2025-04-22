import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../utils/extensions.dart';
import '../models/generic_chart_data_model.dart';
import 'donut_chart_indicator.dart';

class MonthlyBreakdownDonutChart extends StatelessWidget {
  final List<GenericChartDataModel> data;

  const MonthlyBreakdownDonutChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.8,
      child: Row(
        children: <Widget>[
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: PieChart(
                PieChartData(
                  borderData: FlBorderData(show: false),
                  sectionsSpace: 1,
                  centerSpaceRadius: 40,
                  startDegreeOffset: -90,
                  sections: createDonutSections(data),
                ),
              ),
            ),
          ),
          createLegend(data.take(8).toList()),
          const SizedBox(width: 10),
        ],
      ),
    );
  }

  Column createLegend(List<GenericChartDataModel> donutSectionData) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          donutSectionData.asMap().entries.map((sectionData) {
            return Indicator(
              color: List<Color>.from(Colors.primaries)[sectionData.key],
              text:
                  sectionData.value.key.length > 25
                      ? sectionData.value.key.truncateWithEllipsis(15)
                      : sectionData.value.key,
              isSquare: true,
            );
          }).toList(),
    );
  }

  List<PieChartSectionData> createDonutSections(
    List<GenericChartDataModel> donutSectionData,
  ) {
    final totalExpenses = donutSectionData.fold(
      0.0,
      (sum, account) => sum + account.value.abs(),
    );

    return List.generate(donutSectionData.length, (index) {
      final sectionData = donutSectionData[index];
      final percentage =
          totalExpenses > 0
              ? (sectionData.value.abs() / totalExpenses * 100)
              : 0;

      return PieChartSectionData(
        color: List<Color>.from(Colors.primaries)[index],
        value: sectionData.value.toDouble(),
        title:
            percentage > 7
                ? '${sectionData.value.abs().toStringAsFixed(0)}€\n(${percentage.toStringAsFixed(0)}%)'
                : '',
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    });
  }
}
