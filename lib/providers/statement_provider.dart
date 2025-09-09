import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

import '../models/statement_filter_model.dart';
import '../models/statement_request_model.dart';
import '../models/statement_model.dart';
import '../models/statement_sorting_request.dart';
import '../utils/jwt_http_client.dart';

class StatementProvider with ChangeNotifier {
  final apiUrl = dotenv.env['API_URL'];
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  bool _isLoading = false;
  String _errorMessage = '';

  List<Statement> _allStatements = [];
  List<Statement> _filteredStatements = [];
  StatementFilterRequest _filters = StatementFilterRequest();
  StatementSortingRequest _sorting = StatementSortingRequest();

  List<Statement> get statements => _filteredStatements;
  StatementFilterRequest get filters => _filters;
  StatementSortingRequest get sorting => _sorting;

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchStatements(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      final client = JwtHttpClient(context, _secureStorage);
      final response = await client.get(Uri.parse('$apiUrl/api/statements'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        _allStatements = data.map((json) => Statement.fromJson(json)).toList();
        _applyFilters();
        _errorMessage = '';
      } else {
        _errorMessage = 'Failed to load statements: ${response.statusCode}';
      }
    } catch (e) {
      _errorMessage = 'Error fetching statements: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void updateFilters(StatementFilterRequest newFilters) {
    _filters = newFilters;
    _applyFilters();
  }

  void updateSorting(StatementSortingRequest newSorting) {
    _sorting = newSorting;
    _applyFilters();
  }

  void _applyFilters() {
    _filteredStatements =
        _allStatements.where((statement) {
          if (_filters.accountIds != null &&
              _filters.accountIds!.isNotEmpty &&
              !_filters.accountIds!.contains(statement.account.id)) {
            return false;
          }

          if (_filters.categoryIds != null &&
              _filters.categoryIds!.isNotEmpty &&
              !_filters.categoryIds!.contains(statement.category.id)) {
            return false;
          }

          if (_filters.dateFrom != null &&
              statement.date.isBefore(_filters.dateFrom!)) {
            return false;
          }
          if (_filters.dateTo != null &&
              statement.date.isAfter(_filters.dateTo!)) {
            return false;
          }

          if (_filters.minAmount != null &&
              statement.amount.abs() < _filters.minAmount!) {
            return false;
          }
          if (_filters.maxAmount != null &&
              statement.amount.abs() > _filters.maxAmount!) {
            return false;
          }

          if (_filters.searchText != null &&
              _filters.searchText!.isNotEmpty &&
              !statement.description.toLowerCase().contains(
                _filters.searchText!.toLowerCase(),
              )) {
            return false;
          }

          return true;
        }).toList();

    _filteredStatements.sort((a, b) {
      final compare =
          _sorting.sortBy == 'amount'
              ? a.amount.compareTo(b.amount)
              : a.date.compareTo(b.date);

      return _sorting.direction == 'desc' ? -compare : compare;
    });

    notifyListeners();
  }

  Future<({bool success, String message})> deleteStatement(
    BuildContext context,
    int statementId,
  ) async {
    _isLoading = true;
    notifyListeners();

    try {
      final client = JwtHttpClient(context, _secureStorage);
      final response = await client.delete(
        Uri.parse('$apiUrl/api/statements/$statementId'),
      );

      if (response.statusCode == 204) {
        _errorMessage = '';
        _isLoading = false;
        return (success: true, message: 'Statement deleted! 🗑️');
      } else {
        final errorData = json.decode(response.body);
        _errorMessage = errorData['message'] ?? 'Failed to delete statement';
        return (success: false, message: _errorMessage);
      }
    } catch (e) {
      _errorMessage = 'Error deleting statement: $e';
      return (success: false, message: _errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<({bool success, String message})> postStatement(
    BuildContext context,
    StatementRequest statement,
  ) async {
    _isLoading = true;
    notifyListeners();

    try {
      final client = JwtHttpClient(context, _secureStorage);
      final response = await client.post(
        Uri.parse('$apiUrl/api/statements'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(statement),
      );

      if (response.statusCode == 201) {
        _errorMessage = '';
        _isLoading = false;
        return (success: true, message: 'Statement created! 👌');
      } else {
        final errorData = json.decode(response.body);
        _errorMessage = errorData['message'] ?? 'Failed to create statement';
        return (success: false, message: _errorMessage);
      }
    } catch (e) {
      _errorMessage = 'Error creating statement: $e';
      return (success: false, message: _errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<({bool success, String message})> updateStatement(
    BuildContext context,
    int statementId,
    StatementRequest statement,
  ) async {
    _isLoading = true;
    notifyListeners();

    try {
      final client = JwtHttpClient(context, _secureStorage);
      final response = await client.put(
        Uri.parse('$apiUrl/api/statements/$statementId'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(statement.toJson()),
      );

      if (response.statusCode == 200) {
        _errorMessage = '';
        await fetchStatements(context);
        return (success: true, message: 'Statement updated successfully');
      } else {
        final errorData = json.decode(response.body);
        _errorMessage = errorData['message'] ?? 'Failed to update statement';
        return (success: false, message: _errorMessage);
      }
    } catch (e) {
      _errorMessage = 'Error updating statement: $e';
      return (success: false, message: _errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<({bool success, String message})> markAllUncheckedNow(
    BuildContext context,
  ) async {
    _isLoading = true;
    notifyListeners();

    try {
      final client = JwtHttpClient(context, _secureStorage);
      final response = await client.put(
        Uri.parse('$apiUrl/api/statements/markAllUncheckedNow'),
      );

      if (response.statusCode == 200) {
        _errorMessage = '';
        _isLoading = false;
        return (success: true, message: 'Statements checked! ✅');
      } else {
        final errorData = json.decode(response.body);
        _errorMessage = errorData['message'] ?? 'Failed to check statements';
        return (success: false, message: _errorMessage);
      }
    } catch (e) {
      _errorMessage = 'Error checking statements: $e';
      return (success: false, message: _errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
