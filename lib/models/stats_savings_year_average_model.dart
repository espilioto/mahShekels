class StatsSavingsYearAverageModel {
  final String year;
  final num incomeAmount;
  final num expensesAmount;
  final num savingsAmount;
  final num savingsPercent;

  StatsSavingsYearAverageModel({
    required this.year,
    required this.incomeAmount,
    required this.expensesAmount,
    required this.savingsAmount,
    required this.savingsPercent,
  });

  factory StatsSavingsYearAverageModel.fromJson(Map<String, dynamic> json) {
    return StatsSavingsYearAverageModel(
      year: json['year'],
      incomeAmount: json['incomeAmount'],
      expensesAmount: json['expensesAmount'],
      savingsAmount: json['savingsAmount'],
      savingsPercent: json['savingsPercent'],
    );
  }
}
