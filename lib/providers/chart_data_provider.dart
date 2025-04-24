import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/stats_breakdown_data_for_month_model.dart';
import '../models/generic_chart_data_model.dart';
import '../models/stats_category_details_data_model.dart';
import '../models/stats_monthly_breakdown_data_model.dart';
import '../models/stats_savings_data_model.dart';

class ChartDataProvider with ChangeNotifier {
  final apiUrl = dotenv.env['API_URL'];

  List<GenericKeyValueModel> _overviewBalanceChartData = [];
  List<StatsMonthlyBreakdownData> _monthlyBreakdownData = [];
  StatsSavingsDataModel? _savingsChartData;

  bool _isLoading = false;
  String _errorMessage = '';

  List<GenericKeyValueModel> get overviewBalanceChartData =>
      _overviewBalanceChartData;
  List<StatsMonthlyBreakdownData> get monthlyBreakdownData =>
      _monthlyBreakdownData;
  StatsSavingsDataModel? get savingsChartData => _savingsChartData;

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<StatsCategoryDetailsDataModel?> fetchCategoryAnalyticsChartData(
    int categoryId,
  ) async {
    _isLoading = true;
    // Schedule the notification for the next frame instead of immediate
    Future.microtask(() => notifyListeners());

    try {
      final response = await http.get(
        Uri.parse(
          '$apiUrl/api/Charts/GetCategoryAnalyticsChartData?categoryId=$categoryId',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        var result = StatsCategoryDetailsDataModel.fromJson(data);
        _errorMessage = '';
        return result;
      } else {
        _errorMessage =
            'Failed to load category analytics chart data: ${response.statusCode}';
        return null;
      }
    } catch (e) {
      _errorMessage = 'Error fetching category analytics chart data: $e';
      return null;
    } finally {
      _isLoading = false;
      // Again, schedule for next frame
      Future.microtask(() => notifyListeners());
    }
  }

  Future<StatsBreakdownForMonthData?> fetchMonthlyBreakdownDataForMonth(
    int month,
    int year,
    bool ignoreInitsAndTransfers,
    bool ignoreLoans,
  ) async {
    _isLoading = true;
    // Schedule the notification for the next frame instead of immediate
    Future.microtask(() => notifyListeners());

    try {
      final response = await http.get(
        Uri.parse(
          '$apiUrl/api/Charts/GetBreakdownDataForMonth?month=$month&year=$year&ignoreInitsAndTransfers=$ignoreInitsAndTransfers&ignoreloans=$ignoreLoans',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final result = StatsBreakdownForMonthData.fromJson(data);
        _errorMessage = '';
        return result;
      } else {
        _errorMessage =
            'Failed to load monthly breakdown data: ${response.statusCode}';
        return null;
      }
    } catch (e) {
      _errorMessage = 'Error fetching monthly breakdown data: $e';
      return null;
    } finally {
      _isLoading = false;
      // Again, schedule for next frame
      Future.microtask(() => notifyListeners());
    }
  }

  Future<void> fetchMonthlyBreakdownData(
    bool ignoreInitsAndTransfers,
    bool ignoreLoans,
  ) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse(
          '$apiUrl/api/Charts/GetMonthlyBreakdownData?ignoreInitsAndTransfers=$ignoreInitsAndTransfers&ignoreloans=$ignoreLoans',
        ),
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
            data.map((json) => GenericKeyValueModel.fromJson(json)).toList();
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

  Future<void> fetchSavingsChartData(
    bool ignoreInitsAndTransfers,
    bool ignoreLoans,
  ) async {
    _isLoading = true;
    Future.microtask(() => notifyListeners());

    try {
      final response = await http.get(
        Uri.parse(
          '$apiUrl/api/Charts/GetSavingsRateChartData?ignoreInitsAndTransfers=$ignoreInitsAndTransfers&ignoreloans=$ignoreLoans',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        _savingsChartData = StatsSavingsDataModel.fromJson(data);
        _errorMessage = '';
      } else {
        _errorMessage =
            'Failed to load savings chart data: ${response.statusCode}';
      }
    } catch (e) {
      _errorMessage = 'Error fetching savings chart data: $e';
    } finally {
      _isLoading = false;
      Future.microtask(() => notifyListeners());
    }
  }
}
