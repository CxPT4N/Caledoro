import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ─── Cozy Quests Design Tokens ───────────────────────────────────────────────
// All colors extracted from the Stitch "Caledoro Cozy Quests" design system.
// See DESIGN.md for full specification and usage rules.

class CozyColors {
  CozyColors._();

  // ── Primary ──
  static const Color primary = Color(0xFF4C644C);
  static const Color primaryContainer = Color(0xFFA9C4A6);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onPrimaryContainer = Color(0xFF3A523A);
  static const Color primaryFixed = Color(0xFFCEEACA);
  static const Color primaryFixedDim = Color(0xFFB3CEAF);
  static const Color onPrimaryFixed = Color(0xFF0A200D);
  static const Color onPrimaryFixedVariant = Color(0xFF354C35);
  static const Color inversePrimary = Color(0xFFB3CEAF);

  // ── Secondary ──
  static const Color secondary = Color(0xFF635880);
  static const Color secondaryContainer = Color(0xFFDED0FF);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color onSecondaryContainer = Color(0xFF62577F);
  static const Color secondaryFixed = Color(0xFFE9DDFF);
  static const Color secondaryFixedDim = Color(0xFFCDC0EE);
  static const Color onSecondaryFixed = Color(0xFF1F1539);
  static const Color onSecondaryFixedVariant = Color(0xFF4B4167);

  // ── Tertiary ──
  static const Color tertiary = Color(0xFF884D5A);
  static const Color tertiaryContainer = Color(0xFFF3A9B8);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color onTertiaryContainer = Color(0xFF723B48);
  static const Color tertiaryFixed = Color(0xFFFFD9DF);
  static const Color tertiaryFixedDim = Color(0xFFFDB2C1);
  static const Color onTertiaryFixed = Color(0xFF370B19);
  static const Color onTertiaryFixedVariant = Color(0xFF6C3643);

  // ── Surface / Background ──
  static const Color surface = Color(0xFFFCF9F2);
  static const Color surfaceBright = Color(0xFFFCF9F2);
  static const Color surfaceDim = Color(0xFFDCDAD3);
  static const Color surfaceContainer = Color(0xFFF0EEE7);
  static const Color surfaceContainerHigh = Color(0xFFEBE8E1);
  static const Color surfaceContainerHighest = Color(0xFFE5E2DB);
  static const Color surfaceContainerLow = Color(0xFFF6F3EC);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFE5E2DB);
  static const Color surfaceTint = Color(0xFF4C644C);
  static const Color onSurface = Color(0xFF1C1C18);
  static const Color onSurfaceVariant = Color(0xFF434841);
  static const Color inverseSurface = Color(0xFF31312C);
  static const Color inverseOnSurface = Color(0xFFF3F0EA);
  static const Color background = Color(0xFFFCF9F2);
  static const Color onBackground = Color(0xFF1C1C18);

  // ── Error ──
  static const Color error = Color(0xFFBA1A1A);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color onErrorContainer = Color(0xFF93000A);

  // ── Outline ──
  static const Color outline = Color(0xFF737971);
  static const Color outlineVariant = Color(0xFFC3C8BF);

  // ── Design System Gradients ──
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryContainer],
  );

  // ── Ambient Shadow (30px blur, on_surface at 6%) ──
  static List<BoxShadow> ambientShadow = [
    BoxShadow(
      color: onSurface.withValues(alpha: 0.06),
      blurRadius: 30,
      spreadRadius: 0,
      offset: Offset.zero,
    ),
  ];

  // ── Light ambient for cards on hover ──
  static List<BoxShadow> cardHoverShadow = [
    BoxShadow(
      color: onSurface.withValues(alpha: 0.04),
      blurRadius: 16,
      spreadRadius: 0,
      offset: Offset.zero,
    ),
  ];
}

// ─── Theme Data ──────────────────────────────────────────────────────────────

