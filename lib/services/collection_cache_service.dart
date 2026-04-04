import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import '../models/collection_model.dart';

class CollectionCacheService {
  CollectionCacheService({this.boxName = 'collection_cache'});

  final String boxName;
  Box<dynamic>? _box;

  Future<void> init() async {
    if (_box?.isOpen ?? false) {
      return;
    }

    final directory = await getApplicationSupportDirectory();
    Hive.init(directory.path);
    _box = await Hive.openBox<dynamic>(boxName);
  }

  Future<List<CollectionModel>?> getCollections(String key) async {
    final box = _box;
    if (box == null) {
      throw StateError('CollectionCacheService.init() must be called first.');
    }

    final rawValue = box.get(key);
    if (rawValue == null) {
      return null;
    }

    final values = (rawValue as List<dynamic>)
        .cast<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .map(CollectionModel.fromJson)
        .toList();

    return values;
  }

  Future<void> saveCollections(
    String key,
    List<CollectionModel> collections,
  ) async {
    final box = _box;
    if (box == null) {
      throw StateError('CollectionCacheService.init() must be called first.');
    }

    final payload = collections.map((collection) => collection.toJson()).toList();
    await box.put(key, payload);
  }

  Future<void> clearAll() async {
    final box = _box;
    if (box == null) {
      throw StateError('CollectionCacheService.init() must be called first.');
    }

    await box.clear();
  }
}
