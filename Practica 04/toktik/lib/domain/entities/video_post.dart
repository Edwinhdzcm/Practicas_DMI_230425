/// De dónde viene el video. Decide cómo se reproduce.
enum VideoSource { local, youtube, instagram, facebook }

class VideoPost {
  /// Identificador único (incluye el origen, ej. `yt:abc123`).
  final String id;
  final String caption;

  /// Ruta del asset, URL del mp4 o id de YouTube, según [source].
  final String videoUrl;
  final VideoSource source;

  /// Likes que vienen de la fuente (sin contar el like del usuario).
  final int likes;
  final int views;
  final bool isLiked;

  VideoPost({
    required this.id,
    required this.caption,
    required this.videoUrl,
    this.source = VideoSource.local,
    this.likes = 0,
    this.views = 0,
    this.isLiked = false,
  })  : assert(id.isNotEmpty, 'El video debe tener un id'),
        assert(videoUrl.isNotEmpty, 'El video debe tener una URL o asset'),
        assert(likes >= 0 && views >= 0, 'Likes y views no pueden ser negativos');

  /// Likes que se muestran en pantalla.
  int get displayLikes => likes + (isLiked ? 1 : 0);

  VideoPost copyWith({bool? isLiked}) => VideoPost(
        id: id,
        caption: caption,
        videoUrl: videoUrl,
        source: source,
        likes: likes,
        views: views,
        isLiked: isLiked ?? this.isLiked,
      );
}
