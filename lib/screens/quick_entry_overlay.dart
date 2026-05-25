import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:ui';
import '../models/transaction.dart';
import '../providers/database_provider.dart';
import '../providers/allowance_provider.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:home_widget/home_widget.dart';
import '../services/widget_service.dart';
import 'package:go_router/go_router.dart';

class QuickEntryOverlay extends ConsumerStatefulWidget {
  final bool isIncome;
  const QuickEntryOverlay({super.key, required this.isIncome});

  @override
  ConsumerState<QuickEntryOverlay> createState() => _QuickEntryOverlayState();
}

class _QuickEntryOverlayState extends ConsumerState<QuickEntryOverlay> {
  final TextEditingController _controller = TextEditingController();
  bool _isSuccess = false;

  void _submit() async {
    final text = _controller.text.trim();
    if (text.isEmpty) {
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
      
      // Update widget manually here just to be safe
      final config = await ref.read(userConfigProvider.future);
      final allowance = await ref.read(allowanceProvider.future);
      if (config != null) {
         await WidgetService.updateWidget(allowance, config.monthlyBudget / 30);
      }
      
      setState(() {
        _isSuccess = true;
      });
      
      // Auto-dismiss back to dashboard after 2 seconds
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          context.go('/');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isSuccess) {
      final allowanceAsync = ref.watch(allowanceProvider);
      return GestureDetector(
        onTap: () => context.go('/'),
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check_circle_outline, color: Color(0xFF10B981), size: 120),
                const SizedBox(height: 24),
                const Text("LOGGED", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 4)),
                const SizedBox(height: 48),
                allowanceAsync.when(
                  data: (allowance) {
                    final currencyFormat = NumberFormat.simpleCurrency(locale: Platform.localeName);
                    return Column(
                      children: [
                        const Text("New Balance", style: TextStyle(color: Colors.white54, fontSize: 16)),
                        Text(
                          currencyFormat.format(allowance),
                          style: TextStyle(
                            color: allowance < 0 ? const Color(0xFFEF4444) : Colors.white,
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    );
                  },
                  loading: () => const CircularProgressIndicator(),
                  error: (_, __) => const SizedBox(),
                ),
                const Spacer(),
                const Text("Tap anywhere to close", style: TextStyle(color: Colors.white38, fontSize: 14)),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.8), // Translucent background
      body: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              GestureDetector(
                onTap: _submit,
                child: Container(
                  color: widget.isIncome ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.isIncome ? "SAVE INCOME" : "SAVE EXPENSE",
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 2),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.check, color: Colors.white, size: 20),
                    ],
                  ),
                ),
              ),
              Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: TextField(
                  controller: _controller,
                  autofocus: true,
                  style: Theme.of(context).textTheme.displayMedium,
                  decoration: InputDecoration(
                    hintText: widget.isIncome ? "5000 salary" : "1500 food",
                    hintStyle: TextStyle(color: Colors.grey.withOpacity(0.4)),
                    border: InputBorder.none,
                  ),
                  onSubmitted: (_) => _submit(),
                  keyboardType: TextInputType.text,
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
