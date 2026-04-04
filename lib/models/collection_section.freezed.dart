// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collection_section.dart';

mixin _$CollectionSection {
  String get id => throw UnimplementedError();
  String get collectionId => throw UnimplementedError();
  String get title => throw UnimplementedError();
  int get order => throw UnimplementedError();
  int get contentCount => throw UnimplementedError();

  Map<String, dynamic> toJson() => throw UnimplementedError();
}

class _CollectionSection implements CollectionSection {
  const _CollectionSection({
    required this.id,
    required this.collectionId,
    required this.title,
    required this.order,
    required this.contentCount,
  });

  factory _CollectionSection.fromJson(Map<String, dynamic> json) =>
      _CollectionSection(
        id: json['id'] as String,
        collectionId: json['collectionId'] as String,
        title: json['title'] as String,
        order: json['order'] as int,
        contentCount: json['contentCount'] as int,
      );

  @override
  final String id;

  @override
  final String collectionId;

  @override
  final String title;

  @override
  final int order;

  @override
  final int contentCount;

  @override
  Map<String, dynamic> toJson() => _$CollectionSectionToJson(this);

  @override
  String toString() {
    return 'CollectionSection(id: $id, collectionId: $collectionId, title: $title, '
        'order: $order, contentCount: $contentCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is _CollectionSection &&
            other.id == id &&
            other.collectionId == collectionId &&
            other.title == title &&
            other.order == order &&
            other.contentCount == contentCount);
  }

  @override
  int get hashCode => Object.hash(id, collectionId, title, order, contentCount);
}
