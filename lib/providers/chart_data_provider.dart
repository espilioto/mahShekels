import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/overview_balance_chart_data_model.dart';

class ChartDataProvider with ChangeNotifier {
  final apiUrl = dotenv.env['API_URL'];

  List<OverviewBalanceChartData> _overviewBalanceChartData = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<OverviewBalanceChartData> get overviewBalanceChartData =>
      _overviewBalanceChartData;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

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
