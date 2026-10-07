import 'package:toktik/domain/entities/video_post.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

/// Crea el [VideoPlayerController] correcto según el origen del video.
class VideoSourceResolver {
  VideoSourceResolver._();

  static Future<VideoPlayerController> createController(VideoPost video) async {
    switch (video.source) {
      case VideoSource.local:
        return VideoPlayerController.asset(video.videoUrl);

      case VideoSource.youtube:
        // video_player no entiende links de YouTube: se resuelve un mp4 directo.
        // Se hace al reproducir porque esas URLs caducan en unas horas.
        final url = await _resolveYoutubeStream(video.videoUrl);
        return VideoPlayerController.networkUrl(Uri.parse(url));

      case VideoSource.instagram:
      case VideoSource.facebook:
        return VideoPlayerController.networkUrl(Uri.parse(video.videoUrl));
    }
  }

  static Future<String> _resolveYoutubeStream(String videoId) async {
    final yt = YoutubeExplode();
    try {
      final manifest = await yt.videos.streamsClient.getManifest(videoId);
      // "muxed" = audio y video en el mismo archivo
      return manifest.muxed.withHighestBitrate().url.toString();
    } finally {
      yt.close();
    }
  }
}
