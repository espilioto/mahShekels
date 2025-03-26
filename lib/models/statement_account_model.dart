class StatementAccount {
  final int id;
  final String name;

  StatementAccount({required this.id, required this.name});

  factory StatementAccount.fromJson(Map<String, dynamic> json) {
    return StatementAccount(id: json['id'], name: json['name']);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StatementAccount &&
          runtimeType == other.runtimeType &&
          id == other.id; // Compare only by ID or add other fields

  @override
  int get hashCode => id.hashCode; // Consistent with == implementation
}
