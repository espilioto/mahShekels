import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/account_model.dart';

class AccountProvider with ChangeNotifier {
  final apiUrl = dotenv.env['API_URL'];

  List<Account> _accounts = [];

  bool _isLoading = false;
  String _errorMessage = '';

  List<Account> get accounts => _accounts;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchAccounts() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse('$apiUrl/api/accounts'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        _accounts = data.map((json) => Account.fromJson(json)).toList();
        _errorMessage = '';
      } else {
        _errorMessage = 'Failed to load accounts: ${response.statusCode}';
      }
    } catch (e) {
      _errorMessage = 'Error fetching accounts: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
