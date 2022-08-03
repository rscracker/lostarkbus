// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'userModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return UserModel(
    uid: json['uid'] as String,
    characterList: json['characterList'] as List,
    favoriteList: json['favoriteList'] as List,
  );
}

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'uid': instance.uid,
      'characterList': instance.characterList,
      'favoriteList': instance.favoriteList,
    };
