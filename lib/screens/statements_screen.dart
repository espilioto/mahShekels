import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:vibration/vibration.dart';

import '../models/statement_category_model.dart';
import '../models/statement_account_model.dart';
import '../models/action_type_enum.dart';
import '../models/statement_filter_model.dart';
import '../models/statement_model.dart';
import '../models/statement_sorting_request.dart';
import '../providers/statement_provider.dart';
import '../screens/statement_action_screen.dart';

class StatementsScreen extends StatefulWidget {
  const StatementsScreen({super.key});

  @override
  State<StatementsScreen> createState() => _StatementsScreenState();
}

class _StatementsScreenState extends State<StatementsScreen> {
  final _scrollController = ScrollController();
  final _dateFormat = DateFormat('MMM dd, yyyy');
  final _searchController = TextEditingController();
  DateTimeRange? _dateRange;
  double? _minAmount, _maxAmount;
  final List<int> _selectedAccountIds = [];
  final List<int> _selectedCategoryIds = [];

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refreshData() async {
    await Provider.of<StatementProvider>(
      context,
      listen: false,
    ).fetchStatements(context);
  }

  Future<void> _pickDateRange(BuildContext context) async {
    final initialDateRange =
        _dateRange ??
        DateTimeRange(
          start: DateTime.now().subtract(const Duration(days: 30)),
          end: DateTime.now(),
        );

    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDateRange: initialDateRange,
    );

