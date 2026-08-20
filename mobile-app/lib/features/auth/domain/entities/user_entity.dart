import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String email;
  final String? username;
  final String? fullName;
  final String? avatarUrl;
  final String? phoneNumber;
  final String? homeAddress;
  final double? currentLat;
  final double? currentLng;
  final String? provider;
  final int expPoints;
  final String userLevel;
  final int? tripsCount;
  final int? checkinsCount;
  final int? badgesCount;
  final DateTime? createdAt;
  final DateTime? lastLoginAt;
  final bool isEmailVerified;
  final bool isPhoneVerified;
  final bool isVip;
  final String membershipTier;

  const UserEntity({
    required this.id,
    required this.email,
    this.username,
    this.fullName,
    this.avatarUrl,
    this.phoneNumber,
    this.homeAddress,
    this.currentLat,
    this.currentLng,
    this.provider,
    this.expPoints = 0,
    this.userLevel = 'explorer',
    this.tripsCount = 0,
    this.checkinsCount = 0,
    this.badgesCount = 0,
    this.createdAt,
    this.lastLoginAt,
    this.isEmailVerified = false,
    this.isPhoneVerified = false,
    this.isVip = false,
    this.membershipTier = 'free',
  });

  UserEntity copyWith({
    String? id,
    String? email,
    String? username,
    String? fullName,
    String? avatarUrl,
    String? phoneNumber,
    String? homeAddress,
    double? currentLat,
    double? currentLng,
    String? provider,
    int? expPoints,
    String? userLevel,
    int? tripsCount,
    int? checkinsCount,
    int? badgesCount,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    bool? isEmailVerified,
    bool? isPhoneVerified,
    bool? isVip,
    String? membershipTier,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      fullName: fullName ?? this.fullName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      homeAddress: homeAddress ?? this.homeAddress,
      currentLat: currentLat ?? this.currentLat,
      currentLng: currentLng ?? this.currentLng,
      provider: provider ?? this.provider,
      expPoints: expPoints ?? this.expPoints,
      userLevel: userLevel ?? this.userLevel,
      tripsCount: tripsCount ?? this.tripsCount,
      checkinsCount: checkinsCount ?? this.checkinsCount,
      badgesCount: badgesCount ?? this.badgesCount,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
      isVip: isVip ?? this.isVip,
      membershipTier: membershipTier ?? this.membershipTier,
    );
  }

  @override
  List<Object?> get props => [
        id,
        email,
        username,
        fullName,
        avatarUrl,
        phoneNumber,
        homeAddress,
        currentLat,
        currentLng,
        provider,
        expPoints,
        userLevel,
        tripsCount,
        checkinsCount,
        badgesCount,
        createdAt,
        lastLoginAt,
        isEmailVerified,
        isPhoneVerified,
        isVip,
        membershipTier,
      ];
}
