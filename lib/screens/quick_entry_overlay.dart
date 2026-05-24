import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:ui';
import '../models/transaction.dart';
import '../providers/database_provider.dart';

class QuickEntryOverlay extends ConsumerStatefulWidget {
  final bool isIncome;
  const QuickEntryOverlay({super.key, required this.isIncome});

  @override
  ConsumerState<QuickEntryOverlay> createState() => _QuickEntryOverlayState();
}

class _QuickEntryOverlayState extends ConsumerState<QuickEntryOverlay> {
  final TextEditingController _controller = TextEditingController();

  void _submit() async {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      SystemNavigator.pop();
      return;
    }

    final parts = text.split(' ');
    final amountStr = parts.first;
    final double? amount = double.tryParse(amountStr);

    if (amount != null && amount > 0) {
      final tag = parts.length > 1 ? parts.sublist(1).join(' ') : null;

      final isar = await ref.read(isarProvider.future);
      final tx = Transaction()
        ..amount = amount
        ..isIncome = widget.isIncome
        ..tag = tag
        ..date = DateTime.now();

      await isar.writeTxn(() async {
        await isar.transactions.put(tx);
      });

      ref.invalidate(transactionsProvider);
    }

    SystemNavigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.6), // Translucent background
      body: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                color: widget.isIncome ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                width: double.infinity,
                child: Text(
                  widget.isIncome ? "ADD INCOME" : "ADD EXPENSE",
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _controller,
                  autofocus: true,
                  style: Theme.of(context).textTheme.displayMedium,
                  decoration: const InputDecoration(
                    hintText: "4000 food",
                    border: InputBorder.none,
                  ),
                  onSubmitted: (_) => _submit(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
