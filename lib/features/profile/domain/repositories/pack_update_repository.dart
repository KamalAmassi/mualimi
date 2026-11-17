import '../entities/pack_update_check.dart';

abstract class PackUpdateRepository {
  Future<PackUpdateCheck> check(int grade);
}