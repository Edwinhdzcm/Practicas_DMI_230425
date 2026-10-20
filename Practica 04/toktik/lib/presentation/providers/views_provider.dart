import 'package:flutter/foundation.dart';
import 'package:toktik/domain/datasources/local_storage_datasource.dart';
import 'package:toktik/domain/entities/video_post.dart';

/// Contador de vistas: suma +1 cada vez que un video se vuelve visible
/// y lo persiste en local storage.
class ViewsProvider extends ChangeNotifier {
  final LocalStorageDataSource storage;

  ViewsProvider(this.storage);

  final Map<String, int> _counts = {};

  Future<void> init() async {
    final loaded = await storage.getViewCounts();
    // No sobrescribir conteos frescos si init termina después
    // de haber registrado vistas.
    for (final entry in loaded.entries) {
      _counts.putIfAbsent(entry.key, () => entry.value);
    }
    notifyListeners();
  }

  /// Vistas mostradas: las guardadas o, si no hay, las originales del video.
  int viewsFor(VideoPost video) => _counts[video.id] ?? video.views;

  /// Suma +1 cada vez que el video se vuelve visible.
  /// Se llama cuando el reproductor empieza a reproducir.
  Future<void> registerView(VideoPost video) async {
    final newCount = viewsFor(video) + 1;
    _counts[video.id] = newCount;
    notifyListeners();

    await storage.saveViewCount(id: video.id, count: newCount);
  }
}
