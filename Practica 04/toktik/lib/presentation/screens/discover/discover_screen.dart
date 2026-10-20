import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toktik/presentation/providers/discover_provider.dart';
import 'package:toktik/presentation/widgets/shared/feed_view.dart';

class DiscoverScreen extends StatelessWidget {
  final bool isActive;
  const DiscoverScreen({super.key, this.isActive = true});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DiscoverProvider>();

    return FeedView(
      loading: provider.initialLoading,
      error: provider.error,
      videos: provider.videos,
      isActive: isActive,
      onNearEnd: provider.loadNextPage,
      onRetry: provider.retry,
    );
  }
}
