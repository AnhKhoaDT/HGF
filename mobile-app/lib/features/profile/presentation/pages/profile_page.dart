import 'package:flutter/material.dart';
import '../../../../core/store/app_state.dart';
import '../../../../core/store/store_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';

class ProfilePage extends StatefulWidget {
  final AuthController controller;
  const ProfilePage({super.key, required this.controller});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<void> _handleLogout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.brLg),
        title: const Text('Đăng xuất', style: AppTextStyles.h3),
        content: const Text(
          'Bạn có chắc chắn muốn đăng xuất khỏi ứng dụng không?',
          style: AppTextStyles.body,
        ),
        actions: [
          AppTextButton(
            text: 'Hủy',
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
            child: const Text('Đăng xuất'),
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
        final username = user?.username ?? 'Chưa đặt tên';
        final email = user?.email ?? 'Không có email';
        final level = user?.userLevel ?? 'Nhà Thám Hiểm';
        final exp = user?.expPoints ?? 0;
        const nextLevelExp = 1000;
        final progress = (exp / nextLevelExp).clamp(0.0, 1.0);

        return LoadingOverlay(
          isLoading: auth.isLoading,
          child: ResponsiveScaffold(
            appBar: AppBar(
              centerTitle: true,
              title: const Text('Hồ sơ cá nhân', style: AppTextStyles.h3),
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_rounded,
                    color: AppColors.textPrimary),
              ),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                children: [
                  _userHeader(user?.avatarUrl, username, email),
                  AppSpacing.gapLg,
                  _expCard(level, exp, nextLevelExp, progress),
                  AppSpacing.gapLg,
                  _sectionHeader('Thông tin tài khoản'),
                  AppSpacing.gapSm,
                  _detailTile(
                    Icons.verified_user_outlined,
                    'Trạng thái email',
                    user?.isEmailVerified == true ? 'Đã xác minh' : 'Chưa xác minh',
                    user?.isEmailVerified == true
                        ? AppColors.success
                        : AppColors.warning,
                  ),
                  _detailTile(Icons.date_range_outlined, 'Ngày tham gia',
                      _formatDate(user?.createdAt), AppColors.primary),
                  AppSpacing.gapLg,
                  _sectionHeader('Tùy chọn'),
                  AppSpacing.gapSm,
                  _optionTile(Icons.edit_outlined, 'Chỉnh sửa hồ sơ', () {}),
                  _optionTile(
                      Icons.security_outlined, 'Bảo mật & Mật khẩu', () {}),
                  AppSpacing.gapXl,
                  AppButton(
                    text: 'Đăng xuất',
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

  Widget _userHeader(String? avatarUrl, String username, String email) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primarySoft,
              border: Border.all(color: AppColors.primary, width: 2),
              image: avatarUrl != null && avatarUrl.isNotEmpty
                  ? DecorationImage(
                      image: NetworkImage(avatarUrl), fit: BoxFit.cover)
                  : null,
            ),
            child: avatarUrl == null || avatarUrl.isEmpty
                ? const Icon(Icons.person_rounded,
                    size: 34, color: AppColors.primary)
                : null,
          ),
          AppSpacing.gapMd,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(username,
                    style: AppTextStyles.h3,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Text(email,
                    style: AppTextStyles.caption,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _expCard(String level, int currentExp, int maxExp, double progress) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: AppRadius.brLg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.military_tech_rounded,
                      color: Colors.white, size: 26),
                  AppSpacing.gapXs,
                  Text('Cấp độ: $level',
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Colors.white)),
                ],
              ),
              Text('$currentExp / $maxExp XP',
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white)),
            ],
          ),
          AppSpacing.gapMd,
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.white.withOpacity(0.25),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          AppSpacing.gapSm,
          Text(
            'Khám phá thêm nhiều địa điểm để nhận thêm kinh nghiệm!',
            style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.9)),
          ),
        ],
      ),
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
            Text(label, style: AppTextStyles.body),
            const Spacer(),
            Text(value,
                style: TextStyle(
                    fontSize: 15, color: color, fontWeight: FontWeight.w700)),
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
          title: Text(title,
              style: const TextStyle(
                  fontSize: 15,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600)),
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
