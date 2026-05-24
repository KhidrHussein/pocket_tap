import 'package:isar/isar.dart';

part 'user_config.g.dart';

@collection
class UserConfig {
  Id id = Isar.autoIncrement;

  double monthlyBudget = 0.0;
  int resetDay = 1;
  bool isOnboarded = false;
}
