class StatsYearlyBreakdownData {
  final int year;
  final num income;
  final num expenses;
  final num balance;

  StatsYearlyBreakdownData({
    required this.year,
    required this.income,
    required this.expenses,
    required this.balance,
  });

  factory StatsYearlyBreakdownData.fromJson(Map<String, dynamic> json) {
    return StatsYearlyBreakdownData(
      year: json['year'],
      income: json['income'],
      expenses: json['expenses'],
      balance: json['balance'],
    );
  }
}
