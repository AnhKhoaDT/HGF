import 'package:flutter/material.dart';
import '../../../../core/store/app_state.dart';
import '../../../../core/store/store_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';

class HomePage extends StatefulWidget {
  final AuthController controller;
  const HomePage({super.key, required this.controller});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const _destinations = [
    ['🌲', 'Đà Lạt', 'Lâm Đồng'],
    ['🏖️', 'Đà Nẵng', 'Miền Trung'],
    ['🏮', 'Hội An', 'Phố cổ'],
    ['🏯', 'Hà Nội', 'Thủ đô'],
    ['🐚', 'Nha Trang', 'Khánh Hòa'],
  ];

  static const _interests = [
    ['🏝️', 'Biển'],
    ['⛰️', 'Núi'],
    ['🍜', 'Ẩm thực'],
    ['🏛️', 'Văn hóa'],
    ['📸', 'Sống ảo'],
    ['☕', 'Thư giãn'],
  ];

  int _selectedDest = 0;
  final Set<int> _selectedInterests = {2, 5};

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      maxContentWidth: 720,
      appBar: AppBar(
        titleSpacing: AppSpacing.md,
        title: const AppLogo(size: 30),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_outlined,
                color: AppColors.textPrimary),
          ),
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/profile'),
            icon: const Icon(Icons.account_circle_outlined,
                color: AppColors.textPrimary),
          ),
          AppSpacing.gapXs,
        ],
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _greeting(),
            const SizedBox(height: AppSpacing.lg),
            _sectionTitle('📍 Điểm đến'),
            AppSpacing.gapSm,
            _destinationList(),
            const SizedBox(height: AppSpacing.lg),
            _sectionTitle('🎯 Sở thích'),
            AppSpacing.gapSm,
            _interestChips(),
            const SizedBox(height: AppSpacing.xl),
            AppButton(
              text: '✨ Tạo lịch trình',
              onPressed: _onGenerate,
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _greeting() {
    return StoreConnector<AuthState>(
      selector: (s) => s.auth,
      builder: (context, auth) {
        final name = auth.user?.username ?? auth.user?.fullName ?? 'lữ khách';
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Chào $name 👋', style: AppTextStyles.h1),
            const SizedBox(height: 4),
            Text('Bạn muốn đi đâu chuyến này?',
                style: AppTextStyles.bodyLarge),
          ],
        );
      },
    );
  }

  Widget _sectionTitle(String text) => Text(text, style: AppTextStyles.h3);

  Widget _destinationList() {
    return SizedBox(
      height: 130,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _destinations.length,
        separatorBuilder: (_, __) => AppSpacing.gapSm,
        itemBuilder: (context, i) {
          final d = _destinations[i];
          final selected = _selectedDest == i;
          return GestureDetector(
            onTap: () => setState(() => _selectedDest = i),
            child: Container(
              width: 116,
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: AppRadius.brMd,
                border: Border.all(
                  color: selected ? AppColors.primary : AppColors.border,
                  width: selected ? 2 : 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 64,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: AppColors.primarySoft,
                      borderRadius: BorderRadius.vertical(
                          top: Radius.circular(AppRadius.md)),
                    ),
                    child: Text(d[0], style: const TextStyle(fontSize: 30)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.xs),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(d[1], style: AppTextStyles.label),
                        Text(d[2], style: AppTextStyles.caption),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _interestChips() {
    return Wrap(
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xs,
      children: List.generate(_interests.length, (i) {
        final it = _interests[i];
        final selected = _selectedInterests.contains(i);
        return GestureDetector(
          onTap: () => setState(() {
            selected
                ? _selectedInterests.remove(i)
                : _selectedInterests.add(i);
          }),
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md, vertical: AppSpacing.xs + 1),
            decoration: BoxDecoration(
              color: selected ? AppColors.primary : AppColors.card,
              borderRadius: AppRadius.brPill,
              border: Border.all(
                color: selected ? AppColors.primary : AppColors.border,
              ),
            ),
            child: Text(
              '${it[0]}  ${it[1]}',
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: selected ? Colors.white : AppColors.textPrimary,
              ),
            ),
          ),
        );
      }),
    );
  }

  void _onGenerate() {
    final dest = _destinations[_selectedDest][1];
    showAppSnackBar(context, 'Đang tạo lịch trình cho $dest…');
  }
}
