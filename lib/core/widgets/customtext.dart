import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:the_movie_database/core/theme/app_theme.dart';
import 'package:the_movie_database/core/widgets/dimention.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final Color? fontColor;
  final Color? strokeColor;
  final Color? decorationColor;
  final TextDecoration? textDecoration;
  final TextStyle? style;
  final int? maxLines;
  final double? height;
  final double? letterSpacing;
  final TextOverflow? overflow;

  const CustomText({
    super.key,
    required this.text,
    this.fontSize,
    this.fontWeight,
    this.fontColor,
    this.textAlign,
    this.decorationColor,
    this.textDecoration,
    this.style,
    this.strokeColor,
    this.maxLines,
    this.height,
    this.letterSpacing,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    final val = fontSize == null
        ? Dimensions.fontSize12 / MediaQuery.textScalerOf(context).scale(1)
        : fontSize! / MediaQuery.textScalerOf(context).scale(1);

    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines ?? 5,
      overflow: overflow,
      style: style?.copyWith(fontSize: val) ??
          TextStyle(
            decoration: textDecoration,
            decorationColor: decorationColor,
            fontSize: val - 2.spMin,
            fontWeight: fontWeight ?? FontWeight.w400,
            height: height,
            fontFamily: "SpaceGrotesk",
            letterSpacing: letterSpacing,
            color: fontColor ?? AppTheme.kSubheadingColor,
            overflow: overflow,
            shadows: strokeColor == null
                ? null
                : outlinedText(strokeColor: strokeColor!, strokeWidth: 1),
          ),
    );
  }

  static TextStyle textStyle({
    final double? fontSize,
    required BuildContext? context,
    final FontWeight? fontWeight,
    final TextAlign? textAlign,
    final Color? fontColor,
    final Color? decorationColor,
    final TextDecoration? textDecoration,
    final double? height,
    final double? letterSpacing,
    final TextOverflow? overflow,
  }) {
    final scale =
        context != null ? MediaQuery.textScalerOf(context).scale(1) : 1.0;

    final val = (fontSize ?? Dimensions.fontSize12) / scale;

    return TextStyle(
      decoration: textDecoration,
      decorationColor: decorationColor,
      fontSize: val,
      fontWeight: fontWeight ?? FontWeight.w400,
      color: fontColor ?? AppTheme.kSubheadingColor,
      fontFamily: "Montserrat",
      height: height,
      letterSpacing: letterSpacing,
      overflow: overflow,
    );
  }

  /// Outlines a text using shadows.
  static List<Shadow> outlinedText({
    double strokeWidth = 2,
    Color strokeColor = Colors.black,
    int precision = 5,
  }) {
    Set<Shadow> result = HashSet();
    for (int x = 1; x < strokeWidth + precision; x++) {
      for (int y = 1; y < strokeWidth + precision; y++) {
        double offsetX = x.toDouble();
        double offsetY = y.toDouble();
        result.add(
          Shadow(
            offset: Offset(-strokeWidth / offsetX, -strokeWidth / offsetY),
            color: strokeColor,
          ),
        );
        result.add(
          Shadow(
            offset: Offset(-strokeWidth / offsetX, strokeWidth / offsetY),
            color: strokeColor,
          ),
        );
        result.add(
          Shadow(
            offset: Offset(strokeWidth / offsetX, -strokeWidth / offsetY),
            color: strokeColor,
          ),
        );
        result.add(
          Shadow(
            offset: Offset(strokeWidth / offsetX, strokeWidth / offsetY),
            color: strokeColor,
          ),
        );
      }
    }
    return result.toList();
  }
}
