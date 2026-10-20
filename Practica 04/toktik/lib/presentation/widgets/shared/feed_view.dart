import 'package:flutter/material.dart';
import 'package:toktik/domain/entities/video_post.dart';
import 'package:toktik/presentation/widgets/shared/video_scrollable_view.dart';

/// Estados comunes de una sección: cargando, error, vacío y lista de videos.
class FeedView extends StatelessWidget {
  final bool loading;
  final String? error;
  final List<VideoPost> videos;
  final bool isActive;
  final String emptyMessage;
  final VoidCallback? onNearEnd;
  final VoidCallback? onRetry;

  const FeedView({
    super.key,
    required this.loading,
    required this.videos,
    required this.isActive,
    this.error,
    this.emptyMessage = 'No hay videos todavía',
    this.onNearEnd,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator(strokeWidth: 2));
    }

    if (videos.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(error ?? emptyMessage, textAlign: TextAlign.center),
            if (error != null && onRetry != null)
              TextButton(onPressed: onRetry, child: const Text('Reintentar')),
          ],
        ),
      );
    }

    return VideoScrollableView(
      videos: videos,
      isActive: isActive,
      onNearEnd: onNearEnd,
    );
  }
}
