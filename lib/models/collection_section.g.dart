// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collection_section.dart';

CollectionSection _$CollectionSectionFromJson(Map<String, dynamic> json) {
  return _CollectionSection(
    id: json['id'] as String,
    collectionId: json['collectionId'] as String,
    title: json['title'] as String,
    order: json['order'] as int,
    contentCount: json['contentCount'] as int,
  );
}

Map<String, dynamic> _$CollectionSectionToJson(_CollectionSection instance) =>
    <String, dynamic>{
      'id': instance.id,
      'collectionId': instance.collectionId,
      'title': instance.title,
      'order': instance.order,
      'contentCount': instance.contentCount,
    };
