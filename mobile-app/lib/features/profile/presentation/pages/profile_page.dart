import 'package:flutter/material.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/localization/app_localizations_vi.dart';
import '../../../../core/store/app_state.dart';
import '../../../../core/store/store_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../settings/data/repositories/settings_repository_impl.dart';
import '../../../settings/data/services/settings_api_service.dart';
import '../../../settings/domain/entities/app_settings_entity.dart';
import '../../../settings/domain/usecases/get_app_settings_usecase.dart';

class ProfilePage extends StatefulWidget {
  final AuthController controller;
  final GetAppSettingsUseCase? getAppSettingsUseCase;
  final bool showBackButton;

  const ProfilePage({
    super.key,
    required this.controller,
    this.getAppSettingsUseCase,
    this.showBackButton = true,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final GetAppSettingsUseCase _getAppSettingsUseCase;
  AppSettingsEntity _settings = AppSettingsEntity.defaultSettings();

  @override
  void initState() {
    super.initState();
    _getAppSettingsUseCase = widget.getAppSettingsUseCase ??
        GetAppSettingsUseCase(
          repository: SettingsRepositoryImpl(
            apiService: SettingsApiService(apiClient: ApiClient()),
          ),
        );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchProfile();
    });
  }

  Future<void> _fetchProfile() async {
    final ok = await widget.controller.checkLoginStatus();
    if (!ok && mounted) {
      showAppSnackBar(context, AppLocalizationsVi.errorUnauthorized,
          isError: true);
      Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
      return;
    }
    try {
      final settings = await _getAppSettingsUseCase.call();
      if (mounted) {
        setState(() {
          _settings = settings;
        });
      }
    } catch (_) {}
  }

