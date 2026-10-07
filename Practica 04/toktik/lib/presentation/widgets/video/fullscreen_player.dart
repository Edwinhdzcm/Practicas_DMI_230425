import 'package:flutter/material.dart';
import 'package:toktik/config/helpers/video_source_resolver.dart';
import 'package:toktik/domain/entities/video_post.dart';
import 'package:toktik/presentation/widgets/video/video_background.dart';
import 'package:video_player/video_player.dart';

class FullScreenPlayer extends StatefulWidget {
  final VideoPost video;
  final bool isMuted;

  const FullScreenPlayer({
    super.key,
    required this.video,
    required this.isMuted,
  });

  @override
  State<FullScreenPlayer> createState() => _FullScreenPlayerState();
}

class _FullScreenPlayerState extends State<FullScreenPlayer> {
  VideoPlayerController? _controller;
  late final Future<void> _initFuture;

  /// true cuando el usuario pausó el video con un tap (muestra el ícono central)
  bool _userPaused = false;

  @override
  void initState() {
    super.initState();
    // Se inicializa UNA sola vez (antes se llamaba initialize() en cada build)
    _initFuture = _setupController();
  }

  Future<void> _setupController() async {
    final controller = await VideoSourceResolver.createController(widget.video);

    if (!mounted) {
      await controller.dispose();
      return;
    }

    _controller = controller;
    await controller.initialize();

    if (!mounted) return;
    await controller.setLooping(true);
    await controller.setVolume(widget.isMuted ? 0 : 1);
    await controller.play();
  }

  @override
  void didUpdateWidget(covariant FullScreenPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);

    // El botón de mute cambió
    if (oldWidget.isMuted != widget.isMuted) {
      _controller?.setVolume(widget.isMuted ? 0 : 1);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initFuture,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _VideoError(caption: widget.video.caption);
        }

        if (snapshot.connectionState != ConnectionState.done ||
            _controller == null ||
            !_controller!.value.isInitialized) {
          return const Center(child: CircularProgressIndicator(strokeWidth: 2));
        }

        final controller = _controller!;
        final size = controller.value.size;
        final isVertical = controller.value.aspectRatio < 1;

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            if (controller.value.isPlaying) {
              controller.pause();
              setState(() => _userPaused = true);
              return;
            }
            controller.play();
            setState(() => _userPaused = false);
          },
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Vertical: llena la pantalla. Horizontal: se ve completo.
              FittedBox(
                fit: isVertical ? BoxFit.cover : BoxFit.contain,
                child: SizedBox(
                  width: size.width,
                  height: size.height,
                  child: VideoPlayer(controller),
                ),
              ),

              // Gradiente
              VideoBackground(stops: [0.8, 1.0]),

              // Ícono central al pausar (estilo TikTok)
              Center(
                child: IgnorePointer(
                  child: AnimatedOpacity(
                    opacity: _userPaused ? 1 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: AnimatedScale(
                      scale: _userPaused ? 1 : 1.4,
                      duration: const Duration(milliseconds: 200),
                      child: const Icon(
                        Icons.play_arrow_rounded,
                        size: 100,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ),
              ),

              // Texto
              Positioned(
                bottom: 50,
                left: 20,
                child: _VideoCaption(caption: widget.video.caption),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _VideoCaption extends StatelessWidget {
  final String caption;

  const _VideoCaption({required this.caption});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final titleStyle = Theme.of(context).textTheme.titleLarge;

    return SizedBox(
      width: size.width * 0.6,
      child: Text(
        caption,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: titleStyle,
      ),
    );
  }
}

class _VideoError extends StatelessWidget {
  final String caption;

  const _VideoError({required this.caption});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 40),
            const SizedBox(height: 12),
            Text(
              'No se pudo reproducir este video',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(caption, maxLines: 2, overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}
