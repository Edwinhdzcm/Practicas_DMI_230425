import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toktik/config/theme/app_theme.dart';
import 'package:toktik/infrastructure/datasource/facebook_video_datasource_impl.dart';
import 'package:toktik/infrastructure/datasource/instagram_video_datasource_impl.dart';
import 'package:toktik/infrastructure/datasource/local_video_datasource_impl.dart';
import 'package:toktik/infrastructure/datasource/youtube_video_datasource_impl.dart';
import 'package:toktik/infrastructure/repositories/video_posts_repository_impl.dart';
import 'package:toktik/infrastructure/storage/local_storage_service.dart';
import 'package:toktik/presentation/provider/discover_provider.dart';
import 'package:toktik/presentation/screens/discover/discover_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TokTik',
      debugShowCheckedModeBanner: false,
      theme: AppTheme().getTheme(),
      home: ChangeNotifierProvider(
        create: (_) => DiscoverProvider(
          storage: LocalStorageService(),
          videosRepositoy: VideoPostsRepositoryImpl(
            datasources: [
              LocalVideoDatasource(),
              YoutubeVideoDatasource(),
              InstagramVideoDatasource(),
              FacebookVideoDatasource(),
            ],
          ),
        )..loadNextPage(),
        child: const DiscoverScreen(),
      ),
    );
  }
}
