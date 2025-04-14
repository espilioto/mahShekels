import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/stats_breakdown_data_for_month_data_model.dart';
import '../models/overview_balance_chart_data_model.dart';
import '../models/stats_monthly_breakdown_data_model.dart';

class ChartDataProvider with ChangeNotifier {
  final apiUrl = dotenv.env['API_URL'];

  List<OverviewBalanceChartData> _overviewBalanceChartData = [];
  List<StatsMonthlyBreakdownData> _monthlyBreakdownData = [];
  StatsMonthlyBreakdownForMonthData _monthlyBreakdownDataForMonth =
      StatsMonthlyBreakdownForMonthData();

  bool _isLoading = false;
  String _errorMessage = '';

  List<OverviewBalanceChartData> get overviewBalanceChartData =>
      _overviewBalanceChartData;
  List<StatsMonthlyBreakdownData> get monthlyBreakdownData =>
      _monthlyBreakdownData;
  StatsMonthlyBreakdownForMonthData get monthlyBreakdownDataForMonth =>
      _monthlyBreakdownDataForMonth;

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchMonthlyBreakdownDataForMonth(DateTime date) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('$apiUrl/api/Charts/GetBreakdownDataForMonth?date=$date'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _monthlyBreakdownDataForMonth =
            data
                .map((json) => StatsMonthlyBreakdownForMonthData.fromJson(json))
                .toList();
        _errorMessage = '';
      } else {
        _errorMessage =
            'Failed to load monthly breakdown data: ${response.statusCode}';
      }
    } catch (e) {
      _errorMessage = 'Error fetching monthly breakdown data: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchMonthlyBreakdownData() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('$apiUrl/api/Charts/GetMonthlyBreakdownData'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        _monthlyBreakdownData =
            data
                .map((json) => StatsMonthlyBreakdownData.fromJson(json))
                .toList();
        _errorMessage = '';
      } else {
        _errorMessage =
            'Failed to load monthly breakdown data: ${response.statusCode}';
      }
    } catch (e) {
      _errorMessage = 'Error fetching monthly breakdown data: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchOverviewBalanceChartData() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('$apiUrl/api/Charts/GetOverviewBalanceChartData'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        _overviewBalanceChartData =
            data
                .map((json) => OverviewBalanceChartData.fromJson(json))
                .toList();
        _errorMessage = '';
      } else {
        _errorMessage = 'Failed to load chart data: ${response.statusCode}';
      }
    } catch (e) {
      _errorMessage = 'Error fetching chart data: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
