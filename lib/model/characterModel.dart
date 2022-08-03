import 'package:json_annotation/json_annotation.dart';

part 'characterModel.g.dart';

@JsonSerializable(nullable: true)

class CharacterModel{
  String characterid;
  String nick;
  String server;
  int level;
  String lostArkClass;
  String uid;

  CharacterModel({
    this.characterid,
    this.nick,
    this.server,
    this.level,
    this.lostArkClass,
    this.uid,
  });

  static CharacterModel initCharacterForm(){
    return new CharacterModel(
      characterid: "",
      nick: "",
      server: "",
      level: 0,
      lostArkClass: "",
    );
  }

  factory CharacterModel.fromJson(Map<String, dynamic> json) => _$CharacterModelFromJson(json);

  Map<String, dynamic> toJson() => _$CharacterModelToJson(this);

}