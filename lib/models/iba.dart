import 'package:hive/hive.dart';
part 'iba.g.dart';

// For filtering
@HiveType(typeId: 3)
enum IBA {
  @HiveField(0)
  unforgettables,
  @HiveField(1)
  contemporaryClassics,
  @HiveField(2)
  newEraDrinks
}
