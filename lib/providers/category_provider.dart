import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

import '../utils/jwt_http_client.dart';
import '../models/category_model.dart';

class CategoryProvider with ChangeNotifier {
  final apiUrl = dotenv.env['API_URL'];
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  List<Category> _categories = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<Category> get categories => _categories;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchCategories(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      final client = JwtHttpClient(context, _secureStorage);
      final response = await client.get(Uri.parse('$apiUrl/api/categories'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        _categories = data.map((json) => Category.fromJson(json)).toList();
        _errorMessage = '';
      } else {
        _errorMessage = 'Failed to load categories: ${response.statusCode}';
      }
    } catch (e) {
      _errorMessage = 'Error fetching categories: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
