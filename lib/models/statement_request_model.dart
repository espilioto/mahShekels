class StatementRequest {
  final DateTime date;
  final double amount;
  final String description;
  final String userId;
  final int categoryId;
  final int accountid;

  StatementRequest({
    required this.date,
    required this.amount,
    required this.description,
    required this.userId,
    required this.categoryId,
    required this.accountid,
  });

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'amount': amount,
      'description': description,
      'userid': userId,
      'categoryid': categoryId,
      'accountid': accountid,
    };
  }
}
