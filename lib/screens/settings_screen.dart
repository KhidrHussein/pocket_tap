import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/database_provider.dart';
import '../models/user_config.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _budgetController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final config = ref.read(userConfigProvider).value;
      if (config != null) {
        _budgetController.text = config.monthlyBudget.toStringAsFixed(2);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Monthly Allowance", style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            TextField(
              controller: _budgetController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                prefixText: "₦ ",
                border: OutlineInputBorder(),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () async {
                  final amount = double.tryParse(_budgetController.text) ?? 0.0;
                  if (amount > 0) {
                    final isar = await ref.read(isarProvider.future);
                    var config = await isar.userConfigs.where().findFirst();
                    if (config == null) {
                      config = UserConfig()..resetDay = 1..isOnboarded = true;
                    }
                    config.monthlyBudget = amount;
                    
                    await isar.writeTxn(() async {
                      await isar.userConfigs.put(config!);
                    });
                    
                    ref.invalidate(userConfigProvider);
                    if (context.mounted) {
                      context.pop();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Settings Saved")));
                    }
                  }
                },
                child: const Text("Save & Restart Cycle"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
