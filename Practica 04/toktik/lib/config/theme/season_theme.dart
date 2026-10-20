import 'package:flutter/material.dart';
import 'package:toktik/domain/entities/season.dart';

/// Todo lo que cambia entre temporadas: paleta, tipografía, iconos y audio.
class SeasonTheme {
  final Season season;
  final String name;
  final String emoji;
  final String fontFamily;

  /// Ruta relativa a assets/ (para AssetSource de audioplayers).
  final String audioAsset;

  // Icono de launcher de la temporada (assets/img).
  final String iconAsset;

  // Paleta
  final Color primary;
  final Color secondary;
  final Color background;
  final Color surface;
  final Color likeColor;
  final Color gradientEnd;

  // Iconografía — laterales estilo TikTok literal
  final IconData likeIcon;
  final IconData likedIcon;
  final IconData commentIcon;
  final IconData saveIcon;
  final IconData savedIcon;
  final IconData shareIcon;
  final IconData viewsIcon;
  final IconData discIcon;
  final IconData themeIcon;

  const SeasonTheme({
    required this.season,
    required this.name,
    required this.emoji,
    required this.fontFamily,
    required this.audioAsset,
    required this.iconAsset,
    required this.primary,
    required this.secondary,
    required this.background,
    required this.surface,
    required this.likeColor,
    required this.gradientEnd,
    required this.likeIcon,
    required this.likedIcon,
    required this.commentIcon,
    required this.saveIcon,
    required this.savedIcon,
    required this.shareIcon,
    required this.viewsIcon,
    required this.discIcon,
    required this.themeIcon,
  });

  static SeasonTheme of(Season season) {
    switch (season) {
      case Season.halloween:
        return _halloween;
      case Season.christmas:
        return _christmas;
      case Season.valentine:
        return _valentine;
      case Season.normal:
        return _normal;
    }
  }

  /// Tema de referencia: la temporada Normal.
  ///
  /// Los botones siempre toman sus iconos y colores de aquí, así su
  /// aspecto no cambia al cambiar de temporada. El resto de la UI
  /// (fondo, tipografía, gradientes) sí sigue a la temporada activa.
  static SeasonTheme get normal => _normal;

  static const _normal = SeasonTheme(
    season: Season.normal,
    name: 'Normal',
    emoji: '🎬',
    fontFamily: 'Poppins',
    audioAsset: 'audio/normal.wav',
    iconAsset: 'assets/img/img.jpg',
    primary: Color(0xFFFE2C55),
    secondary: Color(0xFF25F4EE),
    background: Colors.black,
    surface: Color(0xFF121212),
    likeColor: Color(0xFFFE2C55),
    gradientEnd: Colors.black87,
    // Iconos TikTok literales (resto del año).
    likeIcon: Icons.favorite,
    likedIcon: Icons.favorite,
    commentIcon: Icons.chat_bubble,
    saveIcon: Icons.bookmark_border,
    savedIcon: Icons.bookmark,
    shareIcon: Icons.reply,
    viewsIcon: Icons.remove_red_eye_outlined,
    discIcon: Icons.album,
    themeIcon: Icons.palette_outlined,
  );

  static const _halloween = SeasonTheme(
    season: Season.halloween,
    name: 'Halloween',
    emoji: '🎃',
    fontFamily: 'Creepster',
    audioAsset: 'audio/halloween.wav',
    iconAsset: 'assets/img/3.jpg',
    primary: Color(0xFFFF7A00),
    secondary: Color(0xFF8E24AA),
    background: Color(0xFF0D0612),
    surface: Color(0xFF1C0F26),
    likeColor: Color(0xFFFE2C55),
    gradientEnd: Color(0xE61A0826),
    // Iconos de temporada: cambian con la fecha (21 oct -> 2 nov).
    likeIcon: Icons.nights_stay_outlined,
    likedIcon: Icons.nights_stay,
    commentIcon: Icons.forum_outlined,
    saveIcon: Icons.bookmark_border,
    savedIcon: Icons.bookmark,
    shareIcon: Icons.reply,
    viewsIcon: Icons.visibility_outlined,
    discIcon: Icons.nightlight_round,
    themeIcon: Icons.nights_stay,
  );

  static const _christmas = SeasonTheme(
    season: Season.christmas,
    name: 'Navidad',
    emoji: '🎄',
    fontFamily: 'MountainsOfChristmas',
    audioAsset: 'audio/christmas.wav',
    iconAsset: 'assets/img/2.jpg',
    primary: Color(0xFFD32F2F),
    secondary: Color(0xFF2E7D32),
    background: Color(0xFF07140B),
    surface: Color(0xFF10261A),
    likeColor: Color(0xFFFE2C55),
    gradientEnd: Color(0xE6062010),
    // Iconos de temporada: cambian con la fecha (15 dic -> 6 ene).
    likeIcon: Icons.star_border,
    likedIcon: Icons.star,
    commentIcon: Icons.forum_outlined,
    saveIcon: Icons.card_giftcard,
    savedIcon: Icons.card_giftcard,
    shareIcon: Icons.send,
    viewsIcon: Icons.ac_unit,
    discIcon: Icons.celebration,
    themeIcon: Icons.ac_unit,
  );

  static const _valentine = SeasonTheme(
    season: Season.valentine,
    name: 'San Valentín',
    emoji: '💘',
    fontFamily: 'Pacifico',
    audioAsset: 'audio/valentine.wav',
    iconAsset: 'assets/img/1.jpg',
    primary: Color(0xFFFF4081),
    secondary: Color(0xFFF8BBD0),
    background: Color(0xFF1A0510),
    surface: Color(0xFF2B0A1B),
    likeColor: Color(0xFFFE2C55),
    gradientEnd: Color(0xE61F0614),
    // Iconos de temporada: cambian con la fecha (4 feb -> 15 feb).
    likeIcon: Icons.favorite_border,
    likedIcon: Icons.favorite,
    commentIcon: Icons.forum_outlined,
    saveIcon: Icons.bookmark_border,
    savedIcon: Icons.bookmark,
    shareIcon: Icons.send,
    viewsIcon: Icons.visibility_outlined,
    discIcon: Icons.volunteer_activism,
    themeIcon: Icons.favorite,
  );
}