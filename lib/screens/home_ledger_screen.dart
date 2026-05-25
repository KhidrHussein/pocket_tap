import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import '../providers/database_provider.dart';
import '../providers/allowance_provider.dart';
import 'package:go_router/go_router.dart';
import '../models/transaction.dart';
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
