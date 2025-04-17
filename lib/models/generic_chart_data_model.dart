class GenericChartDataModel {
  final String key;
  final num value;

  GenericChartDataModel({required this.key, required this.value});

  factory GenericChartDataModel.fromJson(Map<String, dynamic> json) {
    return GenericChartDataModel(
      key: json['key'],
      value: json['value'],
    );
  }
}
