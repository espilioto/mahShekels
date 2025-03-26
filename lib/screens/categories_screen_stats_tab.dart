import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/category_provider.dart';

class CategoriesStatsTab extends StatelessWidget {
  const CategoriesStatsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryProvider = context.watch<CategoryProvider>();

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Categories Statistics',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Text(
            'Total Categories: ${categoryProvider.categories.length}',
            style: const TextStyle(fontSize: 16),
          ),
          // Add more category-specific stats widgets here
          // For example:
          // const SizedBox(height: 16),
          // Text(
          //   'Most Used Category: ${_getMostUsedCategory(categoryProvider.categories)}',
          //   style: const TextStyle(fontSize: 16),
          // ),
        ],
      ),
    );
  }
}