// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collection_model.dart';

CollectionModel _$CollectionModelFromJson(Map<String, dynamic> json) {
  return _CollectionModel(
    id: json['id'] as String,
    title: json['title'] as String,
    description: json['description'] as String,
    coverImageUrl: json['coverImageUrl'] as String,
    creatorId: json['creatorId'] as String,
    isPremium: json['isPremium'] as bool,
    sectionCount: json['sectionCount'] as int,
    createdAt: DateTime.parse(json['createdAt'] as String),
  );
}

Map<String, dynamic> _$CollectionModelToJson(_CollectionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'coverImageUrl': instance.coverImageUrl,
      'creatorId': instance.creatorId,
      'isPremium': instance.isPremium,
      'sectionCount': instance.sectionCount,
      'createdAt': instance.createdAt.toIso8601String(),
    };
