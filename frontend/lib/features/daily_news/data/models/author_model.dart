
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/author_entity.dart';

part 'author_model.g.dart';


@JsonSerializable()
class AuthorModel extends AuthorEntity {
  const AuthorModel({
    String? authorId,
    String? fullName,
    String? email,
    String? profileImage,
    String? bio,
    String? professionalTitle,
    List<String>? socialLinks,
    int? yearsExperience,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super(
          authorId: authorId,
          fullName: fullName,
          email: email,
          profileImage: profileImage,
          bio: bio,
          professionalTitle: professionalTitle,
          socialLinks: socialLinks,
          yearsExperience: yearsExperience,
          status: status,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  factory AuthorModel.fromJson(Map<String, dynamic> json) =>
      _$AuthorModelFromJson(json);
  Map<String, dynamic> toJson() => _$AuthorModelToJson(this);
}
