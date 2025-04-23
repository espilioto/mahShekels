import 'dart:core';

import '../models/generic_chart_data_model.dart';

class StatsSavingsChartDataModel {
  final List<GenericChartDataModel> incomeChart;
  final List<GenericChartDataModel> expensesChart;
  final List<GenericChartDataModel> savingsChart;

  StatsSavingsChartDataModel({
    required this.incomeChart,
    required this.expensesChart,
    required this.savingsChart,
  });

  factory StatsSavingsChartDataModel.fromJson(Map<String, dynamic> json) {
    return StatsSavingsChartDataModel(
      incomeChart:
          (json['incomeChart'] as List)
              .map((item) => GenericChartDataModel.fromJson(item))
              .toList(),
      expensesChart:
          (json['expensesChart'] as List)
              .map((item) => GenericChartDataModel.fromJson(item))
              .toList(),
      savingsChart:
          (json['savingsChart'] as List)
              .map((item) => GenericChartDataModel.fromJson(item))
              .toList(),
    );
  }
}
