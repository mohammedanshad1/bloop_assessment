import '../models/collection_model.dart';

abstract class CollectionRemoteService {
  Future<List<CollectionModel>> fetchCollections();
}

class MockCollectionRemoteService implements CollectionRemoteService {
  @override
  Future<List<CollectionModel>> fetchCollections() async {
    await Future<void>.delayed(const Duration(milliseconds: 700));

    const data = [
      {
        'id': 'mindful-math',
        'title': 'Mindful Math Foundations',
        'description':
            'A calm, structured course that turns everyday number sense into lasting confidence.',
        'coverImageUrl':
            'https://images.unsplash.com/photo-1509062522246-3755977927d7',
        'creatorId': 'creator_anna',
        'isPremium': false,
        'sectionCount': 4,
        'createdAt': '2024-01-15T10:30:00Z',
      },
      {
        'id': 'spoken-science',
        'title': 'Spoken Science',
        'description':
            'Short, audio-first lessons that make complex science topics easy to revisit on the go.',
        'coverImageUrl':
            'https://images.unsplash.com/photo-1532094349884-543bc11b234d',
        'creatorId': 'creator_ravi',
        'isPremium': true,
        'sectionCount': 6,
        'createdAt': '2024-03-03T08:00:00Z',
      },
      {
        'id': 'history-in-patterns',
        'title': 'History in Patterns',
        'description':
            'Explore key eras through recurring ideas, movements, and turning points instead of rote memorisation.',
        'coverImageUrl':
            'https://images.unsplash.com/photo-1516979187457-637abb4f9353',
        'creatorId': 'creator_lina',
        'isPremium': false,
        'sectionCount': 5,
        'createdAt': '2024-02-10T14:45:00Z',
      },
    ];

    return data.map(CollectionModel.fromJson).toList();
  }
}