    if (picked != null) {
      setState(() => _dateRange = picked);
      _applyFilters();
    }
  }

  void _applyFilters() {
    final provider = Provider.of<StatementProvider>(context, listen: false);

    provider.updateFilters(
      StatementFilterRequest(
        dateFrom: _dateRange?.start,
        dateTo: _dateRange?.end,
        minAmount: _minAmount,
        maxAmount: _maxAmount,
        searchText:
            _searchController.text.isNotEmpty ? _searchController.text : null,
        accountIds:
            _selectedAccountIds.isNotEmpty
                ? _selectedAccountIds.toList()
                : null,
        categoryIds:
            _selectedCategoryIds.isNotEmpty
                ? _selectedCategoryIds.toList()
                : null,
      ),
    );
  }

  void _clearFilters() {
    setState(() {
      _dateRange = null;
      _minAmount = null;
      _maxAmount = null;
      _searchController.clear();
      _selectedAccountIds.clear();
      _selectedCategoryIds.clear();
    });
    _applyFilters();
  }

  @override
  Widget build(BuildContext context) {
    final statementProvider = context.watch<StatementProvider>();
    final accounts =
        statementProvider.statements.map((s) => s.account).toSet().toList();
    final categories =
        statementProvider.statements.map((s) => s.category).toSet().toList();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed:
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (_) => StatementFormActionScreen(action: ActionType.create),
              ),
            ),
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            DropdownButtonHideUnderline(
              child: DropdownButton<StatementAccount>(
                menuWidth: 200,
                items: [
                  const DropdownMenuItem(value: null, child: Text('Accounts')),
                  ...accounts.map(
                    (account) => DropdownMenuItem(
                      value: account,
                      child: Row(
                        children: [
                          _selectedAccountIds.contains(account.id)
                              ? const Icon(Icons.check, size: 20)
                              : const SizedBox(width: 20),
                          Text(account.name),
                        ],
                      ),
                    ),
                  ),
                ],
                onChanged: (StatementAccount? account) {
                  setState(() {
                    if (account == null) {
                      _selectedAccountIds.clear();
                    } else if (_selectedAccountIds.contains(account.id)) {
                      _selectedAccountIds.remove(account.id);
                    } else {
                      _selectedAccountIds.add(account.id);
                    }
                    _applyFilters();
                  });
                },
              ),
            ),

            DropdownButtonHideUnderline(
              child: DropdownButton<StatementCategory>(
                items: [
                  const DropdownMenuItem(
                    value: null,
                    child: Text('Categories'),
                  ),
                  ...categories.map(
                    (category) => DropdownMenuItem(
                      value: category,
                      child: Row(
                        children: [
                          _selectedCategoryIds.contains(category.id)
                              ? const Icon(Icons.check, size: 20)
                              : const SizedBox(width: 20),
                          Text(category.name),
                        ],
                      ),
                    ),
                  ),
                ],
                onChanged: (StatementCategory? category) {
                  setState(() {
                    if (category == null) {
                      _selectedCategoryIds.clear();
                    } else if (_selectedCategoryIds.contains(category.id)) {
                      _selectedCategoryIds.remove(category.id);
                    } else {
                      _selectedCategoryIds.add(category.id);
                    }
                    _applyFilters();
                  });
                },
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: () => _showFilterDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.filter_alt_off),
            onPressed: () => _clearFilters(),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: _buildContent(statementProvider),
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    final statementProvider = context.watch<StatementProvider>();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    ////////////////////////////////////////// Sorting options
                    'Sort by:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const SizedBox(height: 28),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Date ascending
                      IconButton(
                        icon: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.calendar_today),
                            Icon(Icons.arrow_upward, size: 16),
                          ],
                        ),
                        onPressed: () {
                          statementProvider.updateSorting(
                            StatementSortingRequest(
                              sortBy: 'date',
                              direction: 'asc',
                            ),
                          );
                        },
                      ),

                      // Date descending
                      IconButton(
                        icon: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.calendar_today),
                            Icon(Icons.arrow_downward, size: 16),
                          ],
                        ),
                        onPressed: () {
                          statementProvider.updateSorting(
                            StatementSortingRequest(
                              sortBy: 'date',
                              direction: 'desc',
                            ),
                          );
                        },
                      ),

                      // Amount ascending
                      IconButton(
                        icon: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.attach_money),
                            Icon(Icons.arrow_upward, size: 16),
                          ],
                        ),
                        onPressed: () {
                          statementProvider.updateSorting(
                            StatementSortingRequest(
                              sortBy: 'amount',
                              direction: 'asc',
                            ),
                          );
                        },
                      ),

                      // Amount descending
                      IconButton(
                        icon: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.attach_money),
                            Icon(Icons.arrow_downward, size: 16),
                          ],
                        ),
                        onPressed: () {
                          statementProvider.updateSorting(
                            StatementSortingRequest(
                              sortBy: 'amount',
                              direction: 'desc',
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 56),
                  const Text(
                    /////////////////////////////////////////////// filters
                    'Filters:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const SizedBox(height: 28),
                  TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      labelText: 'Search text',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    title: Text(
                      _dateRange == null
                          ? 'Select date range'
                          : '${_dateFormat.format(_dateRange!.start)} - ${_dateFormat.format(_dateRange!.end)}',
                    ),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () => _pickDateRange(context),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Min amount',
                            border: OutlineInputBorder(),
                          ),
                          onChanged:
                              (value) => _minAmount = double.tryParse(value),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Max amount',
                            border: OutlineInputBorder(),
                          ),
                          onChanged:
                              (value) => _maxAmount = double.tryParse(value),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: _clearFilters, child: const Text('Clear')),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _applyFilters();
                },
                child: const Text('Apply'),
              ),
            ],
          ),
    );
  }

  Widget _buildContent(StatementProvider provider) {
    if (provider.isLoading && provider.statements.isEmpty) {
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

    return DraggableScrollbar.rrect(
      controller: _scrollController,
      alwaysVisibleScrollThumb: true,
      heightScrollThumb: 48,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
          decelerationRate: ScrollDecelerationRate.normal,
        ),
        cacheExtent: (provider.statements.length / 2).toDouble(),
        controller: _scrollController,
        itemCount: provider.statements.length,
        itemBuilder: (context, index) {
          final statement = provider.statements[index];
          return _buildStatementCard(statement);
        },
      ),
    );
  }

  Widget _buildStatementCard(Statement statement) {
    return GestureDetector(
      onLongPressStart:
          (details) =>
              _showContextMenu(context, statement, details.globalPosition),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
        child: ListTile(
          contentPadding: const EdgeInsets.all(5),
          title: Text(
            statement.description,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(_dateFormat.format(statement.date)),
              Text(statement.category.name),
            ],
          ),
          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${statement.amount.toStringAsFixed(2)}€',
                style: TextStyle(
                  color:
                      statement.amount == 0
                          ? Colors.white
                          : (statement.amount > 0 ? Colors.green : Colors.red),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(statement.account.name, style: TextStyle(fontSize: 11)),
              if (statement.checkedAt != null) Text('Checked: ${DateFormat('d/M/y H:m').format(statement.checkedAt!)} ✅', style: TextStyle(fontSize: 11)),
            ],
          ),
        ),
      ),
    );
  }

  void _showContextMenu(
    BuildContext context,
    Statement statement,
    Offset tapPosition,
  ) async {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    if (await Vibration.hasVibrator()) {
      await Vibration.vibrate(duration: 10);
    }

    final value = await showMenu<ActionType>(
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromLTWH(tapPosition.dx, tapPosition.dy, 40, 40),
        Offset.zero & overlay.size,
      ),
      items: [
        const PopupMenuItem(
          value: ActionType.duplicate,
          child: Row(
            children: [
              Icon(Icons.copy, size: 20),
              SizedBox(width: 8),
              Text('Duplicate'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: ActionType.edit,
          child: Row(
            children: [
              Icon(Icons.edit, size: 20),
              SizedBox(width: 8),
              Text('Edit'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: ActionType.delete,
          child: Row(
            children: [
              Icon(Icons.delete, size: 20, color: Colors.red),
              SizedBox(width: 8),
              Text('Delete'),
            ],
          ),
        ),
      ],
    );

    if (!mounted) return;

    if (value == ActionType.edit) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (_) => StatementFormActionScreen(
                action: ActionType.edit,
                statement: statement,
              ),
        ),
      );
    } else if (value == ActionType.duplicate) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (_) => StatementFormActionScreen(
                action: ActionType.duplicate,
                statement: statement,
              ),
        ),
      );
    } else if (value == ActionType.delete) {
      final deleteResult = await _confirmDelete(statement.id);

      if (mounted) {
        Fluttertoast.showToast(
          msg: deleteResult.message,
          toastLength:
              deleteResult.success ? Toast.LENGTH_SHORT : Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: deleteResult.success ? Colors.green : Colors.red,
          textColor: Colors.white,
        );

        if (deleteResult.success) {
          await _refreshData();
        }
      }
    }
  }

  Future<({bool success, String message})> _confirmDelete(
    int statementId,
  ) async {
    late ({bool success, String message}) result;

    await showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text('This will permanently delete the statement'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  result = await Provider.of<StatementProvider>(
                    context,
                    listen: false,
                  ).deleteStatement(context, statementId);
                  Navigator.pop(ctx);
                },
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );

    return result;
  }
}
