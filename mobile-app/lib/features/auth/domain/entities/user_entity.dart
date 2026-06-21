import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String email;
  final String? username;
  final String? fullName;
  final String? avatarUrl;
  final String? phoneNumber;
  final int expPoints;
  final String userLevel;
  final DateTime? createdAt;
  final DateTime? lastLoginAt;
  final bool isEmailVerified;
  final bool isPhoneVerified;

  const UserEntity({
    required this.id,
    required this.email,
    this.username,
    this.fullName,
    this.avatarUrl,
    this.phoneNumber,
    this.expPoints = 0,
    this.userLevel = 'explorer',
    required this.createdAt,
    this.lastLoginAt,
    this.isEmailVerified = false,
    this.isPhoneVerified = false,
  });
  UserEntity copyWith({
    String? id,
    String? email,
    String? username,
    String? fullName,
    String? avatarUrl,
    String? phoneNumber,
    int? expPoints,
    String? userLevel,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    bool? isEmailVerified,
    bool? isPhoneVerified,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      fullName: fullName ?? this.fullName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      expPoints: expPoints ?? this.expPoints,
      userLevel: userLevel ?? this.userLevel,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
    );
  }

  static const empty = UserEntity(
    id: '',
    email: '',
    createdAt: null,
  );

  bool get isEmpty => this == UserEntity.empty;
  bool get isNotEmpty => this != UserEntity.empty;

  @override
  List<Object?> get props => [
        id,
        email,
        username,
        fullName,
        avatarUrl,
        phoneNumber,
        expPoints,
        userLevel,
        createdAt,
        lastLoginAt,
        isEmailVerified,
        isPhoneVerified,
      ];
}
