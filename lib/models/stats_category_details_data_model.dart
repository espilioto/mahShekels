import 'dart:core';

import '../models/generic_chart_data_model.dart';

class StatsCategoryDetailsDataModel {
  final List<GenericKeyValueModel> yearAverages;
  final List<GenericKeyValueModel> chartData;

  StatsCategoryDetailsDataModel({
    required this.yearAverages,
    required this.chartData,
  });

  factory StatsCategoryDetailsDataModel.fromJson(Map<String, dynamic> json) {
    return StatsCategoryDetailsDataModel(
      yearAverages:
          (json['yearAverages'] as List)
              .map((item) => GenericKeyValueModel.fromJson(item))
              .toList(),
      chartData:
          (json['chartData'] as List)
              .map((item) => GenericKeyValueModel.fromJson(item))
              .toList(),
    );
  }
}
