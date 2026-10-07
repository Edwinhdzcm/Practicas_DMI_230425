/// Configuración de las APIs externas.
///
/// Las llaves NO se escriben en el código: se pasan al ejecutar con
/// `--dart-define`, así no terminan subidas al repositorio.
///
/// flutter run \
///   --dart-define=YOUTUBE_API_KEY=xxxx \
///   --dart-define=INSTAGRAM_ACCESS_TOKEN=xxxx \
///   --dart-define=INSTAGRAM_USER_ID=xxxx \
///   --dart-define=FACEBOOK_ACCESS_TOKEN=xxxx \
///   --dart-define=FACEBOOK_PAGE_ID=xxxx
class ApiConfig {
  ApiConfig._();

  // YouTube Data API v3
  static const youtubeApiKey = String.fromEnvironment('YOUTUBE_API_KEY');
  static const youtubeRegion = String.fromEnvironment(
    'YOUTUBE_REGION',
    defaultValue: 'MX',
  );

  // Instagram (Graph API) -> cuenta Business/Creator ligada a una página
  static const instagramAccessToken =
      String.fromEnvironment('INSTAGRAM_ACCESS_TOKEN');
  static const instagramUserId = String.fromEnvironment('INSTAGRAM_USER_ID');

  // Facebook (Graph API) -> videos de una página
  static const facebookAccessToken =
      String.fromEnvironment('FACEBOOK_ACCESS_TOKEN');
  static const facebookPageId = String.fromEnvironment('FACEBOOK_PAGE_ID');

  /// Versión de la Graph API de Meta. Si deja de funcionar, súbela.
  static const graphVersion = 'v23.0';

  /// Cuántos videos se piden a cada API.
  static const videosPerSource = 10;

  static bool get hasYoutube => youtubeApiKey.isNotEmpty;

  static bool get hasInstagram =>
      instagramAccessToken.isNotEmpty && instagramUserId.isNotEmpty;

  static bool get hasFacebook =>
      facebookAccessToken.isNotEmpty && facebookPageId.isNotEmpty;
}
