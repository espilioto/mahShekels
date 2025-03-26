import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../utils/hex_color.dart';
import 'donut_chart_indicator.dart';
import '../models/account_model.dart';

class AccountsDonutChart extends StatelessWidget {
  final List<Account> accounts;

  const AccountsDonutChart({super.key, required this.accounts});

  @override
  Widget build(BuildContext context) {
    if (accounts.isEmpty) {
      return Center(child: Text('No accounts'));
    }

    return AspectRatio(
      aspectRatio: 1.8,
      child: Row(
        children: <Widget>[
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: PieChart(
                PieChartData(
                  borderData: FlBorderData(show: false),
                  sectionsSpace: 1,
                  centerSpaceRadius: 40,
                  startDegreeOffset: -90,
                  sections: createDonutSections(accounts),
                ),
              ),
            ),
          ),
          createLegend(accounts),
          const SizedBox(width: 10),
        ],
      ),
    );
  }

  Column createLegend(List<Account> accounts) {
    accounts.sort((a, b) => b.balance.compareTo(a.balance));
    final totalBalance = accounts.fold(
      0.0,
      (sum, account) => sum + account.balance,
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          accounts.map((account) {
            final percentage =
                totalBalance > 0 ? (account.balance / totalBalance * 100) : 0;

            return Indicator(
              color: HexColor.fromHex(account.colorHex),
              text: '${account.name} (${percentage.toStringAsFixed(1)}%)',
              isSquare: true,
            );
          }).toList(),
    );
  }

  List<PieChartSectionData> createDonutSections(List<Account> accounts) {
    accounts.sort((a, b) => b.balance.compareTo(a.balance));
    final totalBalance = accounts.fold(
      0.0,
      (sum, account) => sum + account.balance,
    );

    return List.generate(accounts.length, (index) {
      final account = accounts[index];
      final percentage =
          totalBalance > 0 ? (account.balance / totalBalance * 100) : 0;

      return PieChartSectionData(
        color: HexColor.fromHex(accounts[index].colorHex),
        value: account.balance,
        title: percentage > 3 ? '${percentage.toStringAsFixed(1)}%' : '',
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    });
  }
}
