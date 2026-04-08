// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'author_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthorModel _$AuthorModelFromJson(Map<String, dynamic> json) => AuthorModel(
      authorId: json['authorId'] as String?,
      fullName: json['fullName'] as String?,
      email: json['email'] as String?,
      profileImage: json['profileImage'] as String?,
      bio: json['bio'] as String?,
      professionalTitle: json['professionalTitle'] as String?,
      socialLinks: (json['socialLinks'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      yearsExperience: (json['yearsExperience'] as num?)?.toInt(),
      status: json['status'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$AuthorModelToJson(AuthorModel instance) =>
    <String, dynamic>{
      'authorId': instance.authorId,
      'fullName': instance.fullName,
      'professionalTitle': instance.professionalTitle,
      'email': instance.email,
      'profileImage': instance.profileImage,
      'bio': instance.bio,
      'socialLinks': instance.socialLinks,
      'status': instance.status,
      'yearsExperience': instance.yearsExperience,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
