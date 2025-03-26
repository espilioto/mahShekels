import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '/models/category_model.dart';

class CategoryProvider with ChangeNotifier {
  final apiUrl = dotenv.env['API_URL'];

  List<Category> _categories = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<Category> get categories => _categories;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchCategories() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse('$apiUrl/api/categories'));
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
