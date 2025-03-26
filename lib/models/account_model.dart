class Account {
  final int id;
  final String name;
  final double balance;
  final String colorHex;

  Account({
    required this.id,
    required this.name,
    required this.balance,
    required this.colorHex,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'],
      name: json['name'],
      balance: json['balance'],
      colorHex: json['colorHex'],
    );
  }
}
