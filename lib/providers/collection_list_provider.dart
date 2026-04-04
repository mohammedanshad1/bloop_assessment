import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/collection_model.dart';
import '../services/collection_cache_service.dart';
import '../services/collection_remote_service.dart';

const _collectionCacheKey = 'collection_list';

final collectionCacheServiceProvider = Provider<CollectionCacheService>((ref) {
  return CollectionCacheService();
});

final collectionRemoteServiceProvider = Provider<CollectionRemoteService>((ref) {
  return MockCollectionRemoteService();
});

final collectionListProvider =
    AsyncNotifierProvider<CollectionListNotifier, List<CollectionModel>>(
  CollectionListNotifier.new,
);

class CollectionListNotifier extends AsyncNotifier<List<CollectionModel>> {
  late final CollectionCacheService _cacheService;
  late final CollectionRemoteService _remoteService;

  @override
  FutureOr<List<CollectionModel>> build() async {
    _cacheService = ref.read(collectionCacheServiceProvider);
    _remoteService = ref.read(collectionRemoteServiceProvider);

    await _cacheService.init();
    final cachedCollections = await _cacheService.getCollections(
      _collectionCacheKey,
    );

    if (cachedCollections != null) {
      unawaited(_refreshInBackground());
      return cachedCollections;
    }

    return _fetchAndPersist();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetchAndPersist);
  }

  Future<void> _refreshInBackground() async {
    final freshCollections = await AsyncValue.guard(_fetchAndPersist);
    try {
      state = freshCollections;
    } on StateError {
      // The notifier was disposed before the background refresh completed.
    }
  }

  Future<List<CollectionModel>> _fetchAndPersist() async {
    final freshCollections = await _remoteService.fetchCollections();
    await _cacheService.saveCollections(_collectionCacheKey, freshCollections);
    return freshCollections;
  }
}
