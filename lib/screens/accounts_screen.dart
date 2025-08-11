import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/account_provider.dart';
import '../models/account_model.dart';

class AccountsScreen extends StatefulWidget {
  const AccountsScreen({super.key});

  @override
  State<AccountsScreen> createState() => _AccountsScreenState();
}

class _AccountsScreenState extends State<AccountsScreen> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _refreshData() async {
    await Provider.of<AccountProvider>(
      context,
      listen: false,
    ).fetchAccounts(context);
  }

  @override
  Widget build(BuildContext context) {
    final accountProvider = context.watch<AccountProvider>();

    return RefreshIndicator(
      onRefresh: _refreshData,
      child: _buildContent(accountProvider),
    );
  }

  Widget _buildContent(AccountProvider provider) {
    if (provider.isLoading && provider.accounts.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(provider.errorMessage),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _refreshData, child: const Text('Retry')),
          ],
        ),
      );
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
        decelerationRate: ScrollDecelerationRate.normal,
      ),
      cacheExtent: (provider.accounts.length).toDouble(),
      controller: _scrollController,
      itemCount: provider.accounts.length,
      itemBuilder: (context, index) {
        final statement = provider.accounts[index];
        return _buildAccountCard(statement);
      },
    );
  }

  Widget _buildAccountCard(Account account) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
      child: ListTile(
        contentPadding: const EdgeInsets.all(5),
        title: Text(
          account.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