class AppTheme {
  static TextTheme _buildTextTheme(Brightness brightness) {
    final color = brightness == Brightness.light
        ? CozyColors.onSurface
        : CozyColors.inverseOnSurface;

    return TextTheme(
      // Headlines: Plus Jakarta Sans
      displayLarge: GoogleFonts.plusJakartaSans(
          fontSize: 57, fontWeight: FontWeight.w600, color: color),
      displayMedium: GoogleFonts.plusJakartaSans(
          fontSize: 45, fontWeight: FontWeight.w600, color: color),
      displaySmall: GoogleFonts.plusJakartaSans(
          fontSize: 36, fontWeight: FontWeight.w600, color: color),
      headlineLarge: GoogleFonts.plusJakartaSans(
          fontSize: 32, fontWeight: FontWeight.w600, color: color),
      headlineMedium: GoogleFonts.plusJakartaSans(
          fontSize: 28, fontWeight: FontWeight.w600, color: color),
      headlineSmall: GoogleFonts.plusJakartaSans(
          fontSize: 24, fontWeight: FontWeight.w600, color: color),
      titleLarge: GoogleFonts.plusJakartaSans(
          fontSize: 22, fontWeight: FontWeight.w600, color: color),
      titleMedium: GoogleFonts.plusJakartaSans(
          fontSize: 16, fontWeight: FontWeight.w500, color: color),
      titleSmall: GoogleFonts.plusJakartaSans(
          fontSize: 14, fontWeight: FontWeight.w500, color: color),

      // Body: Be Vietnam Pro
      bodyLarge: GoogleFonts.beVietnamPro(
          fontSize: 16, fontWeight: FontWeight.w400, color: color),
      bodyMedium: GoogleFonts.beVietnamPro(
          fontSize: 14, fontWeight: FontWeight.w400, color: color),
      bodySmall: GoogleFonts.beVietnamPro(
          fontSize: 12, fontWeight: FontWeight.w400, color: color),

      // Labels: Space Grotesk
      labelLarge: GoogleFonts.spaceGrotesk(
          fontSize: 14, fontWeight: FontWeight.w500, color: color),
      labelMedium: GoogleFonts.spaceGrotesk(
          fontSize: 12, fontWeight: FontWeight.w500, color: color),
      labelSmall: GoogleFonts.spaceGrotesk(
          fontSize: 11, fontWeight: FontWeight.w500, color: color),
    );
  }

