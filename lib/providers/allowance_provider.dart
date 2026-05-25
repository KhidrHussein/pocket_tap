import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'database_provider.dart';

final allowanceProvider = FutureProvider<double>((ref) async {
  final userConfig = await ref.watch(userConfigProvider.future);
  final transactions = await ref.watch(transactionsProvider.future);

  if (userConfig == null || !userConfig.isOnboarded) {
    return 0.0;
  }

  final now = DateTime.now();
  
  // Hard reset on the 1st of the month
  final startDate = DateTime(now.year, now.month, 1);
  final endDate = DateTime(now.year, now.month + 1, 1);

  // D_remaining: Days left in the current month (inclusive of today)
  final totalDaysInMonth = DateTime(now.year, now.month + 1, 0).day;
  int daysRemaining = totalDaysInMonth - now.day + 1;
  if (daysRemaining <= 0) daysRemaining = 1; // Failsafe

  double baseMonthly = userConfig.monthlyBudget;
  double totalIncome = 0;
  double totalExpenses = 0;

  for (var tx in transactions) {
    if (tx.date.isAfter(startDate.subtract(const Duration(seconds: 1))) &&
        tx.date.isBefore(endDate)) {
      if (tx.isIncome) {
        totalIncome += tx.amount;
      } else {
        totalExpenses += tx.amount;
      }
    }
  }

  // Smoothing Engine Formula: A_d = (B_m + I_total - E_total) / D_remaining
  return (baseMonthly + totalIncome - totalExpenses) / daysRemaining;
});

final currentCycleInfoProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final userConfig = await ref.watch(userConfigProvider.future);
  if (userConfig == null || !userConfig.isOnboarded) {
    return {'elapsedDays': 1, 'totalDays': 30, 'remainingBudget': 0.0};
  }

  final now = DateTime.now();
  final startDate = DateTime(now.year, now.month, 1);
  final endDate = DateTime(now.year, now.month + 1, 1);

  final totalDaysInMonth = DateTime(now.year, now.month + 1, 0).day;
  int elapsedDays = now.day;

  final transactions = await ref.watch(transactionsProvider.future);
  double totalIncome = 0;
  double totalExpenses = 0;

  for (var tx in transactions) {
    if (tx.date.isAfter(startDate.subtract(const Duration(seconds: 1))) &&
        tx.date.isBefore(endDate)) {
      if (tx.isIncome) {
        totalIncome += tx.amount;
      } else {
        totalExpenses += tx.amount;
      }
    }
  }

  double remainingOverall = userConfig.monthlyBudget + totalIncome - totalExpenses;

  return {
    'elapsedDays': elapsedDays,
    'totalDays': totalDaysInMonth,
    'remainingBudget': remainingOverall,
  };
});
