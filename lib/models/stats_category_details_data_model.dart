import 'dart:core';

import '../models/generic_chart_data_model.dart';

class StatsCategoryDetailsDataModel {
  final List<GenericKeyValueModel> yearSums;
  final List<GenericKeyValueModel> chartData;

  StatsCategoryDetailsDataModel({
    required this.yearSums,
    required this.chartData,
  });

  factory StatsCategoryDetailsDataModel.fromJson(Map<String, dynamic> json) {
    return StatsCategoryDetailsDataModel(
      yearSums:
          (json['yearSums'] as List)
              .map((item) => GenericKeyValueModel.fromJson(item))
              .toList(),
      chartData:
          (json['chartData'] as List)
              .map((item) => GenericKeyValueModel.fromJson(item))
              .toList(),
    );
  }
}
