import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:lostarkbus/controller/mainController.dart';
import 'package:lostarkbus/model/busModel.dart';
import 'package:lostarkbus/model/characterModel.dart';
import 'package:lostarkbus/model/userModel.dart';

import 'package:get/get.dart';
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

  getInitData(List myCharacter) async{
    List myParty = [];
    List characterList = [];
    QuerySnapshot snapshot1 = await busCollection.where("uploader", isEqualTo: _user.uid).get();
    snapshot1.docs.forEach((e) {
      myParty.add(e.data());
    });
    _mainController.myUpload.assignAll(myParty);
    print(_mainController.myUpload);
    for(int i = 0; i < myCharacter.length ; i++){
      Map<String, dynamic> character;
      await characterCollection.doc(myCharacter[i]).get().then((e) => character = e.data());
      characterList.add(character);
    }
    _mainController.characterList.assignAll(characterList);
  }

  Future<bool> setUser(String uid) async{
    print(uid);
    DocumentSnapshot snapshot = await userCollection.doc(uid).get();
    print("aaa : ${snapshot.data()}");
    if(snapshot.data() == null) { //앱 처음
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
      getInitData(userdata['characterList']);
      _mainController.favoriteList.assignAll(userdata['favoriteList']);
      print("second login");

      return Future.value(true);
    }
  }

  Future<CharacterModel> getCharacterData(String body, String nick){
    CharacterModel characterData = CharacterModel.initCharacterForm();
    List splited = body.split("profile-character-info__lv");
    characterData.nick = nick;
    // characterData.level= int.parse(splited[1].substring(5,7));
    String level2 = body.split("달성 아이템 레벨</span><span><small>Lv.</small>")[1].substring(0,15).split('<small>')[0].toString().replaceAll(",", "");
    characterData.level = int.parse(level2);
    String laClass = splited[0].toString().trim();
    characterData.lostArkClass = laClass.substring(laClass.length - 48, laClass.length-20).split("\"")[2];
    characterData.server = body.split("profile-character-info__server")[1].split("\"")[2].substring(1);
    return Future.value(characterData);
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
      _user.characterList.add(id);
      await userCollection.doc(_user.uid).update({"characterList" : _user.characterList});
    } else{
      _user.favoriteList.add(character.toJson());
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
    _mainController.myUpload.add(busForm.toJson());
  }

  participationBus(String docId, Map<String,dynamic> character) async{
    // List serverNum = [];
    // await busCollection.doc(docId).get().then((e){
    //   serverNum = e.data()["numPassenger"][e.data()["server"]
    //       .indexOf(character['server'])][character['server']];
    // });
    // await busCollection.doc(docId).update({"numPassenger.${character['server']}" : [serverNum[0] + 1, serverNum[1]]});
    await busCollection.doc(docId).update({"passengerList" : FieldValue.arrayUnion([character])});
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
      return busCollection.where("passengerList" , arrayContainsAny: _mainController.characterList).snapshots();
    return null;
  }

  Stream<QuerySnapshot> getBusData(String server, {String type, String sort}){
    if(server == "전섭"){
      if(type != null){
        return busCollection.orderBy('time', descending: false).where("busName", isEqualTo: type).snapshots();
      }
      return busCollection.orderBy("time", descending: false).snapshots();
    } else {
      if(type != null){
        return busCollection.orderBy('time', descending: false).where("server", arrayContains: server).where("busName", isEqualTo: type).snapshots();
      }
      return busCollection.orderBy("time", descending: false).where("server", arrayContains: server).snapshots();
    }
  }

  Stream<DocumentSnapshot> getBusDetail(String uid){
    return busCollection.doc(uid).snapshots();
  }

  Stream<QuerySnapshot> getMapData(String server, String type, String region){
    if(server == "전섭"){
      if(type != null && region != null){
        return mapCollection.where("type", isEqualTo: type).where("loc1", isEqualTo: region).snapshots();
      } else if(type != null && region == null){
        return mapCollection.where("type", isEqualTo: type).snapshots();
      } else if(type == null && region != null){
        return mapCollection.where("loc1", isEqualTo: region).snapshots();
      }
      return mapCollection.snapshots();
    } else {
      if(type != null && region != null){
        return mapCollection.where("uploader.server", isEqualTo: server).where("type", isEqualTo: type).where("loc1", isEqualTo: region).snapshots();
      } else if(type != null && region == null){
        return mapCollection.where("uploader.server", isEqualTo: server).where("type", isEqualTo: type).snapshots();
      } else if(type == null && region != null){
        return mapCollection.where("uploader.server", isEqualTo: server).where("loc1", isEqualTo: region).snapshots();
      }
      return mapCollection.where("uploader.server", isEqualTo: server).snapshots();
    }
  }

  Stream<QuerySnapshot> getTradeData(String server, {String item, String sort}){
    if(server == "전섭"){
      if(item != null){
        return tradeCollection.where("item", isEqualTo: item).snapshots();
      }
      return tradeCollection.snapshots();
    } else {
      if(item != null){
        return tradeCollection.where("server", isEqualTo: server).where("item", isEqualTo: item).snapshots();
      }
      return tradeCollection.where("server", isEqualTo: server).snapshots();
    }
    
  }
}