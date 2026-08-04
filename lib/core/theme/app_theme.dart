import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AppTheme {
  const AppTheme._();

  static const _brandSeed = Color(0xFF0E7C66);

  static ThemeData build(Brightness brightness) {
    final isLight = brightness == Brightness.light;
    final scheme = ColorScheme.fromSeed(
      seedColor: _brandSeed,
      brightness: brightness,
    );
    final typography = Typography.material2021(
      platform: TargetPlatform.android,
      colorScheme: scheme,
    );
    final textTheme = (isLight ? typography.black : typography.white).apply(
      fontFamily: 'Poppins',
      bodyColor: scheme.onSurface,
      displayColor: scheme.onSurface,
      decorationColor: scheme.onSurface,
    );
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      textTheme: textTheme,
      extensions: [PhrasebookColors.fromScheme(scheme)],
      scaffoldBackgroundColor: isLight
          ? const Color(0xFFF8F7F3)
          : const Color(0xFF121715),
      appBarTheme: AppBarTheme(
        centerTitle: false,
        backgroundColor: scheme.surface,
        surfaceTintColor: scheme.surfaceTint.withValues(alpha: 0),
        foregroundColor: scheme.onSurface,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: scheme.onSurface,
          fontWeight: FontWeight.w800,
        ),
        toolbarTextStyle: textTheme.bodyMedium?.copyWith(
          color: scheme.onSurface,
        ),
        iconTheme: IconThemeData(color: scheme.onSurface),
        actionsIconTheme: IconThemeData(color: scheme.onSurface),
        elevation: 0,
      ),
      iconTheme: IconThemeData(color: scheme.onSurface),
      primaryIconTheme: IconThemeData(color: scheme.onPrimary),
      cardTheme: CardThemeData(
        margin: EdgeInsets.zero,
        elevation: 0,
        color: isLight
            ? scheme.surfaceContainerLowest
            : scheme.surfaceContainerHighest,
        surfaceTintColor: scheme.surfaceTint.withValues(alpha: 0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant.withValues(alpha: isLight ? 0.65 : 0.45),
        thickness: 1,
        space: 1,
      ),
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        minLeadingWidth: 44,
        minVerticalPadding: 12,
        iconColor: scheme.onSurfaceVariant,
        textColor: scheme.onSurface,
        titleTextStyle: textTheme.bodyLarge?.copyWith(
          color: scheme.onSurface,
          fontWeight: FontWeight.w700,
        ),
        subtitleTextStyle: textTheme.bodySmall?.copyWith(
          color: scheme.onSurfaceVariant,
        ),
      ),
      dropdownMenuTheme: DropdownMenuThemeData(
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: scheme.surfaceContainerLowest,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: scheme.outlineVariant),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: scheme.outlineVariant),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: scheme.primary, width: 1.4),
          ),
        ),
        textStyle: textTheme.bodyMedium?.copyWith(color: scheme.onSurface),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerLowest,
        iconColor: scheme.onSurfaceVariant,
        prefixIconColor: scheme.onSurfaceVariant,
        suffixIconColor: scheme.onSurfaceVariant,
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: scheme.onSurfaceVariant,
        ),
        labelStyle: textTheme.bodyMedium?.copyWith(
          color: scheme.onSurfaceVariant,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: scheme.primary, width: 1.4),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 68,
        elevation: 0,
        backgroundColor: isLight
            ? scheme.surfaceContainerLowest
            : scheme.surfaceContainer,
        indicatorColor: PhrasebookColors.fromScheme(scheme).brandSoft,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => textTheme.labelSmall?.copyWith(
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w800
                : FontWeight.w600,
            color: states.contains(WidgetState.selected)
                ? scheme.primary
                : scheme.onSurfaceVariant,
          ),
        ),
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            color: states.contains(WidgetState.selected)
                ? scheme.primary
                : scheme.onSurfaceVariant,
          ),
        ),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.windows: CupertinoPageTransitionsBuilder(),
          TargetPlatform.linux: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }
}

class PhrasebookColors extends ThemeExtension<PhrasebookColors> {
  const PhrasebookColors({
    required this.headerStart,
    required this.headerEnd,
    required this.greenHeaderStart,
    required this.greenHeaderEnd,
    required this.pinkHeaderStart,
    required this.pinkHeaderEnd,
    required this.slateHeaderStart,
    required this.slateHeaderEnd,
    required this.success,
    required this.favorite,
    required this.infoSoft,
    required this.successSoft,
    required this.brandSoft,
    required this.warningSoft,
    required this.danger,
    required this.orange,
    required this.cardBorder,
    required this.categoryTiles,
  });

  final Color headerStart;
  final Color headerEnd;
  final Color greenHeaderStart;
  final Color greenHeaderEnd;
  final Color pinkHeaderStart;
  final Color pinkHeaderEnd;
  final Color slateHeaderStart;
  final Color slateHeaderEnd;
  final Color success;
  final Color favorite;
  final Color infoSoft;
  final Color successSoft;
  final Color brandSoft;
  final Color warningSoft;
  final Color danger;
  final Color orange;
  final Color cardBorder;
  final List<Color> categoryTiles;

