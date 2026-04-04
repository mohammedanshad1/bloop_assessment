// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collection_model.dart';

mixin _$CollectionModel {
  String get id => throw UnimplementedError();
  String get title => throw UnimplementedError();
  String get description => throw UnimplementedError();
  String get coverImageUrl => throw UnimplementedError();
  String get creatorId => throw UnimplementedError();
  bool get isPremium => throw UnimplementedError();
  int get sectionCount => throw UnimplementedError();
  DateTime get createdAt => throw UnimplementedError();

  Map<String, dynamic> toJson() => throw UnimplementedError();
}

class _CollectionModel implements CollectionModel {
  const _CollectionModel({
    required this.id,
    required this.title,
    required this.description,
    required this.coverImageUrl,
    required this.creatorId,
    required this.isPremium,
    required this.sectionCount,
    required this.createdAt,
  });

  factory _CollectionModel.fromJson(Map<String, dynamic> json) =>
      _CollectionModel(
        id: json['id'] as String,
        title: json['title'] as String,
        description: json['description'] as String,
        coverImageUrl: json['coverImageUrl'] as String,
        creatorId: json['creatorId'] as String,
        isPremium: json['isPremium'] as bool,
        sectionCount: json['sectionCount'] as int,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );

  @override
  final String id;

  @override
  final String title;

  @override
  final String description;

  @override
  final String coverImageUrl;

  @override
  final String creatorId;

  @override
  final bool isPremium;

  @override
  final int sectionCount;

  @override
  final DateTime createdAt;

  @override
  Map<String, dynamic> toJson() => _$CollectionModelToJson(this);

  @override
  String toString() {
    return 'CollectionModel(id: $id, title: $title, description: $description, '
        'coverImageUrl: $coverImageUrl, creatorId: $creatorId, '
        'isPremium: $isPremium, sectionCount: $sectionCount, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is _CollectionModel &&
            other.id == id &&
            other.title == title &&
            other.description == description &&
            other.coverImageUrl == coverImageUrl &&
            other.creatorId == creatorId &&
            other.isPremium == isPremium &&
            other.sectionCount == sectionCount &&
            other.createdAt == createdAt);
  }

  @override
  int get hashCode => Object.hash(
        id,
        title,
        description,
        coverImageUrl,
        creatorId,
        isPremium,
        sectionCount,
        createdAt,
      );
}
