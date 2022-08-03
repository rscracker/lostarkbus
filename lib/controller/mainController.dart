import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:lostarkbus/model/characterModel.dart';
import 'package:lostarkbus/model/userModel.dart';
import 'package:lostarkbus/services/database.dart';


class MainController extends GetxController{
  var user = UserModel().obs;
  RxList characterList = [].obs;
  RxList myUpload = [].obs;
  RxList nickList = [].obs;
  RxList favoriteList = [].obs;

  @override
  void onInit() {
    super.onInit();
  }

  updateUser(UserModel user){
    this.user(user);
  }

  addCharacter(CharacterModel character, int type) async{
    //this.user.value.characterList.add(character.toJson());
    if(type == 0){
      this.characterList.add(character.toJson());
    } else {
      print("add favorite");
      this.favoriteList.add(character.toJson());
    }
    await DatabaseService.instance.addCharacter(character, type);
  }


}