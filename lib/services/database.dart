import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lostarkbus/controller/mainController.dart';
import 'package:lostarkbus/model/busModel.dart';
import 'package:lostarkbus/model/characterModel.dart';
import 'package:lostarkbus/model/userModel.dart';

import 'package:get/get.dart';
import 'package:lostarkbus/widget/circularProgress.dart';
import 'package:lostarkbus/widget/flushbar.dart';
class DatabaseService {
  DatabaseService._privateConstructor();

  static final DatabaseService _instance = DatabaseService._privateConstructor();

  static DatabaseService get instance => _instance;

  MainController _mainController = Get.find();

  UserModel get _user => _mainController.user.value;

  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');

  final CollectionReference busCollection = FirebaseFirestore.instance.collection('bus');

  final CollectionReference tradeCollection = FirebaseFirestore.instance.collection('trade');

  final CollectionReference mapCollection = FirebaseFirestore.instance.collection('map');

  final CollectionReference characterCollection = FirebaseFirestore.instance.collection('character');

  getInitData(List myCharacter, List myFavorite) async{
    List myParty = [];
    List characterList = [];
    List favoriteList = [];
    _mainController.uidList.assignAll(myCharacter);
    for(int i = 0; i < myCharacter.length ; i++){
      Map<String, dynamic> character;
      await characterCollection.doc(myCharacter[i]).get().then((e) => character = e.data());
      characterList.add(character);
    }
    for(int i = 0; i < myFavorite.length ; i++){
      Map<String, dynamic> character;
      await characterCollection.doc(myFavorite[i]).get().then((e) => character = e.data());
      favoriteList.add(character);
    }
    _mainController.characterList.assignAll(characterList);
    _mainController.favoriteList.assignAll(favoriteList);
  }

  Future<bool> setUser(String uid) async{
    print(uid);
    DocumentSnapshot snapshot = await userCollection.doc(uid).get();
    print("aaa : ${snapshot.data()}");
    if(snapshot.data() == null) { //??? ??????
      UserModel initUser = UserModel.initUser();
      initUser.uid = uid;
      _mainController.updateUser(initUser);
      print("first login");
      saveUserData(uid);
      return Future.value(false);
    } else {
      Map<String, dynamic> userdata = snapshot.data();
      userdata['uid'] = uid;
      _mainController.updateUser(UserModel.fromJson(userdata));
      //_mainController.characterList.assignAll(userdata['characterList']);
      print('aaaa ${userdata['favoriteList']}');
      getInitData(userdata['characterList'], userdata['favoriteList']);
      //_mainController.favoriteList.assignAll(userdata['favoriteList']);
      print("second login");

      return Future.value(true);
    }
  }

  Future<CharacterModel> getCharacterData(String body, String nick){
    CharacterModel characterData = CharacterModel.initCharacterForm();
    List splited = body.split("profile-character-info__lv");
    characterData.nick = nick;
    // characterData.level= int.parse(splited[1].substring(5,7));
    String level2 = body.split("?????? ????????? ??????</span><span><small>Lv.</small>")[1].substring(0,15).split('<small>')[0].toString().replaceAll(",", "");
    characterData.level = int.parse(level2);
    String laClass = splited[0].toString().trim();
    characterData.lostArkClass = laClass.substring(laClass.length - 48, laClass.length-20).split("\"")[2];
    characterData.server = body.split("profile-character-info__server")[1].split("\"")[2].substring(1);
    return Future.value(characterData);
  }

  updateCharacterLevel(String body, CharacterModel character, int index, int type) async{
    String updatedLevel = body.split("?????? ????????? ??????</span><span><small>Lv.</small>")[1].substring(0,15).split('<small>')[0].toString().replaceAll(",", "");
    if(int.parse(updatedLevel) != character.level){
      if(type == 0){
        _mainController.characterList[index]['level'] = updatedLevel;
        _mainController.characterList.refresh();
        await characterCollection.doc(character.characterid).update({"level" : int.parse(updatedLevel)});
      } else if (type == 1){
        _mainController.favoriteList[index]['level'] = updatedLevel;
        _mainController.favoriteList.refresh();
        await characterCollection.doc(character.characterid).update({"level" : int.parse(updatedLevel)});
      }
    }

  }