  Future<void> _handleLogout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.brLg),
        title: Text(AppLocalizationsVi.logout, style: AppTextStyles.h3),
        content: const Text(
          'Bạn có chắc chắn muốn đăng xuất khỏi ứng dụng không?',
          style: AppTextStyles.body,
        ),
        actions: [
          AppTextButton(
            text: AppLocalizationsVi.cancel,
            onPressed: () => Navigator.pop(context, false),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              minimumSize: const Size(0, 44),
              shape: const RoundedRectangleBorder(borderRadius: AppRadius.brSm),
            ),
            child: Text(AppLocalizationsVi.logout),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await widget.controller.logout();
      if (mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AuthState>(
      selector: (s) => s.auth,
      builder: (context, auth) {
        final user = auth.user;
        final fullName = user?.fullName ?? user?.username ?? 'Chưa đặt tên';
        final email = user?.email ?? 'Không có email';
        final phone = user?.phoneNumber ?? AppLocalizationsVi.notUpdated;
        final address = user?.homeAddress ?? AppLocalizationsVi.notUpdated;
        final location = (user?.currentLat != null && user?.currentLng != null)
            ? '${user!.currentLat!.toStringAsFixed(4)}, ${user.currentLng!.toStringAsFixed(4)}'
            : AppLocalizationsVi.notUpdated;
        final exp = user?.expPoints ?? 0;
        final explorerExp = _settings.levelThresholds['explorer'] ?? 1000;
        final gemHunterExp = _settings.levelThresholds['gem_hunter'] ?? 5000;
        final discoveryMasterExp =
            _settings.levelThresholds['discovery_master'] ?? 20000;

        int nextLevelExp = explorerExp;
        String level = AppLocalizationsVi.explorerLevel;
        if (exp >= explorerExp && exp < gemHunterExp) {
          level = AppLocalizationsVi.gemHunterLevel;
          nextLevelExp = gemHunterExp;
        } else if (exp >= gemHunterExp && exp < discoveryMasterExp) {
          level = AppLocalizationsVi.discoveryMasterLevel;
          nextLevelExp = discoveryMasterExp;
        } else if (exp >= discoveryMasterExp) {
          level = AppLocalizationsVi.legendLevel;
          nextLevelExp = 50000;
        }

        final progress = (exp / nextLevelExp).clamp(0.0, 1.0);
        final providerName = user?.provider?.toUpperCase() ?? 'LOCAL';

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            centerTitle: true,
            title: const Text(AppLocalizationsVi.profileTitle, style: AppTextStyles.h3),
            automaticallyImplyLeading: false,
            leading: (widget.showBackButton && Navigator.canPop(context))
                ? IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_rounded,
                        color: AppColors.textPrimary),
                  )
                : null,
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh_rounded,
                    color: AppColors.primary),
                onPressed: _fetchProfile,
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: _fetchProfile,
            color: AppColors.primary,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                children: [
                  _userHeader(user?.avatarUrl, fullName, email, providerName),
                  AppSpacing.gapLg,
                  if (_settings.enableVipSystem) ...[
                    _vipMembershipCard(user?.isVip ?? false, user?.membershipTier ?? 'free'),
                    AppSpacing.gapLg,
                  ],
                  _modernLevelCard(
                    level,
                    exp,
                    nextLevelExp,
                    progress,
                    user?.tripsCount ?? 0,
                    user?.checkinsCount ?? 0,
                    user?.badgesCount ?? 0,
                  ),
                  AppSpacing.gapLg,
                  _sectionHeader(AppLocalizationsVi.personalInfoAndLocation),
                  AppSpacing.gapSm,
                  _detailTile(
                    Icons.phone_outlined,
                    AppLocalizationsVi.phoneNumberLabel,
                    phone,
                    phone != AppLocalizationsVi.notUpdated
                        ? AppColors.textPrimary
                        : AppColors.textTertiary,
                  ),
                  _detailTile(
                    Icons.home_outlined,
                    AppLocalizationsVi.homeAddress,
                    address,
                    address != AppLocalizationsVi.notUpdated
                        ? AppColors.textPrimary
                        : AppColors.textTertiary,
                  ),
                  _detailTile(
                    Icons.my_location_rounded,
                    AppLocalizationsVi.currentLocation,
                    location,
                    location != AppLocalizationsVi.notUpdated
                        ? AppColors.textPrimary
                        : AppColors.textTertiary,
                  ),
                  _detailTile(
                    Icons.verified_user_outlined,
                    AppLocalizationsVi.emailStatus,
                    user?.isEmailVerified == true
                        ? AppLocalizationsVi.emailVerified
                        : AppLocalizationsVi.emailUnverified,
                    user?.isEmailVerified == true
                        ? AppColors.success
                        : AppColors.warning,
                  ),
                  _detailTile(
                    Icons.date_range_outlined,
                    AppLocalizationsVi.joinedDate,
                    _formatDate(user?.createdAt),
                    AppColors.primary,
                  ),
                  AppSpacing.gapLg,
                  _sectionHeader(AppLocalizationsVi.options),
                  AppSpacing.gapSm,
                  _optionTile(Icons.edit_outlined, AppLocalizationsVi.editProfile, () {
                    showAppSnackBar(context, AppLocalizationsVi.editProfileInDev);
                  }),
                  _optionTile(
                    Icons.security_outlined,
                    AppLocalizationsVi.securityAndPassword,
                    () => Navigator.pushNamed(context, '/security-settings'),
                  ),
                  AppSpacing.gapXl,
                  AppButton(
                    text: AppLocalizationsVi.logout,
                    variant: AppButtonVariant.outline,
                    onPressed: _handleLogout,
                  ),
                  AppSpacing.gapXl,
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _userHeader(
      String? avatarUrl, String fullName, String email, String provider) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primarySoft,
                  border: Border.all(color: AppColors.primary, width: 2.5),
                  image: avatarUrl != null && avatarUrl.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(avatarUrl), fit: BoxFit.cover)
                      : null,
                ),
                child: avatarUrl == null || avatarUrl.isEmpty
                    ? const Icon(Icons.person_rounded,
                        size: 38, color: AppColors.primary)
                    : null,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.camera_alt_rounded,
                      size: 14, color: Colors.white),
                ),
              ),
            ],
          ),
          AppSpacing.gapMd,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fullName,
                  style: AppTextStyles.h3,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  email,
                  style: AppTextStyles.caption,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.primarySoft,
                    borderRadius: AppRadius.brSm,
                  ),
                  child: Text(
                    provider,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _vipMembershipCard(bool isVip, String tier) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isVip
              ? [const Color(0xFFFFD700), const Color(0xFFFFA500)]
              : [const Color(0xFF1E3C72), const Color(0xFF2A5298)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: AppRadius.brLg,
        boxShadow: [
          BoxShadow(
            color: isVip
                ? Colors.amber.withValues(alpha: 0.3)
                : Colors.blue.withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      isVip ? Icons.stars_rounded : Icons.account_circle_outlined,
                      color: isVip ? Colors.amberAccent : Colors.white,
                      size: 26,
                    ),
                    AppSpacing.gapSm,
                    Flexible(
                      child: Text(
                        isVip
                            ? AppLocalizationsVi.vipAccount
                            : AppLocalizationsVi.freeTierTitle,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              if (!isVip) ...[
                AppSpacing.gapSm,
                GestureDetector(
                  onTap: _showUpgradeVipModal,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.amberAccent,
                      borderRadius: AppRadius.brSm,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.workspace_premium_rounded,
                            size: 14, color: Colors.black),
                        const SizedBox(width: 4),
                        Text(
                          AppLocalizationsVi.upgradeVip,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
          AppSpacing.gapMd,
          const Divider(color: Colors.white24, height: 1),
          AppSpacing.gapMd,
          if (isVip) ...[
            _perkRow(AppLocalizationsVi.vipPerk1, isIncluded: true),
            const SizedBox(height: 4),
            _perkRow(AppLocalizationsVi.vipPerk2, isIncluded: true),
            const SizedBox(height: 4),
            _perkRow(AppLocalizationsVi.vipPerk3, isIncluded: true),
            const SizedBox(height: 4),
            _perkRow(AppLocalizationsVi.vipPerk4, isIncluded: true),
          ] else ...[
            _perkRow(AppLocalizationsVi.freePerk1, isIncluded: true),
            const SizedBox(height: 4),
            _perkRow(AppLocalizationsVi.freePerk2, isIncluded: true),
            const SizedBox(height: 4),
            _perkRow(AppLocalizationsVi.freePerk3, isIncluded: true),
            const SizedBox(height: 4),
            _perkRow(AppLocalizationsVi.freePerkLocked1, isLocked: true),
            const SizedBox(height: 4),
            _perkRow(AppLocalizationsVi.freePerkLocked2, isLocked: true),
            const SizedBox(height: 4),
            _perkRow(AppLocalizationsVi.freePerkLocked3, isLocked: true),
          ],
        ],
      ),
    );
  }

  Widget _perkRow(String perkText, {bool isIncluded = true, bool isLocked = false}) {
    return Row(
      children: [
        Icon(
          isLocked
              ? Icons.lock_outline_rounded
              : (isIncluded ? Icons.check_circle_rounded : Icons.cancel_outlined),
          color: isLocked
              ? Colors.white60
              : (isIncluded ? Colors.amberAccent : Colors.white38),
          size: 16,
        ),
        AppSpacing.gapSm,
        Expanded(
          child: Text(
            perkText,
            style: TextStyle(
              fontSize: 12,
              color: isLocked ? Colors.white70 : Colors.white.withValues(alpha: 0.95),
              fontWeight: isIncluded && !isLocked ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  String _formatCurrency(int price, String currency) {
    final s = price.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(s[i]);
    }
    return '${buffer.toString()}đ';
  }

  void _showUpgradeVipModal() {
    final monthlyPriceStr =
        '${_formatCurrency(_settings.monthlyVipPrice, _settings.currency)} / tháng';
    final yearlyPriceStr =
        '${_formatCurrency(_settings.yearlyVipPrice, _settings.currency)} / năm (tiết kiệm ${_settings.yearlyDiscountPercent}%)';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            AppSpacing.gapLg,
            Row(
              children: [
                const Icon(Icons.workspace_premium_rounded,
                    color: Colors.amber, size: 32),
                AppSpacing.gapMd,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppLocalizationsVi.upgradeVipTitle,
                          style: AppTextStyles.h3),
                      Text(AppLocalizationsVi.upgradeVipSubtitle,
                          style: AppTextStyles.caption),
                    ],
                  ),
                ),
              ],
            ),
            AppSpacing.gapLg,
            _planCard(AppLocalizationsVi.monthlyPlan, monthlyPriceStr, false),
            AppSpacing.gapMd,
            _planCard(AppLocalizationsVi.yearlyPlan, yearlyPriceStr, true),
            AppSpacing.gapLg,
            AppButton(
              text: AppLocalizationsVi.upgradeVip,
              onPressed: () {
                Navigator.pop(context);
                showAppSnackBar(
                  context,
                  AppLocalizationsVi.paymentGatewayIntegrationToast,
                );
              },
            ),
            AppSpacing.gapLg,
          ],
        ),
      ),
    );
  }

  Widget _planCard(String title, String price, bool isPopular) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isPopular
            ? AppColors.primarySoft
            : AppColors.background,
        borderRadius: AppRadius.brMd,
        border: Border.all(
          color: isPopular ? AppColors.primary : AppColors.border,
          width: isPopular ? 2 : 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary)),
                Text(price,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary)),
              ],
            ),
          ),
          Radio<bool>(
            value: isPopular,
            groupValue: true,
            activeColor: AppColors.primary,
            onChanged: (v) {},
          ),
        ],
      ),
    );
  }

  Widget _modernLevelCard(
    String level,
    int currentExp,
    int maxExp,
    double progress,
    int trips,
    int checkins,
    int badges,
  ) {
    return GestureDetector(
      onTap: _showXpGuideModal,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primary,
              AppColors.primaryDark,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: AppRadius.brLg,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.3),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.emoji_events_rounded,
                          color: Colors.amberAccent,
                          size: 24,
                        ),
                      ),
                      AppSpacing.gapSm,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'DANH HIỆU',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white70,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(Icons.info_outline_rounded,
                                    size: 12, color: Colors.white70),
                              ],
                            ),
                            Text(
                              level,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                AppSpacing.gapSm,
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: AppRadius.brSm,
                  ),
                  child: Text(
                    '$currentExp / $maxExp XP',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            AppSpacing.gapMd,
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: Colors.white.withValues(alpha: 0.2),
                valueColor:
                    const AlwaysStoppedAnimation<Color>(Colors.amberAccent),
              ),
            ),
            AppSpacing.gapLg,
            Container(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.12),
                borderRadius: AppRadius.brMd,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _statColumn('$trips', AppLocalizationsVi.tripsCountLabel),
                  Container(
                    height: 24,
                    width: 1,
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                  _statColumn('$checkins', AppLocalizationsVi.checkinsCountLabel),
                  Container(
                    height: 24,
                    width: 1,
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                  _statColumn('$badges', AppLocalizationsVi.badgesCountLabel),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showXpGuideModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              AppSpacing.gapLg,
              Row(
                children: [
                  const Icon(Icons.stars_rounded, color: Colors.amber, size: 28),
                  AppSpacing.gapMd,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(AppLocalizationsVi.xpGuideTitle,
                            style: AppTextStyles.h3),
                        Text(AppLocalizationsVi.xpGuideSubtitle,
                            style: AppTextStyles.caption),
                      ],
                    ),
                  ),
                ],
              ),
              AppSpacing.gapLg,
              Text(AppLocalizationsVi.rankMilestonesTitle,
                  style: AppTextStyles.h3),
              AppSpacing.gapSm,
              _missionTile(
                Icons.explore_rounded,
                AppLocalizationsVi.explorerLevel,
                '0 - 1.000 XP (Mức bắt đầu)',
                Colors.green,
              ),
              _missionTile(
                Icons.auto_awesome_rounded,
                AppLocalizationsVi.gemHunterLevel,
                '1.000 - 5.000 XP',
                Colors.blue,
              ),
              _missionTile(
                Icons.military_tech_rounded,
                AppLocalizationsVi.discoveryMasterLevel,
                '5.000 - 20.000 XP',
                Colors.purple,
              ),
              _missionTile(
                Icons.workspace_premium_rounded,
                AppLocalizationsVi.legendLevel,
                '> 50.000 XP (Huyền thoại)',
                Colors.amber,
              ),
              AppSpacing.gapLg,
              Text('Nhiệm vụ tích điểm XP', style: AppTextStyles.h3),
              AppSpacing.gapSm,
              _missionTile(
                Icons.location_on_outlined,
                AppLocalizationsVi.missionCheckin,
                '+50 XP mỗi lượt check-in',
                AppColors.primary,
              ),
              _missionTile(
                Icons.rate_review_outlined,
                AppLocalizationsVi.missionReview,
                '+30 XP mỗi bài đánh giá địa điểm',
                AppColors.primary,
              ),
              _missionTile(
                Icons.map_outlined,
                AppLocalizationsVi.missionCreateItinerary,
                '+100 XP mỗi lịch trình du lịch',
                AppColors.primary,
              ),
              _missionTile(
                Icons.local_fire_department_rounded,
                AppLocalizationsVi.missionDailyStreak,
                '+10 XP mỗi ngày đăng nhập liên tục',
                AppColors.primary,
              ),
              AppSpacing.gapLg,
              AppButton(
                text: AppLocalizationsVi.confirm,
                onPressed: () => Navigator.pop(context),
              ),
              AppSpacing.gapLg,
            ],
          ),
        ),
      ),
    );
  }

  Widget _missionTile(
      IconData icon, String title, String subtitle, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.xs),
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: AppRadius.brMd,
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 22),
          AppSpacing.gapMd,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.label.copyWith(color: AppColors.textPrimary)),
                Text(subtitle,
                    style: AppTextStyles.caption.copyWith(fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statColumn(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.white.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }

  Widget _sectionHeader(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(title.toUpperCase(), style: AppTextStyles.overline),
    );
  }

  Widget _detailTile(IconData icon, String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: AppCard(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Icon(icon, color: AppColors.textTertiary, size: AppSizes.iconMd),
            AppSpacing.gapMd,
            Expanded(
              child: Text(label, style: AppTextStyles.body),
            ),
            AppSpacing.gapSm,
            Flexible(
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _optionTile(IconData icon, String title, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: AppCard(
        padding: EdgeInsets.zero,
        onTap: onTap,
        child: ListTile(
          leading: Icon(icon, color: AppColors.primary, size: AppSizes.iconMd),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          trailing: const Icon(Icons.chevron_right_rounded,
              color: AppColors.textTertiary),
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
