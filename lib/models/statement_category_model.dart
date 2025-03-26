class StatementCategory {
  final int id;
  final String name;

  StatementCategory({required this.id, required this.name});

  factory StatementCategory.fromJson(Map<String, dynamic> json) {
    return StatementCategory(id: json['id'], name: json['name']);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StatementCategory &&
          runtimeType == other.runtimeType &&
          id == other.id; // Compare only by ID or add other fields

  @override
  int get hashCode => id.hashCode; // Consistent with == implementation
}
