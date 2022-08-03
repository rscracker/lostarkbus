import 'package:json_annotation/json_annotation.dart';

part 'userModel.g.dart';

@JsonSerializable(nullable: true)

class UserModel {
  String uid;
  List characterList;
  List favoriteList;

  UserModel({
    this.uid,
    this.characterList,
    this.favoriteList,
  });

  static UserModel initUser(){
    return new UserModel(
      characterList: [],
      favoriteList: [],
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);


}