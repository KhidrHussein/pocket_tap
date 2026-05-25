import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import '../providers/database_provider.dart';
import '../providers/allowance_provider.dart';
import 'package:go_router/go_router.dart';
import '../models/transaction.dart';
import '../models/user_config.dart';
import 'dart:ui';

class HomeLedgerScreen extends ConsumerWidget {
  const HomeLedgerScreen({super.key});

  List<Widget> _buildListItems(List<Transaction> transactions, BuildContext context, NumberFormat currencyFormat) {
    final List<Widget> items = [];
    String? lastDateStr;

    for (final tx in transactions) {
      final dateStr = DateFormat('MMMM d, yyyy').format(tx.date);
      if (dateStr != lastDateStr) {
        items.add(
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
            child: Text(
              dateStr.toUpperCase(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white54,
                letterSpacing: 1.2,
                fontSize: 12,
              ),
            ),
          ),
        );
        lastDateStr = dateStr;
      }

      final prefix = tx.isIncome ? "[ + ]" : "[ - ]";
      final color = tx.isIncome ? const Color(0xFF10B981) : const Color(0xFFEF4444);
      final tagText = tx.tag != null && tx.tag!.isNotEmpty ? " • ${tx.tag}" : " • Untagged";
      
      items.add(
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          title: Text(
            "$prefix ${currencyFormat.format(tx.amount)}$tagText",
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          subtitle: Text(
            DateFormat('h:mm a').format(tx.date),
            style: Theme.of(context).textTheme.bodySmall,
          ),
        )
      );
    }
    return items;
  }

  void _showRestructureDialog(BuildContext context, WidgetRef ref) {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1F2937), // Dark Gray
          title: const Text("Restructure Budget", style: TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("How much extra do you need this month?", style: TextStyle(color: Colors.white70)),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                autofocus: true,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                decoration: const InputDecoration(
                  hintText: "20000",
                  hintStyle: TextStyle(color: Colors.white24),
                  border: InputBorder.none,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("CANCEL", style: TextStyle(color: Colors.white54)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF10B981)),
              onPressed: () async {
                final amount = double.tryParse(controller.text) ?? 0.0;
                if (amount > 0) {
                  final isar = await ref.read(isarProvider.future);
                  final config = await isar.userConfigs.where().findFirst();
                  if (config != null) {
                    config.monthlyBudget += amount;
                    await isar.writeTxn(() async {
                      await isar.userConfigs.put(config);
                    });
                    ref.invalidate(userConfigProvider);
                    ref.invalidate(allowanceProvider);
                    ref.invalidate(currentCycleInfoProvider);
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  }
                }
              },
              child: const Text("ADD TO BUDGET", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cycleInfoAsync = ref.watch(currentCycleInfoProvider);
    final transactionsAsync = ref.watch(transactionsProvider);
    final allowanceAsync = ref.watch(allowanceProvider);

    final currencyFormat = NumberFormat.simpleCurrency(locale: Platform.localeName);

    return Scaffold(
      appBar: AppBar(
        title: const Text("PocketTap"),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              context.push('/settings');
            },
          )
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.small(
            heroTag: 'dash_expense',
            backgroundColor: const Color(0xFFEF4444),
            onPressed: () => context.push('/entry?type=expense'),
            child: const Icon(Icons.remove, color: Colors.white),
          ),
          const SizedBox(width: 8),
          FloatingActionButton.small(
            heroTag: 'dash_income',
            backgroundColor: const Color(0xFF10B981),
            onPressed: () => context.push('/entry?type=income'),
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ],
      ),
      body: Column(
        children: [
          // Debt Mode Escape Hatch
          allowanceAsync.when(
            data: (allowance) {
              if (allowance < 0) {
                return Container(
                  width: double.infinity,
                  color: const Color(0xFF991B1B), // Darker Red for emphasis
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.warning_amber_rounded, color: Colors.white, size: 28),
                          SizedBox(width: 12),
                          Text("DEBT MODE", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "-${currencyFormat.format(allowance.abs())} to recover",
                        style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF991B1B),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          onPressed: () => _showRestructureDialog(context, ref),
                          child: const Text("RESTRUCTURE BUDGET", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                        ),
                      )
                    ],
                  ),
                );
              }
              return const SizedBox();
            },
            loading: () => const SizedBox(),
            error: (_, __) => const SizedBox(),
          ),

          // Top Header (Normal State)
          Container(
            padding: const EdgeInsets.all(24),
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Theme.of(context).dividerColor)),
            ),
            child: cycleInfoAsync.when(
              data: (info) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Day ${info['elapsedDays']} of ${info['totalDays']}.",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Text(
                      "${currencyFormat.format(info['remainingBudget'])} remaining overall.",
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    const SizedBox(height: 16),
                    allowanceAsync.when(
                      data: (allowance) {
                        return Text(
                          allowance < 0 ? "You are overbudget" : "Today's Allowance: ${currencyFormat.format(allowance)}",
                          style: TextStyle(
                            fontSize: 20,
                            color: allowance < 0 ? const Color(0xFFEF4444) : Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                      loading: () => const CircularProgressIndicator(),
                      error: (_, __) => const Text("Error loading allowance"),
                    ),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Text("Error: $err"),
            ),
          ),
          
          // Ledger
          Expanded(
            child: transactionsAsync.when(
              data: (transactions) {
                if (transactions.isEmpty) {
                  return const Center(child: Text("No transactions yet."));
                }
                
                final listItems = _buildListItems(transactions, context, currencyFormat);
                
                return ListView.builder(
                  itemCount: listItems.length,
                  itemBuilder: (context, index) => listItems[index],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text("Error: $err")),
            ),
          ),
        ],
      ),
    );
  }
}
