import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import '../providers/database_provider.dart';
import '../providers/allowance_provider.dart';
import 'package:go_router/go_router.dart';

class HomeLedgerScreen extends ConsumerWidget {
  const HomeLedgerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cycleInfoAsync = ref.watch(currentCycleInfoProvider);
    final transactionsAsync = ref.watch(transactionsProvider);
    final allowanceAsync = ref.watch(allowanceProvider);

    final currencyFormat = NumberFormat.currency(symbol: '₦', decimalDigits: 2);

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
      body: Column(
        children: [
          // Top Header
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
                          "Today's Allowance: ${currencyFormat.format(allowance)}",
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
                return ListView.builder(
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    final tx = transactions[index];
                    final prefix = tx.isIncome ? "[ + ]" : "[ - ]";
                    final color = tx.isIncome ? const Color(0xFF10B981) : const Color(0xFFEF4444);
                    final tagText = tx.tag != null && tx.tag!.isNotEmpty ? " • ${tx.tag}" : " • Untagged";
                    return ListTile(
                      title: Text(
                        "$prefix ${currencyFormat.format(tx.amount)}$tagText",
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.bold,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                      subtitle: Text(
                        DateFormat('MMM d, h:mm a').format(tx.date),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    );
                  },
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