  factory PhrasebookColors.fromScheme(ColorScheme scheme) {
    final light = scheme.brightness == Brightness.light;
    return PhrasebookColors(
      headerStart: scheme.primary,
      headerEnd: light ? const Color(0xFF10B981) : const Color(0xFF064E3B),
      greenHeaderStart: light
          ? const Color(0xFF0E7C66)
          : const Color(0xFF09513F),
      greenHeaderEnd: light ? const Color(0xFF10B981) : const Color(0xFF063A30),
      pinkHeaderStart: light
          ? const Color(0xFFEF4A84)
          : const Color(0xFF8B1E4F),
      pinkHeaderEnd: light ? const Color(0xFFD93672) : const Color(0xFF64143A),
      slateHeaderStart: light
          ? const Color(0xFF6B7280)
          : const Color(0xFF243044),
      slateHeaderEnd: light ? const Color(0xFF374151) : const Color(0xFF151D2B),
      success: light ? const Color(0xFF0E7C66) : const Color(0xFF34D399),
      favorite: const Color(0xFFFFC107),
      infoSoft: light ? const Color(0xFFEFF6FF) : const Color(0xFF172033),
      successSoft: light ? const Color(0xFFE8F7F1) : const Color(0xFF0D2A22),
      brandSoft: light ? const Color(0xFFE5F6EF) : const Color(0xFF12362E),
      warningSoft: light ? const Color(0xFFFFF5E0) : const Color(0xFF3A2810),
      danger: light ? const Color(0xFFEF4444) : const Color(0xFFFF7A7A),
      orange: light ? const Color(0xFFFF9E0B) : const Color(0xFFFFB74D),
      cardBorder: light
          ? const Color(0xFFE8E5DC)
          : scheme.outlineVariant.withValues(alpha: 0.55),
      categoryTiles: const [
        Color(0xFF0E7C66),
        Color(0xFFEF4444),
        Color(0xFFF59E0B),
        Color(0xFF2F80ED),
        Color(0xFF7C3AED),
        Color(0xFF10B981),
        Color(0xFF38BDF8),
        Color(0xFFE11D48),
        Color(0xFF14B8A6),
        Color(0xFFEC4899),
        Color(0xFF84CC16),
        Color(0xFF6366F1),
        Color(0xFFF97316),
        Color(0xFF64748B),
        Color(0xFF0EA5E9),
        Color(0xFF22C55E),
        Color(0xFF8B5CF6),
        Color(0xFF06B6D4),
        Color(0xFFDC2626),
      ],
    );
  }

  @override
  PhrasebookColors copyWith({
    Color? headerStart,
    Color? headerEnd,
    Color? greenHeaderStart,
    Color? greenHeaderEnd,
    Color? pinkHeaderStart,
    Color? pinkHeaderEnd,
    Color? slateHeaderStart,
    Color? slateHeaderEnd,
    Color? success,
    Color? favorite,
    Color? infoSoft,
    Color? successSoft,
    Color? brandSoft,
    Color? warningSoft,
    Color? danger,
    Color? orange,
    Color? cardBorder,
    List<Color>? categoryTiles,
  }) => PhrasebookColors(
    headerStart: headerStart ?? this.headerStart,
    headerEnd: headerEnd ?? this.headerEnd,
    greenHeaderStart: greenHeaderStart ?? this.greenHeaderStart,
    greenHeaderEnd: greenHeaderEnd ?? this.greenHeaderEnd,
    pinkHeaderStart: pinkHeaderStart ?? this.pinkHeaderStart,
    pinkHeaderEnd: pinkHeaderEnd ?? this.pinkHeaderEnd,
    slateHeaderStart: slateHeaderStart ?? this.slateHeaderStart,
    slateHeaderEnd: slateHeaderEnd ?? this.slateHeaderEnd,
    success: success ?? this.success,
    favorite: favorite ?? this.favorite,
    infoSoft: infoSoft ?? this.infoSoft,
    successSoft: successSoft ?? this.successSoft,
    brandSoft: brandSoft ?? this.brandSoft,
    warningSoft: warningSoft ?? this.warningSoft,
    danger: danger ?? this.danger,
    orange: orange ?? this.orange,
    cardBorder: cardBorder ?? this.cardBorder,
    categoryTiles: categoryTiles ?? this.categoryTiles,
  );

  @override
  PhrasebookColors lerp(ThemeExtension<PhrasebookColors>? other, double t) {
    if (other is! PhrasebookColors) return this;
    return PhrasebookColors(
      headerStart: Color.lerp(headerStart, other.headerStart, t)!,
      headerEnd: Color.lerp(headerEnd, other.headerEnd, t)!,
      greenHeaderStart: Color.lerp(
        greenHeaderStart,
        other.greenHeaderStart,
        t,
      )!,
      greenHeaderEnd: Color.lerp(greenHeaderEnd, other.greenHeaderEnd, t)!,
      pinkHeaderStart: Color.lerp(pinkHeaderStart, other.pinkHeaderStart, t)!,
      pinkHeaderEnd: Color.lerp(pinkHeaderEnd, other.pinkHeaderEnd, t)!,
      slateHeaderStart: Color.lerp(
        slateHeaderStart,
        other.slateHeaderStart,
        t,
      )!,
      slateHeaderEnd: Color.lerp(slateHeaderEnd, other.slateHeaderEnd, t)!,
      success: Color.lerp(success, other.success, t)!,
      favorite: Color.lerp(favorite, other.favorite, t)!,
      infoSoft: Color.lerp(infoSoft, other.infoSoft, t)!,
      successSoft: Color.lerp(successSoft, other.successSoft, t)!,
      brandSoft: Color.lerp(brandSoft, other.brandSoft, t)!,
      warningSoft: Color.lerp(warningSoft, other.warningSoft, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      orange: Color.lerp(orange, other.orange, t)!,
      cardBorder: Color.lerp(cardBorder, other.cardBorder, t)!,
      categoryTiles: categoryTiles,
    );
  }
}

extension PhrasebookTheme on ThemeData {
  PhrasebookColors get phrasebook =>
      extension<PhrasebookColors>() ?? PhrasebookColors.fromScheme(colorScheme);
}
