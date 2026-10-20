import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toktik/config/helpers/season_audio_player.dart';
import 'package:toktik/config/theme/app_theme.dart';
import 'package:toktik/domain/entities/video_source.dart';
import 'package:toktik/infrastructure/datasources/dailymotion_video_datasource_impl.dart';
import 'package:toktik/infrastructure/datasources/local_video_datasource_impl.dart';
import 'package:toktik/infrastructure/datasources/prefs_local_storage_datasource.dart';
import 'package:toktik/infrastructure/datasources/vimeo_video_datasource_impl.dart';
import 'package:toktik/infrastructure/datasources/youtube_video_datasource_impl.dart';
import 'package:toktik/infrastructure/repositories/video_posts_repository_impl.dart';
import 'package:toktik/infrastructure/repositories/for_you_repository_impl.dart';
import 'package:toktik/infrastructure/repositories/likes_repository_impl.dart';
import 'package:toktik/infrastructure/repositories/settings_repository_impl.dart';
import 'package:toktik/presentation/providers/discover_provider.dart';
import 'package:toktik/presentation/providers/favorites_provider.dart';
import 'package:toktik/presentation/providers/for_you_provider.dart';
import 'package:toktik/presentation/providers/playback_provider.dart';
import 'package:toktik/presentation/providers/theme_provider.dart';
import 'package:toktik/presentation/providers/views_provider.dart';
import 'package:toktik/presentation/screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ---- Composición de dependencias (datasources -> repositories) ----
  final prefs = await SharedPreferences.getInstance();
  final storage = PrefsLocalStorageDataSource(prefs);

  final localDs = LocalVideoDatasource();
  final youtubeDs = YoutubeVideoDatasource();
  final dailymotionDs = DailymotionVideoDatasource();
  final vimeoDs = VimeoVideoDatasource();

  final discoverRepo = VideoPostsRepositoryImpl(videosDatasource: localDs);
  final forYouRepo = ForYouRepositoryImpl([youtubeDs, dailymotionDs, vimeoDs]);
  final likesRepo = LikesRepositoryImpl(
    storage: storage,
    resolvers: {
      VideoSource.local: localDs,
      VideoSource.youtube: youtubeDs,
      VideoSource.dailymotion: dailymotionDs,
      VideoSource.vimeo: vimeoDs,
    },
  );
  final settingsRepo = SettingsRepositoryImpl(storage);

  runApp(MyApp(
    discoverRepo: discoverRepo,
    forYouRepo: forYouRepo,
    likesRepo: likesRepo,
    settingsRepo: settingsRepo,
    storage: storage,
  ));
}

class MyApp extends StatelessWidget {
  final VideoPostsRepositoryImpl discoverRepo;
  final ForYouRepositoryImpl forYouRepo;
  final LikesRepositoryImpl likesRepo;
  final SettingsRepositoryImpl settingsRepo;
  final PrefsLocalStorageDataSource storage;

  const MyApp({
    super.key,
    required this.discoverRepo,
    required this.forYouRepo,
    required this.likesRepo,
    required this.settingsRepo,
    required this.storage,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(
            repository: settingsRepo,
            audio: SeasonAudioPlayer(),
          )..init(),
        ),
        ChangeNotifierProvider(
          create: (_) => PlaybackProvider(settingsRepo)..init(),
        ),
        ChangeNotifierProvider(
          create: (_) => FavoritesProvider(likesRepo)..init(),
        ),
        ChangeNotifierProvider(
          create: (_) => ViewsProvider(storage)..init(),
        ),
        ChangeNotifierProvider(
          lazy: false,
          create: (_) => DiscoverProvider(videosRepositoy: discoverRepo)..loadNextPage(),
        ),
        ChangeNotifierProvider(
          lazy: false,
          create: (_) => ForYouProvider(videosRepositoy: forYouRepo)..loadNextPage(),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) => MaterialApp(
          title: 'TokTik',
          debugShowCheckedModeBanner: false,
          theme: AppTheme(themeProvider.theme).getTheme(),
          home: const SplashScreen(),
        ),
      ),
    );
  }
}
