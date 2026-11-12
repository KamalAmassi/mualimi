import '../../domain/repositories/llm_repository.dart';
import '../datasources/llm_data_source.dart';

class LlmRepositoryImpl implements LlmRepository {
  LlmRepositoryImpl(this._source);
  final LlmDataSource _source;

  @override
  Stream<String> generate(String prompt, {required int maxOutputTokens}) =>
      _source.generate(prompt, maxOutputTokens: maxOutputTokens);

  @override
  Future<void> stop() => _source.stop();
}
