import 'statement_account_model.dart';
import 'statement_category_model.dart';

class Statement {
  final int id;
  final DateTime date;
  final double amount;
  final String description;
  final String? userId;
  final DateTime? checkedAt;
  final StatementCategory category;
  final StatementAccount account;

  Statement({
    required this.id,
    required this.date,
    required this.amount,
    required this.description,
    required this.userId,
    required this.category,
    required this.account,
    required this.checkedAt,
  });

  factory Statement.fromJson(Map<String, dynamic> json) {
    return Statement(
      id: json['id'],
      date: DateTime.parse(json['date']),
      amount: json['amount'],
      description: json['description'],
      userId: json['userId'],
      checkedAt: json['checkedAt'] != null ? DateTime.parse(json['checkedAt']) : null,
      category: StatementCategory.fromJson(json['category']),
      account: StatementAccount.fromJson(json['account']),
    );
  }
}
