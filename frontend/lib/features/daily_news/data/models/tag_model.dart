import 'package:floor/floor.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/tag_entity.dart';

part 'tag_model.g.dart';

@Entity(tableName: 'tags', primaryKeys: ['id'])
@JsonSerializable()
class TagModel extends TagEntity {
  const TagModel({
    String? id,
    String? label,
    int? usageCount,
  }) : super(
          id: id,
          label: label,
          usageCount: usageCount,
        );

  factory TagModel.fromJson(Map<String, dynamic> json) =>
      _$TagModelFromJson(json);
  Map<String, dynamic> toJson() => _$TagModelToJson(this);
}