  static final ColorScheme _lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: CozyColors.primary,
    onPrimary: CozyColors.onPrimary,
    primaryContainer: CozyColors.primaryContainer,
    onPrimaryContainer: CozyColors.onPrimaryContainer,
    primaryFixed: CozyColors.primaryFixed,
    primaryFixedDim: CozyColors.primaryFixedDim,
    onPrimaryFixed: CozyColors.onPrimaryFixed,
    onPrimaryFixedVariant: CozyColors.onPrimaryFixedVariant,
    inversePrimary: CozyColors.inversePrimary,
    secondary: CozyColors.secondary,
    onSecondary: CozyColors.onSecondary,
    secondaryContainer: CozyColors.secondaryContainer,
    onSecondaryContainer: CozyColors.onSecondaryContainer,
    secondaryFixed: CozyColors.secondaryFixed,
    secondaryFixedDim: CozyColors.secondaryFixedDim,
    onSecondaryFixed: CozyColors.onSecondaryFixed,
    onSecondaryFixedVariant: CozyColors.onSecondaryFixedVariant,
    tertiary: CozyColors.tertiary,
    onTertiary: CozyColors.onTertiary,
    tertiaryContainer: CozyColors.tertiaryContainer,
    onTertiaryContainer: CozyColors.onTertiaryContainer,
    tertiaryFixed: CozyColors.tertiaryFixed,
    tertiaryFixedDim: CozyColors.tertiaryFixedDim,
    onTertiaryFixed: CozyColors.onTertiaryFixed,
    onTertiaryFixedVariant: CozyColors.onTertiaryFixedVariant,
    error: CozyColors.error,
    onError: CozyColors.onError,
    errorContainer: CozyColors.errorContainer,
    onErrorContainer: CozyColors.onErrorContainer,
    surface: CozyColors.surface,
    onSurface: CozyColors.onSurface,
    surfaceDim: CozyColors.surfaceDim,
    surfaceBright: CozyColors.surfaceBright,
    surfaceContainerLowest: CozyColors.surfaceContainerLowest,
    surfaceContainerLow: CozyColors.surfaceContainerLow,
    surfaceContainer: CozyColors.surfaceContainer,
    surfaceContainerHigh: CozyColors.surfaceContainerHigh,
    surfaceContainerHighest: CozyColors.surfaceContainerHighest,
    surfaceTint: CozyColors.surfaceTint,
    onSurfaceVariant: CozyColors.onSurfaceVariant,
    outline: CozyColors.outline,
    outlineVariant: CozyColors.outlineVariant,
    inverseSurface: CozyColors.inverseSurface,
    onInverseSurface: CozyColors.inverseOnSurface,
    shadow: CozyColors.onSurface,
    scrim: CozyColors.onSurface,
  );

  static final ColorScheme _darkColorScheme = ColorScheme.fromSeed(
    seedColor: CozyColors.primaryContainer,
    brightness: Brightness.dark,
  );

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: _lightColorScheme,
    textTheme: _buildTextTheme(Brightness.light),
    scaffoldBackgroundColor: CozyColors.surface,

    // ── AppBar ──
    appBarTheme: AppBarTheme(
      backgroundColor: CozyColors.surface,
      foregroundColor: CozyColors.onSurface,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: GoogleFonts.plusJakartaSans(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: CozyColors.onSurface,
      ),
    ),

    // ── Card — 24px radius, tonal layering, no elevation ──
    cardTheme: CardThemeData(
      color: CozyColors.surfaceContainerLowest,
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
    ),

    // ── Elevated Button — Primary gradient pill ──
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: CozyColors.primary,
        foregroundColor: CozyColors.onPrimary,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
        shape: const StadiumBorder(),
        textStyle:
            GoogleFonts.spaceGrotesk(fontSize: 14, fontWeight: FontWeight.w600),
      ),
    ),

    // ── Text Button ──
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: CozyColors.primary,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        shape: const StadiumBorder(),
        textStyle:
            GoogleFonts.spaceGrotesk(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    ),

    // ── Outlined Button ──
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: CozyColors.primary,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
        shape: const StadiumBorder(),
        side: BorderSide(
            color: CozyColors.outlineVariant.withValues(alpha: 0.15)),
      ),
    ),

    // ── FAB — Pill gradient ──
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: CozyColors.primary,
      foregroundColor: CozyColors.onPrimary,
      elevation: 0,
      shape: const StadiumBorder(),
    ),

    // ── Checkbox — 28x28, 10px radius ──
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return CozyColors.primary;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(CozyColors.onPrimary),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      side: BorderSide(color: CozyColors.outline, width: 1.5),
      visualDensity: VisualDensity.comfortable,
    ),

    // ── Switch ──
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return CozyColors.onPrimary;
        }
        return CozyColors.outline;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return CozyColors.primary;
        }
        return CozyColors.surfaceContainerHighest;
      }),
    ),

    // ── Input Decoration — Rounded, no border ──
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: CozyColors.surfaceContainerLow,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: BorderSide(color: CozyColors.primary, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      labelStyle: GoogleFonts.beVietnamPro(
        color: CozyColors.onSurfaceVariant,
        fontSize: 14,
      ),
    ),

    // ── Bottom Navigation — Cozy style ──
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: CozyColors.surfaceContainerLowest,
      indicatorColor: CozyColors.primaryContainer,
      elevation: 0,
      height: 72,
      labelTextStyle: WidgetStateProperty.all(
        GoogleFonts.spaceGrotesk(fontSize: 12, fontWeight: FontWeight.w500),
      ),
    ),

    // ── Bottom Sheet — Glassmorphism prep ──
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: CozyColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      elevation: 0,
    ),

    // ── SnackBar ──
    snackBarTheme: SnackBarThemeData(
      backgroundColor: CozyColors.inverseSurface,
      contentTextStyle: GoogleFonts.beVietnamPro(
        color: CozyColors.inverseOnSurface,
        fontSize: 14,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      behavior: SnackBarBehavior.floating,
    ),

    // ── Divider — technically forbidden, but set invisible if used ──
    dividerTheme: DividerThemeData(
      color: CozyColors.outlineVariant.withValues(alpha: 0.15),
      thickness: 0,
      space: 32,
    ),

    // ── Dialog ──
    dialogTheme: DialogThemeData(
      backgroundColor: CozyColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 0,
    ),

    // ── Chip — Quest tags ──
    chipTheme: ChipThemeData(
      backgroundColor: CozyColors.surfaceContainerHigh,
      labelStyle: GoogleFonts.spaceGrotesk(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: CozyColors.onSurface,
      ),
      shape: const StadiumBorder(),
      side: BorderSide.none,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: _darkColorScheme,
    textTheme: _buildTextTheme(Brightness.dark),
    scaffoldBackgroundColor: _darkColorScheme.surface,
    appBarTheme: AppBarTheme(
      backgroundColor: _darkColorScheme.surface,
      foregroundColor: _darkColorScheme.onSurface,
      elevation: 0,
      scrolledUnderElevation: 0,
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
        shape: const StadiumBorder(),
        elevation: 0,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: BorderSide.none,
      ),
      filled: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    ),
    navigationBarTheme: NavigationBarThemeData(
      elevation: 0,
      height: 72,
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      elevation: 0,
    ),
    checkboxTheme: CheckboxThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
    chipTheme: ChipThemeData(
      shape: const StadiumBorder(),
      side: BorderSide.none,
    ),
  );
}