  deleteCharacter(String characterId, int index, int type) async{
    if(type == 0){
      await userCollection.doc(_user.uid).update({"characterList" : FieldValue.arrayRemove([characterId])});
      _mainController.characterList.removeAt(index);
    } else {
      await userCollection.doc(_user.uid).update({"favoriteList" : FieldValue.arrayRemove([characterId])});
      _mainController.favoriteList.removeAt(index);
    }
    await characterCollection.doc(characterId).delete();
  }

  saveUserData(String uid) async{
    await userCollection.doc(uid).set(_user.toJson());
  }
  
  addCharacter(CharacterModel character, int type) async{
    String id;
    await characterCollection.add({}).then((e) => id = e.id);
    character.characterid = id;
    character.uid = _user.uid;
    await characterCollection.doc(id).update(character.toJson());
    if(type == 0){
      _mainController.characterList.add(character.toJson());
      _user.characterList.add(id);
      await userCollection.doc(_user.uid).update({"characterList" : _user.characterList});
    } else{
      _user.favoriteList.add(id);
      _mainController.favoriteList.add(character.toJson());
      await userCollection.doc(_user.uid).update({"favoriteList" : _user.favoriteList});
    }
  }

  addTrade(Map<String, dynamic> character, Map<String, dynamic> form) async{
    String id;
    await tradeCollection.add({}).then((value){
      id = value.id;
    });
    form["docId"] = id;
    form['buy'] = 0;
    await tradeCollection.doc(id).set(form);
  }

  registerBus(BusModel busForm) async{
    String id;
    await busCollection.add({}).then((e) => id = e.id);
    busForm.docId = id;
    await busCollection.doc(id).set(busForm.toJson());
    //_mainController.myUpload.add(busForm.toJson());
  }

  registerPay1(String docId, int index, String receiver) async{
    List passenger = [];
    await busCollection.doc(docId).get().then((e) => passenger.assignAll(e.data()['passengerList']));
    passenger[index]["payment"]  = [receiver, "??????"];
    await busCollection.doc(docId).update({"passengerList" : passenger});
  }

  registerPay2(String docId, int index, String receiver, List jewel) async{
    List passenger = [];
    await busCollection.doc(docId).get().then((e) => passenger.assignAll(e.data()['passengerList']));
    passenger[index]["payment"]  = [receiver, jewel[0], jewel[1]];
    await busCollection.doc(docId).update({"passengerList" : passenger});
  }
  
  buyItem(String docId, int quantity) async{
    await tradeCollection.doc(docId).update({"buy" : FieldValue.increment(quantity)});
}

  participationBus(String docId, Map<String,dynamic> character, int type) async{
    character['payment'] = [];
    List numPassenger = [];
    await busCollection.doc(docId).get().then((e){
      numPassenger.assignAll(e.data()["numPassenger"]);
    });
    numPassenger[type] = numPassenger[type] - 1;
    await busCollection.doc(docId).update({"numPassenger" : numPassenger});
    await busCollection.doc(docId).update({"passengerList" : FieldValue.arrayUnion([character])});
    await busCollection.doc(docId).update({"passengerUidList" : FieldValue.arrayUnion([_user.uid])});
  }

  applyBus(String docId, Map<dynamic, dynamic> character) async{
    await busCollection.doc(docId).update({"applyList" : FieldValue.arrayUnion([character])});
  }

  acceptApply(String docId, int index, Map<dynamic, dynamic> character) async{
    List applyList = [];
    bool numCheck = false;
    await busCollection.doc(docId).get().then((e){
      applyList = e.data()["applyList"];
      if(e.data()['numDriver'] - 1 == e.data()['driverList'].length){
        numCheck = true;
      }
    });
    applyList.removeAt(index);
    await busCollection.doc(docId).update({"applyList" : applyList});
    await busCollection.doc(docId).update({"driverList" : FieldValue.arrayUnion([character])});
    if(numCheck){
      await busCollection.doc(docId).update({"type" : 0});
    }
  }

  refuseApply(String docId, int index) async{
    List applyList = [];
    await busCollection.doc(docId).get().then((e){
      applyList = e.data()["applyList"];
    });
    applyList.removeAt(index);
    await busCollection.doc(docId).update({"applyList" : applyList});
  }

  participationMap(String docId, Map<String,dynamic> character) async{
    await mapCollection.doc(docId).update({"participation" : FieldValue.arrayUnion([character])});
  }

