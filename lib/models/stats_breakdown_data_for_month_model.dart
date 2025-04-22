import '../models/statement_model.dart';
import 'generic_chart_data_model.dart';

class StatsBreakdownForMonthData {
  final String title;
  final List<GenericChartDataModel> donutData;
  final List<Statement> incomeStatements;
  final List<Statement> expenseStatements;
  final num totalIncome;
  final num totalExpenses;
  final num balance;

  StatsBreakdownForMonthData({
    required this.title,
    required this.donutData,
    required this.incomeStatements,
    required this.expenseStatements,
    required this.totalIncome,
    required this.totalExpenses,
    required this.balance,
  });

  factory StatsBreakdownForMonthData.fromJson(Map<String, dynamic> json) {
    return StatsBreakdownForMonthData(
      title: json['title'],
      donutData:
          (json['donutData'] as List)
              .map((item) => GenericChartDataModel.fromJson(item))
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
