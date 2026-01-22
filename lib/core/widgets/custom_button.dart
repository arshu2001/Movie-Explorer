import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:the_movie_database/core/theme/app_theme.dart';

class DefaultElevatedButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final double width;
  final double height;
  final bool loading;
  final double borderRadius;

  const DefaultElevatedButton({
    super.key,
    required this.child,
     this.onPressed,
    this.backgroundColor = const Color(0XFF003580),
    this.width = 353,
    this.height = 52.0,
    this.loading = false,
    this.borderRadius = 6.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width.w,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.r),
        border: Border.all(
          color: AppTheme.kWhite.withValues(alpha: 44),
          width: 0.5
        )
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius.r),
          ),
        ),
        onPressed: loading ? null : onPressed,
        child: loading
            ? const SizedBox(
                height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2))
            : child, // Accepts any child widget dynamically
      ),
    );
  }
}