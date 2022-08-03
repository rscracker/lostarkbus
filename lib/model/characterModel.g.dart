// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'characterModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CharacterModel _$CharacterModelFromJson(Map<String, dynamic> json) {
  return CharacterModel(
    characterid: json['characterid'] as String,
    nick: json['nick'] as String,
    server: json['server'] as String,
    level: json['level'] as int,
    lostArkClass: json['lostArkClass'] as String,
    uid: json['uid'] as String,
  );
}

Map<String, dynamic> _$CharacterModelToJson(CharacterModel instance) =>
    <String, dynamic>{
      'characterid': instance.characterid,
      'nick': instance.nick,
      'server': instance.server,
      'level': instance.level,
      'lostArkClass': instance.lostArkClass,
      'uid': instance.uid,
    };