  addMap(Map<String, dynamic> character, String type, String loc1, String loc2, int time) async{
    Map<String, dynamic> mapData = {
      "docId" : "",
      "uploader" : character,
      "type" : type,
      "loc1" : loc1,
      "loc2" : loc2,
      "time" : time,
      "participation" : [character],
    };
    String id;
    await mapCollection.add({}).then((value){
      id = value.id;
    });
    mapData["docId"] = id;
    await mapCollection.doc(id).set(mapData);
  }

  Stream<QuerySnapshot> getmyParty(){
    if(_mainController.characterList.isNotEmpty)
      return busCollection.where("passengerUidList" , arrayContains: _user.uid).snapshots();
    return null;
  }

  Stream<QuerySnapshot> getmyParty2(){
    if(_mainController.characterList.isNotEmpty)
      return busCollection.where("driverList" , arrayContainsAny: _mainController.characterList).orderBy('time', descending: false).snapshots();
    return null;
  }

  Stream<QuerySnapshot> getBusData(String server, {String type, String sort}){
    int time = DateTime.now().hour * 100 + DateTime.now().minute;
    print('hour : ${DateTime.now().hour}');
    print(time);
    if(server == "?????? ??????"){
      if(type != null){
        return busCollection.where("time" , isGreaterThan: time).orderBy('time', descending: false).where("busName", isEqualTo: type).snapshots(); // ?????????
      }
      return busCollection.where("time" , isGreaterThan: time).orderBy("time", descending: false).snapshots();
    } else {
      if(type != null){
        return busCollection.where("time" , isGreaterThan: time).orderBy('time', descending: false).where("server", arrayContains: server).where("busName", isEqualTo: type).snapshots();
      }
      return busCollection.where("time" , isGreaterThan: time).orderBy("time", descending: false).where("server", arrayContains: server).snapshots();
    }
  }

  Stream<DocumentSnapshot> getBusDetail(String uid){
    return busCollection.doc(uid).snapshots();
  }

  Stream<QuerySnapshot> getMapData(String server, String type, String region){
    int time = DateTime.now().hour * 100 + DateTime.now().minute;
    if(server == "?????? ??????"){
      if(type != null && region != null){
        return mapCollection.where("time", isGreaterThan: time).where("type", isEqualTo: type).where("loc1", isEqualTo: region).orderBy("time", descending: false).snapshots();
      } else if(type != null && region == null){
        return mapCollection.where("time", isGreaterThan: time).where("type", isEqualTo: type).orderBy("time", descending: false).snapshots();
      } else if(type == null && region != null){
        return mapCollection.where("time", isGreaterThan: time).where("loc1", isEqualTo: region).orderBy("time", descending: false).snapshots();
      }
      return mapCollection.where("time", isGreaterThan: time).snapshots();
    } else {
      if(type != null && region != null){
        return mapCollection.where("time", isGreaterThan: time).where("uploader.server", isEqualTo: server).where("type", isEqualTo: type).where("loc1", isEqualTo: region).orderBy("time", descending: false).snapshots();
      } else if(type != null && region == null){
        return mapCollection.where("time", isGreaterThan: time).where("uploader.server", isEqualTo: server).where("type", isEqualTo: type).orderBy("time", descending: false).snapshots();
      } else if(type == null && region != null){
        return mapCollection.where("time", isGreaterThan: time).where("uploader.server", isEqualTo: server).where("loc1", isEqualTo: region).orderBy("time", descending: false).snapshots();
      }
      return mapCollection.where("time", isGreaterThan: time).where("uploader.server", isEqualTo: server).orderBy("time", descending: false).snapshots();
    }
  }

  Stream<QuerySnapshot> getTradeData(String server, {String item, String sort}){
    if(server == "?????? ??????"){
      if(item != null){
        return tradeCollection.where("item", isEqualTo: item).snapshots();
      }
      return tradeCollection.snapshots();
    } else {
      if(item != null){
        return tradeCollection.where("uploader.server", isEqualTo: server).where("item", isEqualTo: item).snapshots();
      }
      return tradeCollection.where("uploader.server", isEqualTo: server).snapshots();
    }
  }

  Stream<DocumentSnapshot> getCharacter(String characterId){
    return characterCollection.doc(characterId).snapshots();
  }


  Stream<DocumentSnapshot> buyableQuantity(String docId){
    return tradeCollection.doc(docId).snapshots();
  }


}