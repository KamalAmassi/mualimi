import '../../domain/entities/saved_answer.dart';
import '../../domain/repositories/saved_answers_repository.dart';
import '../datasources/saved_answers_local_data_source.dart';

class SavedAnswersRepositoryImpl implements SavedAnswersRepository {
  SavedAnswersRepositoryImpl(this._local);
  final SavedAnswersLocalDataSource _local;

  @override
  Future<void> save(SavedAnswer answer) => _local.save(answer);

  @override
  Future<List<SavedAnswer>> all() => _local.all();

  @override
  Future<void> delete(int id) => _local.delete(id);
}
