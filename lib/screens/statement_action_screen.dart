import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/action_type_enum.dart';
import '../models/statement_model.dart';
import '../models/statement_request_model.dart';
import '../providers/account_provider.dart';
import '../providers/category_provider.dart';
import '../providers/statement_provider.dart';

class StatementFormActionScreen extends StatefulWidget {
  final ActionType action;
  final Statement? statement;

  const StatementFormActionScreen({
    super.key,
    required this.action,
    this.statement,
  });

  @override
  State<StatementFormActionScreen> createState() => _StatementFormScreenState();
}

class _StatementFormScreenState extends State<StatementFormActionScreen> {
  final _formKey = GlobalKey<FormState>();
  late int _id;
  DateTime _selectedDate = DateTime.now().toUtc();
  int? _selectedAccountId;
  int? _selectedCategoryId;

  late TextEditingController _amountController;
  late TextEditingController _descriptionController;

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
    _descriptionController = TextEditingController();

    if (widget.action == ActionType.create) {
      // Initialize with first account/category if available
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final accountProvider = Provider.of<AccountProvider>(
          context,
          listen: false,
        );
        final categoryProvider = Provider.of<CategoryProvider>(
          context,
          listen: false,
        );

        if (accountProvider.accounts.isNotEmpty) {
          _selectedAccountId = accountProvider.accounts.first.id;
        }
        if (categoryProvider.categories.isNotEmpty) {
          _selectedCategoryId = categoryProvider.categories.first.id;
        }

        if (mounted) setState(() {});
      });
    } else if (widget.statement != null &&
        (widget.action == ActionType.edit ||
            widget.action == ActionType.duplicate)) {
      _id = widget.statement!.id;
      _selectedDate = widget.statement!.date;
      _selectedAccountId = widget.statement!.account.id;
      _selectedCategoryId = widget.statement!.category.id;

      _amountController = TextEditingController(
        text: widget.statement!.amount.toStringAsFixed(2),
      );
      _descriptionController = TextEditingController(
        text: widget.statement!.description,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    late String title;
    if (widget.action == ActionType.create) {
      title = 'Add Statement';
    } else if (widget.action == ActionType.edit) {
      title = 'Edit Statement';
    } else if (widget.action == ActionType.duplicate) {
      title = 'Duplicate Statement';
    }

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: _buildFormContent(),
      bottomNavigationBar: _buildBottomSaveButton(),
    );
  }

  Widget _buildBottomSaveButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50), // Full width
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: _submitForm,
        child: const Text('SAVE', style: TextStyle(fontSize: 18)),
      ),
    );
  }

  Widget _buildFormContent() {
    final accountProvider = Provider.of<AccountProvider>(context);
    final categoryProvider = Provider.of<CategoryProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            //datepicker
            InkWell(
              onTap: () => _selectDate(context),
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Date',
                  border: OutlineInputBorder(),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(DateFormat.yMMMMd().add_jm().format(_selectedDate)),
                    const Icon(Icons.calendar_today),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Amount Field
            TextFormField(
              controller: _amountController,
              decoration: const InputDecoration(
                labelText: 'Amount',
                prefixText: '€ ',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Enter amount';
                if (double.tryParse(value) == null) return 'Invalid amount';
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Account Dropdown
            DropdownButtonFormField<int>(
              value: _selectedAccountId,
              decoration: const InputDecoration(
                labelText: 'Account',
                border: OutlineInputBorder(),
              ),
              items:
                  accountProvider.accounts
                      .map(
                        (account) => DropdownMenuItem(
                          value: account.id,
                          child: Text(account.name),
                        ),
                      )
                      .toList(),
              onChanged:
                  (accountId) => setState(() => _selectedAccountId = accountId),
              validator: (value) => value == null ? 'Select an account' : null,
            ),

            const SizedBox(height: 16),

            // Category Dropdown
            DropdownButtonFormField<int>(
              value: _selectedCategoryId,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
              items:
                  categoryProvider.categories
                      .map(
                        (category) => DropdownMenuItem(
                          value: category.id,
                          child: Text(category.name),
                        ),
                      )
                      .toList(),
              onChanged:
                  (categoryId) =>
                      setState(() => _selectedCategoryId = categoryId),
              validator: (value) => value == null ? 'Select a category' : null,
            ),

            const SizedBox(height: 16),

            // description Field
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate;

    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          child: SizedBox(
            height: 400,
            child: CalendarDatePicker(
              initialDate: _selectedDate,
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
              currentDate: DateTime.now(),
              onDateChanged: (date) {
                pickedDate = date;
                Navigator.pop(context); // Close dialog immediately
              },
            ),
          ),
        );
      },
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() => _selectedDate = pickedDate!);
    }
  }

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      final statementToSubmit = StatementRequest(
        date: _selectedDate,
        amount: double.tryParse(_amountController.text) ?? 0.0,
        description: _descriptionController.text,
        userId: '1', //TODO update when auth is done
        categoryId: _selectedCategoryId!,
        accountid: _selectedAccountId!,
      );

      final statementProvider = Provider.of<StatementProvider>(
        context,
        listen: false,
      );

      late ({bool success, String message}) result;

      if (widget.action == ActionType.create ||
          widget.action == ActionType.duplicate) {
        result = await statementProvider.postStatement(statementToSubmit);
      } else if (widget.action == ActionType.edit) {
        result = await statementProvider.updateStatement(
          context,
          _id,
          statementToSubmit
        );
      }

      Fluttertoast.showToast(
        msg: result.message,
        toastLength: result.success ? Toast.LENGTH_SHORT : Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: result.success ? Colors.green : Colors.red,
        textColor: Colors.white,
      );

      if (result.success && mounted) {
        statementProvider.fetchStatements(context);
      }
    }
  }
}
