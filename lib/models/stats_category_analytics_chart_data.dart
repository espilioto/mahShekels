class StatsCategoryAnalyticsChartData {
  final String date;
  final double amount;

  StatsCategoryAnalyticsChartData({required this.date, required this.amount});

  factory StatsCategoryAnalyticsChartData.fromJson(Map<String, dynamic> json) {
    return StatsCategoryAnalyticsChartData(
      date: json['date'],
      amount: json['amount'],
    );
  }
}
