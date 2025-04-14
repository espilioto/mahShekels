class StatsMonthlyBreakdownData {
  final String monthYear;
  final num income;
  final num expenses;
  final num balance;

  StatsMonthlyBreakdownData({
    required this.monthYear,
    required this.income,
    required this.expenses,
    required this.balance,
  });

  factory StatsMonthlyBreakdownData.fromJson(Map<String, dynamic> json) {
    return StatsMonthlyBreakdownData(
      monthYear: json['monthYear'],
      income: json['income'],
      expenses: json['expenses'],
      balance: json['balance'],
    );
  }
}
