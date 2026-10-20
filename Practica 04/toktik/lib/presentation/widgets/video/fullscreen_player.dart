import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toktik/config/theme/season_theme.dart';
import 'package:toktik/domain/entities/video_post.dart';
import 'package:toktik/presentation/providers/playback_provider.dart';
import 'package:toktik/presentation/providers/theme_provider.dart';
import 'package:toktik/presentation/providers/views_provider.dart';
import 'package:toktik/presentation/widgets/video/video_background.dart';
import 'package:video_player/video_player.dart';

class FullScreenPlayer extends StatefulWidget {
  final VideoPost video;

  /// Solo el video activo (visible) se reproduce.
  final bool isActive;

  const FullScreenPlayer({
    super.key,
    required this.video,
    required this.isActive,
  });

  @override
  State<FullScreenPlayer> createState() => _FullScreenPlayerState();
}

class _FullScreenPlayerState extends State<FullScreenPlayer> {
  VideoPlayerController? _controller;
  bool _ready = false;
  bool _hasError = false;
  bool _pausedByUser = false;
  bool _muted = false;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  Future<void> _initController() async {
    final video = widget.video;
    final controller = video.isLocal
        ? VideoPlayerController.asset(video.videoUrl)
        : VideoPlayerController.network(video.videoUrl);
    _controller = controller;

    try {
      await controller.initialize();
      if (!mounted) return;
      await controller.setLooping(true);
      await controller.setVolume(_muted ? 0 : 1);
      setState(() => _ready = true);
      _syncPlayback();
      _maybeCountView();
    } catch (_) {
      if (mounted) setState(() => _hasError = true);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Se vuelve a ejecutar cada vez que cambia el mute global.
    _muted = Provider.of<PlaybackProvider>(context).isMuted;
    if (_ready) _controller?.setVolume(_muted ? 0 : 1);
  }

  @override
  void didUpdateWidget(covariant FullScreenPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isActive != widget.isActive) {
      _pausedByUser = false;
      _syncPlayback();
      _maybeCountView();
    }
  }

  /// Suma +1 cuando este video empieza a verse (ya listo y activo).
  /// Se hace en postFrame para no notificar durante el build.
  void _maybeCountView() {
    if (!_ready || !widget.isActive || !mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_ready || !widget.isActive) return;
      try {
        context.read<ViewsProvider>().registerView(widget.video);
      } catch (_) {
        // provider aún no disponible: se contará en la próxima activación
      }
    });
  }

  void _syncPlayback() {
    final controller = _controller;
    if (!_ready || controller == null) return;

    if (widget.isActive && !_pausedByUser) {
      controller.play();
    } else {
      controller.pause();
    }
  }

  void _togglePlay() {
    final controller = _controller;
    if (!_ready || controller == null) return;

    setState(() => _pausedByUser = controller.value.isPlaying);
    _syncPlayback();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final SeasonTheme theme = context.watch<ThemeProvider>().theme;

    if (_hasError) {
      return const _VideoError();
    }

    final controller = _controller;
    if (!_ready || controller == null) {
      return const Center(child: CircularProgressIndicator(strokeWidth: 2));
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _togglePlay,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Video a pantalla completa (recortado, sin deformarse)
          ClipRect(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: controller.value.size.width,
                height: controller.value.size.height,
                child: VideoPlayer(controller),
              ),
            ),
          ),

          // Gradiente inferior con el color de la temporada
          VideoBackground(
            colors: [Colors.transparent, theme.gradientEnd],
            stops: const [0.6, 1.0],
          ),

          // Icono de pausa al centro
          Center(
            child: AnimatedOpacity(
              opacity: _pausedByUser ? 1 : 0,
              duration: const Duration(milliseconds: 200),
              child: const Icon(
                Icons.play_arrow_rounded,
                size: 96,
                color: Colors.white70,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VideoError extends StatelessWidget {
  const _VideoError();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.error_outline, size: 48, color: Colors.white54),
          SizedBox(height: 8),
          Text('No se pudo reproducir este video',
              style: TextStyle(color: Colors.white54)),
        ],
      ),
    );
  }
}
