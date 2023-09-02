// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'space_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SpaceModel _$SpaceModelFromJson(Map<String, dynamic> json) => SpaceModel(
      name: json['name'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      id: json['id'] as String,
      isPinned: json['isPinned'] as bool,
      members: json['members'] as int,
      messages: json['messages'] as int,
      isJoined: json['isJoined'] as bool? ?? false,
    );

Map<String, dynamic> _$SpaceModelToJson(SpaceModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
      'id': instance.id,
      'isPinned': instance.isPinned,
      'isJoined': instance.isJoined,
      'members': instance.members,
      'messages': instance.messages,
    };
