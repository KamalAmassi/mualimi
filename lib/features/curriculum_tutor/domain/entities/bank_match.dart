import 'package:equatable/equatable.dart';

import 'bank_entry.dart';

class BankMatch extends Equatable {
  const BankMatch(this.entry, this.score);

  final BankEntry entry;
  final double score;

  @override
  List<Object?> get props => [entry, score];
}
