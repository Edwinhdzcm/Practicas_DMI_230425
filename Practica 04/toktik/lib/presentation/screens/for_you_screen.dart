import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toktik/presentation/providers/for_you_provider.dart';
import 'package:toktik/presentation/widgets/shared/feed_view.dart';

class ForYouScreen extends StatelessWidget {
  final bool isActive;
  const ForYouScreen({super.key, this.isActive = true});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ForYouProvider>();

    return FeedView(
      loading: provider.initialLoading,
      error: provider.error,
      videos: provider.videos,
      isActive: isActive,
      emptyMessage: 'No se pudieron obtener videos de YouTube, Dailymotion '
          'o Vimeo. Revisa tu conexión.',
      onNearEnd: provider.loadNextPage,
      onRetry: provider.retry,
    );
  }
}
