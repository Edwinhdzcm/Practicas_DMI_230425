import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toktik/config/helpers/human_formats.dart';
import 'package:toktik/config/theme/season_theme.dart';
import 'package:toktik/domain/entities/video_post.dart';
import 'package:toktik/presentation/providers/favorites_provider.dart';
import 'package:toktik/presentation/providers/views_provider.dart';

/// Columna lateral derecha estilo TikTok literal:
/// corazón, comentario, guardar, compartir, vistas + disco girando.
class VideoButtons extends StatefulWidget {
  final VideoPost video;

  const VideoButtons({super.key, required this.video});

  @override
  State<VideoButtons> createState() => _VideoButtonsState();
}

class _VideoButtonsState extends State<VideoButtons> {
  bool _saved = false;

  // Contadores pseudo-reales derivados del video para que siempre
  // se vean como TikTok aunque el backend solo traiga likes/views.
  int _commentsFor(int likes, int views, String id) {
    final h = id.hashCode.abs();
    return likes ~/ 9 + views ~/ 25 + (h % 800) + 120;
  }

  int _savesFor(int likes, String id) {
    final h = id.hashCode.abs();
    return likes ~/ 12 + (h % 1500) + 80;
  }

  int _sharesFor(int likes, int views, String id) {
    final h = id.hashCode.abs();
    return likes ~/ 18 + views ~/ 60 + (h % 900) + 45;
  }

  @override
  Widget build(BuildContext context) {
    // Los botones conservan siempre el aspecto de la temporada Normal:
    // cambiar de tema no los altera.
    final theme = SeasonTheme.normal;
    final favorites = context.watch<FavoritesProvider>();
    final viewsProvider = context.watch<ViewsProvider>();

    final liked = favorites.isLiked(widget.video.id);
    final likes = favorites.likesFor(widget.video);
    final views = viewsProvider.viewsFor(widget.video);
    final comments = _commentsFor(likes, views, widget.video.id);
    var saves = _savesFor(likes, widget.video.id);
    if (_saved) saves += 1;
    final shares = _sharesFor(likes, views, widget.video.id);

    // Rosa TikTok oficial, igual en todas las temporadas.
    const tiktokRed = Color(0xFFFE2C55);
    const tiktokYellow = Color(0xFFFACC15);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 1. LIKE — corazón relleno, blanco -> rojo
        _TikTokAction(
          icon: liked ? theme.likedIcon : theme.likeIcon,
          value: likes,
          color: liked ? tiktokRed : Colors.white,
          onPressed: () => favorites.toggleLike(widget.video),
        ),
        const SizedBox(height: 16),
        // 2. COMENTARIOS — globo de diálogo
        _TikTokAction(
          icon: theme.commentIcon,
          value: comments,
          onPressed: () {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(
                  content: Text('Comentarios próximamente'),
                  duration: Duration(seconds: 1),
                ),
              );
          },
        ),
        const SizedBox(height: 16),
        // 3. GUARDAR — bookmark, blanco -> amarillo
        _TikTokAction(
          icon: _saved ? theme.savedIcon : theme.saveIcon,
          value: saves,
          color: _saved ? tiktokYellow : Colors.white,
          onPressed: () => setState(() => _saved = !_saved),
        ),
        const SizedBox(height: 16),
        // 4. COMPARTIR — flecha curva (reply espejado = TikTok share)
        _TikTokAction(
          icon: theme.shareIcon,
          value: shares,
          mirror: true,
          onPressed: () {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(
                  content: Text('¡Enlace copiado!'),
                  duration: Duration(seconds: 1),
                ),
              );
          },
        ),
        const SizedBox(height: 16),
        // 5. VISTAS — ojo + contador en vivo (sí suma al ver el video)
        _TikTokAction(
          icon: theme.viewsIcon,
          value: views,
          onPressed: () {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(
                    '$views reproducciones',
                  ),
                  duration: const Duration(seconds: 1),
                ),
              );
          },
        ),
        const SizedBox(height: 24),
        // 5. DISCO — vinilo girando como TikTok
        SpinPerfect(
          infinite: true,
          duration: const Duration(seconds: 5),
          child: Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF2A2A2A), Colors.black],
              ),
              border: Border.all(color: Colors.white24, width: 8),
            ),
            child: const Center(
              child: Icon(Icons.music_note, color: Colors.white, size: 16),
            ),
          ),
        ),
      ],
    );
  }
}

/// Icono + contador estilo TikTok: icono 35px blanco, número 12px semibold.
class _TikTokAction extends StatelessWidget {
  final IconData icon;
  final int value;
  final Color color;
  final VoidCallback onPressed;
  final bool mirror;

  const _TikTokAction({
    required this.icon,
    required this.value,
    required this.onPressed,
    this.color = Colors.white,
    this.mirror = false,
  });

  @override
  Widget build(BuildContext context) {
    final iconWidget = Icon(icon, color: color, size: 35);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: onPressed,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          icon: mirror
              ? Transform.flip(
                  flipX: true,
                  child: iconWidget,
                )
              : iconWidget,
        ),
        const SizedBox(height: 2),
        Text(
          HumanFormats.humanReadbleNumber(value.toDouble()),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
