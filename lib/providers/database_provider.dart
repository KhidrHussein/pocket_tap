import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../models/transaction.dart';
import '../models/user_config.dart';

final isarProvider = FutureProvider<Isar>((ref) async {
  final dir = await getApplicationDocumentsDirectory();
  return await Isar.open(
    [TransactionSchema, UserConfigSchema],
    directory: dir.path,
  );
});

final userConfigProvider = FutureProvider<UserConfig?>((ref) async {
  final isar = await ref.watch(isarProvider.future);
  return isar.userConfigs.where().findFirst();
});

final transactionsProvider = FutureProvider<List<Transaction>>((ref) async {
  final isar = await ref.watch(isarProvider.future);
  return isar.transactions.where().sortByDateDesc().findAll();
});
