import 'package:equatable/equatable.dart';

class AuthorEntity extends Equatable {
  final String? authorId;
  final String? fullName;
  final String? professionalTitle;
  final String? email;
  final String? profileImage;
  final String? bio;
  final List<String>? socialLinks;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const AuthorEntity({
    this.authorId,
    this.fullName,
    this.professionalTitle,
    this.email,
    this.profileImage,
    this.bio,
    this.socialLinks,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        authorId,
        fullName,
        professionalTitle,
        email,
        profileImage,
        bio,
        socialLinks,
        status,
        createdAt,
        updatedAt,
      ];
}
