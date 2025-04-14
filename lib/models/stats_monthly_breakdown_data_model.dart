class StatsMonthlyBreakdownData {
  final String monthYear;
  final int month;
  final int year;
  final num income;
  final num expenses;
  final num balance;

  StatsMonthlyBreakdownData({
    required this.monthYear,
    required this.month,
    required this.year,
    required this.income,
    required this.expenses,
    required this.balance,
  });

  factory StatsMonthlyBreakdownData.fromJson(Map<String, dynamic> json) {
    return StatsMonthlyBreakdownData(
      monthYear: json['monthYear'],
      month: json['month'],
      year: json['year'],
      income: json['income'],
      expenses: json['expenses'],
      balance: json['balance'],
    );
  }
}
