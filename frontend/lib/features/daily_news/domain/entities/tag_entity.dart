import 'package:equatable/equatable.dart';

class TagEntity extends Equatable {
  final String? id;
  final String? label;
  final int? usageCount;

  const TagEntity({
    this.id,
    this.label,
    this.usageCount,
  });

  @override
  List<Object?> get props => [id, label, usageCount];
}
