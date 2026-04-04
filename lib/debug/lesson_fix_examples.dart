import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class LessonModel {
  LessonModel({
    required this.id,
    required this.title,
    required this.thumbnail,
  });

  final String id;
  final String title;
  final String thumbnail;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'thumbnail': thumbnail,
      };

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel(
      id: json['id'] as String,
      title: json['title'] as String,
      thumbnail: json['thumbnail'] as String,
    );
  }
}

class LessonCacheService {
  late Box<dynamic> _box;

  Future<void> init() async {
    // Fix 1: using the documents directory risks user-visible files and backup churn,
    // so the cache should live in the support directory that is intended for app-managed data.
    final dir = await getApplicationSupportDirectory();
    Hive.init(dir.path);
    _box = await Hive.openBox<dynamic>('lessons');
  }

  Future<void> saveLesson(LessonModel lesson) async {
    await _box.put(lesson.id, lesson.toJson());
  }

  Future<LessonModel?> getLesson(String id) async {
    final data = _box.get(id);

    // Fix 2: a cache miss returns null, and passing that into fromJson would throw at runtime,
    // so the method must short-circuit and return null when the lesson is absent.
    if (data == null) {
      return null;
    }

    return LessonModel.fromJson(Map<String, dynamic>.from(data as Map));
  }

  Future<void> clearAll() async {
    await _box.clear();
  }
}

class LessonFirestoreService {
  Future<List<LessonModel>> fetchLessons() async {
    return [
      LessonModel(
        id: 'lesson-1',
        title: 'Fractions you can feel',
        thumbnail: 'thumb-1',
      ),
      LessonModel(
        id: 'lesson-2',
        title: 'Atoms in plain language',
        thumbnail: 'thumb-2',
      ),
    ];
  }
}

class ImageCacheService {
  Future<String?> resolveThumbnail(String lessonId) async {
    return 'resolved-$lessonId';
  }
}

final lessonNotifierProvider =
    AsyncNotifierProvider<LessonNotifier, List<LessonModel>>(
  LessonNotifier.new,
);

class LessonNotifier extends AsyncNotifier<List<LessonModel>> {
  @override
  Future<List<LessonModel>> build() async {
    final cache = LessonCacheService();
    await cache.init();
    return _fetchAndCache(cache);
  }

  Future<List<LessonModel>> _fetchAndCache(LessonCacheService cache) async {
    final lessons = await LessonFirestoreService().fetchLessons();
    await Future.wait(lessons.map(cache.saveLesson));
    return lessons;
  }
}

final lessonThumbnailProvider =
    FutureProvider.family<String?, String>((ref, lessonId) {
  return ImageCacheService().resolveThumbnail(lessonId);
});

class LessonListWidget extends ConsumerWidget {
  const LessonListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lessonsAsync = ref.watch(lessonNotifierProvider);
    return lessonsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Text('Error: $e'),
      data: (lessons) {
        return ListView.builder(
          itemCount: lessons.length,
          itemBuilder: (context, index) {
            final lesson = lessons[index];

            // Fix 3: creating a new Future inside every list item rebuild causes repeated async work
            // and thumbnail flicker, so the lookup is moved into a provider that reuses the same future by lesson id.
            final thumbnailAsync = ref.watch(lessonThumbnailProvider(lesson.id));
            return LessonTile(
              lesson: lesson,
              thumbnail: thumbnailAsync.value,
            );
          },
        );
      },
    );
  }
}

class LessonTile extends StatelessWidget {
  const LessonTile({
    super.key,
    required this.lesson,
    required this.thumbnail,
  });

  final LessonModel lesson;
  final String? thumbnail;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(lesson.title),
      subtitle: Text(thumbnail ?? 'Loading thumbnail...'),
    );
  }
}

class LessonDocument {
  LessonDocument({
    required this.id,
    required this.payload,
  });

  final String id;
  final Map<String, dynamic> payload;

  Map<String, dynamic> data() => Map<String, dynamic>.from(payload);
}

class LessonSnapshot {
  LessonSnapshot(this.docs);

  final List<LessonDocument> docs;
}

class LessonStreamApi {
  Stream<LessonSnapshot> lessonsForCourse(String courseId) async* {
    yield LessonSnapshot([
      LessonDocument(
        id: 'lesson-1',
        payload: {
          'courseId': courseId,
          'title': 'Warm-up',
          'thumbnail': 'thumb-1',
        },
      ),
    ]);
  }
}

StreamSubscription<LessonSnapshot>? _sub;

void listenToLessons(String courseId, LessonStreamApi api) {
  _sub?.cancel();
  _sub = api.lessonsForCourse(courseId).listen((snapshot) {
    final lessons = snapshot.docs.map((doc) {
      final data = doc.data();

      // Fix 4: mutating the original snapshot map can leak side effects into shared snapshot data,
      // so we create a fresh map copy before inserting the document id for JSON parsing.
      final lessonJson = <String, dynamic>{...data, 'id': doc.id};
      return LessonModel.fromJson(lessonJson);
    }).toList();

    debugPrint('$lessons');
  });
}
