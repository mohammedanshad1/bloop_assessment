BLOOP  |  Flutter Developer Assessment  |  Round 1 
 
Flutter Developer 
Take-Home Assessment 
Duration 3–4 hours total 
Flutter version 3.x stable — state which version in your README 
Deadline 72 hours from receipt 
Submission format GitHub repository 
 
Important: Every task requires a running Flutter app on a real device or simulator — not Flutter Web. 
Submissions without screen recordings or screenshots will not be reviewed. 
 
Part 1  —  State Management & Data Layer 
Topics: Riverpod  |  Hive  |  Freezed  |  Firebase Firestore          Estimated time: ~90 minutes 
Bloop organises learning content into Collections (courses) and Sections (chapters). Build a 
self-contained mini-module that fetches, caches, and displays a collection list using the same 
patterns we use in production. 
 
Task 1.1 — Data models 
Create Freezed + JSON-serialisable models for the two entities below. Do not skip @freezed — 
we use code generation throughout the project. 
 
// Collection 
{ 
  "id": "string", 
  "title": "string", 
  "description": "string", 
  "coverImageUrl": "string", 
  "creatorId": "string", 
  "isPremium": false, 
  "sectionCount": 4, 
  "createdAt": "2024-01-15T10:30:00Z" 
} 
 
// CollectionSection 
{ 
  "id": "string", 
  "collectionId": "string", 
  "title": "string", 
  "order": 0, 
  "contentCount": 3 
} 
 
Task 1.2 — Caching layer 
Implement a CollectionCacheService using Hive. It must: 
• Store and retrieve a list of CollectionModel objects by key 
• Persist to disk using getApplicationSupportDirectory() — not the documents directory 
• Expose a Future<void> init() that must be called before any read or write 
• Handle a cache miss gracefully — return null, do not throw 
• Include a clearAll() method 
Task 1.3 — Riverpod provider  (key task) 
Build a collectionListProvider using AsyncNotifierProvider (not FutureProvider) that implements 
a cache-first, then refresh strategy: 
1. On build, initialise the cache service and immediately emit cached data if available, so 
the UI has something to display right away 
2. In the background using unawaited(), fetch fresh data from Firestore and update state 
3. Save the fresh data back to cache 
4. Expose a public refresh() method that forces a Firestore fetch and updates state 
Note: You may mock the Firestore call with a local JSON list if you do not want to set up a full 
Firebase project. We are evaluating the provider architecture and cache integration — not whether 
Firestore is live. 
Task 1.4 — Written explanation 
In a NOTES.md file, answer in 3–5 sentences: 
Why did we ask you to use AsyncNotifierProvider instead of FutureProvider for this task? What 
does the cache-first strategy prevent from the user's perspective? 
Required deliverables for Part 1 
• Working code that compiles and runs (flutter run must succeed) 
• NOTES.md with your written answers to Task 1.4 
Part 2  —  Debug & Fix 
Topics: Code review  |  Flutter patterns  |  Performance          
Estimated time: ~40 minutes 
The code below has four bugs. Some will cause runtime errors; one will cause a subtle but real 
performance problem. Find all four, fix them, and write a comment above each fix explaining 
what was wrong and why your fix is correct. 
Important: Do not just make the code look right. Each bug has a specific consequence. Your 
explanation must identify the consequence, not just describe the change. 
 
class LessonCacheService { 
  late Box _box; 
 
  Future<void> init() async { 
    // bug 1 
    final dir = await getApplicationDocumentsDirectory(); 
    Hive.init(dir.path); 
    _box = await Hive.openBox('lessons'); 
  } 
 
  Future<void> saveLesson(LessonModel lesson) async { 
    await _box.put(lesson.id, lesson.toJson()); 
  } 
 
  Future<LessonModel?> getLesson(String id) async { 
    final data = _box.get(id); 
    return LessonModel.fromJson(data); // bug 2 
  } 
 
  Future<void> clearAll() async { 
    await _box.clear(); 
  } 
} 
 
// ── 
 
class LessonNotifier extends AsyncNotifier<List<LessonModel>> { 
  @override 
  Future<List<LessonModel>> build() async { 
    final cache = LessonCacheService(); 
    await cache.init(); 
    return _fetchAndCache(cache); 
  } 
 
  Future<List<LessonModel>> _fetchAndCache(LessonCacheService cache) async { 
    final lessons = await LessonFirestoreService().fetchLessons(); 
    await cache.saveLesson(lessons.first); 
    return lessons; 
  } 
} 
 
// ── 
 
class LessonListWidget extends StatelessWidget { 
  const LessonListWidget({super.key}); 
 
  @override 
  Widget build(BuildContext context) { 
    return Consumer( 
      builder: (context, ref, _) { 
        final lessonsAsync = ref.watch(lessonNotifierProvider); 
        return lessonsAsync.when( 
          loading: () => const CircularProgressIndicator(), 
          error: (e, _) => Text('Error: $e'), 
          data: (lessons) { 
            return ListView.builder( 
              itemCount: lessons.length, 
              itemBuilder: (context, index) { 
                final lesson = lessons[index]; 
                return FutureBuilder( // bug 3 
                  future: ImageCacheService().resolveThumbnail(lesson.id), 
                  builder: (context, snapshot) { 
                    return LessonTile( 
                      lesson: lesson, 
                      thumbnail: snapshot.data, 
                    ); 
                  }, 
                ); 
              }, 
            ); 
          }, 
        ); 
      }, 
    ); 
  } 
} 
 
// ── 
 
StreamSubscription? _sub; 
 
void listenToLessons(String courseId) { 
  _sub = FirebaseFirestore.instance 
      .collection('lessons') 
      .where('courseId', isEqualTo: courseId) 
      .snapshots() 
      .listen((snapshot) { 
    final lessons = snapshot.docs.map((doc) { 
      final data = doc.data(); 
      data['id'] = doc.id; // bug 4 
      return LessonModel.fromJson(data); 
    }).toList(); 
    print(lessons); 
  }); 
} 
 
Required deliverables for Part 2 
• All four bugs fixed with a comment above each explaining the consequence and the fix 
• Code must compile and run 
 
Submission Checklist 
1. GitHub repository — public, or invite us as a collaborator. Commit history must be 
meaningful. Squashing everything into one commit is a red flag. 
2. NOTES.md with your written answer to Task 1.4. 
3. README.md stating: Flutter version used, how to run the project, any mocked or 
simplified parts and why. 
4. Code must compile and run — we will clone your repo and run flutter run ourselves. 
Reminder: We do not score on lines of code or whether all parts are complete. Parts 1 and 2 
submitted with clear, well-explained code will rank higher than both parts done hastily. Prioritise quality 
over coverage. 
Bloop  |  Alethex Group  |  Confidential — do not distribute