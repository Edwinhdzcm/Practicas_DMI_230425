import 'package:flutter/material.dart';
import 'package:toktik/domain/entities/video_post.dart';
import 'package:toktik/presentation/widgets/shared/video_buttons.dart';
import 'package:toktik/presentation/widgets/video/fullscreen_player.dart';
import 'package:toktik/presentation/widgets/video/video_description.dart';

/// Lista vertical de videos (estilo TikTok).
class VideoScrollableView extends StatefulWidget {
  final List<VideoPost> videos;

  /// false cuando la sección no está visible (se pausan todos los videos).
  final bool isActive;

  /// Se llama al acercarse al final para cargar más videos.
  final VoidCallback? onNearEnd;

  const VideoScrollableView({
    super.key,
    required this.videos,
    this.isActive = true,
    this.onNearEnd,
  });

  @override
  State<VideoScrollableView> createState() => _VideoScrollableViewState();
}

class _VideoScrollableViewState extends State<VideoScrollableView> {
  int _current = 0;

  void _onPageChanged(int index) {
    setState(() => _current = index);
    if (index >= widget.videos.length - 2) widget.onNearEnd?.call();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return PageView.builder(
      scrollDirection: Axis.vertical,
      physics: const BouncingScrollPhysics(),
      itemCount: widget.videos.length,
      onPageChanged: _onPageChanged,
      itemBuilder: (context, index) {
        final VideoPost videoPost = widget.videos[index];

        return Stack(
          children: [
            // Video Player + gradiente
            SizedBox.expand(
              child: FullScreenPlayer(
                key: ValueKey(videoPost.id),
                video: videoPost,
                isActive: widget.isActive && index == _current,
              ),
            ),

            // Título + descripción (con "... más")
            Positioned(
              bottom: 30 + bottomInset,
              left: 20,
              child: SizedBox(
                width: size.width * 0.65,
                child: VideoDescription(
                  caption: videoPost.caption,
                  description: videoPost.description,
                ),
              ),
            ),

            // Botones
            Positioned(
              bottom: 40 + bottomInset,
              right: 12,
              child: VideoButtons(video: videoPost),
            ),
          ],
        );
      },
    );
  }
}
