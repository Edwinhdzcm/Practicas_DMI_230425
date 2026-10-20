/// Origen (datasource) de un video.
enum VideoSource { local, youtube, dailymotion, vimeo }

extension VideoSourceLabel on VideoSource {
  String get label {
    switch (this) {
      case VideoSource.local:
        return 'Local';
      case VideoSource.youtube:
        return 'YouTube';
      case VideoSource.dailymotion:
        return 'Dailymotion';
      case VideoSource.vimeo:
        return 'Vimeo';
    }
  }
}
