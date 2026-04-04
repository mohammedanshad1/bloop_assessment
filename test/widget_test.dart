import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bloop_assessment/main.dart';
import 'package:bloop_assessment/models/collection_model.dart';
import 'package:bloop_assessment/providers/collection_list_provider.dart';
import 'package:bloop_assessment/services/collection_cache_service.dart';
import 'package:bloop_assessment/services/collection_remote_service.dart';

class _FakeCollectionRemoteService implements CollectionRemoteService {
  @override
  Future<List<CollectionModel>> fetchCollections() async {
    return [
      CollectionModel(
        id: 'test-collection',
        title: 'Test Collection',
        description: 'Loaded from a fake service for widget testing.',
        coverImageUrl: 'https://example.com/test.jpg',
        creatorId: 'tester',
        isPremium: false,
        sectionCount: 2,
        createdAt: DateTime.parse('2024-01-15T10:30:00Z'),
      ),
    ];
  }
}

class _InMemoryCollectionCacheService extends CollectionCacheService {
  _InMemoryCollectionCacheService() : super(boxName: 'test_collection_cache');

  List<CollectionModel>? _data;

  @override
  Future<void> init() async {}

  @override
  Future<List<CollectionModel>?> getCollections(String key) async => _data;

  @override
  Future<void> saveCollections(
    String key,
    List<CollectionModel> collections,
  ) async {
    _data = collections;
  }

  @override
  Future<void> clearAll() async {
    _data = null;
  }
}

void main() {
  testWidgets('renders collection list content', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          collectionCacheServiceProvider.overrideWith(
            (ref) => _InMemoryCollectionCacheService(),
          ),
          collectionRemoteServiceProvider.overrideWith(
            (ref) => _FakeCollectionRemoteService(),
          ),
        ],
        child: const MyApp(),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text('Bloop Collections'), findsOneWidget);
    expect(find.text('Test Collection'), findsOneWidget);
    expect(
      find.text('Loaded from a fake service for widget testing.'),
      findsOneWidget,
    );
  });
}
