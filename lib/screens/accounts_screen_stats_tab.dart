import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/account_provider.dart';

class AccountsStatsTab extends StatelessWidget {
  const AccountsStatsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final accountProvider = context.watch<AccountProvider>();

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Accounts Statistics',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Text(
            'Total Accounts: ${accountProvider.accounts.length}',
            style: const TextStyle(fontSize: 16),
          ),
          // Add more stats widgets here as needed
        ],
      ),
    );
  }
}
