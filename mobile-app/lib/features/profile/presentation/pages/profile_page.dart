import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/viewmodels/auth_view_model.dart';

class ProfilePage extends StatefulWidget {
  final AuthViewModel viewModel;
  const ProfilePage({Key? key, required this.viewModel}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<void> _handleLogout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.darkSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Đăng xuất',
          style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Bạn có chắc chắn muốn đăng xuất khỏi ứng dụng không?',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy', style: TextStyle(color: AppColors.brandPrimary, fontWeight: FontWeight.w600)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Đăng xuất'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await widget.viewModel.logout();
      if (mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.viewModel.user;
    final username = user?.username ?? 'Chưa đặt tên';
    final email = user?.email ?? 'Không có email';
    final userLevel = user?.userLevel ?? 'Explorer';
    final exp = user?.expPoints ?? 0;
    
    // Calculate level progression (e.g. next level at 1000 exp)
    final nextLevelExp = 1000;
    final progress = (exp / nextLevelExp).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        child: Stack(
          children: [
            // Background Gradient
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: AppColors.darkGradient,
                ),
              ),
            ),
            
            // Content
            Column(
              children: [
                _buildAppBar(context),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 16),
                        
                        // Avatar & Basic Info Card
                        _buildUserHeader(user?.avatarUrl, username, email),
                        const SizedBox(height: 24),
                        
                        // Experience & Gamification Section (Vibrant Brand Gradient)
                        _buildExpCard(userLevel, exp, nextLevelExp, progress),
                        const SizedBox(height: 24),
                        
                        // Details Section
                        _buildSectionHeader('Thông tin tài khoản'),
                        const SizedBox(height: 10),
                        _buildDetailTile(Icons.verified_user_outlined, 'Trạng thái email', user?.isEmailVerified == true ? 'Đã xác minh' : 'Chưa xác minh', user?.isEmailVerified == true ? AppColors.success : AppColors.warning),
                        _buildDetailTile(Icons.date_range_outlined, 'Ngày tham gia', _formatDate(user?.createdAt), AppColors.brandPrimary),
                        const SizedBox(height: 24),
                        
                        // Utilities Section
                        _buildSectionHeader('Tùy chọn'),
                        const SizedBox(height: 10),
                        _buildOptionTile(Icons.edit_outlined, 'Chỉnh sửa hồ sơ', () {}),
                        _buildOptionTile(Icons.security_outlined, 'Bảo mật & Mật khẩu', () {}),
                        const SizedBox(height: 32),
                        
                        // Logout Button
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: _handleLogout,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.error.withOpacity(0.1),
                              foregroundColor: AppColors.error,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                                side: BorderSide(
                                  color: AppColors.error.withOpacity(0.3),
                                  width: 1.5,
                                ),
                              ),
                            ),
                            child: const Text(
                              'Đăng xuất',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            
            // Full Screen Loading Overlay while logging out
            ListenableBuilder(
              listenable: widget.viewModel,
              builder: (context, _) {
                if (!widget.viewModel.isLoading) return const SizedBox.shrink();
                return Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.6),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.brandPrimary,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: AppColors.textPrimary,
            ),
            style: IconButton.styleFrom(
              backgroundColor: AppColors.darkSurface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: AppColors.darkBorder.withOpacity(0.3),
                  width: 1,
                ),
              ),
            ),
          ),
          const Text(
            'Hồ sơ cá nhân',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(width: 48), // Spacing placeholder to center title
        ],
      ),
    );
  }

  Widget _buildUserHeader(String? avatarUrl, String username, String email) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.darkBorder.withOpacity(0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.brandPrimary.withOpacity(0.1),
              border: Border.all(
                color: AppColors.brandPrimary,
                width: 2,
              ),
              image: avatarUrl != null && avatarUrl.isNotEmpty
                  ? DecorationImage(
                      image: NetworkImage(avatarUrl),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: avatarUrl == null || avatarUrl.isEmpty
                ? const Icon(
                    Icons.person_rounded,
                    size: 36,
                    color: AppColors.brandPrimary,
                  )
                : null,
          ),
          const SizedBox(width: 16),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  username,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  email,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textTertiary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpCard(String level, int currentExp, int maxExp, double progress) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppColors.brandGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.brandPrimary.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.military_tech_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Cấp độ: $level',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Text(
                '$currentExp / $maxExp XP',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.white.withOpacity(0.25),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Khám phá thêm nhiều địa điểm để nhận thêm kinh nghiệm!',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          color: AppColors.textTertiary,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildDetailTile(IconData icon, String label, String value, Color valueColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.darkBorder.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textTertiary, size: 22),
          const SizedBox(width: 16),
          Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              color: valueColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionTile(IconData icon, String title, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.darkBorder.withOpacity(0.3),
        ),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: AppColors.brandPrimary, size: 22),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right_rounded,
          color: AppColors.textTertiary,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
