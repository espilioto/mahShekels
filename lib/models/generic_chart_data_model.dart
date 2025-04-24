class GenericKeyValueModel {
  final String key;
  final num value;

  GenericKeyValueModel({required this.key, required this.value});

  factory GenericKeyValueModel.fromJson(Map<String, dynamic> json) {
    return GenericKeyValueModel(key: json['key'], value: json['value']);
  }
}
