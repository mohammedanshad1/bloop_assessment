# bloop_assessment

Flutter take-home implementation for the Bloop Flutter Developer Assessment.

## Flutter version

Flutter `3.29.0` stable (project metadata revision `35c388afb57ef061d06a39b537336c87e0e3d1b1`).

## What is included

- Part 1 implemented with `freezed`, `json_serializable`, Hive-backed caching, and a Riverpod `AsyncNotifierProvider`
- Cache-first collection loading with a background refresh via `unawaited()`
- A mocked remote data source instead of a live Firestore project so the architecture stays self-contained
- Part 2 fixes captured in `lib/debug/lesson_fix_examples.dart` with comments above each fix explaining the bug, consequence, and correction

## How to run

1. Run `flutter pub get`
2. Run `flutter test`
3. Run `flutter run`

## Notes

- The Firestore fetch in Part 1 is intentionally mocked with local JSON-shaped data because the assessment explicitly allows that simplification.
- Freezed/JSON generated model files are checked into the repo, so you only need `build_runner` again if you change the model definitions.
- The UI is designed for mobile Flutter targets, not Flutter Web.
