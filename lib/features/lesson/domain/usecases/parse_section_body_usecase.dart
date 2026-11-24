import '../entities/section_block.dart';
import '../section_body/section_body_parser.dart';

class ParseSectionBodyUseCase {
  const ParseSectionBodyUseCase([this._parser = const SectionBodyParser()]);
  final SectionBodyParser _parser;

  List<SectionBlock> call(String body) => _parser.parse(body);
}
