import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/repositories/movie_repository.dart';
import 'package:cinemapedia/main.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';

class _FakeMovieRepository implements MovieRepository {
  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async => [];

  @override
  Future<List<Movie>> getPopular({int page = 1}) async => [];

  @override
  Future<List<Movie>> getUpcoming({int page = 1}) async => [];

  @override
  Future<List<Movie>> getTopRated({int page = 1}) async => [];

  @override
  Future<Movie> getMovieById(String id) async => Movie(
        adult: false,
        backdropPath: '',
        genreIds: const [],
        id: 0,
        originalLanguage: 'es',
        originalTitle: 'Test',
        overview: '',
        popularity: 0,
        posterPath: '',
        releaseDate: DateTime(2026),
        title: 'Test',
        video: false,
        voteAverage: 0,
        voteCount: 0,
      );

  @override
  Future<List<Movie>> searchMovies(String query) async => [];
}

void main() {
  testWidgets('La app arranca sin errores', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          movieRepositoryProvider.overrideWithValue(_FakeMovieRepository()),
        ],
        child: const MainApp(),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
