class StatementFilterRequest {
  final List<int>? accountIds;
  final List<int>? categoryIds;
  final DateTime? dateFrom;
  final DateTime? dateTo;
  final double? minAmount;
  final double? maxAmount;
  final String? searchText;

  StatementFilterRequest({
    this.accountIds,
    this.categoryIds,
    this.dateFrom,
    this.dateTo,
    this.minAmount,
    this.maxAmount,
    this.searchText,
  });
}
