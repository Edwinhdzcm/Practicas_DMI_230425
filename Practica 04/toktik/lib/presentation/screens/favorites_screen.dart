import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toktik/presentation/providers/favorites_provider.dart';
import 'package:toktik/presentation/widgets/shared/feed_view.dart';

class FavoritesScreen extends StatelessWidget {
  final bool isActive;
  const FavoritesScreen({super.key, this.isActive = true});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FavoritesProvider>();

    return FeedView(
      loading: provider.loading,
      videos: provider.favorites,
      isActive: isActive,
      emptyMessage: 'Aún no tienes favoritos.\nDa "me gusta" a un video para verlo aquí.',
    );
  }
}
