import 'package:isar/isar.dart';

part 'transaction.g.dart';

@collection
class Transaction {
  Id id = Isar.autoIncrement;

  double amount = 0.0;
  bool isIncome = false;
  DateTime date = DateTime.now();
  String? tag;
}
