import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/stats_monthly_breakdown_data_model.dart';

class MonthlySummaryCard extends StatelessWidget {
  final StatsMonthlyBreakdownData month;
  final VoidCallback? onTap;

  const MonthlySummaryCard({super.key, required this.month, this.onTap});

  @override
  Widget build(BuildContext context) {
    final balanceColor =
        month.balance == 0
            ? Colors.white
            : (month.balance > 0 ? Colors.green : Colors.red);
    final textTheme = Theme.of(context).textTheme;
    final isPositive = month.balance >= 0;

    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Month-Year Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        month.monthYear,
                        style: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 10),
                      Icon(
                        isPositive ? Icons.trending_up : Icons.trending_down,
                        color: isPositive ? Colors.green : Colors.red,
                        size: 20,
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: balanceColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      NumberFormat.currency(symbol: '€').format(month.balance),
                      style: textTheme.titleMedium?.copyWith(
                        color: balanceColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              _buildFinancialBar(context, month: month),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFinancialBar(
    BuildContext context, {
    required StatsMonthlyBreakdownData month,
  }) {
    final total = month.income + month.expenses.abs();
    final value = total == 0 ? 0.5 : (month.income / total);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              NumberFormat.currency(symbol: '€').format(month.income),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: month.income > 0 ? Colors.green : Colors.red,
              ),
            ),
            Text(
              NumberFormat.currency(symbol: '€').format(month.expenses),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: month.expenses > 0 ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        LinearProgressIndicator(
          value: value,
          backgroundColor: Colors.red,
          color: Colors.green,
          minHeight: 6,
          borderRadius: BorderRadius.circular(3),
        ),
      ],
    );
  }
}
