import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'database_provider.dart';

final allowanceProvider = FutureProvider<double>((ref) async {
  final userConfig = await ref.watch(userConfigProvider.future);
  final transactions = await ref.watch(transactionsProvider.future);

  if (userConfig == null || !userConfig.isOnboarded) {
    return 0.0;
  }

  final now = DateTime.now();
  final resetDay = userConfig.resetDay;
  
  // Calculate start date of the current cycle
  DateTime startDate;
  if (now.day >= resetDay) {
    startDate = DateTime(now.year, now.month, resetDay);
  } else {
    // Previous month
    int prevMonth = now.month == 1 ? 12 : now.month - 1;
    int prevYear = now.month == 1 ? now.year - 1 : now.year;
    int maxDaysInPrevMonth = DateTime(prevYear, prevMonth + 1, 0).day;
    int actualResetDay = resetDay > maxDaysInPrevMonth ? maxDaysInPrevMonth : resetDay;
    startDate = DateTime(prevYear, prevMonth, actualResetDay);
  }

  // Calculate end date of the current cycle
  int nextMonth = startDate.month == 12 ? 1 : startDate.month + 1;
  int nextYear = startDate.month == 12 ? startDate.year + 1 : startDate.year;
  int maxDaysInNextMonth = DateTime(nextYear, nextMonth + 1, 0).day;
  int actualEndResetDay = resetDay > maxDaysInNextMonth ? maxDaysInNextMonth : resetDay;
  DateTime endDate = DateTime(nextYear, nextMonth, actualEndResetDay);

  int totalDaysInCycle = endDate.difference(startDate).inDays;
  if (totalDaysInCycle == 0) totalDaysInCycle = 1;

  // elapsed days (including today)
  int elapsedDays = DateTime(now.year, now.month, now.day)
      .difference(DateTime(startDate.year, startDate.month, startDate.day))
      .inDays + 1;

  double baseDaily = userConfig.monthlyBudget / totalDaysInCycle;
  double accumulatedBase = baseDaily * elapsedDays;

  // Calculate Total I and Total E in the cycle
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

  return accumulatedBase + totalIncome - totalExpenses;
});

final currentCycleInfoProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final userConfig = await ref.watch(userConfigProvider.future);
  if (userConfig == null || !userConfig.isOnboarded) {
    return {'elapsedDays': 1, 'totalDays': 30, 'remainingBudget': 0.0};
  }

  final now = DateTime.now();
  final resetDay = userConfig.resetDay;
  
  DateTime startDate;
  if (now.day >= resetDay) {
    startDate = DateTime(now.year, now.month, resetDay);
  } else {
    int prevMonth = now.month == 1 ? 12 : now.month - 1;
    int prevYear = now.month == 1 ? now.year - 1 : now.year;
    int maxDaysInPrevMonth = DateTime(prevYear, prevMonth + 1, 0).day;
    int actualResetDay = resetDay > maxDaysInPrevMonth ? maxDaysInPrevMonth : resetDay;
    startDate = DateTime(prevYear, prevMonth, actualResetDay);
  }

  int nextMonth = startDate.month == 12 ? 1 : startDate.month + 1;
  int nextYear = startDate.month == 12 ? startDate.year + 1 : startDate.year;
  int maxDaysInNextMonth = DateTime(nextYear, nextMonth + 1, 0).day;
  int actualEndResetDay = resetDay > maxDaysInNextMonth ? maxDaysInNextMonth : resetDay;
  DateTime endDate = DateTime(nextYear, nextMonth, actualEndResetDay);

  int totalDaysInCycle = endDate.difference(startDate).inDays;
  if (totalDaysInCycle == 0) totalDaysInCycle = 1;

  int elapsedDays = DateTime(now.year, now.month, now.day)
      .difference(DateTime(startDate.year, startDate.month, startDate.day))
      .inDays + 1;

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
    'totalDays': totalDaysInCycle,
    'remainingBudget': remainingOverall,
  };
});
