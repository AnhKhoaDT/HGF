import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    super.username,
    super.fullName,
    super.avatarUrl,
    super.phoneNumber,
    super.homeAddress,
    super.currentLat,
    super.currentLng,
    super.provider,
    super.expPoints = 0,
    super.userLevel = 'explorer',
    super.tripsCount = 0,
    super.checkinsCount = 0,
    super.badgesCount = 0,
    super.createdAt,
    super.lastLoginAt,
    super.isEmailVerified = false,
    super.isPhoneVerified = false,
    super.isVip = false,
    super.membershipTier = 'free',
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final data = (json['data'] is Map<String, dynamic>)
        ? json['data'] as Map<String, dynamic>
        : json;

    final profile = (data['profile'] is Map<String, dynamic>)
        ? data['profile'] as Map<String, dynamic>
        : null;

    final latVal = data['current_lat'] ?? json['current_lat'] ?? profile?['current_lat'];
    final lngVal = data['current_lng'] ?? json['current_lng'] ?? profile?['current_lng'];

    return UserModel(
      id: (data['id'] ?? json['id'] ?? '') as String,
      email: (data['email'] ?? json['email'] ?? '') as String,
      username: (data['username'] ?? json['username']) as String?,
      fullName: (data['full_name'] ?? json['full_name'] ?? profile?['full_name']) as String?,
      avatarUrl: (data['avatar_url'] ?? json['avatar_url'] ?? profile?['avatar_url']) as String?,
      phoneNumber: (data['phone_number'] ?? json['phone_number'] ?? profile?['phone_number']) as String?,
      homeAddress: (data['home_address'] ?? json['home_address'] ?? profile?['home_address']) as String?,
      currentLat: latVal is num ? latVal.toDouble() : null,
      currentLng: lngVal is num ? lngVal.toDouble() : null,
      provider: (data['provider'] ?? json['provider']) as String?,
      expPoints: (data['exp_points'] ?? json['exp_points'] ?? profile?['exp_points']) as int? ?? 0,
      userLevel: (data['level_title'] ?? json['level_title'] ?? profile?['level_title']) as String? ?? 'explorer',
      tripsCount: (data['trips_count'] ?? json['trips_count'] ?? profile?['trips_count']) as int? ?? 0,
      checkinsCount: (data['checkins_count'] ?? json['checkins_count'] ?? profile?['checkins_count']) as int? ?? 0,
      badgesCount: (data['badges_count'] ?? json['badges_count'] ?? profile?['badges_count']) as int? ?? 0,
      createdAt: (data['created_at'] ?? json['created_at']) != null
          ? DateTime.parse((data['created_at'] ?? json['created_at']) as String)
          : null,
      lastLoginAt: (data['last_login_at'] ?? json['last_login_at']) != null
          ? DateTime.parse((data['last_login_at'] ?? json['last_login_at']) as String)
          : null,
      isEmailVerified: (data['is_email_verified'] ?? json['is_email_verified']) as bool? ?? false,
      isPhoneVerified: (data['is_phone_verified'] ?? json['is_phone_verified']) as bool? ?? false,
      isVip: (data['is_vip'] ?? json['is_vip']) as bool? ?? false,
      membershipTier: (data['membership_tier'] ?? json['membership_tier']) as String? ?? 'free',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'full_name': fullName,
      'avatar_url': avatarUrl,
      'phone_number': phoneNumber,
      'home_address': homeAddress,
      'current_lat': currentLat,
      'current_lng': currentLng,
      'provider': provider,
      'exp_points': expPoints,
      'level_title': userLevel,
      'trips_count': tripsCount,
      'checkins_count': checkinsCount,
      'badges_count': badgesCount,
      'created_at': createdAt?.toIso8601String(),
      'last_login_at': lastLoginAt?.toIso8601String(),
      'is_email_verified': isEmailVerified,
      'is_phone_verified': isPhoneVerified,
      'is_vip': isVip,
      'membership_tier': membershipTier,
    };
  }
}
