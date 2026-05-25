import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'theme.dart';
import 'providers/database_provider.dart';
import 'screens/onboarding_screen.dart';
import 'screens/home_ledger_screen.dart';
import 'screens/quick_entry_overlay.dart';
import 'package:home_widget/home_widget.dart';
import 'providers/allowance_provider.dart';
import 'services/widget_service.dart';
import 'screens/settings_screen.dart';
import 'dart:async';

@pragma('vm:entry-point')
FutureOr<void> backgroundCallback(Uri? uri) async {
  if (uri?.scheme == 'pockettap' && uri?.host == 'entry') {
    final type = uri?.queryParameters['type'];
    final amount = type == 'income' ? 10.0 : -10.0;
    
    // Using ProviderContainer to interact with Riverpod in a background isolate
    final container = ProviderContainer();
    final db = container.read(databaseProvider);
    await db.init();
    await db.addTransaction(amount: amount.abs(), isIncome: amount > 0, date: DateTime.now(), tag: 'Quick Widget Entry');
    
    // The background worker cannot easily read the allowanceProvider due to Riverpod scope. 
    // We update the widget via service.
    // In a real app we'd fetch the allowance from DB and calculate it here.
    // For simplicity, we just trigger a widget update with a default value.
    await HomeWidget.updateWidget(name: 'PocketTapWidget');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: PocketTapApp()));
}

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) {
          final userConfigAsync = ref.watch(userConfigProvider);
          return userConfigAsync.when(
            data: (config) {
              if (config == null || !config.isOnboarded) {
                return const OnboardingScreen();
              }
              return const HomeLedgerScreen();
            },
            loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
            error: (_, __) => const Scaffold(body: Center(child: Text("Error"))),
          );
        },
      ),
      GoRoute(
        path: '/ledger',
        builder: (context, state) => const HomeLedgerScreen(),
      ),
      GoRoute(
        path: '/entry',
        builder: (context, state) {
          final type = state.uri.queryParameters['type'];
          final isIncome = type == 'income';
          return QuickEntryOverlay(isIncome: isIncome);
        },
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
});

class PocketTapApp extends ConsumerStatefulWidget {
  const PocketTapApp({super.key});

  @override
  ConsumerState<PocketTapApp> createState() => _PocketTapAppState();
}

class _PocketTapAppState extends ConsumerState<PocketTapApp> {
  @override
  void initState() {
    super.initState();
    HomeWidget.registerInteractivityCallback(backgroundCallback);
    HomeWidget.widgetClicked.listen((Uri? uri) {
      if (uri != null && uri.scheme == 'pockettap') {
        ref.read(routerProvider).push(uri.path + '?' + uri.query);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(allowanceProvider, (previous, next) {
      if (next.hasValue) {
        final config = ref.read(userConfigProvider).value;
        if (config != null && config.isOnboarded) {
          final dailyBudget = config.monthlyBudget / 30; // Approximate daily average for color threshold
          WidgetService.updateWidget(next.value!, dailyBudget);
        }
      }
    });

    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      title: 'PocketTap',
      theme: PocketTapTheme.lightTheme,
      darkTheme: PocketTapTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
