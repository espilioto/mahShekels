import 'dart:core';

import '../models/stats_savings_year_average_model.dart';
import '../models/generic_chart_data_model.dart';

class StatsSavingsDataModel {
  final List<StatsSavingsYearAverageModel> yearAverage;
  final List<GenericKeyValueModel> incomeChart;
  final List<GenericKeyValueModel> expensesChart;
  final List<GenericKeyValueModel> savingsChart;

  StatsSavingsDataModel({
    required this.yearAverage,
    required this.incomeChart,
    required this.expensesChart,
    required this.savingsChart,
  });

  factory StatsSavingsDataModel.fromJson(Map<String, dynamic> json) {
    return StatsSavingsDataModel(
      yearAverage:
          (json['averagesPerYear'] as List)
              .map((item) => StatsSavingsYearAverageModel.fromJson(item))
              .toList(),
      incomeChart:
          (json['incomeChart'] as List)
              .map((item) => GenericKeyValueModel.fromJson(item))
              .toList(),
      expensesChart:
          (json['expensesChart'] as List)
              .map((item) => GenericKeyValueModel.fromJson(item))
              .toList(),
      savingsChart:
          (json['savingsChart'] as List)
              .map((item) => GenericKeyValueModel.fromJson(item))
              .toList(),
    );
  }
}
