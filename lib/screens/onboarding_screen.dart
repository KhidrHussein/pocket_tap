import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import '../models/user_config.dart';
import '../providers/database_provider.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final TextEditingController _controller = TextEditingController();
  int _step = 1;

  String get _currencySymbol {
    var format = NumberFormat.simpleCurrency(locale: Platform.localeName);
    return format.currencySymbol;
  }

  void _saveBudget() async {
    final double? budget = double.tryParse(_controller.text);
    if (budget != null && budget > 0) {
      final isar = await ref.read(isarProvider.future);
      final config = UserConfig()
        ..monthlyBudget = budget
        ..resetDay = 1
        ..isOnboarded = true;
        
      await isar.writeTxn(() async {
        await isar.userConfigs.put(config);
      });
      
      // refresh provider
      ref.invalidate(userConfigProvider);
      
      setState(() {
        _step = 2;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_step == 1) {
      return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),
                Text(
                  "What is your baseline spending limit for this month?",
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                const SizedBox(height: 40),
                TextField(
                  controller: _controller,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  autofocus: true,
                  style: Theme.of(context).textTheme.displayLarge,
                  decoration: InputDecoration(
                    prefixText: _currencySymbol,
                    border: InputBorder.none,
                    hintText: "0",
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: _saveBudget,
                  child: const Text("CONTINUE"),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      // Step 2
      final double budget = double.parse(_controller.text);
      final double daily = budget / 30; // Approximation for onboarding display
      final formattedDaily = NumberFormat.simpleCurrency(locale: Platform.localeName).format(daily);

      return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "You have $formattedDaily to spend today.\nLet's keep it that way.",
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                const SizedBox(height: 40),
                const Text(
                  "Add the PocketTap widget to your home screen for ultra-fast tracking.",
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 60),
                ElevatedButton(
                  onPressed: () {
                    context.go('/ledger');
                  },
                  child: const Text("ENTER APP"),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}
