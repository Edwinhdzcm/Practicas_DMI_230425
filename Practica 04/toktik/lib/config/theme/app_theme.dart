import 'package:flutter/material.dart';
import 'package:toktik/config/theme/season_theme.dart';

class AppTheme {
  final SeasonTheme season;

  AppTheme(this.season);

  ThemeData getTheme() {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: season.fontFamily,
      scaffoldBackgroundColor: season.background,
      colorScheme: ColorScheme.dark(
        primary: season.primary,
        secondary: season.secondary,
        background: season.background,
        surface: season.surface,
      ),
    );

    // Los botones no siguen a la temporada: siempre usan los colores de la
    // temporada Normal, para que su aspecto no cambie al cambiar de tema.
    final buttonColor = SeasonTheme.normal.primary;

    return base.copyWith(
      textTheme: base.textTheme.apply(
        fontFamily: season.fontFamily,
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
      bottomSheetTheme: BottomSheetThemeData(backgroundColor: season.surface),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: buttonColor,
          disabledForegroundColor: buttonColor.withAlpha(90),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          foregroundColor: Colors.white,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: buttonColor,
          foregroundColor: Colors.white,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: buttonColor,
          side: BorderSide(color: buttonColor),
        ),
      ),
    );
  }
}
