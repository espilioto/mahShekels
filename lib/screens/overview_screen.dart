import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/category_provider.dart';
import '../providers/chart_data_provider.dart';
import '../widgets/donut_chart_with_legend_for_accounts.dart';
import '../widgets/overview_balance_line_chart.dart';
import '../providers/account_provider.dart';

class OverviewScreen extends StatefulWidget {
  const OverviewScreen({super.key});

  @override
  State<OverviewScreen> createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  @override
  Widget build(BuildContext context) {
    final accountProvider = context.watch<AccountProvider>();
    final chartDataProvider = context.watch<ChartDataProvider>();
    final categoryProvider = context.watch<CategoryProvider>();

    return Scaffold(
      body: generateOverview(accountProvider, chartDataProvider),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          accountProvider.fetchAccounts(context);
          chartDataProvider.fetchOverviewBalanceChartData(context);
          categoryProvider.fetchCategories(context);
        },
        child: Icon(Icons.refresh),
      ),
    );
  }

  Widget generateOverview(
    AccountProvider accountProvider,
    ChartDataProvider chartDataProvider,
  ) {
    return Column(
      children: [
        Expanded(
          flex: 33,
          child:
              accountProvider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : AccountsDonutChart(accounts: accountProvider.accounts),
        ),
        Expanded(
          flex: 33,
          child:
              chartDataProvider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : OverviewBalanceLineChart(
                    chartData: chartDataProvider.overviewBalanceChartData,
                  ),
        ),
        Expanded(
          flex: 33,
          child: ListView.builder(
            itemCount: accountProvider.accounts.length,
            itemBuilder: (context, index) {
              final account = accountProvider.accounts[index];
              return ListTile(
                dense: true,
                visualDensity: VisualDensity.compact,
                subtitle: Text('${account.name} (${account.balance}€)'),
              );
            },
          ),
        ),
      ],
    );
  }
}
