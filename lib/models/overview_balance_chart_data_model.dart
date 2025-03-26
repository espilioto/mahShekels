class OverviewBalanceChartData {
  final String date;
  final double balance;

  OverviewBalanceChartData({required this.date, required this.balance});

  factory OverviewBalanceChartData.fromJson(Map<String, dynamic> json) {
    return OverviewBalanceChartData(
      date: json['date'],
      balance: json['balance'],
    );
  }
}
