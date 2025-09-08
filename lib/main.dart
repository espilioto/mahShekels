import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import '../providers/account_provider.dart';
import '../providers/category_provider.dart';
import '../providers/chart_data_provider.dart';
import '../providers/statement_provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Priority: --dart-define (manual override)
  const envFromDefine = String.fromEnvironment('ENV_FILE', defaultValue: '');

  // 2. Fallback: Auto-detect release/debug
  const isProduction = bool.fromEnvironment('dart.vm.product');
  final envFile =
      envFromDefine.isNotEmpty
          ? envFromDefine
          : (isProduction ? '.env.production' : '.env.development');

  // Load the file
  try {
    await dotenv.load(fileName: envFile);
    debugPrint('Environment loaded: $envFile');
  } catch (e) {
    debugPrint('Failed to load $envFile: $e');
    // Fallback or exit gracefully
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AccountProvider()..fetchAccounts(context),
        ),
        ChangeNotifierProvider(
          create: (_) => StatementProvider()..fetchStatements(context),
        ),
        ChangeNotifierProvider(
          create: (_) => CategoryProvider()..fetchCategories(context),
        ),
        ChangeNotifierProvider(
          create:
              (_) =>
                  ChartDataProvider()
                    ..fetchOverviewBalanceChartData(context)
                    ..fetchMonthlyBreakdownData(true, true, context)
                    ..fetchYearlyBreakdownData(true, true, context),
        ),
      ],
      child: MaterialApp(
        title: 'mahShekels',
        theme: ThemeData(colorScheme: ColorScheme.dark()),
        navigatorKey: navigatorKey,
        initialRoute: '/',
        routes: {
          '/': (context) => const LoginScreen(),
          '/home': (context) => const HomeScreen(),
        },
      ),
    );
  }
}
