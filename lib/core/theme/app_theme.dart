import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AppTheme {
  const AppTheme._();

  static const _brandSeed = Color(0xFF167C80);

  static ThemeData build(Brightness brightness) {
    final isLight = brightness == Brightness.light;
    final scheme = ColorScheme.fromSeed(
      seedColor: _brandSeed,
      brightness: brightness,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      extensions: [PhrasebookColors.fromScheme(scheme)],
      scaffoldBackgroundColor: scheme.surface,
      appBarTheme: AppBarTheme(
        centerTitle: false,
        backgroundColor: scheme.surface,
        surfaceTintColor: scheme.surfaceTint.withValues(alpha: 0),
        elevation: 0,
      ),
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
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        minLeadingWidth: 44,
        minVerticalPadding: 12,
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
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
  final Color cardBorder;
  final List<Color> categoryTiles;

  factory PhrasebookColors.fromScheme(ColorScheme scheme) => PhrasebookColors(
    headerStart: const Color(0xFF0476F2),
    headerEnd: const Color(0xFF0064D8),
    greenHeaderStart: const Color(0xFF197251),
    greenHeaderEnd: const Color(0xFF105F43),
    pinkHeaderStart: const Color(0xFFE84B8D),
    pinkHeaderEnd: const Color(0xFFD73577),
    slateHeaderStart: const Color(0xFF33465F),
    slateHeaderEnd: const Color(0xFF25354B),
    success: const Color(0xFF009D4F),
    favorite: const Color(0xFFFFB300),
    infoSoft: const Color(0xFFEAF3FF),
    successSoft: const Color(0xFFEAF8F0),
    cardBorder: scheme.outlineVariant,
    categoryTiles: const [
      Color(0xFF0875E8),
      Color(0xFF35B86F),
      Color(0xFFFF8A2A),
      Color(0xFF7E5CE6),
      Color(0xFF16B8B4),
      Color(0xFFFFB51D),
      Color(0xFF00A862),
      Color(0xFF00A6D6),
      Color(0xFFFF6C45),
      Color(0xFFE8508B),
      Color(0xFF8BC34A),
      Color(0xFF167CFF),
      Color(0xFF8E5CF7),
      Color(0xFFE55353),
      Color(0xFFFFA000),
      Color(0xFFEC5E99),
      Color(0xFF8D6E63),
      Color(0xFF607D8B),
      Color(0xFF1E5BB8),
    ],
  );

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
      cardBorder: Color.lerp(cardBorder, other.cardBorder, t)!,
      categoryTiles: categoryTiles,
    );
  }
}

extension PhrasebookTheme on ThemeData {
  PhrasebookColors get phrasebook =>
      extension<PhrasebookColors>() ?? PhrasebookColors.fromScheme(colorScheme);
}
