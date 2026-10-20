import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:toktik/domain/entities/season.dart';

/// Cambia el icono del launcher según la temporada.
///
/// Android: activa el activity-alias de la temporada
/// (MainActivity.kt) con los mipmaps generados desde assets/img.
/// iOS: usa el icono alterno declarado en Info.plist (AppDelegate.swift).
/// Normal usa el icono primario (assets/img/img.jpg).
class AppIconService {
  static const _channel = MethodChannel('toktik/app_icon');

  static Future<void> applySeason(Season season) async {
    try {
      await _channel.invokeMethod('setSeasonIcon', {'season': season.name});
    } on MissingPluginException catch (_) {
      // Tests o plataforma sin canal nativo: no hace nada.
      debugPrint('AppIconService: canal no disponible (${season.name})');
    } catch (e) {
      debugPrint('AppIconService: no se pudo cambiar el icono: $e');
    }
  }
}
