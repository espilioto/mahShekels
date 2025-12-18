class StatementRequest {
  final DateTime date;
  final double amount;
  final String description;
  final int categoryId;
  final int accountid;

  StatementRequest({
    required this.date,
    required this.amount,
    required this.description,
    required this.categoryId,
    required this.accountid,
  });

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'amount': amount,
      'description': description,
      'categoryid': categoryId,
      'accountid': accountid,
    };
  }
}
