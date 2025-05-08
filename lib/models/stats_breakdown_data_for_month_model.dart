import '../models/statement_model.dart';
import 'generic_chart_data_model.dart';

class StatsBreakdownDetailData {
  final String title;
  final List<GenericKeyValueModel> donutData;
  final List<Statement> incomeStatements;
  final List<Statement> expenseStatements;
  final num totalIncome;
  final num totalExpenses;
  final num balance;

  StatsBreakdownDetailData({
    required this.title,
    required this.donutData,
    required this.incomeStatements,
    required this.expenseStatements,
    required this.totalIncome,
    required this.totalExpenses,
    required this.balance,
  });

  factory StatsBreakdownDetailData.fromJson(Map<String, dynamic> json) {
    return StatsBreakdownDetailData(
      title: json['title'],
      donutData:
          (json['donutData'] as List)
              .map((item) => GenericKeyValueModel.fromJson(item))
              .toList(),
      incomeStatements:
          (json['incomeStatements'] as List)
              .map((item) => Statement.fromJson(item))
              .toList(),
      expenseStatements:
          (json['expenseStatements'] as List)
              .map((item) => Statement.fromJson(item))
              .toList(),
      totalIncome: json['totalIncome'],
      totalExpenses: json['totalExpenses'],
      balance: json['balance'],
    );
  }
}
