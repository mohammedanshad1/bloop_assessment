import 'package:freezed_annotation/freezed_annotation.dart';

part 'collection_section.freezed.dart';
part 'collection_section.g.dart';

@freezed
class CollectionSection with _$CollectionSection {
  const factory CollectionSection({
    required String id,
    required String collectionId,
    required String title,
    required int order,
    required int contentCount,
  }) = _CollectionSection;

  factory CollectionSection.fromJson(Map<String, dynamic> json) =>
      _$CollectionSectionFromJson(json);
}
