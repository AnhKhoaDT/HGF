import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';

class AppSearchBar extends StatelessWidget {
  final String hintText;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onFilterTap;
  final bool showFilter;
  final TextEditingController? controller;
  final bool readOnly;

  const AppSearchBar({
    super.key,
    required this.hintText,
    this.onTap,
    this.onChanged,
    this.onFilterTap,
    this.showFilter = true,
    this.controller,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: AppRadius.brMd,
          border: Border.all(color: AppColors.border),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadowSoft,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.search_rounded,
                color: AppColors.textTertiary, size: 22),
            const SizedBox(width: 10),
            Expanded(
              child: readOnly || onTap != null
                  ? Text(
                      hintText,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textTertiary,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  : TextField(
                      controller: controller,
                      onChanged: onChanged,
                      decoration: InputDecoration(
                        hintText: hintText,
                        hintStyle: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textTertiary,
                          fontWeight: FontWeight.w500,
                        ),
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
            ),
            if (showFilter) ...[
              GestureDetector(
                onTap: onFilterTap ?? onTap,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.primarySoft,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.tune_rounded,
                      color: AppColors.primary, size: 18),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
